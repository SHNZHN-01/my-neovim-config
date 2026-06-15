# flake.nix
#
# A standalone flake exposing your custom Neovim build, structured with
# flake-parts so it composes cleanly with the rest of your dendritic setup.
#
# It exposes three things to consumers:
#
#   1. packages.<system>.neovim-shnzhn  -> `nix run`, `nix build`, direct refs
#   2. overlays.default                 -> inject `neovim-shnzhn` into any pkgs
#   3. nixosModules.default             -> "just give me the editor" module
#
{
  description = "Self-contained Neovim with plugins, packaged via flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      # flake-parts only needs nixpkgs' lib; pin it to *our* nixpkgs so the
      # lockfile doesn't carry a second nixpkgs revision around.
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    # mkFlake evaluates a flake-parts "module tree" and produces the final
    # flake outputs attrset. `inherit inputs` makes `inputs` (and therefore
    # `inputs.self`) available to every module in the tree.
    flake-parts.lib.mkFlake { inherit inputs; } {
      # The systems for which `perSystem` will be instantiated. Each entry
      # becomes a key under packages.<system>, devShells.<system>, etc.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # ----------------------------------------------------------------- #
      # Per-system outputs                                                 #
      # ----------------------------------------------------------------- #
      # `perSystem` is flake-parts' abstraction over the
      # `packages.x86_64-linux = ...; packages.aarch64-linux = ...;`
      # boilerplate. The function below runs once per entry in `systems`,
      # with `pkgs` already imported for that system.
      perSystem =
        {
          pkgs,
          self',
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          packages = {
            # callPackage auto-wires the arguments of ./neovim.nix
            # (symlinkJoin, neovim-unwrapped, vimPlugins, ...) from `pkgs`.
            # The empty {} is the override set — consumers can do
            #   neovim-shnzhn.override { neovim-unwrapped = ...; }
            # later thanks to callPackage's makeOverridable wrapping.
            neovim-shnzhn = pkgs.callPackage ./neovim.nix { src = inputs.self; };

            # `nix run <this-flake>` / `nix build <this-flake>` with no
            # attribute path resolves to `default`.
            default = inputs.self.packages.${pkgs.system}.neovim-shnzhn;
          };
        };

      # ----------------------------------------------------------------- #
      # System-independent outputs                                         #
      # ----------------------------------------------------------------- #
      # Everything under `flake.` is passed through verbatim to the final
      # flake outputs (no per-system fan-out).
      flake = {
        # Overlay: lets a consumer graft `neovim-shnzhn` into their own
        # nixpkgs instance, so it inherits *their* nixpkgs pin, config
        # (allowUnfree, etc.) and any other overlays they apply.
        #
        # `final.callPackage` (rather than `prev`) means our package picks
        # up the fully-overlaid package set — e.g. if the consumer also
        # overlays neovim-unwrapped, we build against their version.
        overlays.default = final: _prev: {
          neovim-shnzhn = final.callPackage ./neovim.nix { src = inputs.self; };
        };

        # Convenience NixOS module. Importing it:
        #   * applies the overlay to the host's nixpkgs
        #   * installs the editor system-wide
        #
        # Note: `inputs` here is captured lexically from the outer
        # `outputs = inputs @ {...}` binding — the module itself only takes
        # the standard NixOS module args.
        nixosModules.default = { pkgs, ... }: {
          nixpkgs.overlays = [ inputs.self.overlays.default ];
          environment.systemPackages = [ pkgs.neovim-shnzhn ];
        };
      };
    };
}
