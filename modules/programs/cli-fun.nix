{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    program.cliFun.enable = lib.mkEnableOption "Enable somehwat useless CLI programs";
  };

  config = lib.mkIf config.program.cliFun.enable {
    environment.systemPackages = with pkgs; [
      asciiquarium
      cbonsai
      clolcat
      lolcat
      cmatrix
      cowsay
      fastfetch
      inputs.retch.defaultPackage.${pkgs.system}
      figlet
      neofetch
      rsclock # Rust -- It's a tui clock
      nitch
      macchina # Neofetch alternative in Rust
      pipes-rs
      sl
      toilet
      (fortune.override {withOffensive = true;})
      peaclock
    ];
  };
}
