{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.zsh.nvm;
  pkg = pkgs.nvm;
in
  {
    options = {
      programs.zsh.nvm = {
        enable = mkOption {
          default = false;
          description = ''
            Enable nvm.
          '';
        };

        enableForRoot = mkOption {
          default = false;
          description = ''
            Enable nvm for root.
          '';
        };

        autoUse = mkOption {
          default = false;
          description = ''
            Automatically call `nvm use` when entering a directory with a .nvmrc file.
          '';
        };

        buildFromSource = mkOption {
          default = true;
          description = ''
            Build from source when installing instead of using prebuilt binaries.
          '';
        };

        enableCompletion = mkOption {
          default = true;
          description = ''
            Enable argument completion.
          '';
        };

        force32Bit = mkOption {
          default = false;
          description = ''
            Use 32-bit Node.js on a 64-bit system.
          '';
        };

				package = mkOption {
					default = pkg;
				};
      };
    };

    config = mkIf cfg.enable {
      fileSystems."lib" = {
        options = [ "bind" ];
        fsType = "bind";
        device = pkgs.pkgsi686Linux.glibc + "/lib";
        mountPoint = "/lib";
      };

      fileSystems."lib64" = {
        options = [ "bind" ];
        fsType = "bind";
        device = pkgs.glibc + "/lib64";
        mountPoint = "/lib64";
      };

      programs.zsh.interactiveShellInit = with builtins; /* zsh */ ''
        ${optionalString (!cfg.enableForRoot) /* zsh */ ''
          if [[ $USER != 'root' || $NVM_ENABLE_ROOT = 'yes' ]]; then
        ''}

        LDFLAGS="$NVM_LDFLAGS $LDFLAGS" \
        CPPFLAGS="$NVM_CPPFLAGS $CPPFLAGS" \
        LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NVM_LD_LIBRARY_PATH \
        PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$NVM_PKG_CONFIG_PATH \
          source ${cfg.package}/share/nvm/nvm.sh

        # this is quite gross
        function _nnw-wrap {
          local name="$1" code="$2"

          eval "
            ''${code:+function __nnw_orig-$(functions $name)}

            function $name {
              $code
              nnw_set_prefix=1 _nnw-exec \
                ''${''${code:+__nnw_orig-$name}:-command $name} \$@
            }
          "
        }

        function _nnw-exec {
          if [[ $nnw_set_prefix -eq 1 ]]; then
            local nnw_set_prefix=0

            if [[ ! -v npm_config_prefix ]]; then
              local version=$(_nnw-exec command node --version)
              local npm_config_prefix=$(nvm_version_path $version)
            fi

            npm_config_prefix=$npm_config_prefix _nnw-exec $@
          else
            local env
            local nnw_set_path=''${nnw_set_path:-1}

            if [[ $1 == 'command' ]]; then
              shift
              env=env
            fi

            if [[ $nnw_set_path -eq 0 ]]; then
              LDFLAGS="$NVM_LDFLAGS $LDFLAGS" \
              CPPFLAGS="$NVM_CPPFLAGS $CPPFLAGS" \
              LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NVM_LD_LIBRARY_PATH \
              PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$NVM_PKG_CONFIG_PATH \
                $env $@
            else
              LDFLAGS="$NVM_LDFLAGS $LDFLAGS" \
              CPPFLAGS="$NVM_CPPFLAGS $CPPFLAGS" \
              LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NVM_LD_LIBRARY_PATH \
              PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$NVM_PKG_CONFIG_PATH \
              PATH=$PATH:$NVM_PATH \
                $env $@
            fi
          fi
        }

        if functions nvm >/dev/null; then
          _nnw-wrap nvm $'
            local nnw_set_path=0
            local npm_config_prefix
            if [[ $1 == "use" ]]; then
              npm_config_prefix=$(nvm_version_path $(nvm_match_version $2))
            fi
          '
        fi

        function _nnw-auto-wrap {
          local command=''${1%% *}

          if which -p $command >/dev/null; then
            if [[ $(which -p $command) =~ ^$NVM_DIR/.*\/bin\/[a-z0-9_-]+$ ]]; then
              _nnw-wrap $command
            fi
          fi
        }

        autoload -Uz add-zsh-hook
        add-zsh-hook preexec _nnw-auto-wrap

        ${optionalString (cfg.enableCompletion) /* zsh */ ''
          source ${cfg.package}/share/nvm/bash_completion
        ''}

        ${optionalString (cfg.buildFromSource) /* zsh */ ''
          export NVM_SOURCE_INSTALL=1
          export npm_config_build_from_source=true
        ''}

        ${optionalString (!cfg.buildFromSource) /* zsh */ ''
          export NVM_SOURCE_INSTALL=0
          export npm_config_build_from_source=false
        ''}

        ${optionalString (cfg.force32Bit) /* zsh */ ''
          function nvm_get_arch { nvm_echo "x86" }
          export npm_config_arch=ia32
          export npm_config_target_arch=ia32
        ''}

        ${optionalString (cfg.autoUse) /* zsh */ ''
          export NVM_AUTO_USE=true

          autoload -U add-zsh-hook

          function load-nvmrc {
            local node_version="$(nvm version)"
            local nvmrc_path="$(nvm_find_nvmrc)"

            if [[ -n "$nvmrc_path" ]]; then
              local nvmrc_node_version=$(nvm version "$(cat "$nvmrc_path")")

              if [[ "$nvmrc_node_version" = "N/A" ]]; then
                nvm install
              elif [[ "$nvmrc_node_version" != "$node_version" ]]; then
                nvm use
              fi
            elif [[ "$node_version" != "$(nvm version default)" ]]; then
              echo "Reverting to nvm default version"
              nvm use default
            fi
          }

          add-zsh-hook chpwd load-nvmrc
          load-nvmrc
        ''}

        ${optionalString (!cfg.enableForRoot) /* zsh */ ''
          fi
        ''}
      '';
    };
  }
