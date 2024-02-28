{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  networking.hostName = "bytebox"; 

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  services.xserver = {
    displayManager.defaultSession = "plasmawayland";
    videoDrivers = [ "amdgpu" ];
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  programs.dconf.enable = true;

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # User account
  users.users.scabbage = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "scabbage";
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" ];
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
    ];
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Shell aliases
  programs.fish.shellAliases = {
    l = "ls -alh";
    lg = "lazygit";
    cfg = "vi $HOME/.config/nixos/bytebox/configuration.nix";
    nbs = "sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/bytebox/configuration.nix";
    try = "nix-shell -p ";
    search = "nix search nixpkgs ";
    vi  = "nvim";
    vim = "nvim";
    dotfiles = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
    import-dotfiles = "git clone --bare git@github.com:TheScabbage/dotfiles.git $HOME/.dotfiles";
    yeet = "git push";
    yoink = "git pull";
    oc = "find . | entr -r ";
    ns = "nix-shell";
    vid = "neovide";
  };

  # OpenGL
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true; 
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  # OpenSSH
  services.openssh.enable = true;

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
    glibc
    glib
    libevdev
    icu
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

  # Meat and potatoes
  environment.systemPackages = with pkgs; [

    # CLI Tools
    neovim
    ripgrep
    btop
    wget
    curl
    git
    git-lfs
    lf
    zoxide
    fzf
    tldr
    wezterm
    unzip
    barrier
    gnupg
    pinentry
    docker-compose
    ffmpeg
    dos2unix
    entr
    gcc
    tmux
    openssl
    wine64
    evtest
    gh
    gamemode
    conda
    steam
    steamPackages.steamcmd
    stow
    lazygit
    cloc
    exercism
    p7zip
    ollama

    cmake
    gcc9
    glibc
    glib
    libllvm


    # phat GUI Apps
    neovide
    (firefox.override {
        cfg.nativeMessagingHosts.packages = [pkgs.plasma5Packages.plasma-browser-integration];
      })
    unityhub
    vscode
    reaper
    bitwarden
    obsidian
    freecad
    davinci-resolve
    peek
    rhythmbox
    picard
    yt-dlp
    jamesdsp
    libsForQt5.kcalc
    rustdesk
    rustdesk-server
    xemu
    libsForQt5.spectacle

    # Talk with monkeys
    skypeforlinux
    # signal being shit so using flatpak until its fixed
    #signal-desktop

    (discord.override {
        # For some reason discord breaks now with OpenAsar.
        # Disabled until issue is fixed.
        # withOpenASAR = true;
        withVencord = true;
    })

    # Allow neovim -> system clipboard
    xclip
    wl-clipboard

    # Zig
    zig
    zls
    rustup

    # Go
    go
    pkg-config

    # JavaScript
    nodejs_21
    typescript

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

    # Arduino
    arduino
    arduino-mk
    arduino-cli
    arduino-language-server

    # Python
    python3

    # Java
    jdt-language-server

    # Others
    odin
    ocaml
    jdk17
    vala

    electron
    xwayland
    xwaylandvideobridge

    freetype
    sqlite
    libxml2
    xml2
    SDL2

    # Vanity
    nerdfonts
    neofetch
  ];


  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";
}
