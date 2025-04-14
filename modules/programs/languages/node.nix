# Node
{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.languages.node.enable = lib.mkEnableOption "Enable the Node.js programming language";
  };

  config = lib.mkIf config.program.languages.node.enable {
    nixpkgs.overlays = [
    ];
    environment.systemPackages = with pkgs; [
      biome
      nodejs_latest
      nodemon
      typescript
      typescript-language-server
      pnpm
      yarn
      bun
      deno
      # nodePackages_latest.vscode-languageservers-extracted
      yaml-language-server
      dockerfile-language-server-nodejs
      bash-language-server
      #    nodePackages_latest.graphql-language-service-cli

      # tree-sitter
      # ktree-sitter-grammars
      # python113Packages.python-lsp-server
    ];
  };
}
