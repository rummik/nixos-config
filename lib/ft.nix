let

  attrsList = list:
    builtins.listToAttrs (map (name: { inherit name; value = ""; }) list);

in

attrsList [
  "dosini"
  "nix"
  "sh"
  "tmux"
  "vim"
  "xf86conf"
  "zsh"
]
