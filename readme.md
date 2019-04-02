## Personal NixOS configs

This uses [Home Manager](https://github.com/rycee/home-manager) to manage (some)
dotfiles

### Usage
Symlink host file from `hosts/<hostname>.nix` to `configuration.nix`

```
export NIXHOST=<HOST NAME>

sudo sh <<SETUP
mv /etc/nixos /etc/nixos-orig
git clone https://gitlab.com/zick.kim/nixos/nixos-config.git /etc/nixos
cp /etc/nixos-orig/hardware-configuration.nix /etc/nixos
[ ! -e /etc/nixos/hosts/$NIXHOST.nix ] && mv /etc/nixos-orig/configuration.nix /etc/nixos/hosts/$NIXHOST.nix
ln -sr /etc/nixos/hosts/$NIXHOST.nix /etc/nixos/configuration.nix
SETUP
```

#### Nix Darwin
```
export NIXHOST=<HOST NAME>

nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
git clone https://gitlab.com/zick.kim/nixos/nixos-config.git ~/Nix
[ ! -e ~/Nix/hosts/$NIXHOST.nix ] && mv ~/.nixpkgs/darwin-configuration.nix ~/Nix/hosts/$NIXHOST.nix
ln -s ~/Nix/hosts/$NIXHOST.nix ~/Nix/configuration.nix
ln -sf ~/Nix/hosts/$NIXHOST.nix ~/.nixpkgs/darwin-configuration.nix
```

### Layout
- `cfgs/` - Package configurations
  - `cfgs/home` - [Home Manager](https://github.com/rycee/home-manager) configurations
- `hosts/` - Host specific configurations
- `options/` - Option files for custom packages
- `pkgs/` - Custom packages
- `presets/` - General shared configurations

### Debugging
Run `nix repl '<nixpkgs/nixos>'`, configuration results are under `config.*`

### Syncing
Assuming you have a separate local repository, and want to sync all refs in
order to push them

```
git checkout --detach
git fetch local '+refs/heads/*:refs/heads/*'
git push origin --all
git checkout master
```
