{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./sys/game.nix
    ./sys/music.nix
    ./sys/programming.nix
    ./sys/term.nix
    ./sys/bluetooth.nix
    ./sys/de/kde.nix
    ./sys/shell/fish.nix
  ];

  # Settings for stateful data, like file locations and database versions
  system.stateVersion = "23.05";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "bytebox"; 
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  services.resolved.enable = true;
  networking.interfaces.eno1.wakeOnLan.enable = true;

  fileSystems."/mnt/brother-chungus" = {
      device = "/dev/disk/by-uuid/388c40a0-ef36-4d7c-b08f-6cd9af63b9c6";
      fsType = "ext4";
    };

  boot.loader.systemd-boot.enable = true;
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
    LD_PRELOAD = "";
    DOTNET_CLI_TELEMETRY_OPTOUT = "true";
  };

  virtualisation.libvirtd.enable = true;

  # User account
  users.users.scabbage = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "scabbage";
    extraGroups = [ "audio" "networkmanager" "wheel" "libvirtd" "dialout" "docker" "uinput" "wireshark" "kvm" "adbusers"];
    packages = with pkgs; [
      chromium
      kate
      gimp
      glava
      obs-studio
      vlc
      prismlauncher
      prusa-slicer
      inkscape
      qbittorrent
      rnote
      qdirstat
      davinci-resolve
      verilator
    ];
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

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
    #glfw
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
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "scabbage" ];

  services.locate.enable = true;

  # Enable manpages
  documentation.dev.enable = true;
  documentation.man = {
    # In order to enable to mandoc man-db has to be disabled.
    man-db.enable = false;
    mandoc.enable = true;
  };

  programs.wireshark.enable = true;

  ## System Packages
  environment.systemPackages = with pkgs; [
    ##  CLI Tools
    vim
    neovim
    neovim-remote
    ripgrep
    btop
    wget
    curl
    tmux
    bat
    eza
    fzf
    stow
    yazi
    lazygit
    trashy

    mpv
    fd
    zellij
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

    # Phat GUI Apps
    neovide
    (firefox.override {
        cfg.nativeMessagingHosts.packages = [pkgs.plasma5Packages.plasma-browser-integration];
      })
    vscode
    unityhub
    bitwarden
    thunderbird
    obsidian
    freecad
    libreoffice
    kooha
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
    # wine64Packages.stagingFull
    winePackages.stagingFull
    cups
    ventoy-full
    platformio
    parsec-bin
    usbimager
    rpi-imager
    rpcs3

    # Talk with monkeys
    skypeforlinux
    signal-desktop
    discord
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
    SDL2

    # printing
    brlaser

    # Vanity
    fastfetch
  ];

fonts.packages = with pkgs; [
  jetbrains-mono
  helvetica-neue-lt-std
  # Nerd fonts on 24.11
  nerdfonts

  # Nerd fonts on Unstable
  #nerd-fonts.noto
  #nerd-fonts.hack
  #nerd-fonts.fira-mono
  #nerd-fonts.fira-code
];

}
