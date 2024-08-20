# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

#  let
#   nixos-load-src = pkgs.fetchFromGitHub {
#     owner = "paulchambaz";
#     repo = "nixos-plymouth";
#   };
#   nixos-load = pkgs.callPackage nixos-load-src {};
# in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.plymouth.enable = true; 
  #boot.loader.systemd-boot.configurationLimit = 12;
  boot.plymouth = {
    enable = true;
     # themePackages = [ nixos-bgrt-plymouth];
     theme = "bgrt";
  };

  #sops.defaultSopsFile = ./secrets.yaml;
  #boot.initrd.luks.devices."luks-515df98e-91e6-4714-bc04-093adad99922".device = "/dev/disk/by-uuid/515df98e-91e6-4714-bc04-093adad99922";
  boot.initrd.luks.devices."luks-164cbc37-fe46-4be4-9059-f6c1b4743e89".device = "/dev/disk/by-uuid/164cbc37-fe46-4be4-9059-f6c1b4743e89";
  networking.hostName = "ThinkPad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

#  system.autoUpgrade = {
#    enable = true;
#    flake = "self.output";
#    operation = "boot";
#    flags = [
#      "--commit-lock-file"
#      "-L" 
#    ];
#    dates = "02:00";
#    randomizedDelaySec = "45min";
#  };

##create /persistent
#
#  fileSystems."/persistent" = {
#    device = "/dev/disk/by-uuid/b787556b-e7e1-41cc-b2d9-c51567397971";
#    neededForBoot = true;
#    fsType = "ext4";
#  };


# enable Garbage collecting
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
# Enable Flakes 
 # nix.settings.experimental-features = ["nix-command" "flakes"];
   nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
# set uo auto-cpufreq 
  # ---Snip---
  programs.auto-cpufreq.enable = true;
   # optionally, you can configure your auto-cpufreq settings, if you have any
  programs.auto-cpufreq.settings = {
   charger = {
     governor = "performance";
     turbo = "auto";
   };

   battery = {
     governor = "powersave";
     turbo = "auto";
   };
 };
   # ---Snip---

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};


  # enable tailscale 
  # services.tailscale.enable= true;  

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.pcscd.enable = true;
  # services.xserver.displayManager.defaultSession = "plasmawayland";
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };
  environment.variables.QT_QTA_PLATFORM = "wayland;xcb";
#  environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
 # programs.dconf.enable = true;

#  qt = {
#  enable = true;
#  platformTheme = "gnome";
#  style = "adwaita-dark";
#};


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.ratbagd.enable = true;
  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
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
  users.users.jaziel = {
    isNormalUser = true;
    description = "Jaziel";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
     #firefox
#       kate
#       alacritty
      
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "jaziel";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # enable Flatpak
  services.flatpak.enable = true;
 # fonts.fontDir.enable = true;
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [
        libsForQt5.breeze-qt5  # for plasma
  #      gnome.gnome-themes-extra
      ];
      pathsToLink = [ "/share/icons" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts-emoji
      jetbrains-mono
      nerdfonts
      corefonts
      vistafonts
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
 # hplip
  nixos-bgrt-plymouth
  libsForQt5.breeze-plymouth
  libsForQt5.discover
  # corefonts
  nil
  starship
  distrobox
#  steam
#  thunderbird
#  bluez
#  tmux
  eza
#  lf
#  neovim
#  brave
  git
  stow 
  usbutils
  acpi
  ];

  programs.kdeconnect.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  virtualisation.waydroid.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
