# Miscellaneous language servers (1 or 2 per)
{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    program.languages.misc.enable = lib.mkEnableOption "Enable miscellaneous language servers";
  };

  config = lib.mkIf config.program.languages.misc.enable {
    nixpkgs.overlays = [
    ];
    environment.systemPackages = with pkgs; [
      marksman # Markdown
      markdown-oxide # Markdown
      nixd # Nix lsp
      # nil # Other nix LSP
      nixfmt-rfc-style # Nix formatter - official one
      zls
      emmet-language-server
      buf
      cmake-language-server
      docker-compose-language-service
      vscode-extensions.vadimcn.vscode-lldb
      # terraform-ls
      # ansible-language-5erver
      # vue-language-server
      hyprls
      helix-gpt
    ];
  };
}
