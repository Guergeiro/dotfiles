{ ... }:
{
  flake.homeModules.aws =
    {
      pkgs,
      lib,
      host,
      ...
    }:
    let
      isWork = host.personal == false;
    in
    {
      home.packages =
        with pkgs;
        lib.mkIf isWork [
          bruno
        ];
    };
}
