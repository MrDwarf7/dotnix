# Python
{pkgs, ...}: {
  nixpkgs.overlays = [
    #
  ];

  environment.systemPackages = with pkgs; [
    python313Full
    # python313Packages
    python313FreeThreading
    python313Packages.lsp-tree-sitter
    python313Packages.ruff
    python313Packages.pyright
    python313Packages.uv
    python313Packages.black
  ];
}
