# AGENTS.md

Guidance for AI coding agents and contributors working on **orm4cf**. For the code architecture (services, criteria builders, ORM utilities), see [.github/copilot-instructions.md](.github/copilot-instructions.md).

## Origin

- orm4cf is a fork of [cborm](https://github.com/coldbox-modules/cborm) **5.1.0** by Ortus Solutions, maintained by the [modules4cf](https://github.com/modules4cf) contributors.
- It is **not affiliated with, sponsored by, or endorsed by Ortus Solutions, Corp**. ColdBox and cborm are Ortus trademarks; use those names only for attribution and technical references (such as the `cborm` module name), never as our own branding.

## License rules (Apache License 2.0)

- Keep `LICENSE` (the canonical Apache 2.0 text, unmodified) and `NOTICE`.
- Never remove existing Ortus copyright headers (`Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp`).
- When you modify a file that has an Ortus header, add this line directly under `www.ortussolutions.com` (once per file), as required by section 4(b):
  ```
   * Modified by the modules4cf contributors, 2026
  ```
- The "Origin and attribution" section in `readme.md` must stay.

## Versioning and changelog

- `box.json` `version` always holds the **plain next release version** (for example `5.2.0`), with no suffixes. The release workflow tags `v<version>`, finalizes the changelog, adds `+<build>` only to the packaged artifact, and then runs `box bump --minor`.
- Follow semver. Don't change the version in feature or fix PRs.
- `changelog.md` follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/). Add every user-facing change under `## [Unreleased]` in the matching subsection (`### Added`, `### Fixed`, ...).

## Internal module name stays `cborm`

The ForgeBox slug and the project name are `orm4cf`, but the module name, folder, mappings (`/cborm`, `cborm.models.*`), `moduleSettings.cborm` and WireBox IDs (`entityService@cborm`, `UniqueValidator@cborm`, ...) stay `cborm`. Renaming them would break every existing application and entity that extends `cborm.models.*`. Don't rename them unless a dedicated, planned breaking-change PR does so.

## Engines and tests

- Engines: BoxLang 1 (with and without CFML compat), Lucee 6 and 7 (Lucee's Hibernate ORM extension), Adobe ColdFusion 2023 and 2025. ColdBox 8.
- The CI matrix is in `.github/workflows/tests.yml` (called by `pr.yml` on every push to a non-main branch). `be` jobs are experimental and may fail.
- Run locally:
  1. `box run-script startdbs` (MySQL via `docker-compose.yml`), and copy `.env.template` to `.env`.
  2. `box run-script install:dependencies`
  3. `box server start serverConfigFile=server-<engine>.json` (for example `server-lucee@7.json`, `server-boxlang-cfml@1.json`)
  4. `box testbox run`, or open `/tests/runner.cfm`.
- `box run-script format` before committing. CI checks formatting.
- The test harness derives the module mapping from the folder name. The checkout folder must be named `cborm` (CI checks out into `cborm/`).
- Tests must never swallow exceptions or be skipped to get green. Fix the cause, or put engine-specific workarounds in `models/util/support/<Engine>ORMUtil.cfc`.

## Lucee notes

- Lucee is detected in `ORMUtilFactory` (`server.lucee` present and not BoxLang) and uses `LuceeORMUtil`.
- Lucee CI uses Lucee's own Hibernate ORM extension, pinned to an exact version via `env.LUCEE_EXTENSIONS` in `server-lucee@6.json` and `server-lucee@7.json` (`<extension id>;version=<version>`). Bump the pinned version manually when a new extension release comes out, in both files. Use Lucee's extension, not the older Ortus ORM extension.
- Lucee 6/7 log through Log4j 2, so `setupHibernateLogging` uses `org.apache.logging.log4j.core.config.Configurator`, not the Log4j 1 classes.

## CI caveats

- `release.yml` and `snapshot.yml` still target Ortus resources (S3 buckets `downloads.ortussolutions.com` / `apidocs.ortussolutions.com`, Ortus author email) and need `FORGEBOX_TOKEN`, AWS and Slack secrets that are not configured. Don't trigger releases until they are migrated.
- The JUnit report step can't create check runs on fork PRs ("Resource not accessible by integration"). That message alone is not a test failure.

## Pull requests

- One concern per PR (for example license, rebrand, engine support, a single fix), each with its tests.
- Branch from `main`, never force-push, and keep commit messages descriptive.
- Update the changelog and any affected docs in the same PR.
