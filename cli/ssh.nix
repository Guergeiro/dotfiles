{
  sshConfig,
  lib,
  pkgs,
  config,
  nix-secrets,
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
      "${config.home.homeDirectory}/.colima/ssh_config"
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
          UserKnownHostsFile = "${config.home.homeDirectory}/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "${config.home.homeDirectory}/.ssh/master-%r@%n:%p";
          ControlPersist = "no";

          AddKeysToAgent = "yes";
        };
      }
    ];
  };

  home.file = lib.genAttrs [ "id_ed25519.pub" "sign_key.pub" ] (name: {
    source = "${nix-secrets}/${name}";
    target = "./.ssh/${name}";
    force = true;
  });

  programs.keychain = {
    enable = true;
    enableBashIntegration = true;
    keys = [
      config.age.secrets.id_ed25519.path
    ];
  };
}
