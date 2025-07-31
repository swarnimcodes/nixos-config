{ config, pkgs, zen-browser, ... }:

{
  home.username = "swarnim";
  home.homeDirectory = "/home/swarnim";

  imports = [
    zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };

  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];

  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        color-modes = true;
        auto-format = true;
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = [ "nil" ];
          formatter = { command = "nixpkgs-fmt"; };
          auto-format = true;
        }
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "swarnimcodes";
    userEmail = "swarnim14.9@hotmail.com";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -al";
      rebuild = "sudo nixos-rebuild switch --flake ~/git/nix/nix-config";
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  services.ssh-agent.enable = true;

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Iosevka";
      font-size = 14;
      keybind = "shift+enter=text:\\n";
    };
  };

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "ghostty";
      name = "Open Ghostty Terminal";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super><Shift>q" ];
    };
  };

  home.stateVersion = "25.05";
}
