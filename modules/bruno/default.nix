{ ... }:
{
  flake.homeModules.bruno =
    { pkgs, host, ... }:
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
