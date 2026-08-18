{
  pkgs,
  isPersonal,
  ...
}:
let
  enable = pkgs.stdenv.hostPlatform.isLinux && isPersonal;
in
{
  programs.zapzap.enable = enable;
}
