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
  };

  outputs = inputs@{ nixpkgs, nixvim, ... }:
    let
      nvim-config = import ./config;
      lazy-nvim-config = import ./config/lazy.nix;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./pre-commit-hooks.nix
      ];
      systems = ["x86_64-linux"];
      perSystem = { pkgs, system, config, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = nvim-config;
          };
          lazynvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = lazy-nvim-config;
          };
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.neovim-nightly-overlay.overlay
              inputs.nixd.overlays.default
            ];
          };
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "A nixvim configuration";
            };
          };
          packages = {
            default = nvim;
            nvim = nvim;
            lazynvim = lazynvim;
          };
          formatter = pkgs.nixpkgs-fmt;
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
