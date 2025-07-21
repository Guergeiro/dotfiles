{ lib, starship-dracula, ... }:
let
  draculaPalette = builtins.fromTOML (builtins.readFile "${starship-dracula}/starship.toml");
in
{
  programs.starship = {
    enable = true;
    settings = lib.recursiveUpdate {
      add_newline = true;
      format = lib.concatStrings [
        "$hostname"
        "$shlvl"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$guix_shell"
        "$nix_shell"
        "$memory_usage"
        "$env_var"
        "$custom"
        "$sudo"
        "$line_break"
        "$jobs"
        "$container"
        "$shell"
        "$character"
      ];
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        read_only = " ";
        style = "bold blue";
      };
      git_branch = {
        symbol = " ";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "";
        stashed = "≡";
        untracked = "​";
        modified = "​";
        renamed = "​";
        deleted = "​";
        staged = "​";
      };
    } draculaPalette;
  };
}
