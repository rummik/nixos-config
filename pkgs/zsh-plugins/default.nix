{
  lib,
  pkgs,
  sources,
}: let
  buildZshPlugin =
    { file ? null, name ? pname, pname ? null, script ? null,
      src ? pkgs.writeTextDir "${lib.getName name}.plugin.zsh" script, ... }:
    {
      src = toString src;
      name = lib.getName name;
      ${if isNull file then null else "file"} = toString file;
    };
in {
  themes.rummik = buildZshPlugin sources.zsh-theme-rummik;

  any-nix-shell = buildZshPlugin (with pkgs.any-nix-shell; {
    inherit pname;
    script = ''
      ${src}/bin/any-nix-shell zsh | source /dev/stdin
    '';
  });

  dug = buildZshPlugin sources.dug;
  fast-syntax-highlighting = buildZshPlugin sources.fast-syntax-highlighting;
  ing = buildZshPlugin sources.ing;
  isup = buildZshPlugin sources.isup;

  just-completions = buildZshPlugin (with pkgs.just; {
    name = "just-completions";
    script = ''
      path+=(${pkgs.just}/share/zsh/site-functions)
      fpath+=(${pkgs.just}/share/zsh/site-functions)
    '';
  });

  nix-zsh-completions = buildZshPlugin pkgs.nix-zsh-completions;
  please = buildZshPlugin sources.please;
  slowcat = buildZshPlugin sources.slowcat;
  tailf = buildZshPlugin sources.tailf;
  wakatime-zsh-plugin = buildZshPlugin sources.wakatime-zsh-plugin;
  zsh-autocomplete = buildZshPlugin sources.zsh-autocomplete;
  zsh-autosuggestions = buildZshPlugin sources.zsh-autosuggestions;
  zsh-completions = buildZshPlugin sources.zsh-completions;
  zsh-vi-mode = buildZshPlugin sources.zsh-vi-mode;
}
