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

  services.clipcat.enable = true;
  services.blueman-applet.enable = true;
  home.packages = with pkgs; [
    python3Packages.dbus-fast
    python3Packages.iwlib
    python3Packages.pulsectl-asyncio
    python3Packages.xdg
  ];
}
