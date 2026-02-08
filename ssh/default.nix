{
  pkgs,
  sshConfig,
  lib,
  ...
}:
let
  matchBlocks = builtins.listToAttrs (
    map (config: {
      name = config.hostname;
      value = config;
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
    matchBlocks = lib.mkMerge [
      matchBlocks
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
}
