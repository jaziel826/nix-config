{ config, pkgs, pkgs-unstable, winappsPkg, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jaziel";
  home.homeDirectory = "/home/jaziel";
  #nixpkgs.config.allowUnfreePredicate = _: true;
  #nixpkgs-unstable.config.allowUnfree = true;


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
#  gtk = {
#    enable = true;
#    theme = {
#      name = "Breeze";
#      package = pkgs.libsForQt5.breeze-gtk;
#    };
#  };
  #environment.variables = {
 #   dotfiles = config.lib.file.mkOutOfStoreSymlink "/home/jaziel/repos/configs";
 #   };

  #systemd.service.kde-baloo.enable = false;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  jetbrains-mono
#  nerdfonts
  catppuccin-kde
  yubikey-manager
  kitty
  catppuccin-gtk
  masterpdfeditor4
 # pgadmin4-desktopmode
  #catppuccin-qt5ct
  gcc
  tmux
  #poppler
#  megasync
  fastfetch
  jq
  fd
  ripgrep
  zoxide
  file
  bat
  starship 
  #steam
  thunderbird
  traceroute
  tmux
  eza
  #libsForQt5.partitionmanager
  gparted
  lf
  fzf
  mpv
  trash-cli
  #onlyoffice-bin
  inkscape
  doggo
  alacritty
  #mission-center
  ansible
#   nodePackages_latest.npm
  firefox
  kdePackages.kate
  localsend
  #corefonts
  #vistafonts
  neovim
 ## lobster
  btop
  brave
  #yazi
  #mullvad-browser
  stow 
  #libreoffice
  #protonvpn-cli
  #protonvpn-gui
  proton-pass
  zellij
  yubikey-personalization
 # libsForQt5.plasma-browser-integration
  # libsForQt5.kdeconnect-kde
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ])

  ++

  (with pkgs-unstable; [
  freerdp
  ]);
fonts.fontconfig.enable = true;

programs.bash = {
    enable = true;
    shellAliases = {
    ls = "exa --all --long --icons --color=always --group-directories-first";
    cat = "bat";
    cd = "z";
    cdi = "zi";
    v = "$EDITOR ";
    pc = "protonvpn-cli connect";
    pr = "protonvpn-cli reconnect";
    zj = "zellij";
    lob = "lobster";
    flake-up = "nix flake update --commit-lock-file";
    nixos-new = "sudo nixos-rebuild switch --flake /home/jaziel/repos/nixos/";
    home-rebuild = "home-manager switch --flake /home/jaziel/repos/nixos/";
    };
    bashrcExtra = ''
      . ~/repos/configs/bash/.bashrc
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
notify_on_finish() {
    local status=$?
    local cmd
    cmd=$(history 1 | sed 's/^ *[0-9]* *//')
    notify "$status" "$cmd"
    return $status
}

  eval "$(zoxide init bash)"
    '';
  };

xdg.userDirs = {
	enable = true;
	setSessionVariables = true;
	createDirectories = true;
	desktop = "$HOME/desktop";
	download = "$HOME/downloads";
  documents = "$HOME/documents";

	
	};
programs.yazi = {
  enable = true;
  shellWrapperName = "yy";
  };
#  keymap = {
#    prepend.manager.keymap = [
#      {
#      on = ["g" "n"];
#      run = "cd /home/jaziel/repos/configs/nixos";
#      desc = "Go to Nix config";
#      }
#    ];
#    completion.keymap = [
#      {
#        on = ["<Esc>"];
#        run = "close";
#        desc = "Cancel completion";
#      }
#      {
#        on = ["<Tab>"];
#        run = "close --submit";
#        desc = "Submit the completion";
#      }
#    ];
#};
#};
#};

programs.git= {
  enable = true;
  settings.user.name = "Jaziel Amadiz";
  settings.user.email = "jaziel.amadiz@pm.me";
  signing.format = null;
};
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
      "/home/jaziel/vim" = {
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "/home/jaziel/repos/configs/vim/.vim";
          target = "/home/jaziel/.vim";
        };
      "/home/jaziel/.vimrc" = {
          source = config.lib.file.mkOutOfStoreSymlink "/home/jaziel/repos/configs/vim/.vimrc";
          target = "/home/jaziel/.vimrc";
       };
      "/home/jaziel/.tmux.conf" = {
          source = config.lib.file.mkOutOfStoreSymlink "/home/jaziel/repos/configs/tmux/.tmux.conf";
          target = "/home/jaziel/.tmux.conf";
        };
      "/home/jaziel/.config/starship.toml" = {
          source = config.lib.file.mkOutOfStoreSymlink "/home/jaziel/repos/configs/starship/.config/starship.toml";
          target = "/home/jaziel/.config/starship.toml";
        };
      "/home/jaziel/.config/lf" = {
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "/home/jaziel/repos/configs/lf/.config/lf";
          target = "/home/jaziel/.config/lf";
        };
     "/home/jaziel/.config/alacritty" = {
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "/home/jaziel/repos/configs/alacritty/.config/alacritty";
          target = "/home/jaziel/.config/alacritty";
        };
      "/home/jaziel/.config/btop" = {
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "/home/jaziel/repos/configs/btop/.config/btop";
          target = "/home/jaziel/.config/btop";
        };
#      .bashrc = {
#          source = /home/jaziel/repos/repos/configs/bash/.bashrc;
#    };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jaziel/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "kate";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin"; 	# Not technically in the official xdg specification
    XDG_DESKTOP_DIR="$HOME/desktop";
    XDG_DOWNLOAD_DIR="$HOME/downloads";
    XDG_DOCUMENTS_DIR="$HOME/documents";

};



  home.file.".local/bin/winapps".source = "${winappsPkg}/bin/winapps";
  #home.file.".local/share/winapps".force = true;


  home.sessionPath = [
    "$XDG_BIN_HOME"
    "$HOME/.local/bin"
    "/usr/local/bin"
];
  # reload system units when switch
  systemd.user.startServices = "sd-switch";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false;
}
