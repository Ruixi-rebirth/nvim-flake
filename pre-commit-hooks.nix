{ inputs, ... }:
{
  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem.pre-commit = {
    settings.excludes = [ "flake.lock" ];
    settings.hooks = {
      nixfmt-rfc-style.enable = true;
      prettier.enable = true;
    };
  };
}
