{
  sshConfig,
  lib,
  pkgs,
  config,
  ...
}:
let
  settings = builtins.listToAttrs (
    map (config: {
      name = config.Hostname;
      value =
        let
          expandedAttrs = builtins.mapAttrs (
            key: value:
            if builtins.isString value then
              builtins.replaceStrings [ "cloudflared" ] [ "${pkgs.cloudflared}/bin/cloudflared" ] value
            else
              value
          ) config;
        in
        expandedAttrs;
    }) sshConfig
  );
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "~/.colima/ssh_config"
    ];
    settings = lib.mkMerge [
      settings
      {
        "*" = {
          ForwardAgent = false;
          Compression = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";

          AddKeysToAgent = "yes";
        };
      }
    ];
  };

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    keys = [
      config.age.secrets.id_ed25519.path
    ];
  };
}
