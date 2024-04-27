## Ruixi-rebirth'nvim

My Neovim configuration uses [nixvim](https://github.com/nix-community/nixvim), with lazy loading handled by the plugin [lazy.nvim](https://github.com/folke/lazy.nvim).

[![Cachix Cache](https://img.shields.io/badge/cachix-ruixi_rebirth-blue.svg)](https://ruixi-rebirth.cachix.org) ![Build and populate cache](https://github.com/Ruixi-rebirth/nvim-flake/workflows/push_to_cachix/badge.svg)

### Flake Usage

- Temporarily use it in the terminal:

```console
nix run "github:Ruixi-rebirth/nvim-flake#lazynvim"
```

- Use as a package:

```nix
{
  inputs = {
    nvim-flake.url = "github:Ruixi-rebirth/nvim-flake";
  };

  outputs = inputs: {
    nixosConfigurations."my-laptop-hostname" =
    let system = "x86_64-linux";
    in nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [({pkgs, config, ... }: {
        config = {
          nix.settings = {
            # add binary caches
            trusted-public-keys = [
              "ruixi-rebirth.cachix.org-1:ypGqoIU9MfXwv/fE02ZGg8mutJqmcYHgLTR1DMoPGac="
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            ];
            substituters = [
              "https://ruixi-rebirth.cachix.org"
              "https://cache.nixos.org"
            ];
          };

          # pull specific packages (built against inputs.nixpkgs, usually `nixos-unstable`)
          environment.systemPackages = [
            inputs.nvim-flake.packages.${system}.lazynvim
          ];
        };
      })];
    };
  };
}
```
