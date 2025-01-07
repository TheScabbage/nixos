{ config, pkgs, ... }: {
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Settings for stateful data, like file locations and database versions
  system.stateVersion = "23.05";

  networking.hostName = "bytebox"; 
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  services.resolved.enable = true;

  fileSystems."/mnt/brother-chungus" = {
      device = "/dev/disk/by-uuid/388c40a0-ef36-4d7c-b08f-6cd9af63b9c6";
      fsType = "ext4";
    };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.configurationName = "Nix";
  boot.loader.grub.extraGrubInstallArgs = [ "--bootloader-id=Nix" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ xone ];

  # for bluetooth xbox gamepads
  hardware.xpadneo.enable = true;
  boot.extraModprobeConfig = '' options bluetooth disable_ertm=1 '';

  # for xbox wireless adapter
  hardware.xone.enable = true;

  # use steam-hardware module for KK3 nintendo switch mode
  hardware.steam-hardware.enable = true;

  # Fixes Finals crashing on startup
  boot.kernelParams = [ "clearcpuid=304" ];

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

  # Desktop Environment
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  xdg.portal.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  programs.dconf.enable = true;

  # Keyboard
  # Switch to US layout and emulate Dvorak in hardware instead
  services.xserver.xkb = {
    layout = "us";
    #variant = "dvorak";
  };

  #console.keyMap = "dvorak";
  console.keyMap = "us";

  # Enable CUPS to print documents.
  #services.printing.enable = true;
  #services.avahi = {
  #  enable = true;
  #  nssmdns4 = true;
  #  openFirewall = true;
  #};

  # Enable sound with pipewire.
  nixpkgs.config.pulseaudio = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.variables.YDOTOOL_SOCKET    = "/tmp/ydotools";
  environment.variables.GSETTINGS_BACKEND = "keyfile";

  virtualisation.libvirtd.enable = true;

  programs.fish.enable = true;

  # User account
  users.users.scabbage = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "scabbage";
    extraGroups = [ "audio" "networkmanager" "wheel" "libvirtd" "dialout" "docker" "uinput" "wireshark"];
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Shell aliases
  programs.fish.shellAliases = {
    l = "eza -alh";
    lg = "lazygit";
    cfg = "pushd . && cd $HOME/.config/nixos/bytebox/ && vi ./configuration.nix && popd";
    nbs = "sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/bytebox/configuration.nix";
    ndg = "sudo nix-collect-garbage --delete-older-than 7d";
    try = "nix-shell -p ";
    search = "nix search nixpkgs ";
    vi  = "nvim";
    vw  = "neovide . &";
    sd = "pwd > ~/.local/share/jumpdir";
    jd = "cd $(cat ~/.local/share/jumpdir)";
    clone = "git clone --recursive ";
    oc = "find . | entr -r ";
    ns = "nix-shell ";
    nsp = "nix-shell --pure ";
    vid = "neovide";
    udot = "pushd ~/dotfiles && stow . && popd && echo \"Dotfiles updated.\" || echo \"Failed to update dotfiles.\"";
    fcd = "cd $(fzf --walker=dir,follow,hidden)";
    cr = "clear";
    mtm = "~/.config/tmux/startup.sh";
    tma = "tmux attach";
    ndkb = "~/Android/Sdk/ndk/ndk-build";
    u = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    b = "cd -";
    yz = "yazi";
  };

  # Graphics
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; 
  #hardware.graphics.extraPackages = with pkgs; [
  #  #rocmPackages.clr.icd
  #  #pkgs.mesa.drivers
  #];

  # OpenSSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Flatpak
  services.flatpak.enable = true;

  # Sets up all the libraries to load
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc 
    zlib
    openssl
    openssl.dev
    udev
    libevdev
    icu
    glew
    glfw
    glfw2
    libllvm
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.pipewire.wireplumber.enable = true;
  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-hw-volume" = true;
        # Remove the phone profiles cuz they sound like ass
        "bluez5.enable-msbc" = false;
        "bluez5.roles" = [ "a2dp_sink" "a2dp_source" ];
    };
  };

  services.blueman.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "scabbage" ];

  services.locate.enable = true;

  # Enable manpages
  documentation.dev.enable = true;

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
    bat
    yazi
    mpv
    eza
    fd
    zellij
    zoxide
    fzf
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
    tmux
    openssl
    pkg-config
    evtest
    gh
    dig
    gamemode
    conda
    stow
    lazygit
    cloc
    exercism
    ollama
    tree-sitter
    evemu
    ydotool
    busybox
    wlr-randr
    wmctrl
    trashy
    desktop-file-utils
    pandoc
    inotify-tools
    bzip2
    e2fsprogs
    cairo
    mqttx
    zip
    appimage-run

    # Terminals
    wezterm
    alacritty
    kitty

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
    floorp
    unityhub
    bitwarden
    thunderbird
    obsidian
    freecad
    libreoffice
    kooha
    libsForQt5.kcalc
    rustdesk
    rustdesk-server
    xemu
    libsForQt5.spectacle
    qpwgraph
    gparted
    libsForQt5.kdialog
    qimgv
    # wine64Packages.stagingFull
    winePackages.stagingFull
    cups
    qemu_full
    virt-manager
    ventoy-full
    platformio
    parsec-bin
    usbimager
    rpi-imager
    rpcs3

    steam
    steamPackages.steamcmd
    protonplus
    (import ./modules/proton-ge.nix {
      inherit stdenv fetchurl;
    })
    xemu

    # Music/Audio
    reaper
    audacity
    picard
    rhythmbox
    yt-dlp

    # Talk with monkeys
    skypeforlinux
    signal-desktop
    (discord.override {
      withOpenASAR = true;
    })

    ( vesktop.override { withSystemVencord = false; } )

    nheko

    # Allow neovim -> system clipboard
    xclip
    wl-clipboard

    ## Programming
    # Zig
    zig
    zls

    # Rust
    cargo
    rustup
    cargo-cross
    rust-analyzer
    libunwind
    libclang

    # Go
    go
    gopls

    # Lua
    lua
    lua54Packages.luarocks

    # CSharp
    omnisharp-roslyn
    dotnet-sdk_8
    dotnet-runtime_8
    dotnet-runtime
    icu
    powershell
    vimPlugins.omnisharp-extended-lsp-nvim
    dotnetPackages.Nuget
    mono

    # Arduino
    arduino
    arduino-mk
    arduino-cli
    arduino-language-server

    # ESP32
    esptool

    # Python
    (python311.withPackages (p: with p; [
        pip
        pyserial
    ]))

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

    # DE Shit
    electron
    xwayland
    xwaylandvideobridge
    xdg-desktop-portal

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
  nerd-fonts.noto
  nerd-fonts.hack
  nerd-fonts.fira-mono
  nerd-fonts.fira-code
  helvetica-neue-lt-std
];

}
