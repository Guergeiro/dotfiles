{ host, lib, ... }:
let
  gradleProperties = host.gradle or { };
in
{
  programs.gradle = {
    enable = true;
    settings = lib.mkMerge [
      {
        "org.gradle.jvmargs" = "-Xmx2048m";
      }
      gradleProperties
    ];
  };
}
