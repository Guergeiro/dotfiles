{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    bitwarden-cli
  ];

  programs.bash.initExtra = ''
    if [ -z "$BW_SESSION" ] && [ -z "$TMUX" ]; then
      read -p "Unlock Bitwarden? (y/n): " answer
      if [[ "$answer" =~ ^[Yy]$ ]]; then
        export BW_SESSION="$(${pkgs.bitwarden-cli}/bin/bw unlock --raw)"
      fi
    fi
  '';
}
