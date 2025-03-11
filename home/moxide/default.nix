{
  config,
  pkgs,
  lib,
  ...
}: let
  utils = import ../../utils.nix {lib = lib;};
  generators = import ./mkYaml.nix {
    lib = lib;
    pkgs = pkgs;
  };
in {
  options = {
    home.moxide.enable = lib.mkEnableOption "Enable moxide (config)";

    home.moxide.paths = lib.mkOption {
      type = with lib.types; listOf (attrsOf str);
      default = [
        {
          name = "Home";
          path = "~/";
        }
      ];
      description = "List of directories with name and path to include in the YAML file";
    };
    home.moxide.templates = lib.mkOption {
      default = {
        "nvim".windows = [
          {
            name = " Neovim";
            panes = ["nvim"];
          }
        ];
      };
      description = "List of directories with name and path to include in the YAML file";
    };
    home.moxide.projects = lib.mkOption {
      default = {};
      description = "List of projects with name and path to include in the yaml files";
    };
  };

  config = lib.mkIf config.home.moxide.enable {
    home.file = let
      directories = {
        ".config/moxide/directories.yaml".text = generators.mkDirectoryYaml config.home.moxide.paths;
      };
      templates =
        utils.transformAttrs
        (config.home.moxide.templates)
        (entry: ".config/moxide/templates/${entry.key}.yaml")
        (entry: {text = generators.mkTemplateYaml entry;});
      projects =
        utils.transformAttrs
        (config.home.moxide.projects)
        (entry: ".config/moxide/projects/${entry.key}.yaml")
        (entry: {text = generators.mkProjectYaml entry;});
    in
      directories
      // templates
      // projects;
  };
}
