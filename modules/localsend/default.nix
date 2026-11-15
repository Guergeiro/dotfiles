{ ... }:
{
  flake.homeModules.localsend = { pkgs, ... }: {
    home.packages = with pkgs; [
      localsend
    ];
  };
}
