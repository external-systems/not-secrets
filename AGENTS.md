# AGENTS.md

Public placeholder values for external-systems fleets. This flake owns the
values schema, the lib and the guard checks; the private
external-systems/secrets imports them and supplies the real values. Both
must keep the same output shape, so a consumer can swap one for the other
with `--override-input`.

## Layout
- `flake.nix`: inputs (all follow external-systems/pkgs); imports `org-pkgs.flakeModules.default` (treefmt, docs and slides, lock-sync), `flakeModules/values.nix`, the guards and the docs settings. No dev partition.
- `flakeModules/values.nix`: turns `values/` into the `values`, `lib`, `modules.schema`, `schemaVersion` and `flakeModules` outputs. secrets imports it as `flakeModules.values`.
- `flakeModules/checks.nix`: the value guards; secrets imports it as `flakeModules.checks`.
- `schema/`, `lib/`: the schema module and pure helpers (`lib/tests.nix`: eval tests).
- `values/`: placeholders only (RFC 5737/3849/7042/2606 ranges, all-zero Storage Box ids).
- `documentation/`: MkDocs site (`docs/*.md`) and deck (`slides/slides.md`); `flake-module.nix` holds the `docs.*` settings (pkgs flakeModules.docs).
- `devenv.yaml` + `devenv.lock` + `devenv.nix`: the dev shell. The org shell comes from external-systems/pkgs (`org-pkgs/devenv` in devenv.yaml).

## Tool loop
- The shell is devenv. If `DEVENV_ROOT` is unset, run commands with `devenv shell -- <cmd>`.
- `git add` new files before any `nix` command.
- `fmt`, then `check`. Both must pass before a change is done.
- After `nix flake update org-pkgs`, run `sync-locks` in the same commit.

## Rules
- Load the `nix-style` skill before editing any `.nix` file.
- No dev-only inputs: formatting and docs come from org-pkgs (nix-style skill).
- Never put a real value here: `checks.placeholders-only` fails on anything outside the documentation ranges.
- A new host, link, network, domain, port or storage box lands here first, then in secrets (`checks.shape-parity`).
- Work on a branch and open a PR. Never push to `main`.
