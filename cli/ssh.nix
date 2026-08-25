{
  sshConfig,
  lib,
  sshKeys,
  pkgs,
  ...
}:
let
  settings = builtins.listToAttrs (
    map (config: {
      name = config.hostname;
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
          forwardAgent = false;
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";

          addKeysToAgent = "yes";
        };
      }
    ];
  };

  home.file = lib.mkMerge [
    sshKeys
  ];

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    keys = [
      "~/.ssh/id_ed25519"
    ];
  };
}
