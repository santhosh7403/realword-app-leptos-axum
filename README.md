# 🚀 A Near-Realworld Leptos Web App with Axum and PostgreSQL Backend


<picture>
    <source srcset="https://raw.githubusercontent.com/leptos-rs/leptos/main/docs/logos/Leptos_logo_Solid_White.svg" media="(prefers-color-scheme: dark)">
    <img src="https://raw.githubusercontent.com/leptos-rs/leptos/main/docs/logos/Leptos_logo_RGB.svg" alt="Leptos Logo">
</picture>

This repository hosts a **Leptos demo application** developed as part of my exploration and experimentation with the **Rust/Leptos framework**. This project is more complex than the previously shared [ demo-tools-app-leptos-07-actix-tailwind](https://github.com/santhosh7403/demo-tools-app-leptos-07-actix-tailwind) and is intended to serve as a **more realistic, working example** for developers considering Leptos for their next project. I hope this hands-on code provides valuable insight into the framework's capabilities.


A comparative SQLite version of the application is also maintained [here.](https://github.com/santhosh7403/realworld-app-leptos-axum-sqlite) This alternative offers identical UI and functionality but features:
1. An optimization for rapid deployment due to simplified database setup steps, contrasting with the more involved configuration of the PostgreSQL version.
2. A minor difference in full-text search implementation, as the underlying database engines handle this feature differently.


Before proceeding, you can view the application's functionality via the[ screenshots here ](https://github.com/santhosh7403/realworld-app-leptos-axum/blob/main/App_Screenshots.md).

---

## 🛠️ Key Technologies & Features

This application leverages the following core technologies and features:

* Leptos
* axum
* Server-Side Rendering (SSR)
* sqlite
* fts5 (Full-Text Search)
* Modal Windows
* argon2 (Password Encryption)
* uuid
* tailwindcss
* fontawesome icons

---

## ⚙️ Installation and Setup

**Prerequisites**

By default, `cargo-leptos` requires the **Rust nightly** toolchain and several cargo extensions. If you encounter issues, ensure these tools are installed. Consult the [ rustup documentation ](https://rustup.rs) for detailed instructions.

### Required Tools

Ensure the following Rust toolchains and dependencies are installed:


1.  `rustup toolchain install nightly --allow-downgrade` (Installs or ensures the **Rust nightly** toolchain is available)
2.  `rustup update` (Updates all installed Rust toolchains to their latest version)
3.  `rustup target add wasm32-unknown-unknown` (Adds the target necessary for compiling Rust to WebAssembly)
4.  `cargo install cargo-generate` (Installs the project templating tool)
5.  `cargo install cargo-leptos --locked` (Installs the essential Leptos build tool)


### Clone Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/santhosh7403/realworld-app-leptos-axum.git]
cd realword-app-leptos-axum
```


### Database Initialization

1. `source .env` - set the DATABASE_URL env variable

2, Follow the steps in [ README_DATABASE.md ](https://github.com/santhosh7403/realworld-app-leptos-axum-sqlite/blob/main/README_DATABASE.md) to initialize the database schema and data.

### Run Application

You may now build and run the application:

```bash
cargo leptos watch 
# OR
cargo leptos serve
```
---

### Application access

Once the application has started successfully, access it via your web browser at [ localhost:3000 ](http://localhost:3000/)

Sample application screens.
<img width="1924" height="1033" alt="image" src="https://github.com/user-attachments/assets/2eb4d1ab-d80a-46a7-8cbd-768692b7e435" />
<img width="1924" height="1033" alt="image" src="https://github.com/user-attachments/assets/e4c10d56-48ec-4432-96a4-6c330d27dd0f" />
<img width="1924" height="1033" alt="image" src="https://github.com/user-attachments/assets/b74cd6d7-f21a-4ee8-bf6b-50794154a0ab" />





More screenshots are [ available here ](https://github.com/santhosh7403/realworld-app-leptos-axum/blob/main/App_Screenshots.md)

---

### Sample User Data

The application is pre-populated with sample users and data for immediate testing and demonstration.

1.   Available Users: user1 to user5

2.   Password: The password is the same as the username (e.g., user1 has a password of user1).

To remove this default data, delete the basedata files within the `./migrations` folder and follow the database setup steps outlined in the [README_DATABASE.md](https://github.com/santhosh7403/realworld-app-leptos-axum-sqlite/blob/main/README_DATABASE.md).

---

### PostgreSQL Full Text Search

The application features a robust full-text search capability powered by PostgreSQL Full Text Search, which indexes three key fields from the `articles` table. For developers interested in the implementation or experimenting with different search methodologies, comprehensive documentation is available in the PostgreSQL [documentation here. ](https://www.postgresql.org/docs/17/textsearch.html)

Another blog post on [PostgreSQL Full Text Search](https://iniakunhuda.medium.com/postgresql-full-text-search-a-powerful-alternative-to-elasticsearch-for-small-to-medium-d9524e001fe0)


## 🙏 Inspiration and Acknowledgements

The foundational structure of this application is derived from the realworld example by [Bechma/realworld-leptos](https://github.com/Bechma/realworld-leptos), with appreciation to any antecedent projects.

This particular version was initiated during the transition from Leptos 0.6 to 0.7 as a personal learning exercise. It has since undergone significant experimentation and refinement, including:

*   A complete user interface redesign utilizing tailwindcss and fontawesome icons.

*   Implementation of modal windows and re-wired page navigation.

*   Integration of SQLite FTS5 for comprehensive full-text search capabilities.

*   An updated, non-reloading pagination method for search results
