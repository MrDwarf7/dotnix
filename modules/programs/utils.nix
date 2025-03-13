{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    program.utils.enable = lib.mkEnableOption "Enable utility programs";
  };

  config = lib.mkIf config.program.utils.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
      nh
      unzip
      tokei
      pamixer
      pavucontrol
      upower
      ngrok
      wf-recorder
      # keyd
      (writers.writeRustBin "colors" {} (builtins.readFile ../scripts/colors.rs))
      (writers.writeRustBin "timestamp" {} (builtins.readFile ../scripts/timestamp.rs))
    ];

    # keyd = {
    #   enable = true;
    #   configFile = ../../no_nix/capslock-escape-with-vim-mode.conf;
    #   # configFile = ../../no_nix/capslock-esc.conf;
    # };

    # services.kanata = {
    #   enable = true;

    #   keyboards.keyb = {
    #     configFile = ../../noneNix/kanata.kbd;
    #   };
    # };
  };
}
