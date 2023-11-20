{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bytebox"; 

  networking.networkmanager.enable = true;

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

  services.xserver.enable = true;

  # Desktop Environment
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Keyboard
  services.xserver = {
    layout = "us";
    xkbVariant = "dvorak";
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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
    ];
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Shell aliases
  programs.fish.shellAliases = {
    l = "ls -alh";
    cfg = "vi $HOME/.config/nixos/bytebox/configuration.nix";
    nbs = "sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/bytebox/configuration.nix";
    try = "nix-shell -p ";
    vi  = "nvim";
    vim = "nvim";
    dotfiles = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
    import-dotfiles = "git clone --bare git@github.com:TheScabbage/dotfiles.git $HOME/.dotfiles";
    yeet = "git push";
    yoink = "git pull";
  };


  hardware.opengl.driSupport32Bit = true; 

  services.flatpak.enable = true;

  # Meat and potatoes
  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
    which
    unzip
    barrier
    ocaml
    rustup
    go
    pkg-config
    odin
    gcc
    tmux
    openssl

    cmake
    gcc9
    libllvm

    bitwarden
    blender
    discord
    discordo
    vencord
    skypeforlinux
    signal-desktop
    
    vscode
    reaper
    freecad
    prusa-slicer
    
    freetype
    sqlite
    libxml2
    xml2
    SDL2

    # Vanity
    nerdfonts
    neofetch
  ];

  # OpenSSH
  services.openssh.enable = true;

  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";
}
