let

  inherit (import ../channels) __nixPath;

in

import <nur> {
  repoOverrides.rummik = import <nur-rummik> {};
}
