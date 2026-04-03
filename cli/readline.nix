{ ... }:
{
  programs.readline = {
    enable = true;
    variables = {
      completion-ignore-case = true;
      show-mode-in-prompt = true;
      editing-mode = "vi";
      blink-matching-paren = true;
      keyseq-timeout = 0;
    };
    extraConfig = ''
      $if mode=vi
        set keymap vi-insert
        TAB: menu-complete
        "\e[Z": menu-complete-backward
        "p": self-insert

        "\C-p": history-search-backward
        "\C-n": history-search-forward
        # alt dot cycles through last argument
        "\e.": yank-last-arg
        "\e\e": "\e0\C-ki"

        set keymap vi-command
        "u": undo
        "D": kill-line
        "dw": kill-word
        "dd": kill-whole-line
        "db": backward-kill-word
        "cc": "ddi"
        "cw": "dwi"
        "cb": "dbi"
        "diw": "lbdw"
        "yiw": "lbyw"
        "ciw": "lbcw"
        "diW": "lBdW"
        "yiW": "lByW"
        "ciW": "lBcW"
        "gg": beginning-of-history
        "G": end-of-history
        "\e\e": "\e0\C-ki"
      $endif
    '';
  };
}
