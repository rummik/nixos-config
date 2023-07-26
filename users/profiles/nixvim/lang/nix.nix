{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    plugins.lsp.enable = true;
    plugins.lsp.servers.nil_ls.enable = true;

    # plugins.lsp.servers.nil_ls.settings = {
    #   formatting.command = [ "${pkgs.alejandra}/bin/alejandra" ];
    # };

    # plugins.lsp.servers.rnix-lsp.enable = true;

    extraConfigVim = /* vim */ ''
      au BufRead,BufNewFile flake.lock setf json
    '';
  };
}
