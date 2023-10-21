{ inputs, ... }: {
  imports = [ inputs.pre-commit-hooks.flakeModule ];

  perSystem.pre-commit = {
    settings.hooks = {
      nixpkgs-fmt.enable = true;
      prettier.enable = true;
    };
  };
}
