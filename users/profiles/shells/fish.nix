{ pkgs, ... }: {

  home.packages = [
    pkgs.babelfish
  ];

  programs.fish = {
    enable = true;

    interactiveShellInit = /* fish */ ''
      # set fish_vi_force_cursor
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
    '';

    functions = {
      fish_user_key_bindings = {
        body = /* fish */ ''
          # enable vi mode, and set the initial mode with `default` (command mode), `insert`, `visual`
          fish_vi_key_bindings insert

          # unbind some common emacs-style bindings
          for mode in default insert visual
            # clipboard
            bind -e -M $mode --preset \cx \cv
            # yank, kill-ring
            bind -e -M $mode --preset \cy \ey \cu \cw \ed
          end

          # bind ctrl-d to exit if the line is empty
          bind \cd 'set -l cmd (commandline); if test -z "$cmd"; commandline -f exit; end'
          bind -M insert \cd 'set -l cmd (commandline); if test -z "$cmd"; commandline -f exit; end'
          bind -M visual \cd 'set -l cmd (commandline); if test -z "$cmd"; commandline -f exit; end'

          # bind insert-mode ctrl-n/p to history search
          bind -M insert \cn down-or-search
          bind -M insert \cp up-or-search

          # bind insert-mode ctrl-a/e to beginning/end of line
          bind -M insert \ca 'beginning-of-line'
          bind -M insert \ce 'end-of-line'

          # bind insert-mode delete to delete-char; default fiddles with cursor position
          bind -M insert -k dc delete-char

          # bind insert-mode alt+l to complete autosuggestted line
          bind -M insert \el accept-autosuggestion
        '';
      };
    };

    plugins = let
      toFishPlugin = plugin: {
        inherit (plugin) name src;
      };

      genFishPlugins = plugins: map toFishPlugin plugins;
    in
      genFishPlugins (with pkgs.fishPlugins; [
        # colored-man-pages
        # done # may cause issues with stopping tasks?
        # grc
        # sponge
      ]);
  };
}
