# Node/NPM ecosystem
{pkgs, ...}: {
  nixpkgs.overlays = [
    #
  ];

  environment.systemPackages = with pkgs; [
    nodePackages_latest.nodemon
    nodePackages_latest.typescript
    nodePackages_latest.typescript-language-server
    nodePackages_latest.pnpm
    nodePackages_latest.yarn
    bun
    deno
    # nodePackages_latest.vscode-languageservers-extracted
    nodePackages_latest.yaml-language-server
    nodePackages_latest.dockerfile-language-server-nodejs
    nodePackages_latest.bash-language-server
    #    nodePackages_latest.graphql-language-service-cli

    # tree-sitter
    # ktree-sitter-grammars
    # python113Packages.python-lsp-server
  ];
}
