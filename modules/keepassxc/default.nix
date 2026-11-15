{ ... }:
{
  flake.homeModules.keepassxc =
    { host, ... }:
    let
      isWork = host.personal == false;
    in
    {
      programs.keepassxc.enable = isWork;
    };
}
