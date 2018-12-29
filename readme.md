## Personal NixOS configs

This uses [Home Manager](https://github.com/rycee/home-manager) to manage (some)
dotfiles

### Usage
Symlink host file from `hosts/<hostname>.nix` to `configuration.nix`

```
export NIXHOST=<HOST NAME>

sudo sh <<SETUP
mv /etc/nixos /etc/nixos-orig
git clone https://gitlab.com/zick.kim/nixos/nixos-config /etc/nixos
cp /etc/nixos-orig/hardware-configuration.nix /etc/nixos
[ ! -e hosts/$NIXHOST.nix ] && mv /etc/nixos-orig/configuration.nix /etc/nixos/hosts/$NIXHOST.nix
ln -sr /etc/nixos/hosts/$NIXHOST.nix /etc/nixos/configuration.nix
SETUP
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
