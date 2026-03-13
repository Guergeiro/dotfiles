{
  config,
  pkgs,
  dotfilesDir,
  ...
}:
let
  qtileDir = "${dotfilesDir}/qtile/qtile";
in
{
  home.file.".config/qtile" = {
    source = config.lib.file.mkOutOfStoreSymlink "${qtileDir}/qtile/";
    recursive = true;
    force = true;
  };
}
