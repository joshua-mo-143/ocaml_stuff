# Dream_service
An Ocaml web service built using the Dream framework.

Contains the following:
- A basic Docker Compose setup (can use with Postgres)
- A basic Dockerfile
- CRUD routes
- Separate module files
- Type definitions generated by atdgen (requires atdgen installed)
- Migration files

## How to use
To get started with this project, you'll need to do the following:
- Run the following shell snippet:

``` bash
opam install . --deps-only
opam install atdgen
opam install caqti_driver_postgresql
```
- Next, use `dune build` to make sure everything works
- Use `docker compose up` to start up the Postgres instance.

**Note that the migrations are not applied automatically.** You will need to use a DB migration tool to avoid Postgres-related errors. I use `sqlx-cli` (from Rust) as I already have it installed, but you can use your favourite tool.