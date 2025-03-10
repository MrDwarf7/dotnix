{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.lsp.enable = lib.mkEnableOption "Enable Language Server Protocol programs";
  };

  config = lib.mkIf config.program.lsp.enable {
    environment.systemPackages = with pkgs; [
      nixd
      # rust-anaylzer
      vscode-langservers-extracted
      emmet-ls
      tailwindcss-language-server
    ];
  };
}
