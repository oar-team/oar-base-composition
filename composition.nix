{ pkgs, modulesPath, nur, helpers,flavour, ... }: {
  dockerPorts.frontend = [ "8443:443" "8000:80" ];
  nodes =
    let
      commonConfig = import ./common_config.nix { inherit pkgs modulesPath nur flavour; };
    in {
      frontend = { ... }: {
        imports = [ commonConfig ];

        services.oar.client.enable = true;
        services.oar.web.enable = true;
        services.oar.web.drawgantt.enable = true;
        services.oar.web.monika.enable = true;
      };

      server = { ... }: {
        imports = [ commonConfig ];
        services.oar.server.enable = true;
        services.oar.dbserver.enable = true;
      };

      node = { ... }: {
        imports = [ commonConfig ];
        services.oar.node = { enable = true; };
      };
    };

  rolesDistribution = { node = 3; };
  testScript = ''
    frontend.succeed("true")
  '';
}
