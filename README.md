A near realworld leptos web app with axum postgres backend
=======
<picture>
    <source srcset="https://raw.githubusercontent.com/leptos-rs/leptos/main/docs/logos/Leptos_logo_Solid_White.svg" media="(prefers-color-scheme: dark)">
    <img src="https://raw.githubusercontent.com/leptos-rs/leptos/main/docs/logos/Leptos_logo_RGB.svg" alt="Leptos Logo">
</picture>


This is another Leptos demo application that I worked on as part of my learning Rust/Leptos and carrying out experiments. This one is little more complex  compared to the previously shared one [ demo-tools-app-leptos-07-actix-tailwind ](https://github.com/santhosh7403/demo-tools-app-leptos-07-actix-tailwind). I hope this code may help anyone who is seriously considering Leptos framework in their next project and wants a hands-on or a more real-world working example.

There also a sqlite version which has only few steps to run whereas postgres version (this one) has few more DB setup steps, though UI & function wise same. The sqlite version is [ here ](https://github.com/santhosh7403/realword-app-leptos-axum-sqlite)


Before proceeding to clone, you may take a look on the [ screenshots here ](https://github.com/santhosh7403/realword-app-leptos-axum/blob/main/App_Screenshots.md), that will give a quick good insight into this app and you can decide.



This app includes:<br/>
        Leptos<br/>
        axum<br/>
        SSR<br/>
        postgres<br/>
        Modal Windows<br/>
        uuid<br/>
        tailwindcss<br/>
        fontawesome icons<br/>

To test it out, clone the repo and run.

`git clone https://github.com/santhosh7403/realword-app-leptos-axum.git`

`cd realword-app-leptos-axum`

`source .env`  - export the environment variables to where cargo build going to run.

Now we need setup a database and initialize it. Please refer the [ DB readme ](https://github.com/santhosh7403/realword-app-leptos-axum/blob/main/README_DATABASE.md) for this step since it has multiple ways and you choose which one is appropriate and easy for you.


And the final build and run step, however, ensure rust toolchains and cargo-leptos are installed for that.<br/>

`cargo leptos watch`  or `cargo leptos serve`


# Rust toolchain
Above command expects rust toolchains and cargo-leptos are installed already, if you don't have cargo-leptos installed, you can install it with<br/>

`cargo install cargo-leptos --locked`

By default, `cargo-leptos` uses `nightly` Rust, `cargo-generate` etc. If you run into any trouble, you may need to install one or more of these tools. Please refer [ rustup here ](https://rustup.rs).

1. `rustup toolchain install nightly --allow-downgrade` - make sure you have Rust nightly
2. `rustup update` - update the rust toolchains to latest
3. `rustup target add wasm32-unknown-unknown` - add the ability to compile Rust to WebAssembly
4. `cargo install cargo-generate` - install cargo-generate binary

Now you may run the build.

  `cargo leptos watch`  or `cargo leptos serve`

# Application access

Once application started, access application from you web browser [ localhost:3000 ](http://localhost:3000/)

The application screen looks like this
<img width="1809" height="1030" alt="image" src="https://github.com/user-attachments/assets/f4ffb361-8bbd-488f-b64b-0ed67a2bbc07" />



More screenshots are [ available here ](https://github.com/santhosh7403/realword-app-leptos-axum/blob/main/App_Screenshots.md)



To showcase the app and test, some sample users and data are populated. User names 'user1' to 'user5' are available and password is same as username. In case if you want to remove this data, you may delete the 'basedata' files inside migrations folder before build and run (essentially do the `sqlx database reset` step in the README_databse).


# Inspiration and Thanks

The base of this app is from [ here ](https://github.com/Bechma/realworld-leptos), though there may be other original versions some where else, not sure.

I initially started this as leptos06 to 07 change in this app (though, above reference repo also seems updated now!) as my learning and got interest to try out more experiments. Overall user interface changed, some with modal windows, tailwindcss and fontawesome icons, re-wired pages, some functionality changes etc. Now looking to add the FTS (full text search) and so on.
