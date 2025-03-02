{ inputs, ... }:
{
  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem.pre-commit = {
    settings.excludes = [ "flake.lock" ];
    settings.hooks = {
      nixfmt.enable = true;
      prettier.enable = true;
    };
  };
}
