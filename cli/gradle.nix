{ gradleProperties, lib, ... }:
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
