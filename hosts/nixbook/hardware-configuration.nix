{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/hardware/network/broadcom-43xx.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.apple-macbook-pro-11-1
    inputs.nixos-hardware.nixosModules.apple-macbook-pro-11-5
    # Machine is technically this --
    inputs.nixos-hardware.nixosModules.apple-macbook-pro-12-1
    ./disk-config.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["wl"];
  boot.kernelModules = ["kvm-intel" "wl"];
  boot.extraModulePackages = [config.boot.kernelPackages.broadcom_sta];

  # Fixes the issue with the Broadcom 43xx wireless card when resume/unspend and the wifi won't reconnect
  powerManagement.powerUpCommands = ''
    ${pkgs.systemd}/bin/systemctl restart wpa_supplicant.service
  '';

  # testing
  hardware.enableAllFirmware = true;
  boot.blacklistedKernelModules = [
    "brcmfmac"
  ];

  ## Make kernal bootup FAST! -- may also leak your data lmao
  # mitigations=off
  boot.kernelParams = [
    "hid_apple.swap_fn_leftctrl=1"
  ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
