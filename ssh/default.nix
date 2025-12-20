{
  pkgs,
  hosts,
  lib,
  ...
}:
let
  matchBlocks = builtins.listToAttrs (
    map (host: {
      name = host.hostname;
      value = host;
    }) hosts
  );
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
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
