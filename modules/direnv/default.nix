{ ... }:
{
  flake.homeModules.direnv = { ... }: {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
