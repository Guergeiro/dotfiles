{ inputs, self, ... }:
let
  hostname = "macbook";
  host = builtins.fromJSON (builtins.readFile "${inputs.nix-secrets}/${hostname}/host.json");
  standalone = true;
in
{
  flake.homeConfigurations.${hostname} = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = host.system; };
    modules = [
      self.homeModules.home
    ];
    extraSpecialArgs = {
      inherit
        inputs
        hostname
        host
        standalone
        ;
    };
  };
}
