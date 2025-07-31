{ config, pkgs, ... }:

{
  home.username = "swarnim";
  home.homeDirectory = "/home/swarnim";

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

  home.stateVersion = "25.05";
}
