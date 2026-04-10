# WordPress Docker Runtime

This project is a local WordPress runtime that runs entirely through Docker. It uses the official WordPress Docker image for the main application runtime, includes a database service, and adds phpMyAdmin for database access.

## Quick Start

```bash
./bin/up
```

Then open:

```text
http://localhost:8080
```

phpMyAdmin is available at:

```text
http://localhost:8081
```

If `.env` does not exist yet, `./bin/up` creates it from `.env.example`.

## Common Commands

```bash
./bin/up
./bin/down
./bin/wp core version
./bin/wp plugin list
./bin/wp theme list
```

## Local URL

The default local site URL is:

```text
http://localhost:8080
```

Change the port in `.env` if needed.

## Project Shape

- `compose.yaml` defines the Docker-first runtime.
- `wordpress:latest` is the default official WordPress runtime image.
- `mariadb:latest` is the default database service.
- `phpmyadmin:latest` is available for database inspection on a local port.
- WordPress core lives in a Docker volume shared by the runtime and WP-CLI containers.
- Local development-owned WordPress files are mounted from `./wordpress` into `wp-content` paths inside the container.

## Codex Expectations

- Use `./bin/up`, `./bin/down`, and `./bin/wp` before anything else.
- Do not rely on host PHP or host WordPress tools.
- Keep the stack aligned with the official WordPress Docker image approach.
- Update docs when the workflow changes.

Full day-to-day usage lives in [docs/usage.md](/Users/toomaj/Projects/wordpress-on-docker/docs/usage.md).
