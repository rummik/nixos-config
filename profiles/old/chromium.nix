{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    chromium
    #plasma-browser-integration
  ];

  nixpkgs.config.chromium = {
    #enablePepperFlash = true; # Because apparently it's not completely dead...
    #enableWideVine = true; # DRM nonsense
    pulseSupport = true;
  };

  environment.variables = {
    BROWSER = pkgs.lib.mkOverride 0 "chromium";
  };

  networking.firewall.allowedUDPPortRanges = [
    {
      from = 32768;
      to = 61000;
    }
  ];

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 8008;
      to = 8009;
    }
  ];

  networking.firewall.allowedUDPPorts = [
    1900
  ];

  programs.chromium = {
    enable = true;

    extensions = [
      "kpfdencgganfkljiacdcclkoohakjkjn" # KDE Breeze Theme
      #"cimiefiiaegbelhefglklhhakcgmhkai" # Plasma Integration

      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin - https://github.com/gorhill/uBlock
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium - https://github.com/philc/vimium
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere - https://github.com/EFForg/https-everywhere
      "klbibkeccnjlkjkiokjodocebajanakg" # The Great Suspender - https://github.com/deanoemcke/thegreatsuspender
      #      "mippmhcfjhliihkkdobllhpdnmmciaim" # Tab Master 5000 - https://github.com/jaszhix/tab-master-5000-extension
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey - https://github.com/Tampermonkey/tampermonkey
      #      "hhinaapppaileiechjoiifaancjggfjm" # Last.fm scrobbler - https://github.com/web-scrobbler/web-scrobbler
      #      "mjoedlfflcchnleknnceiplgaeoegien" # Isometric contributions - https://github.com/jasonlong/isometric-contributions
      "einpaelgookohagofgnnkcfjbkkgepnp" # Random User-Agent - https://github.com/tarampampam/random-user-agent
    ];

    extraOpts = {
      EnableMediaRouter = true;
      #ShowCastIconInToolbar = true;
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    chromium =
      (pkgs.chromium.override {
        # load-media-router-component-extension is required for Chromecast/Google Cast
        commandLineArgs = builtins.replaceStrings [ "\n" ] [ " " ] ''
          --load-media-router-component-extension=1
          --ignore-gpu-blacklist=1
          --enable-features=ViewsCastDialog
        '';
      })
      .overrideAttrs (oldAttrs: rec {
        buildInputs = with pkgs;
          oldAttrs.buildInputs
          ++ [
            #plasma-browser-integration
          ];
      });
  };
}
