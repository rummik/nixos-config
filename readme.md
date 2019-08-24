## *Kim's personal NixOS configs

Makes use of [Home Manager](https://github.com/rycee/home-manager) to manage
dotfiles

Also works under [Nix-Darwin](https://github.com/LnL7/nix-darwin)

Maybe useful to others?  There are shenanigans in `configuration.nix`, and some
of the `default.nix` files -- primarily when dealing with imports, and platform
specifics

It also includes some slightly unconventional Nix syntax adjustments to hack in
fenced syntax highlighting within strings

### Layout
- `channels/` - Pinned channels
- `config/` - Package configurations
  - `config/home-manager` - [Home Manager](https://github.com/rycee/home-manager) configurations
- `hosts/` - Host specific configurations
- `modules/` - Custom  modules
- `overlays/` - Package overlays
- `profiles/` - Configuration profiles

### Debugging
Run `nix repl '<nixpkgs/nixos>'`, configuration results are under `config.*`,
reload with `:r`

Or use `nixos-option` to determine the current and default values for an option,
and view the option's description

Alternatively use `nix repl '<darwin>'`, or `darwin-option` if using nix-darwin

### Fenced syntax highlighting

The selection of fenced languages is over at [config/neovim.nix](config/neovim.nix)

![Tmux syntax highlighting in Vim](screenshots/tmux.png)
