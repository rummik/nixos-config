{ config, ... }:

let
  acmeOptions = {
    useACMEHost = "www.rummik.com";
    forceSSL = true;
  };
in
  {
    security.acme.certs."www.rummik.com" = {
      email = "acme@9k1.us";

      extraDomains = {
        "pub.rummik.com" = null;
        "src.rummik.com" = null;
        "git.rummik.com" = null;
      };
    };

    services.nginx.virtualHosts."www.rummik.com" = acmeOptions // {
      default = true;
      enableACME = true;
      useACMEHost = null;
      serverAliases = [ "rummik.com" ];
      root = "/home/rummik/public_html";

      extraConfig = ''
        error_page 404 = /pub/404.html;

        rewrite ^/pub/((?!404.html).+) http://pub.rummik.com/$1;
        rewrite ^/(archives/.+) http://blg.rummik.com/$1;
      '';

      locations."~ ^/(demos|social|ping)".extraConfig = ''
        return 404;
      '';

    };

    services.nginx.virtualHosts."src.rummik.com" = acmeOptions // {
      serverAliases = [ "git.rummik.com" ];

      root = "/home/rummik/public_html/pub";

      extraConfig = ''
        error_page 404 = /404.html;
      '';

      locations."~ ^/(?!\.well-known|404)".extraConfig = ''
        rewrite ^/\.(.+) https://github.com/rummik/dotfiles/raw/master/.$1 last;
        rewrite ^/~ https://github.com/rummik last;
        rewrite ^((/[a-zA-Z0-9_-]+)+)? https://github.com/rummik$1 last;
      '';
    };

    services.nginx.virtualHosts."pub.rummik.com" = acmeOptions // {
      root = "/home/rummik/public_html/pub";

      extraConfig = ''
        error_page 404 = /404.html;
        rewrite ^/?$ https://www.rummik.com;
      '';

      locations."~ ^/.+".extraConfig = ''
        autoindex on;
      '';
    };
  }
