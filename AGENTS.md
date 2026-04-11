# AGENTS

This repository is a minimal, Docker-first WordPress runtime project.

## Workflow rules for Codex

- Never rely on host PHP, host Composer, or host WordPress tooling.
- Always use the project scripts first:
  - `./bin/up`
  - `./bin/down`
  - `./bin/wp`
- Prefer Docker Compose based workflows over ad hoc Docker commands.
- Keep the project aligned with the official WordPress Docker image approach.
- The runtime image extends the official WordPress image only to expose `wp` on `PATH`.
- Do not introduce custom PHP builds, PHP version switching, Composer, or extra infrastructure unless WordPress itself strictly requires it.
- Do not add extra services such as phpMyAdmin, Redis, Mailhog, queues, or search services unless the current task explicitly requires them.
- Treat `compose.yaml` and the `bin/` scripts as the canonical local workflow.
- Update `README.md` and `docs/usage.md` whenever scripts, commands, or workflow expectations change.

## Practical notes

- The repository bind-mounts local development-owned `wp-content` directories into Docker.
- Use `./bin/wp ...` for all WP-CLI tasks so commands run against the Dockerized local site.
- Keep changes minimal, practical, and easy for a new developer to use immediately.
