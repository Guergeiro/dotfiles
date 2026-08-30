{
  isWork,
  awsCli,
  lib,
  ...
}:
{
  programs.awscli = {
    enable = isWork;
    settings = lib.mkMerge [
      (lib.mapAttrs' (name: p: {
        name = "profile ${name}";
        value = {
          region = p.region;
          sso_account_id = p.account_id;
          sso_role_name = p.role;
          sso_session = "aws";
        };
      }) awsCli.profiles)
      {
        "sso-session aws" = {
          sso_start_url = awsCli.sso.start_url;
          sso_region = awsCli.sso.region;
          sso_registration_scopes = "sso:account:access";
        };
      }
    ];
  };
}
