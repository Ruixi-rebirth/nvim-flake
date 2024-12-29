{
  description = "Ruixi-rebirth's NixVim configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixd.url = "github:nix-community/nixd";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    #plugins list
    avante-nvim = {
      url = "github:yetone/avante.nvim";
      flake = false;
    };
    lz-n = {
      url = "github:nvim-neorocks/lz.n";
      flake = false;
    };

  };

  outputs =
    inputs@{ self, ... }:
    let
      lazy-nvim-config = import ./config/lazy.nix;
      lz-nvim-config = import ./config;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./pre-commit-hooks.nix
      ];
      debug = true;
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      perSystem =
        {
          pkgs,
          system,
          config,
          ...
        }:
        let
          nixvimLib = inputs.nixvim.lib.${system};
          nixvim' = inputs.nixvim.legacyPackages.${system};
          lazynvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = lazy-nvim-config;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = lz-nvim-config;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.neovim-nightly-overlay.overlays.default
              inputs.nixd.overlays.default
            ];
          };
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNvim {
              nvim = nvim;
            };
            lazynvim = nixvimLib.check.mkTestDerivationFromNvim {
              nvim = lazynvim;
            };
          };
          packages = {
            default = nvim;
            nvim = nvim;
            lazynvim = lazynvim;
          };
          formatter = pkgs.nixfmt-rfc-style;
          devShells = {
            default = pkgs.mkShell {
              shellHook = ''
                ${config.pre-commit.installationScript}
              '';
            };
          };
        };
    };
}
