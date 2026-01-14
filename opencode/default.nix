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
      mcp = {
        "astro-mcp-server" = {
          type = "remote";
          url = "https://mcp.docs.astro.build/mcp";
          enabled = true;
        };
      };
    };
  };
}
