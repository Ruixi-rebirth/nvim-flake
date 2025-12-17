{
  description = "Ruixi-rebirth's NixVim configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-root.url = "github:srid/flake-root";
    nixpkgs.url = "github:NixOS/nixpkgs";
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
    minuet-ai-nvim = {
      url = "github:milanglacier/minuet-ai.nvim";
      flake = false;
    };
    blink-cmp.url = "github:saghen/blink.cmp";
    vim-translator = {
      url = "github:voldikss/vim-translator";
      flake = false;
    };
    none-ls-nvim = {
      url = "github:nvimtools/none-ls.nvim";
      flake = false;
    };
    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    copilot-cmp-nvim = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      lazy-nvim-config = import ./config/lazy.nix;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
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
        in
        {
          treefmt.config = {
            inherit (config.flake-root) projectRootFile;
            flakeCheck = true;
            settings = {
              global.excludes = [
                # "*.yml"
              ];
            };
            package = pkgs.treefmt;
            programs.prettier.enable = true;
            programs.stylua = {
              enable = true;
              settings = {
                indent_type = "Spaces";
                indent_width = 2;
              };
            };
            programs.nixfmt.enable = true;
          };

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowBroken = true;
            };
            overlays = [
              # inputs.neovim-nightly-overlay.overlays.default
              # (final: prev: {
              #   neovim-unwrapped =
              #     inputs.neovim-nightly-overlay.packages.${final.stdenv.hostPlatform.system}.default;
              # })
              inputs.nixd.overlays.default
            ];
          };
          checks = {
            # Run `nix flake check .` to verify config is not broken
            default = nixvimLib.check.mkTestDerivationFromNvim {
              name = "";
              nvim = lazynvim;
            };
          };
          packages = {
            default = lazynvim;
            lazynvim = lazynvim;
          };
          formatter = config.treefmt.build.wrapper;
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
