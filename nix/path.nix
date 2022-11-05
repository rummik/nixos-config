import ../channels

/*let

  inherit (builtins) attrValues mapAttrs removeAttrs attrNames;

  sources = removeAttrs (import ./sources.nix) [ "__functor" ];

in


rec {
  __nixPath =

    (map
      (prefix: { inherit prefix; path = sources.${prefix}.outPath; })
      (attrNames sources)
    )
    #(attrValues (mapAttrs (prefix: source: { inherit prefix; path = source.outPath; }) sources))

    ++

    [
      # Configuration
      #{ prefix = "darwin-config"; path = ../configuration.nix; }
      { prefix = "nixos-config"; path = ../configuration.nix; }

     #{ prefix = "binary-caches"; path = ./binary-caches; }
     #{ prefix = "darwin"; path = ./darwin; }
     #{ prefix = "home-manager"; path = ./home-manager; }
     #{ prefix = "morph"; path = ./morph; }
     #{ prefix = "nixos"; path = ./nixos; }
     #{ prefix = "nixos-hardware"; path = ./nixos-hardware; }

     ## Nixpkgs
     #{ prefix = "nixpkgs"; path = ./nixpkgs; }
     #{ prefix = "nixpkgs-unstable"; path = ./nixpkgs-unstable; }

      #{ prefix = "nixpkgs"; path = sources.nixpkgs.outPath; }

      # Overlays
      { prefix = "nixpkgs-overlays"; path = ../overlays/default.nix; }
      { prefix = "nixpkgs-unstable-overlays"; path = ../overlays/unstable.nix; }

     ## Nur
     #{ prefix = "nur"; path = ./nur; }
      { prefix = "nur-rummik"; path = ../channels/nur-rummik; }
    ];

  nixPath = map ({ prefix, path }: "${prefix}=${__replaceStrings [ "/mnt/" ] [ "/" ] (toString path)}") __nixPath;
}*/
