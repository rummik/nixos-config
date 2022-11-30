# vim: set ft=just :

hostname := lowercase(`hostname -s`)
username := env_var('USER')
shell := env_var('SHELL')

set dotenv-load

nix_build_options := env_var_or_default('NIX_BUILD_OPTIONS', '')
nvfetcher_options := env_var_or_default('NVFETCHER_OPTIONS', '')

@_default:
  just --list --unsorted

# Start a nix development shell
@shell:
  nix develop -c {{shell}}

# Generic builder
_nix-build platform target activator *args:
  nix build \
    --no-update-lock-file \
    --no-write-lock-file \
    {{nix_build_options}} \
    --print-build-logs --show-trace --verbose \
    --out-link 'result-{{platform}}-{{target}}' \
    {{args}} \
    '.#{{platform}}Configurations.{{activator}}'

# NixOS/Nix-Darwin toplevel builder
_build-toplevel platform *args: (
  _nix-build (platform) (hostname) (hostname + '.config.system.build.toplevel') (args)
)

# NixOS/Nix-Darwin rebuild
_rebuild platform action *args: (build args)
  sudo {{platform}}-rebuild {{action}} --flake . {{nix_build_options}} {{args}}

# Home Manager builder
_build-home *args: (
  _nix-build ('home') (username) (username + '@' + hostname + '.activationPackage') (args)
)

# Build a NixOS system
[linux]
build *args: (_build-toplevel 'nixos' args)

# Build a Nix-Darwin system
[macos]
build *args: (_build-toplevel 'darwin' args)

dry-build *args: (build args '--dry-run')

# Switch currently running NixOS system
[linux]
switch *args: _build-home (_rebuild 'nixos' 'switch' args)

[linux]
boot *args: (_rebuild 'nixos' 'boot' args)

# Switch currenttly active Nix-Darwin system
[macos]
switch *args: (_rebuild 'darwin' 'switch' args)

build-home *args: (_build-home args)
dry-build-home *args: (build-home args '--dry-run')
switch-home *args: (_build-home args)
  ./result-home-{{username}}/activate

# Edit an Agenix secret
edit-secret secret:
  cd secrets && agenix -e {{file_name(secret)}}

# Rekey Agenix secrets
rekey:
  cd secrets && agenix -r


# Alias for `bootstrap-build bootstrap-write`
bootstrap: bootstrap-build bootstrap-write

# Build our bootstrap ISO image
bootstrap-build:
  @nix run nixos-generators \
    --inputs-from . \
    --no-update-lock-file \
    --no-write-lock-file \
    -- \
    --format install-iso \
    --flake '.#bootstrap' \
    --out-link result-iso

# Write the bootstrap ISO image to a USB drive
bootstrap-write:
  @nix run nixpkgs#bootiso \
    --inputs-from . \
    --no-update-lock-file \
    --no-write-lock-file \
    -- \
    ./result-iso/iso/bootstrap.iso

# Directory tree with .info annotations
@info:
  # -F: Appends '/', '=', '*', '@', '|' or '>' as per ls -F
  # -I: Do not list files that match the given pattern
  nix run nixpkgs#tree \
    --inputs-from . \
    --no-update-lock-file \
    --no-write-lock-file \
    -- \
    --dirsfirst \
    --gitignore \
    --info \
    --matchdirs \
    --noreport \
    -I nixos-disabled/ \
    -I screenshots/ \
    -F

_nvfetcher *args:
  nix run nvfetcher \
    --inputs-from . \
    --no-update-lock-file \
    --no-write-lock-file \
    -- \
    {{nvfetcher_options}} \
    --config pkgs/sources.toml \
    --build-dir pkgs/_sources \
    {{args}}

# Update pkgs listed in pkgs/sources.toml
update-pkgs: _nvfetcher

# Update flake inputs
update-inputs:
  nix flake update
  nix flake lock

# Dry run for Home Manager and NixOS/Nix-Darwin
check:
  nix flake check

# Lint and format Nix code
lint:
  @nix fmt

clean:
  #!/bin/sh
  for result in $(ls -d ./result* 2>/dev/null); do
    unlink $result
    echo removed "'$result'"
  done
