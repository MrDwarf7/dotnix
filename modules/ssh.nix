{
  config,
  lib,
  ...
}: {
  options = {
    sshModule.enable = lib.mkEnableOption "Enable ssh settings";
  };

  config = lib.mkIf config.sshModule.enable {
    services.openssh = {
      enable = true;
      settings = {
        #PermitRootLogin = "no";
        #PasswordAuthentication = true;
      };
      allowSFTP = true;
    };
  };
}
