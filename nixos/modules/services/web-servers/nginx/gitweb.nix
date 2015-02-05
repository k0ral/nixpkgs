{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx.gitweb;
  gitwebConfigFile = pkgs.writeText "gitweb.conf" ''
    $projectroot = "${cfg.projectRoot}";
    ${cfg.extraConfig}
  '';
in
{
  options.services.nginx.gitweb = {
    enable = mkEnableOption "gitweb in nginx";

    projectRoot = mkOption {
      default = "/srv/git";
      type = types.path;
      description = ''
        Path to git projects (bare repositories) that should be served by
        gitweb. Must not end with a slash.
      '';
    };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = "Verbatim configuration text appended to the generated gitweb.conf file.";
    };

    extraNginxConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Verbatim configuration text appended within the generated gitweb server section in nginx.conf file.";
    };

    serverName = mkOption {
      type = types.str;
      default = ''gitweb${if config.networking.domain == null then "" else ".${config.networking.domain}"}'';
      description = "Domain name associated to gitweb.";
    };

    accessLog = mkOption {
      type = types.path;
      default = "/var/log/gitweb";
      description = "Access log file.";
    };

    errorLog = mkOption {
      type = types.path;
      default = "/var/log/gitweb.error";
      description = "Error log file.";
    };

    fcgiwrapSocket = mkOption {
      type = types.path;
      default = "/run/fcgiwrap.sock";
      description = "Path to fcgiwrap socket.";
    };
  };

  config = mkIf cfg.enable {
    services.fcgiwrap.enable = true;
    services.nginx.enable = true;

    services.nginx.httpConfig = ''
      server {
        server_name ${cfg.serverName};
        root ${pkgs.git}/share/gitweb/;
        index gitweb.cgi;
        gzip off;
        access_log ${cfg.accessLog};
        error_log  ${cfg.errorLog};

        fastcgi_param GITWEB_CONFIG ${gitwebConfigFile};

        location ~ ".gitweb.cgi" {
            fastcgi_pass    unix:${cfg.fcgiwrapSocket};
        }

        ${cfg.extraNginxConfig}
      }
    '';
  };

}
