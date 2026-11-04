# not-secrets

[![ci](https://img.shields.io/github/actions/workflow/status/external-systems/not-secrets/ci.yml?branch=main&label=ci&logo=github)](https://github.com/external-systems/not-secrets/actions/workflows/ci.yml)
[![release](https://img.shields.io/github/v/release/external-systems/not-secrets?label=release&color=d97757)](https://github.com/external-systems/not-secrets/releases/latest)
[![docs](https://img.shields.io/website?url=https%3A%2F%2Fnot-secrets.external.systems%2F&label=docs&up_message=online&down_message=offline)](https://not-secrets.external.systems/)
[![license](https://img.shields.io/github/license/external-systems/not-secrets)](https://github.com/external-systems/not-secrets/blob/main/LICENSE)
[![built with Nix](https://img.shields.io/badge/built_with-Nix-5277C3?logo=nixos&logoColor=white)](https://nixos.org)

Public placeholder values for External Systems fleets, and the schema,
lib and guard checks that the private `external-systems/secrets` reuses.
Both flakes expose the same outputs, so a consumer pins this one and swaps
in the private one at deploy time:

```sh
clan machines update <machine> --flake . -- --override-input secrets github:external-systems/secrets
```

<iframe src="slides/index.html" title="Slide deck"
  style="width: 100%; aspect-ratio: 16 / 9; border: 0;"
  allowfullscreen></iframe>

## Outputs

| Output | What |
| --- | --- |
| `values` | The evaluated, type-checked attrset consumers read |
| `lib` | `addr`, `prefix`, `mkValues`, `shapeOf`, and the guard asserts |
| `schemaVersion` | Bumped on breaking shape changes |
| `modules.schema` | The schema as a plain module |
| `flakeModules.values` | Turns a `values/` directory into the outputs above |
| `flakeModules.checks` | The value guards, for a dev partition |

## Placeholders

Placeholders use documentation ranges only: IPv4 from RFC 5737, IPv6 from
RFC 3849 (`2001:db8::/32`), MACs from RFC 7042 and names under RFC 2606
(`example.com`, `.test`), and Hetzner Storage Box ids are all-zero
(`u000000`). `checks.placeholders-only` fails if anything else
lands here; in secrets, `checks.no-placeholders` fails the other way round.

Everything here ends up in the world-readable `/nix/store` of a deployed
machine. Credentials belong in clan vars, never in either repo.

## Checks

| Check | Fails when |
| --- | --- |
| `treefmt` | formatting or an org linter finding (alejandra, deadnix, statix, nixf-diagnose, shellcheck, sizelint) |
| `lock-sync` | `flake.lock`, `dev/flake.lock` and `devenv.lock` disagree on nixpkgs |
| `lib-tests` | a schema or guard eval test fails |
| `placeholders-only` | a value sits outside the documentation ranges |
| `documentation`, `slides` | the docs site or the deck stops building |
