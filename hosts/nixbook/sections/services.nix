{pkgs, ...}: {
  imports = [
  ];

  services = {
    openssh = {
      enable = true;
      # permitRootLogin = "no";
      allowSFTP = true;
    };

    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };
  };
}
