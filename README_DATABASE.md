
# Database steps

This App requires a postgres database. It can be your existing postgres instance or you may run in a container which can be done in few steps as described below.

# Existing postgres instance

If you have an existing postgres instance, then create a new database reflecting the 'DATABASE_URL' value in the .env file (inside root folder).

For example, currently the line in .env file is DATABASE_URL="postgres://postgres:mysecretpassword@localhost/postgres3".

In that, 'postgres:mysecretpassword' string is the username & password used to connect and '@localhost' is the hostname of the DB server where postgres is running listening on default port 5432. In case of a different port, you need to explicitly add it like this '@localhost:5444' where 5444 is the port number . And the last parameter 'postgres3' string is the database name. 

So, adjust the DATABASE_URL to reflect the correct parameters of your postgres instance.


# Postgres in a container.

It is easy pull a postgres container image and run a container using podman (a drop in replacement for docker) or docker.


`podman pull postgres:latest`  - pulls the latest postgres image from repo

`podman images`  - lists the images available - verify we have image.

    santhosh@fedora:~$ podman images
    REPOSITORY                  TAG         IMAGE ID      CREATED        SIZE
    docker.io/library/postgres  latest      fbd9a209d4e8  5 weeks ago    446 MB



`podman run -it --name my-postgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 postgres` - This command runs a container with name 'my-postgres' and sets an ENV variable POSTGRES_PASSWORD.
The DB user name ENV variable not set, since it takes the default user as 'postgres' if it is not set. if you want it non-default user for some reason, you may add another -e POSTGRES_USER=newuser to the above command.
The -p 5432:5432 sets the listening port in container and mapping it to the port of container running host, hence we can access it from host throgh this host port.
The last 'postgres' string in command selects the image name from which this container is created.

if more details of the conatiner image required, please refer [ here ](https://hub.docker.com/_/postgres)


If all goes well, container will be running as expected and you may verify like below

`podman ps -a`  - list all containers

    santhosh@fedora:~$ podman ps -a
    CONTAINER ID  IMAGE                              COMMAND     CREATED       STATUS                  PORTS                   NAMES
    3ce7ddc87857  docker.io/library/postgres:latest  postgres    2 weeks ago   Up 20 hours             0.0.0.0:5432->5432/tcp  my-postgres


# Additional steps (optional)

Though above steps are enough to run a DB to test this web app, adding sqlx-cli command-line utility will help to drop/create/reset the DB easily.

To install sqlx-cli, run below command. However, it all expects you have rust toolchains installed, refer the Rust toolchain section in main readme to install.

`cargo install sqlx-cli`  - this installs utility

Now move to the root folder i.e `cd realworld-app-leptos-07-axum` 

Then you may do the operations like 

`sqlx database drop`  - DB drop
`sqlx database create` - DB create
`sqlx database reset` - DB reset

This assumes you have the correct DATABASE_URL environment variable set on the terminal you opened. It can be set by running  `source .env` command from the project root folder.