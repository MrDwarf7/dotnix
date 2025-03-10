# Miscellaneous language servers (1 or 2 per)
{
  pkgs,
  inputs,
  ...
}: {
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
    inputs.hyprls
    helix-gpt
  ];
}
