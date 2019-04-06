## *Kim's Personal NixOS configs

This uses [Home Manager](https://github.com/rycee/home-manager) to manage (some)
dotfiles

### Installing
```
# optionally set/export HOST to select a default host file
curl https://gitlab.com/zick.kim/nixos/nixos-config/raw/master/install.sh | sh
```

### Layout
- `cfgs/` - Package configurations
  - `cfgs/home` - [Home Manager](https://github.com/rycee/home-manager) configurations
- `hosts/` - Host specific configurations
- `options/` - Option files for custom packages
- `pkgs/` - Custom packages
- `presets/` - General shared configurations

### Debugging
Run `nix repl '<nixpkgs/nixos>'`, configuration results are under `config.*`,
reload with `:r`

Or use `nixos-option` to determine the current and default values for an option,
and view the option's description

### Syncing
Assuming you have a separate local repository, and want to sync all refs in
order to push them

```
git checkout --detach
git fetch local '+refs/heads/*:refs/heads/*'
git push origin --all
git checkout master
```
