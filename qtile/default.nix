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
  home.file.".config/qtile/config.py" = {
    source = config.lib.file.mkOutOfStoreSymlink "${qtileDir}/config.py";
    force = true;
  };
}
