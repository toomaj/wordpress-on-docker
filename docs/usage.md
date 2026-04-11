# Usage Guide

## Overview

This project uses a Docker-first WordPress workflow. WordPress runs in Docker, the database runs in Docker, WP-CLI runs inside the main WordPress runtime container, and phpMyAdmin is available for database access in the browser. The local repository owns the development-facing `wp-content` directories, while the official WordPress image provides the application runtime base.

## Prerequisites

- Docker installed
- Docker running
- `docker compose` available
- Bash available

## First-Time Setup

From the repository root:

```bash
./bin/up
```

What this does:

- Verifies Docker is installed and reachable
- Creates `.env` from `.env.example` if needed
- Ensures the local `wordpress/` mount directories exist
- Refreshes the bundled default themes and plugins from the current WordPress image
- Starts the database and WordPress services
- Starts phpMyAdmin

After startup, open:

```text
http://localhost:8080
```

phpMyAdmin is available at:

```text
http://localhost:8081
```

## Starting the Environment

Use:

```bash
./bin/up
```

This is the canonical way to start the WordPress runtime environment.

## Stopping the Environment

Use:

```bash
./bin/down
```

This stops the compose project cleanly and removes orphaned containers. It does not delete your source code, and it does not destroy the database volume.

## Running WP-CLI

Use:

```bash
./bin/wp <arguments>
```

The wrapper runs WP-CLI inside the main WordPress container against the local WordPress install and passes all arguments through as-is.

Example:

```bash
./bin/wp core version
```

## Passing Arbitrary Arguments Through the Wrapper

Anything after `./bin/wp` is passed directly to WP-CLI.

Examples:

```bash
./bin/wp plugin install query-monitor --activate
./bin/wp option get siteurl
./bin/wp user create editor editor@example.com --role=editor --user_pass=secret123
```

## Common Tasks

Check the WordPress core version:

```bash
./bin/wp core version
```

List installed plugins:

```bash
./bin/wp plugin list
```

List installed themes:

```bash
./bin/wp theme list
```

Read the home option:

```bash
./bin/wp option get home
```

List users:

```bash
./bin/wp user list
```

## How Local File Mounting Works

This repository uses a split storage model:

- WordPress core and generated runtime files live in a Docker volume at `/var/www/html`
- Development-owned `wp-content` directories are bind-mounted from the host
- `./bin/up` refreshes official bundled themes and plugins into the local bind mounts

The bind mounts are:

- `./wordpress/plugins` -> `/var/www/html/wp-content/plugins`
- `./wordpress/themes` -> `/var/www/html/wp-content/themes`
- `./wordpress/mu-plugins` -> `/var/www/html/wp-content/mu-plugins`
- `./wordpress/uploads` -> `/var/www/html/wp-content/uploads`

This keeps theme, plugin, mu-plugin, and upload files local where practical, while WordPress core stays in Docker inside the runtime container. It also keeps the default bundled themes and plugins aligned with the currently configured WordPress image.

## Accessing the Local WordPress Site

By default, the local site is available at:

```text
http://localhost:8080
```

If you change `WORDPRESS_PORT` in `.env`, use that port instead.

By default, phpMyAdmin is available at:

```text
http://localhost:8081
```

If you change `PHPMYADMIN_PORT` in `.env`, use that port instead.

## Troubleshooting

### Docker not running

Symptom:

```text
Docker is installed but not reachable
```

Fix:

- Start Docker Desktop on macOS
- Start the Docker daemon on Linux
- Run `docker info` to confirm Docker is reachable

### Port already in use

Symptom:

The WordPress container fails to start because port `8080` is already taken.

Fix:

- Change `WORDPRESS_PORT` in `.env`
- Run the environment again

Example:

```bash
sed -i.bak 's/^WORDPRESS_PORT=.*/WORDPRESS_PORT=8090/' .env
./bin/up
```

### File mount issues

Symptom:

Local plugin or theme changes are not visible in the container.

Fix:

- Confirm you are editing files under `./wordpress/plugins`, `./wordpress/themes`, or `./wordpress/mu-plugins`
- Run `docker compose ps`
- Restart the environment with `./bin/down` then `./bin/up`

### Database connection issues

Symptom:

WordPress shows a database connection error.

Fix:

- Confirm the `db` service is running:

```bash
docker compose ps
```

- Check that WordPress and database credentials in `.env` match
- Review container logs:

```bash
docker compose logs db
docker compose logs wordpress
```

### WordPress container not starting

Symptom:

The `wordpress` service exits or keeps restarting.

Fix:

- Check logs:

```bash
docker compose logs wordpress
```

- Confirm Docker can pull the configured images
- Confirm the configured local port is free
- Confirm the `db` service becomes healthy

## FAQ

### Do I need host PHP?

No. Use Docker and the project scripts only.

### Do I need Composer?

No. This project intentionally avoids Composer unless WordPress itself would require it.

### Where should I put plugins and themes?

Put them under `./wordpress/plugins` and `./wordpress/themes`.

### How do I run WP-CLI?

Use `./bin/wp ...`.

### Does `./bin/down` delete my database?

No. It stops the environment and leaves volumes intact.
