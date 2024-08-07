{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Settings for stateful data, like file locations and database versions
  system.stateVersion = "23.05";

  networking.hostName = "bytebox"; 
  networking.nameservers = [ "9.9.9.9" "1.1.1.1" ];

  fileSystems."/mnt/brother-chungus" = {
      device = "/dev/disk/by-uuid/388c40a0-ef36-4d7c-b08f-6cd9af63b9c6";
      fsType = "ext4";
    };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
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

  boot.kernelModules = [ "uinput" ];

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
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    desktopManager.plasma5.enable = true;
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "plasmawayland";

  programs.dconf.enable = true;

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    #variant = "dvorak";
  };

  # Configure console keymap
  #console.keyMap = "dvorak";
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.fish.enable = true;
  environment.variables.YDOTOOL_SOCKET = "/tmp/ydotools";

  # User account
  users.users.scabbage = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "scabbage";
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" "uinput" ];
    packages = with pkgs; [
      chromium
      kate
      gimp
      obs-studio
      vlc
      prismlauncher
      prusa-slicer
      inkscape
      qbittorrent
      rnote
      glava
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
    try = "nix-shell -p ";
    search = "nix search nixpkgs ";
    vi  = "nvim";
    # vw  = "neovide . &";
    sd = "pwd > ~/.local/share/jumpdir";
    jd = "cd $(cat ~/.local/share/jumpdir)";
    yeet = "git push";
    yoink = "git pull";
    oc = "find . | entr -r ";
    ns = "nix-shell ";
    nsp = "nix-shell --pure ";
    vid = "neovide";
    udot = "pushd ~/dotfiles && stow . && popd && echo \"Dotfiles updated.\" || echo \"Failed to update dotfiles.\"";
    fcd = "cd $(fzf --walker=dir,follow,hidden)";
    b = "cd -";
    cr = "clear";
    mtm = "~/.config/tmux/startup.sh";
    tma = "tmux attach";
    ndkb = "~/Android/Sdk/ndk/ndk-build";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    yz = "yazi";
  };

  # OpenGL
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true; 
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    pkgs.mesa.drivers
  ];

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
  ];

  programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
  };

  services.pcscd.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "scabbage" ];

  services.locate.enable = true;

  # Enable manpages
  documentation.dev.enable = true;

  environment.systemPackages = with pkgs;
  let
    stat-rstudio = rstudioWrapper.override {
      packages = with rPackages; [ tidyverse snakecase dplyr magrittr ggpubr ];
    };
  in
  ## System Packages
  [
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
    tmux
    openssl
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

    # Man pages
    man-pages
    man-pages-posix

    # Terminals
    wezterm
    alacritty
    kitty

    # Source control
    git
    git-lfs
    mercurial
    pijul

    gnumake
    cmake
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
    unityhub
    vscode
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
    stat-rstudio
    libsForQt5.kdeconnect-kde
    libsForQt5.kdialog
    qimgv
    android-studio
    android-udev-rules
    barrier
    wine64Packages.stagingFull
    steam
    steamPackages.steamcmd
    lutris
    cups
    alvr
    graphviz
    logisim
    logisim-evolution

    # Music/Audio
    reaper
    distrho
    audacity
    picard
    rhythmbox
    yt-dlp

    # Talk with monkeys
    skypeforlinux
    signal-desktop
    discord

    ( vesktop.override { withSystemVencord = false; } )

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
    libunwind
    libclang

    # Lobster
    lobster

    # Go
    go
    pkg-config

    # Lua
    lua
    lua54Packages.luarocks

    # CSharp
    omnisharp-roslyn
    dotnet-sdk_8
    dotnet-runtime_8
    icu
    powershell
    vimPlugins.omnisharp-extended-lsp-nvim
    dotnetPackages.Nuget

    # Arduino
    arduino
    arduino-mk
    arduino-cli
    arduino-language-server

    # Python
    python312
    python312Packages.pip

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

    # User space gamepad support cuz gulikit kk3
    # doesnt work great with the kernel driver
    xboxdrv

    # DE Shit
    electron
    xwayland
    xwaylandvideobridge
    xdg-desktop-portal
    swayidle
    swaylock

    freetype
    sqlite
    libxml2
    xml2
    SDL2

    # Vanity
    fastfetch
  ];

fonts.packages = with pkgs; [
  noto-fonts
  fira-code
  fira-code-symbols
  jetbrains-mono
  nerdfonts
  helvetica-neue-lt-std
];

}
