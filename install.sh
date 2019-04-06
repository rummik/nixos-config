#!/bin/sh
export HOST
system=$(uname -s)

if [[ $system = "Darwin" ]]; then
  curl https://nixos.org/nix/install | sh
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer

  rm result

  : ${INSTALL_PATH=~/Nix}
  : ${SOURCE_PATH=~/.nixpkgs/darwin-configuration.nix}
fi

: ${INSTALL_PATH=/etc/nixos}

if [[ -d $INSTALL_PATH ]]; then
  mv $INSTALL_PATH $INSTALL_PATH-orig
  : ${SOURCE_PATH=$INSTALL_PATH-orig/configuration.nix}
  cp $INSTALL_PATH-orig/hardware-configuration.nix $INSTALL_PATH
fi

git clone https://gitlab.com/zick.kim/nixos/nixos-config.git $INSTALL_PATH
cd $INSTALL_PATH

if [[ ! -e ./hosts/$HOST.nix ]]; then
  cp $SOURCE_PATH ./hosts/$HOST.nix
fi

if [[ $system = "Darwin" ]]; then
  rm $SOURCE_PATH
  ln -sf configuration.nix $SOURCE_PATH
fi
