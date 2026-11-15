{ ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      inputs',
      ...
    }:
    let
      hookScripts = {
        pre-commit = pkgs.writeShellScript "pre-commit" ''
          format_staged_nix_files() {
            files=$(${pkgs.git}/bin/git diff --cached --name-only --diff-filter=ACMR -- '*.nix')
            [ -z "$files" ] && return 0
            ${pkgs.coreutils}/bin/echo "$files" | ${pkgs.findutils}/bin/xargs ${pkgs.nixfmt}/bin/nixfmt
            ${pkgs.coreutils}/bin/echo "$files" | ${pkgs.findutils}/bin/xargs ${pkgs.git}/bin/git add
          }
          format_staged_nix_files
        '';
        post-commit = pkgs.writeShellScript "post-commit" ''
          exec ${pkgs.git}/bin/git update-index -g
        '';
      };
      hooksDir = pkgs.linkFarm "git-hooks" (
        lib.mapAttrsToList (name: path: {
          inherit name path;
        }) hookScripts
      );
    in
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          nixfmt
          nixd
          inputs'.agenix.packages.default
        ];
        env = {
          GIT_CONFIG_COUNT = "1";
          GIT_CONFIG_KEY_0 = "core.hooksPath";
          GIT_CONFIG_VALUE_0 = hooksDir;
        };
      };
    };
}
