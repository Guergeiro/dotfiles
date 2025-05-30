{ ... }:
{
  programs.readline = {
    enable = true;
    variables = {
      completion-ignore-case=true;
      show-mode-in-prompt=true;
      editing-mode="vi";
      blink-matching-paren=true;
      keyseq-timeout=0;
    };
  };
}
