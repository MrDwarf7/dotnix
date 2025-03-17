{
  pkgs,
  ags,
  lib,
  config,
  spicetify-nix,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (import ./hardware-configuration.nix {inherit config lib pkgs modulesPath inputs;})
    # Testing if we can generate our OWN man-db pages instead of man-db cache doing it (which is slow as)
    # (import ./documentation.nix {inherit pkgs config lib;})
  ];

  bootloader = {
    enableSystemdBoot = true;
    enableRaspberryPi = false;
  };

  fontsModule.enable = true;
  powerOff.enable = true;

  networkModule = {
    enable = true;
    hostName = "nixbook";
  };

  users.users.dwarf = {
    isNormalUser = true;
    description = "Dwarf";
    extraGroups = ["wheel" "networkmanager"]; ## NOTE: netowrkmanager // systemd-networkd // iwp // wpa_supplicant
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  locale.enable = true;

  program = {
    cliFun.enable = true;
    cliDev.enable = true;
    cliMin.enable = true;
    cliRand.enable = true;
    desktop = {
      browsers.enable = true;
      chatting.enable = true;
      graphics.enable = true;
      misc.enable = true;
      terms.enable = true;
      utils.enable = true;
    };

    fishShell.enable = true;
    hypr.enable = true;

    languages = {
      go.enable = true;
      lua.enable = true;
      misc.enable = true;
      node.enable = true;
      python.enable = true;
      rust.enable = true;
    };

    lsp.enable = true;

    miscTools.enable = true;
    river.enable = true;
    utils.enable = true;
  };

  nixModule.enable = true;

  firewall = {
    enable = true;
    tcp = [];
    udp = [];
  };

  # TODO: add this back in once I have a better understanding of how to use it
  sopsSecrets.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.power-profiles-daemon.enable = true;

  # virtualisation.enable = true; ## Not 100% sure this is the right option name

  mime = {
    enable = true;
    apps = with pkgs; {
      "application/pdf" = zathura;
      "image/svg+xml" = inkscape;

      "image/bmp" = eog;
      "image/gif" = eog;
      "image/jpeg" = eog;
      "image/jpg" = eog;
      "image/jxl" = eog;
      "image/pjpeg" = eog;
      "image/png" = eog;
      "image/tiff" = eog;
      "image/webp" = eog;
      "image/x-bmp" = eog;
      "image/x-gray" = eog;
      "image/x-icb" = eog;
      "image/x-ico" = eog;
      "image/x-png" = eog;
      "image/x-portable-anymap" = eog;
      "image/x-portable-bitmap" = eog;
      "image/x-portable-graymap" = eog;
      "image/x-portable-pixmap" = eog;
      "image/x-xbitmap" = eog;
      "image/x-xpixmap" = eog;
      "image/x-pcx" = eog;
      "image/svg+xml-compressed" = eog;
      "image/vnd.wap.wbmp" = eog;
      "image/x-icns" = eog;

      "video/qicktime" = mpv;
      "application/ogg" = mpv;
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs ags spicetify-nix;};
    users.dwarf = {...}: {
      imports = [
        ./home.nix
        ./spicetify.nix
      ];
    };
    backupFileExtension = "backup";
  };
}
