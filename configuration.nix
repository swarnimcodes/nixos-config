# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:


{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    max-jobs = "auto";
    cores = 0;
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    builders-use-substitutes = true;
    warn-dirty = false;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };

  # Performance optimizations
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 12582912 16777216";
    "net.ipv4.tcp_wmem" = "4096 12582912 16777216";
    "net.core.netdev_max_backlog" = 5000;
  };

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  services.irqbalance.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Console font for boot messages
  console = {
    font = "ter-132n";
    packages = with pkgs; [ terminus_font ];
    earlySetup = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Static IP networking configuration
  networking = {
    hostName = "nixos";
    interfaces.wlp3s0 = {
      ipv4.addresses = [{
        address = "192.168.1.14";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.swarnim = {
    isNormalUser = true;
    description = "swarnim";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts.packages = with pkgs; [
    iosevka
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    helix
    ghostty
    fastfetch
    lazygit
    git
    claude-code
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable graphics drivers for hardware acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Intel graphics (best for video encoding/decoding)
      intel-media-driver # VAAPI driver for newer Intel GPUs
      vaapiIntel # VAAPI driver for older Intel GPUs  
      # AMD graphics
      mesa
      amdvlk
    ];
  };

  # Media services
  services.jellyfin = {
    enable = true;
    group = "video"; # Add to video group for GPU access
    openFirewall = true;
  };
  services.immich = {
    enable = true;
    openFirewall = true;
  };
  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.headphones = {
    enable = true;
    group = "media";
    host = "0.0.0.0";
    dataDir = "/media/audio";
  };
  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/media/downloads";
      incomplete-dir = "/media/downloads/incomplete";
    };
    openFirewall = true;
  };
  services.flaresolverr.enable = true;
  services.sabnzbd = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  # Create media directories
  systemd.tmpfiles.rules = [
    "d /media 0755 root root -"
    "d /media/movies 0775 root media -"
    "d /media/tv 0775 root media -"
    "d /media/audio 0775 root media -"
    "d /media/downloads 0775 root media -"
    "d /media/downloads/incomplete 0775 root media -"
  ];

  # Create media group
  users.groups.media = { };

  # Open ports in the firewall for media services
  # networking.firewall.allowedTCPPorts = [
  #   8096 # Jellyfin
  #   7878 # Radarr
  #   8989 # Sonarr
  #   9696 # Prowlarr
  #   9091 # Transmission
  #   8191 # FlareSolverr
  #   8080 # SABnzbd
  # ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
