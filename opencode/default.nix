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
        "astro" = {
          type = "remote";
          url = "https://mcp.docs.astro.build/mcp";
          enabled = true;
        };
        "gh_grep" = {
          type = "remote";
          url = "https://mcp.grep.app";
          enabled = true;
        };
        "terraform" = {
          type = "local";
          command = [
            "docker"
            "run"
            "-i"
            "--rm"
            "hashicorp/terraform-mcp-server:latest"
          ];
          enabled = true;
        };
        "hono" = {
          type = "remote";
          url = "https://hono.dev/llms.txt";
          enabled = true;
        };
      };
    };
  };
}
