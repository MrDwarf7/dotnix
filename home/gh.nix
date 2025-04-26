{
  config,
  lib,
  ...
}: {
  options = {
    home.gh.enable = lib.mkEnableOption "Enable the bat syntax highlighter";
  };

  config = lib.mkIf config.home.gh.enable {
    programs.gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
        hosts = ["github.com"];
      };

      settings = {
        git_protocol = "ssh";
        aliases = {
          co = "pr checkout";
        };
      };
    };
  };
}
