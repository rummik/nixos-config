{ config, ... }:

let
  acmeOptions = {
    enableACME = true;
    onlySSL = true;
  };
in
  {
    services.nginx.virtualHosts."www.rummik.com" = acmeOptions // {
      default = true;
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

    services.nginx.virtualHosts."blg.rummik.com" = acmeOptions // {
      root = "/home/rummik/public_html/blog";

      extraConfig = ''
        error_page 404 = ../pub/404.html;
      '';
    };

    services.nginx.virtualHosts."src.rummik.com" = {
      serverAliases = [ "git.rummik.com" ];

      root = "/home/rummik/public_html/pub";

      extraConfig = ''
        error_page 404 = /404.html;
      '';

      locations."~ ^/(?!\.well-known)".extraConfig = ''
        rewrite ^/\.(.+) https://github.com/rummik/dotfiles/raw/master/.$1 last;
        rewrite ^/~ https://github.com/rummik last;
        rewrite ^((/[a-zA-Z0-9_-]+)+)? https://github.com/rummik$1 last;
      '';
    };

    services.nginx.virtualHosts."off.rummik.com" = acmeOptions // {
      root = "/home/rummik/public_html/social";
    };

    services.nginx.virtualHosts."dmo.rummik.com" = acmeOptions // {
      root = "/home/rummik/public_html/demos";

      extraConfig = ''
        autoindex on;
      '';
    };

    services.nginx.virtualHosts."pub.rummik.com" = {
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
