{
  pkgs,
  ...
}:
let
  adv360bt = {
    identifiers.is_keyboard = true;
    identifiers.vendor_id = 7504;
    identifiers.product_id = 24926;
    identifiers.is_pointing_device = true;
    ignore = false;
    ignore_vendor_events = true;
  };
  adv360 = {
    identifiers.is_keyboard = true;
    identifiers.vendor_id = 10730;
    identifiers.product_id = 866;
    identifiers.is_pointing_device = true;
    ignore = false;
    ignore_vendor_events = true;
  };

  internal = {
    identifiers.is_keyboard = true;
    simple_modifications = [
      {
        from.apple_vendor_top_case_key_code = "keyboard_fn";
        to = [
          {
            key_code = "left_control";
          }
        ];
      }
      {
        from.key_code = "left_control";
        to = [
          {
            apple_vendor_top_case_key_code = "keyboard_fn";

          }
        ];
      }
      {
        from.key_code = "non_us_backslash";
        to = [
          {
            key_code = "grave_accent_and_tilde";
          }
        ];
      }
    ];
  };
in

{
  xdg.configFile."karabiner/karabiner.json".enable = pkgs.stdenv.hostPlatform.isDarwin;
  xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON {
    global.check_for_updates_on_startup = false;
    profiles = [
      {
        name = "Default profile";
        selected = true;
        virtual_hid_keyboard = {
          country_code = 0;
          keyboard_type_v2 = "ansi";
        };
        devices = [
          adv360bt
          adv360
          internal
        ];

        complex_modifications = {
          rules = [
            {
              description = "Caps lock timeout rule";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "caps_lock";
                    modifiers = {
                      optional = [ "any" ];
                    };
                  };
                  to_if_alone = [
                    {
                      key_code = "escape";
                    }
                  ];
                  to_if_held_down = [
                    {
                      key_code = "caps_lock";
                    }
                  ];
                  parameters = {
                    "basic.to_if_alone_timeout_milliseconds" = 500;
                  };
                }
              ];
            }
          ];
        };
      }
    ];
  };
}
