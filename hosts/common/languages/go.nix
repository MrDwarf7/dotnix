{pkgs, ...}: {
  nixpkgs.overlays = [
    #
  ];

  environment.systemPackages = with pkgs; [
    go # Go
    gopls
    delve
  ];
}
