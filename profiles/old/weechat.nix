{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [ weechat aspell aspellDicts.en ];

  nixpkgs.config.packageOverrides = pkgs: {
    weechat = pkgs.weechat.override {
      configure = { availablePlugins, ... }: {
        plugins = with availablePlugins; [
          perl
          tcl
          ruby
          guile
          lua

          (python.withPackages (ps:
            with ps; [
              websocket_client
              dbus-python
            ]))
        ];
      };
    };

    # angrily commenting this out until the weechat package is fixed and
    # reasonable again instead of the nonsense that got merged into master
    /*
    .overrideAttrs (old: rec {
    unwrapped = pkgs.weechat.unwrapped.overrideAttrs (oldAttrs: rec {
      version = "2.2";
      name = "weechat-${version}";

      src = builtins.fetchTarball {
        url = "http://weechat.org/files/src/weechat-${version}.tar.bz2";
        sha256 = "0adsnczsi74v7bqf2xd1n6y04rq0zrpqfy2gxqwxvq857ngsii47";
      };
    });
    });
    */
  };
}
