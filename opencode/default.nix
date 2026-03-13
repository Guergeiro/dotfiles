{
  pkgs,
  lib,
  isPersonal,
  isWork,
  envVars,
  ...
}:
let
  mcpServers = lib.mkMerge [
    {
      "astro_mcp_server" = {
        type = "remote";
        url = "https://mcp.docs.astro.build/mcp";
        enabled = isPersonal;
      };
      "gh_grep" = {
        type = "remote";
        url = "https://mcp.grep.app";
        enabled = true;
      };
      "terraform_mcp_server" = {
        type = "local";
        command = [
          "docker"
          "run"
          "-i"
          "--rm"
          "--pull=always"
          "hashicorp/terraform-mcp-server:latest"
        ];
        enabled = isWork;
      };
      "hono_mcp_server" = {
        type = "remote";
        url = "https://hono.dev/llms.txt";
        enabled = isPersonal;
      };
    }
    (lib.mkIf (envVars ? JENKINS_URL && envVars ? JENKINS_USERNAME && envVars ? JENKINS_PASSWORD) {
      "jenkins_mcp_server" = {
        type = "local";
        command = [
          "docker"
          "run"
          "-i"
          "--rm"
          "--pull=always"
          "-e"
          "JENKINS_URL"
          "-e"
          "JENKINS_USERNAME"
          "-e"
          "JENKINS_PASSWORD"
          "artifactory.boschdevcloud.com/sh-docker-local/mcp-jenkins:latest"
        ];
        environment = {
          JENKINS_URL = envVars.JENKINS_URL;
          JENKINS_USERNAME = envVars.JENKINS_USERNAME;
          JENKINS_PASSWORD = envVars.JENKINS_PASSWORD;
        };
        enabled = true;
      };
    })
    (lib.mkIf (envVars ? SONARQUBE_TOKEN && envVars ? SONARQUBE_URL) {
      "sonar_mcp_server" = {
        type = "local";
        command = [
          "docker"
          "run"
          "-i"
          "--rm"
          "--pull=always"
          "--init"
          "-e"
          "SONARQUBE_TOKEN"
          "-e"
          "SONARQUBE_URL"
          "mcp/sonarqube:latest"
        ];
        environment = {
          SONARQUBE_TOKEN = envVars.SONARQUBE_TOKEN;
          SONARQUBE_URL = envVars.SONARQUBE_URL;
        };
        enabled = true;
      };
    })
  ];
in
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
      mcp = mcpServers;
    };
  };
}
