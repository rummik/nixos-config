{
  programs.nixvim.plugins.lsp.enable = true;
  programs.nixvim.plugins.lsp.servers = {
    html.enable = true;
    cssls.enable = true;
    jsonls.enable = true;
    eslint.enable = true;

    tsserver = {
      enable = true;
      rootDir = "require 'lspconfig.util'.root_pattern('package.json')";
    };

    denols = {
      enable = true;
      rootDir = "require 'lspconfig.util'.root_pattern('deno.json', 'deno.jsonc')";
    };
  };
}
