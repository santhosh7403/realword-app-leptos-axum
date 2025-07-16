use leptos::prelude::*;

#[derive(serde::Deserialize, Clone, serde::Serialize)]
pub enum SignupResponse {
    ValidationError(String),
    CreateUserError(String),
    Success,
}

#[tracing::instrument]
pub fn validate_signup(
    username: String,
    email: String,
    password: String,
) -> Result<crate::models::User, String> {
    crate::models::User::default()
        .set_username(username)?
        .set_password(password)?
        .set_email(email)
}

#[tracing::instrument]
#[server(SignupAction, "/api")]
pub async fn signup_action(
    username: String,
    email: String,
    password: String,
) -> Result<SignupResponse, ServerFnError> {
    match validate_signup(username.clone(), email, password) {
        Ok(user) => match user.insert().await {
            Ok(_) => {
                crate::auth::set_username(username).await;
                // leptos_axum::redirect("/");
                Ok(SignupResponse::Success)
            }
            Err(x) => {
                let x = x.to_string();
                Ok(if x.contains("users_email_key") {
                    SignupResponse::CreateUserError("Duplicated email".to_string())
                } else if x.contains("users_pkey") {
                    SignupResponse::CreateUserError("Duplicated user".to_string())
                } else {
                    tracing::error!("error from DB: {}", x);
                    SignupResponse::CreateUserError(
                        "There is an unknown problem, try again later".to_string(),
                    )
                })
            }
        },
        Err(x) => Ok(SignupResponse::ValidationError(x)),
    }
}

#[server(LoginAction, "/api")]
#[tracing::instrument]
pub async fn login_action(username: String, password: String) -> Result<String, ServerFnError> {
    if sqlx::query_scalar!(
        "SELECT count(username) FROM Users where username=$1 and password=crypt($2, password)",
        username,
        password,
    )
    .fetch_one(crate::database::get_db())
    .await
    .unwrap()
        == Some(1)
    {
        crate::auth::set_username(username).await;
        leptos_axum::redirect("/");
        Ok("Successful".to_string())
    } else {
        let response_options = use_context::<leptos_axum::ResponseOptions>().unwrap();
        response_options.set_status(axum::http::StatusCode::FORBIDDEN);
        Err(ServerFnError::new("Unsuccessful"))
    }
}

#[server(LogoutAction, "/api")]
#[tracing::instrument]
pub async fn logout_action() -> Result<(), ServerFnError> {
    let response_options = use_context::<leptos_axum::ResponseOptions>().unwrap();
    response_options.insert_header(
        axum::http::header::SET_COOKIE,
        axum::http::HeaderValue::from_str(crate::auth::REMOVE_COOKIE)
            .expect("header value couldn't be set"),
    );
    // leptos_axum::redirect("/");
    leptos_axum::redirect("/login");
    Ok(())
}

#[server(CurrentUserAction, "/api")]
#[tracing::instrument]
pub async fn current_user() -> Result<crate::models::User, ServerFnError> {
    let Some(logged_user) = super::get_username() else {
        return Err(ServerFnError::ServerError("you must be logged in".into()));
    };
    crate::models::User::get(logged_user).await.map_err(|err| {
        tracing::error!("problem while retrieving current_user: {err:?}");
        ServerFnError::ServerError("you must be logged in".into())
    })
}
