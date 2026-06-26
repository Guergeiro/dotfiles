{
  lib,
  isPersonal,
  envVars,
  opencode-skills,
  opencode-dracula,
  ...
}:
let
  # TODO: Refactor to use the following:
  # lib.mkIf (lib.all (attr: envVars ? ${attr}) [ "JENKINS_URL" "JENKINS_USERNAME" "JENKINS_PASSWORD" ]) {

  mcpServers = lib.mkMerge [
    {
      "sequential" = {
        type = "local";
        command = [
          "docker"
          "run"
          "-i"
          "--rm"
          "--pull=always"
          "mcp/sequentialthinking:latest"
        ];
        enabled = true;
      };
      "context7" = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        enabled = true;
      };
      "astro" = {
        type = "remote";
        url = "https://mcp.docs.astro.build/mcp";
        enabled = isPersonal;
      };
      "gh_grep" = {
        type = "remote";
        url = "https://mcp.grep.app";
        enabled = true;
      };
    }
    (lib.mkIf (envVars ? JENKINS_URL && envVars ? JENKINS_USERNAME && envVars ? JENKINS_PASSWORD) {
      "jenkins" = {
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
      "sonar" = {
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
    themes = {
      dracula = builtins.fromJSON (builtins.readFile "${opencode-dracula}/dracula.json");
    };
    tui.theme = "dracula";
    skills = {
      tdd = "${opencode-skills.mattpocock}/skills/engineering/tdd";
      codebase-design = "${opencode-skills.mattpocock}/skills/engineering/codebase-design";
    };
    settings = {
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
