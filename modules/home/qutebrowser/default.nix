{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.pluto.desktop.qutebrowser.enable = lib.mkEnableOption "Enable Qutebrowser" // {
    default = true;
  };

  config = lib.mkIf config.pluto.desktop.qutebrowser.enable {
    home.file.".config/ueberzugpp/config.json".text = ''
      {
        "layer": {
          "output": "sixel"
        }
      }
    '';
    home.packages = [
      pkgs.python313Packages.adblock
      pkgs.ueberzugpp
      pkgs.dragon-drop
    ];

    programs.qutebrowser = {
      enable = true;
      searchEngines = {
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        aw = "https://wiki.archlinux.org/?search={}";
        nw = "https://wiki.nixos.org/w/index.php?search={}";
        np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
        no = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
        ho = "https://home-manager-options.extranix.com/?query={}&release=master";
        g = "https://www.google.com/search?hl=en&q={}";
      };
      settings = {
        tabs = {
          position = "right";
          width = "10%";
        };
        # try doing
        editor = {
          # command = [
          #   "foot"
          #   "-T"
          #   "auxiliary text edit"
          #   "hx"
          #   "{file}"
          #   #"+startinsert"
          #   "+call cursor({line}, {column})"
          # ];
          command = [
            "foot"
            "-T"
            "EDITOR"
            "env"
            "-u COLUMNS"
            "-u LINES"
            "hx"
            "{file}:{line}:{column}"
          ];
        };
        fileselect = {
          folder.command = [
            "foot"
            "-T"
            "Folder Select"
            "env"
            "-u COLUMNS"
            "-u LINES"
            "ranger"
            "--choosedir={}"
          ];
          multiple_files.command = [
            "foot"
            "-T"
            "Multiple File Select"
            "env"
            "-u COLUMNS"
            "-u LINES"
            "ranger"
            "--choosefiles={}"
          ];
          single_file.command = [
            "foot"
            "-T"
            "Single File Select"
            "env"
            "-u COLUMNS"
            "-u LINES"
            "ranger"
            "--choosefile={}"
          ];
          handler = "external";
        };
      };
      keyBindings = {
        normal = {
          ",d" = "config-cycle colors.webpage.darkmode.enabled true false";
        };
      };
    };
    #Used for file selection
    programs.ranger = {
      enable = true;
      plugins = [
        # {
        #   name = "zoxide";
        #   src = pkgs.fetchgit {
        #     url = "https://github.com/jchook/ranger-zoxide.git";
        #     rev = "aefff2797b8e3999f659176dc99d76f7186ccc29";
        #     hash = "sha256-07dpg8vhywbpknafbayz26hm5mirgy6bwdw5lpdd5fnpqpcjjpcl";
        #   };
        # }
      ];
      mappings = {
        cz = "zi";
      };
      extraConfig = ''
        set preview_images true
        set preview_images_method ueberzug
      '';
    };
  };
}
