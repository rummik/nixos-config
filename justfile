# vim: set ft=just :

hostname := lowercase(`hostname -s`)
username := env_var('USER')
shell := env_var('SHELL')
pkgs := if os() == 'macos' { 'darwin' } else { 'nixos' }

set dotenv-load
set ignore-comments

nix_build_options := env_var_or_default('NIX_BUILD_OPTIONS', '')
overrides_options := env_var_or_default('OVERRIDES_OPTIONS', '')
nvfetcher_options := env_var_or_default('NVFETCHER_OPTIONS', '')

# Enable some experimental nix features without having to set them system-wide
# or in ~/.config/nix/nix.conf
export NIX_CONFIG := '
warn-dirty = false
accept-flake-config = true
extra-experimental-features = nix-command flakes repl-flake
max-jobs = auto
'

export RULES := absolute_path('./secrets/secrets.nix')

@_default:
  just --list --unsorted

# Start a nix development shell
@shell: (build-home) (_nix 'develop -c' shell)

# Simple wrapper around `nix`
[no-exit-message,no-cd]
@_nix COMMAND *ARGS:
  nix {{COMMAND}} {{ARGS}}

# Just + sudo + PATH passthrough
[private,no-exit-message]
@sudo COMMAND *ARGS:
  sudo PATH=$PATH just {{COMMAND}} {{ARGS}}

# Wrapper around `nix` that selectively disables inadvertent lockfile
# updates, and ensures inputs are read from the local flake
[no-exit-message]
nix COMMAND ACTION *ARGS: (
  _nix
    (COMMAND)
    (if COMMAND == 'run' { '--inputs-from .' } else { '' })
    (if COMMAND / ACTION =~ '^flake/(update|lock)$' { '' } else {
      '--no-update-lock-file --no-write-lock-file'
    })
    (ACTION)
    (ARGS)
)

# Generic builder
_nix-build PLATFORM TARGET ACTIVATOR *ARGS: (
  nix 'build'
    (nix_build_options)
    (overrides_options)
    '--print-build-logs'
    '--show-trace'
    '--verbose'
    '--out-link' ('result-' + PLATFORM + '-' + TARGET)
    (ARGS)
    ('.#' + PLATFORM + 'Configurations.' + ACTIVATOR)
)

# NixOS/Nix-Darwin toplevel builder
_build-toplevel PLATFORM *ARGS: (
  _nix-build (PLATFORM) (hostname) (hostname + '.config.system.build.toplevel') (ARGS)
)

[private]
rebuild ACTION *ARGS: (_nix_rebuild hostname pkgs ACTION ARGS)

[private]
target HOST ACTION *ARGS: (
  _nix_rebuild HOST pkgs ACTION
    '--use-remote-sudo'
    '--target-host' ('root@' + HOST)
    ARGS
)

# NixOS/Nix-Darwin rebuild
[no-exit-message]
_nix_rebuild HOST PLATFORM ACTION *ARGS: (
  nix 'run'
    (PLATFORM + '#' + PLATFORM + '-rebuild')
    '--'
    '--no-update-lock-file --no-write-lock-file'
    '--flake' ('.#' + HOST)
    ACTION
    '--fast'
    nix_build_options
    ARGS
)

_rebuild PLATFORM ACTION *ARGS: (build ARGS) (
  sudo '_nix_rebuild' hostname PLATFORM ACTION ARGS
)

_switch-to-configuration PLATFORM ACTION *ARGS: (build ARGS)
  sudo ./result-{{PLATFORM}}-{{hostname}}/bin/switch-to-configuration {{ACTION}} {{ARGS}}

# Home Manager builder
_build-home *ARGS: (
  _nix-build ('home') (username) (username + '@' + hostname + '.activationPackage') (ARGS)
)

# Build a NixOS/Nix-Darwin system
build *ARGS: (_build-toplevel pkgs ARGS)

dry-build *ARGS: (build ARGS '--dry-run')

# Switch currently running system
switch *ARGS: (_build-home '--no-link') (_rebuild pkgs 'switch' ARGS)

[linux]
boot *ARGS: (_build-home '--no-link') (_rebuild pkgs 'boot' ARGS)

# Search NixOS or Nix-Darwin packages
search *ARGS: (nix 'search' pkgs ARGS)

build-home *ARGS: (_build-home ARGS)
dry-build-home *ARGS: (build-home ARGS '--dry-run')
switch-home *ARGS: (_build-home ARGS)
  ./result-home-{{username}}/activate


# Agenix wrapper
[private,no-exit-message]
@agenix *ARGS:
  cd secrets && just nix run agenix -- {{ARGS}}

# Edit an Agenix secret
edit-secret SECRET: (agenix '-e' file_name(SECRET))

# Rekey Agenix secrets
rekey: (agenix '-r')


# Alias for `bootstrap-build bootstrap-write`
bootstrap: bootstrap-build bootstrap-write

# Build our bootstrap ISO image
bootstrap-build: (
  nix 'run' 'nixos-generators'
    '--'
    '--format install-iso'
    '--flake .#bootstrap'
    '--out-link result-iso'
)

# Write the bootstrap ISO image to a USB drive
bootstrap-write: (
  nix 'run' 'nixpkgs#bootiso'
    '--'
    './result-iso/iso/bootstrap.iso'
)

# Directory tree with .info annotations
@info: (
  nix 'run' 'nixpkgs#tree'
    '--'
    '--dirsfirst'
    '--gitignore'
    '--info'
    '--matchdirs'
    '--noreport'
    '-I nixos-disabled/'
    '-I screenshots/'
    '-F'
)
  # -F: Appends '/', '=', '*', '@', '|' or '>' as per ls -F
  # -I: Do not list files that match the given pattern

[private]
edit *ARGS: build-home
  ./result-home-{{username}}/home-path/bin/nvim \
    -u ./result-home-{{username}}/home-files/.config/nvim/init.lua \
    {{ARGS}}

_nvfetcher *ARGS: (
  nix 'run' 'nvfetcher'
    '--'
    nvfetcher_options
    '--config pkgs/sources.toml'
    '--build-dir pkgs/_sources'
    ARGS
)

[private]
@deploy HOST *ARGS: (
  nix 'run' 'deploy'
    '--'
    '--boot'
    '--skip-checks'
    '--checksigs'
    ('.#' + HOST)
    '--'
    nix_build_options
    overrides_options
)

# Update pkgs listed in pkgs/sources.toml
update-pkgs: _nvfetcher

# Update flake inputs
update-inputs: (nix 'flake' 'update') (nix 'flake' 'lock')

# Update inputs and pkgs
update: update-inputs update-pkgs

# Dry run for Home Manager and NixOS/Nix-Darwin
check: (nix 'flake' 'check')

# Lint and format Nix code
lint:
  @nix fmt

clean:
  #!/bin/sh
  for result in $(ls -d ./result* 2>/dev/null); do
    unlink $result
    echo removed "'$result'"
  done
