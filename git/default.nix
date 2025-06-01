{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    userEmail = "git@brenosalles.com";
    userName = "Breno Salles";
    signing = {
      signByDefault = true;
      format = "ssh";
      key = "~/.ssh/SignKey.pub";
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
