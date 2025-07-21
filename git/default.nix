{
  pkgs,
  lib,
  gitEmail,
  ...
}:
{
  programs.git = {
    enable = true;
    userEmail = gitEmail;
    userName = "Breno Salles";
    signing = {
      signByDefault = true;
      format = "ssh";
      key = "~/.ssh/sign_key.pub";
    };
    extraConfig = {
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
  };
}
