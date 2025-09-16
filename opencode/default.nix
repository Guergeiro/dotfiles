{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      theme = "system";
      autoshare = false;
      autoupdate = false;
      permission = {
        edit = "allow";
        bash = "allow";
      };
    };
  };
}
