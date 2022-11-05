let

  inherit (import ./path.nix) __nixPath;

in

import <nur> {
  repoOverrides.rummik = import <nur-rummik> {};
}
