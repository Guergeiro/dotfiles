{
  config,
  dotfilesDir,
  awesome-wm-widgets,
  ...
}:
let
  awesomeDir = "${dotfilesDir}/awesome/awesome";
in
{
  home.file.".config/awesome/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${awesomeDir}/.config/awesome/";
    recursive = true;
    force = true;
  };
  home.file.".config/awesome/awesome-wm-widgets/" = {
    source = config.lib.file.mkOutOfStoreSymlink awesome-wm-widgets;
    recursive = true;
    force = true;
  };
}
