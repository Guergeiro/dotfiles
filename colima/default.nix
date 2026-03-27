{ config, pkgs, ... }:
{
  services.colima = {
    enable = true;
    # profiles.default = {
    #   isActive = true;
    #   isService = true;
    #   settings.autoActivate = true;
    #   settings.rosetta = true;
    #   settings.cpu = 12;
    #   settings.memory = 24;
    #   settings.vmType = "vz";
    #   settings.network.address = true;
    #   settings.nestedVirtualization = true;
    #   settings.sshConfig = false;
    # };
    profiles.default = {
      isActive = true;
      isService = true;
      settings = {
        cpu = 12;
        disk = 100;
        memory = 24;
        arch = "host";
        runtime = "docker";
        hostname = null;
        kubernetes = {
          enabled = false;
          version = "v1.33.3+k3s1";
          k3sArgs = [ "--disable=traefik" ];
          port = 0;
        };
        autoActivate = true;
        network = {
          address = true;
          mode = "shared";
          interface = "en0";
          preferredRoute = false;
          dns = [ ];
          dnsHosts = {
            "host.docker.internal" = "host.lima.internal";
          };
          hostAddresses = false;
        };
        forwardAgent = false;
        docker = { };
        vmType = "vz";
        portForwarder = "ssh";
        rosetta = true;
        binfmt = true;
        nestedVirtualization = true;
        mountType = "virtiofs";
        mountInotify = false;
        cpuType = "host";
        provision = [ ];
        sshConfig = false;
        sshPort = 0;
        mounts = [ ];
        diskImage = "";
        rootDisk = 20;
        env = { };
      };
    };
  };

  home.sessionVariables = {
    DOCKER_HOST = "unix://${config.home.homeDirectory}/.colima/default/docker.sock";

    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
  };

  # Colima-specific bash initialization
  programs.bash.initExtra = ''
    # Set TESTCONTAINERS_HOST_OVERRIDE dynamically from running Colima instance
    if ${pkgs.colima}/bin/colima status &> /dev/null; then
      export TESTCONTAINERS_HOST_OVERRIDE=$(${pkgs.colima}/bin/colima ls -j | ${pkgs.jq}/bin/jq -r '.address')
    fi
  '';
}
