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
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "swarnimcodes";
    userEmail = "swarnim14.9@hotmail.com";
  };

  programs.bash = {
    enable  = true;
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

  home.stateVersion = "25.05";
}
