# vim: set ft=just :

hostname := lowercase(`hostname -s`)
username := env_var('USER')
shell := env_var('SHELL')
host_platform := if os() == 'macos' { 'darwin' } else { 'nixos' }

set dotenv-load := true
set ignore-comments := true

nix_build_options := env_var_or_default('NIX_BUILD_OPTIONS', '')
nvfetcher_options := env_var_or_default('NVFETCHER_OPTIONS', '')

# Enable some experimental nix features without having to set them system-wide
# or in ~/.config/nix/nix.conf
export NIX_CONFIG := '
  warn-dirty = false
  # accept-flake-config = true
  extra-experimental-features = nix-command flakes repl-flake
  max-jobs = auto
'

export RULES := absolute_path('./secrets/secrets.nix')

@_default:
  just --list --unsorted

# Start a nix development shell
shell: (_nix 'develop -c' shell)

# Run a REPL with the specified flake loaded
repl FLAKE='.': (nix 'repl' FLAKE)

# Simple wrapper around `nix`
[no-exit-message,no-cd]
@_nix COMMAND *ARGS:
  nix {{COMMAND}} {{ARGS}}

# Just + sudo + PATH passthrough
## The `--set` parameter needs a space in there to avoid a bug in just where it
## thinks it's a flag if it begins with a dash
[private,no-exit-message]
@sudo COMMAND *ARGS:
  sudo PATH=$PATH just \
    --set nix_build_options ' {{nix_build_options}}' \
    --set nvfetcher_options ' {{nvfetcher_options}}' \
    {{COMMAND}} \
    {{ARGS}}

[no-exit-message]
@_activate-configuration PLATFORM TARGET ACTION *ARGS: (build ARGS)
  sudo ./result-{{PLATFORM}}-{{TARGET}}/bin/switch-to-configuration {{ACTION}} {{ARGS}}

[no-exit-message]
@_activate PLATFORM TARGET ACTION *ARGS:
  ./result-{{PLATFORM}}-{{TARGET}}/activate {{ACTION}} {{ARGS}}

# Wrapper around `nix` that selectively disables inadvertent lockfile
# updates, and ensures inputs are read from the local flake
[no-exit-message]
nix COMMAND ACTION='' *ARGS='': (
  _nix
    (if COMMAND / ACTION =~ 'flake/(update|lock)' {
      ''
    } else {
      '--accept-flake-config'
    })

    (COMMAND)

    (if COMMAND =~ 'flake|search' {
      ACTION
    } else {
      ''
    })
    (if COMMAND =~ 'run|shell|repl|flake|search' { '--inputs-from .' } else { '' })

    (if COMMAND / ACTION =~ 'show-config|help|profile|flake/(-|update|lock)' {
      ''
    } else {
      '--no-update-lock-file --no-write-lock-file'
    })

    (if COMMAND / ACTION =~ 'build/.*|flake/check' { nix_build_options } else { '' })
    (if COMMAND =~ 'flake|search' { '' } else { ACTION })

    (ARGS)
)

# Generic builder
_nix-build PLATFORM TARGET ACTIVATOR *ARGS: (
  nix 'build'
    '--print-build-logs'
    '--show-trace'
    '--verbose'
    '--no-eval-cache'
    '--out-link' ('result-' + PLATFORM + '-' + TARGET)
    (ARGS)
    ('.#' + PLATFORM + 'Configurations.' + ACTIVATOR)
)

# NixOS/Nix-Darwin toplevel builder
_build-toplevel PLATFORM *ARGS: (
  _nix-build (PLATFORM) (hostname) (hostname + '.config.system.build.toplevel') (ARGS)
)

[private]
rebuild ACTION *ARGS: (_nix-rebuild hostname host_platform ACTION ARGS)

[private]
target HOST ACTION *ARGS: (
  _nix-rebuild HOST host_platform ACTION
    '--use-remote-sudo'
    '--target-host' ('root@' + HOST)
    ARGS
)

# `nix profile` for your system profile
[private]
_nix-profile ACTION *ARGS: (
  nix 'profile' ACTION
    '--profile' '/nix/var/nix/profiles/system'
    ARGS
)

# NixOS/Nix-Darwin rebuild
_nix-rebuild HOST PLATFORM ACTION *ARGS: (
  nix 'run'
    (PLATFORM + '#' + PLATFORM + '-rebuild')
    '--'
    '--flake' ('.#' + HOST)
    ACTION
    '--fast'
    nix_build_options
    ARGS
)

_rebuild PLATFORM ACTION *ARGS: (build '--no-link' ARGS) (
  sudo '_nix-rebuild' hostname PLATFORM ACTION ARGS
)

# NixOS/Nix-Darwin rebuild
_nix-install HOST PLATFORM *ARGS: (
  nix 'shell'
    (PLATFORM + '#' + PLATFORM + '-install-tools')
    '-c' 'nixos-install'
      '--root' '/mnt'
      '--show-trace'
      '--no-root-password'
      '--flake' ('.#' + HOST)
      nix_build_options
      ARGS
)

_install HOST *ARGS: (
  sudo '_nix-install' HOST host_platform ARGS
)

# Home Manager builder
_build-home *ARGS: (
  _nix-build 'home' (username) (username + '@' + hostname + '.activationPackage') ARGS
)

# Build a NixOS/Nix-Darwin system
build *ARGS: (_build-toplevel host_platform ARGS)

# Dry run for Home Manager and NixOS/Nix-Darwin
dry-build *ARGS: (build ARGS '--dry-run')

# Switch currently running system
switch *ARGS: (_build-home '--no-link') (_rebuild host_platform 'switch' ARGS)

[linux]
boot *ARGS: (_build-home '--no-link') (_rebuild host_platform 'boot' ARGS)

# Search NixOS or Nix-Darwin packages
search *ARGS: (nix 'search' host_platform ARGS)

build-home *ARGS: (_build-home ARGS)
dry-build-home *ARGS: (build-home ARGS '--dry-run')
switch-home *ARGS: (_build-home ARGS)
  ./result-home-{{username}}/activate


# Agenix wrapper
[private,no-exit-message]
agenix *ARGS:
  cd secrets && just nix run agenix -- {{ARGS}}

# Edit an Agenix secret
[no-cd]
edit-secret FILE:
  VIMINIT="set noeol nofixeol|source ~/.config/nvim/init.lua" \
    just agenix -e "{{replace(absolute_path(FILE), (justfile_directory() + '/secrets/'), '')}}"

# Rekey Agenix secrets
rekey *ARGS: (agenix '-r' ARGS)


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
info: (
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

[private]
deploy HOST *ARGS: (
  nix 'run' 'deploy'
    '--'
    '--boot'
    '--skip-checks'
    '--checksigs'
    ('.#' + HOST)
    '--'
    nix_build_options
)

# Disko wrapper
[private]
disko *ARGS: (
  nix 'run' 'disko'
    '--'
    '--show-trace'
    '--dry-run'
    '--debug'
    '--flake' ('git+file:.#' + hostname)
    ARGS
)

[private]
cachix *ARGS: (
  nix 'run' 'cachix'
    '--'
    ARGS
)

# nvfetcher wrapper
[private]
nvfetcher *ARGS: (
  nix 'run' 'nvfetcher'
    '--'
    nvfetcher_options
    '--config pkgs/sources.toml'
    '--build-dir pkgs/_sources'
    ARGS
)

# Update pkgs listed in pkgs/sources.toml
update-pkgs: nvfetcher

# Update flake inputs
update-inputs: (nix 'flake' 'update' '--commit-lock-file')

update-missing-inputs: (nix 'flake' 'lock' '--commit-lock-file')

# Update inputs and pkgs
update: update-inputs update-pkgs

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
