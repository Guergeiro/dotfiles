{
  pkgs,
  isPersonal,
  config,
  ...
}:
let
  enable = pkgs.stdenv.hostPlatform.isLinux && isPersonal;
in
{
  programs.zapzap = {
    enable = enable;
    settings = {
      notifications = {
        app = true;
        donation_message = false;
        show_msg = true;
        show_name = true;
        show_photo = true;
        sound = true;
      };
      performance = {
        js_memory_limit_index = 0;
        js_memory_limit_mb = 0;
      };
      on_boarding.initial_setup_completed = true;
      permissions = {
        "auto_grant\\camera" = false;
        "auto_grant\\camera_microphone" = false;
        "auto_grant\\microphone" = false;
        "auto_grant\\screen_contents" = false;
        "auto_grant\\screen_contents_audio" = false;
      };
      system = {
        confirm_on_close = false;
        download_path = "${config.home.homeDirectory}/Downloads";
        interface_language = "system";
        notificationCounter = true;
        quit_in_close = true;
        scale = 100;
        start_background = false;
        start_system = false;
        theme = "auto";
        sidebar = false;
        tray_icon = false;
        wayland = true;
      };
      website.open_page = false;
    };
  };
}
