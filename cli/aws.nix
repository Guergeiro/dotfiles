{
  isWork,
  awsCli,
  lib,
  ...
}:
{
  programs.awscli = {
    enable = isWork;
    settings = (
      lib.mapAttrs' (name: p: {
        name = "profile ${name}";
        value = {
          sso_region = awsCli.sso.region;
          sso_account_id = p.account_id;
          sso_role_name = p.role;
          sso_start_url = awsCli.sso.start_url;
          region = p.region;
        };
      }) awsCli.profiles
    );
  };
}
