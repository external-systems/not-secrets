{
  description = "Public placeholder values for external-systems fleets — same schema and outputs as the private external-systems/secrets";

  inputs = {
    # Shared-input authority for the org: nixpkgs (only its lib is used
    # here) and flake-parts come from the artifact flake, so consumers
    # that already follow it lock nothing new. Named org-pkgs, never
    # pkgs: `pkgs` is the nixpkgs package set everywhere else.
    org-pkgs.url = "github:external-systems/pkgs";
    nixpkgs.follows = "org-pkgs/nixpkgs";
    flake-parts.follows = "org-pkgs/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      # Exposes debug.options / currentSystem.options, which nixd
      # (.vscode/settings.json) reads for flake-parts option hints.
      debug = true;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        # treefmt, docs + slides, lock-sync: everything from pkgs, so this
        # flake has no dev inputs and no dev partition.
        inputs.org-pkgs.flakeModules.default
        ./flakeModules/values.nix
        # The value guards (lib-tests, placeholders-only, ...).
        ./flakeModules/checks.nix
        ./documentation/flake-module.nix
      ];

      values = {
        dir = ./values;
        placeholder = true;
      };
    };
}
