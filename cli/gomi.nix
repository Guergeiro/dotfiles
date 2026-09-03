{
  pkgs,
  lib,
  ...
}:
let
  cleanScript = pkgs.writeShellScript "gomi-daily" ''
    ${pkgs.gomi}/bin/gomi --prune=orphans
    ${pkgs.gomi}/bin/gomi --prune=30d
  '';
in
{
  xdg.configFile."gomi/config.yaml" = {
    text = ''
      core:
        trash:
          strategy: xdg

      ui:
        density: compact
        preview:
          syntax_highlight: true
          colorscheme: dracula
    '';
    force = true;
  };

  home.shellAliases = {
    # Security stuff
    del = "${pkgs.gomi}/bin/gomi";
    rm = "${pkgs.coreutils}/bin/echo Use \"del\", or the full path i.e. \"/bin/rm\"";
  };

  home.packages = [
    pkgs.gomi
  ];

  # macOS (launchd)
  launchd.agents.gomi-daily-job = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [ "${cleanScript}" ];
      StartCalendarInterval = [
        {
          Hour = 12;
          Minute = 0;
        }
      ];
      StandardOutPath = "/tmp/gomi-daily-job.log";
      StandardErrorPath = "/tmp/gomi-daily-job.err.log";
    };
  };

  # NixOS / Linux (systemd)
  systemd.user.services.gomi-daily-job = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    Unit.Description = "gomi daily job";
    Service = {
      Type = "oneshot";
      ExecStart = "${cleanScript}";
    };
  };

  systemd.user.timers.gomi-daily-job = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    Unit.Description = "Run gomi daily job";
    Timer = {
      OnCalendar = "*-*-* 12:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
