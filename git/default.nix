{
  pkgs,
  lib,
  gitConfig,
  ...
}:
{
  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      format = "ssh";
      key = "~/.ssh/sign_key.pub";
    };
    settings = {
      user.email = "git@brenosalles.com";
      user.name = "Breno Salles";
      commit.verbose = true;
      core.editor = "${pkgs.neovim}/bin/nvim";
      merge.tool = "diffconflicts";
      mergetool = {
        keepBackup = false;
        keepTemporaries = false;
        diffconflicts = {
          cmd = lib.concatStringsSep " " [
            "${pkgs.neovim}/bin/nvim"
            ''-c DiffConflicts "$MERGED" "$BASE" "$LOCAL" "$REMOTE"''
          ];
          trustExitCode = true;
        };
      };
      checkout.defaultRemote = "origin";
      diff.tool = "customdiff";
      difftool = {
        prompt = false;
        customdiff.cmd = lib.concatStringsSep " " [
          "${pkgs.neovim}/bin/nvim -R -f -d"
          "-c 'wincmd h'"
          ''-c 'cd $GIT_PREFIX' "$REMOTE" "$LOCAL"''
        ];
      };
    };
    includes = map (config: {
      condition = config.condition;
      contents = lib.mkMerge [
        { user.email = config.gitEmail; }
        (lib.mkIf (config ? signingKey) {
          user.signingKey = config.signingKey;
        })
      ];
    }) gitConfig;
  };
}
