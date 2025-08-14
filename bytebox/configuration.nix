{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./sys/game.nix
    ./sys/music.nix
    ./sys/programming.nix
    ./sys/term.nix
    ./sys/bluetooth.nix
    ./sys/de/dm.nix
    ./sys/de/kde.nix
    #./sys/de/hyprland.nix
    ./sys/shell/fish.nix
    ./sys/keylogging.nix
    ./sys/postgres.nix
  ];

  # Settings for stateful data, like file locations and database versions
  system.stateVersion = "23.05";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 4;
  nix.settings.cores = 8;

  networking.hostName = "bytebox";
  networking.nameservers = [ "9.9.9.9" "1.1.1.1" "8.8.8.8" ];
  services.resolved.enable = true;

  fileSystems."/mnt/brother-chungus" = {
      device = "/dev/disk/by-uuid/388c40a0-ef36-4d7c-b08f-6cd9af63b9c6";
      fsType = "ext4";
    };

  boot.loader.systemd-boot.enable = true;
  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=30s
    DefaultTimeoutKillSec=10s
  '';

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.configurationName = "Nix";
  boot.loader.grub.extraGrubInstallArgs = [ "--bootloader-id=Nix" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  time.timeZone = "Australia/Perth";

  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  programs.dconf.enable = true;

  # Keyboard
  # Switch to US layout and emulate Dvorak in hardware instead
  services.xserver.xkb = {
    layout = "us";
    #variant = "dvorak";
  };

  #console.keyMap = "dvorak";
  console.keyMap = "us";

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.variables = {
    YDOTOOL_SOCKET    = "/tmp/ydotools";
    GSETTINGS_BACKEND = "keyfile";
    DOTNET_CLI_TELEMETRY_OPTOUT = "true";
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "true";
    #PAGER = "sh -c 'col -bx | bat -l man -p'";
    #MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_7}/share/dotnet";
  };

  #virtualisation.libvirtd.enable = true;

  # User account
  users.users.scabbage = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "scabbage";
    extraGroups = [ "audio" "networkmanager" "wheel" "libvirtd" "dialout" "docker" "plugdev" "input" "uinput" "wireshark" "kvm" "adbusers"];
    packages = with pkgs; [
      chromium
      gimp
      krita
      glava
      obs-studio
      vlc
      prismlauncher
      prusa-slicer
      inkscape
      rnote
      qdirstat
      davinci-resolve
      verilator
    ];
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-6.0.36"
    "dotnet-runtime-7.0.20"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-7.0.410"
  ];

  # Graphics
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.amdgpu.opencl.enable = true;
  hardware.amdgpu.amdvlk.enable = true;

  # OpenSSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Flatpak
  services.flatpak.enable = true;

  services.udev.extraRules = ''
# Rules for Oryx web flashing and live training
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

# Legacy rules for live training over webusb (Not needed for firmware v21+)
  # Rule for all ZSA keyboards
  SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
  # Rule for the Moonlander
  SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
  # Rule for the Ergodox EZ
  SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
  # Rule for the Planck EZ
  SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

# Wally Flashing rules for the Ergodox EZ
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
# Keymapp Flashing rules for the Voyager
SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
  '';

  services.syncthing = {
    enable = true;
    user = "scabbage";
    dataDir = "/home/scabbage/documents/scabbagenotes";
    configDir = "/home/scabbage/.config/syncthing";
  };

  # Sets up all the libraries to load
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    #stdenv.cc.cc 
    #zlib
    #openssl
    #openssl.dev
    #udev
    #libevdev
    #icu
    #glew
    #glfw2
    #libllvm
    # used for embedded shit
    pixman
    libgcrypt
    libslirp
    glib
    gtk3
    cairo
    gdk-pixbuf
    vte
    xorg.libX11
  ];

  programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
  };

  services.pcscd.enable = true;

  #virtualisation.docker.enable = true;
  programs.adb.enable = true;

  #virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "scabbage" ];

  services.locate.enable = true;

  # Enable manpages
  documentation.dev.enable = true;
  documentation.man = {
    # In order to enable to mandoc man-db has to be disabled.
    man-db.enable = false;
    mandoc.enable = true;
  };
  documentation.man.generateCaches = true;

  programs.wireshark.enable = true;

  ## System Packages
  environment.systemPackages = with pkgs; [
    ##  CLI Tools
    vim
    neovim
    neovim-remote
    glogg
    ripgrep
    btop
    wget
    curl
    tmux
    zellij
    bat
    eza
    fzf
    stow
    yazi
    lazygit
    delta
    trashy
    kondo
    man-pages
    man-pages-posix
    inetutils
    screenkey
    jq
    pop
    caddy
    nushell

    mpv
    fd
    fselect
    zoxide
    tldr
    unzip
    p7zip
    gnupg
    pinentry
    docker-compose
    ffmpeg
    dos2unix
    entr
    gcc
    wxGTK32
    tbb
    openssl
    pkg-config
    evtest
    gh
    dig
    conda
    cloc
    exercism
    ollama
    tree-sitter
    evemu
    ydotool
    busybox
    wlr-randr
    wmctrl
    desktop-file-utils
    pandoc
    inotify-tools
    bzip2
    e2fsprogs
    cairo
    mqttx
    zip
    appimage-run
    monero-cli
    monero-gui
    p2pool
    timer
    woof
    wireshark
    mullvad-vpn
    syncthing
    syncthingtray

    # Crypto
    libargon2
    ecdsautils

    dotnet-runtime_7
    dotnet-sdk_7
    #dotnet-runtime_6
    #dotnet-sdk_6

    # Source control
    git
    git-lfs
    git-doc
    mercurial
    pijul

    gnumake
    cmake
    just
    gcc9
    libllvm
    ilspycmd
    gdb
    xorg.libX11
    xorg.libX11.dev
    logkeys
    calcurse

    # Phat GUI Apps
    neovide
    librewolf
    (firefox.override {
        cfg.nativeMessagingHosts.packages = [pkgs.plasma5Packages.plasma-browser-integration];
      })
    ladybird
    vscode
    jetbrains.idea-community
    unityhub
    qbittorrent
    bitwarden
    thunderbird
    obsidian
    freecad
    libreoffice
    kdePackages.kcalc
    kdePackages.spectacle
    shutter
    rustdesk
    rustdesk-server
    #xemu
    #qemu_full
    #virt-manager
    ksnip
    qpwgraph
    gparted
    libsForQt5.kdialog
    qimgv
    wine64Packages.stagingFull
    #winePackages.stagingFull
    cups
    platformio
    parsec-bin
    usbimager
    rpi-imager
    rpcs3
    lorien
    qmk
    keymapp

    # Talk with monkeys
    signal-desktop
    discord
    #( discord.override { withVencord = true; })
    ( vesktop.override { withSystemVencord = false; })

    # Allow neovim -> system clipboard
    xclip
    wl-clipboard

    ## Programming
    # Java
    jdk
    jdt-language-server

    # PHP
    php83
    php83Packages.composer

    # Others
    odin
    ocaml
    vala
    nodejs_22
    ghc
    julia

    # DE Shit
    electron

    freetype
    sqlite
    libxml2
    xml2

    # printing
    brlaser

    # Vanity
    fastfetch
  ];

fonts.packages = with pkgs; [
  jetbrains-mono
  helvetica-neue-lt-std
  xkcd-font
  # Nerd fonts on 24.11
  #nerdfonts

  # Nerd fonts on Unstable
  noto-fonts
  nerd-fonts.noto
  nerd-fonts.hack
  nerd-fonts.fira-mono
  nerd-fonts.fira-code
];

}
