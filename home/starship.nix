{
  config,
  lib,
  ...
}: {
  options = {
    home.starship.enable = lib.mkEnableOption "Enable starship config";
  };
  config = lib.mkIf config.home.starship.enable {
    programs.starship = {
      enable = true;
      # Do these in their respective shell configs
      ### enableBashIntegration = true;
      ### enableZshIntegration = true;
      ### enableFishIntegration = true;

      # Can also use this, to incrementally adopt home-manager handling
      # settings = pkgs.lib.importTOML ./starship.toml;

      settings = {
        command_timeout = 10000;

        format = "$username$hostname$os $directory$git_branch$git_commit$git_state$git_status$fill[ ](#767676)$cmd_duration$package$c$cmake$docker_context$dotnet$golang$haskell$lua$meson$mojo$nim$nodejs$rust$zig$jobs\n($sudo)$character";

        fill = {
          symbol = " ";
        };

        character = {
          format = "$symbol ";
          success_symbol = " [❯](purple)";
          error_symbol = " [❯](red)";
          vimcmd_symbol = " [❮](green)";
          vimcmd_replace_symbol = " [❯](orange)";
          vimcmd_visual_symbol = " [❯](yellow)";
        };

        env_var.VIMSHELL = {
          format = "[$env_value]($style)";
          style = "green italic";
        };

        sudo = {
          format = " [$symbol]($style)";
          style = "bold italic bright-yellow";
          symbol = "⋈┈";
          disabled = false;
        };

        # Left prompt elements
        username = {
          disabled = false;
          style_user = "#d3b987";
          format = "[$user]($style)";
        };

        hostname = {
          disabled = false;
          ssh_only = true;
          style = "#d3b987";
          format = "[@$hostname]($style)[ ](#767676)";
        };

        os = {
          disabled = false;
          format = "[ $symbol]($style)";
          style = "#00afff";
          symbols = {
            Alpine = "";
            Arch = "";
            CentOS = "";
            #CoreOS = "";
            Debian = "";
            Fedora = "";
            Gentoo = "";
            Linux = "";
            Macos = "";
            NixOS = "";
            Windows = "";
          };
        };

        directory = {
          truncation_length = 0;
          use_os_path_sep = true;
          repo_root_style = "#0087af";
          fish_style_pwd_dir_length = 3;
          style = "#00afff";
          repo_root_format = "[ $before_root_path]($style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
          format = "[ $path]($style)[$read_only]($read_only_style) ";
        };

        git_branch = {
          symbol = "  ";
          style = "green";
          format = "[ ](#767676)[$symbol$branch]($style)";
        };

        git_status = {
          stashed = "[*$\{count}](blue) ";
          modified = "[!$\{count}](yellow) ";
          staged = "[+$\{count}](green) ";
          untracked = "[?$\{count}](blue)";
          deleted = "[-$\{count}](red) ";
          format = " ([$stashed$modified$staged$untracked $ahead_behind]($style))";
        };

        jobs = {
          disabled = false;
          format = "[$number]($style)";
        };

        status = {
          disabled = false;
          map_symbol = false;
          format = "[$symbol$status]($style)";
        };

        cmd_duration = {
          disabled = false;
          style = "#a8a8a8";
          format = "((#767676)[$duration  ]($style))";
        };

        c = {
          symbol = " ";
          format = "([$symbol($version(-$name)) ]($style))";
        };

        cmake = {
          symbol = "△ ";
          format = "([$symbol($version )]($style))";
          detect_files = ["CMakeLists.txt" "CMakeCache.txt"];
        };

        docker_context = {
          symbol = " ";
          format = "([$symbol$context]($style))";
          detect_files = [
            "docker-compose.yml"
            "docker-compose.yaml"
            "Dockerfile"
            ".dockerignore"
            "compose.yml"
            "compose.yaml"
          ];
        };

        dotnet = {
          symbol = ".NET ";
          detect_extensions = ["csproj" "sln" "fsproj" "xproj" "nuspec"];
          format = "([.NET $version ]($style))";
        };

        golang = {
          symbol = " ";
          format = "([$symbol($version )]($style))";
        };

        haskell = {
          symbol = "λ ";
          format = "([$symbol($version )]($style))";
        };

        lua = {
          symbol = "⨀ ";
          format = "([$symbol($version )]($style))";
        };

        meson = {
          symbol = "⬢ ";
          format = "([$symbol$project]($style))";
          detect_files = ["meson.build" "meson_options.txt"];
        };

        nim = {
          symbol = "▴▲▴ ";
          format = "([$symbol($version )]($style))";
        };

        nix_shell = {
          symbol = " ";
          format = "[$\{symbol}nix $\{state} ]($style)";
        };

        nodejs = {
          symbol = " ";
          format = "([$symbol($version)]($style))";
        };

        package = {
          symbol = "◨ ";
          format = "([$symbol($version )]($style))";
          style = "dimmed yellow italic";
          version_format = "$\{raw}";
        };

        rust = {
          format = "([$symbol($version)]($style))";
          version_format = "$\{major}.$\{minor}";
          symbol = "🦀 ";
        };

        zig = {
          symbol = "↯ ";
          format = "([$symbol($version )]($style))";
          version_format = "$\{major}.$\{minor}.$\{patch}";
          detect_folders = [".zig-cache" "zig-out"];
        };
      };
    };
  };
}
