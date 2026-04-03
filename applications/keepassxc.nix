{ isWork, ... }:
{
  programs.keepassxc.enable = isWork;
}
