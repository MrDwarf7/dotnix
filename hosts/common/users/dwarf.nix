{
  config,
  inputs,
  pkgs,
  ...
}: {
  users.users.dwarf = {
    # initialHashedPassword = "";
    isNormalUser = true;
    description = "Dwarf";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "docker"
      # "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];

    openssh.authorizedKeys.keys = [
      # UPDATE THIS ONCE INSTALL IS DONE AND KEYS ARE GENERATED
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL2t7RviAZyiKh/Ncmt2yiPG/v5RmXCUzMUywXwRGIuY"
    ];

    packages = [
      inputs.home-manager.packages.${pkgs.system}.default
    ];
    # packages = with pkgs; [];
  };
  home-manager.users.dwarf = import ../../../home/dwarf/${config.networking.hostName}.nix;
}
