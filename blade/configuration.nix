# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
 
{ config, pkgs, ... }:
 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  boot.loader.grub.useOSProber = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_12;
 
  networking.hostName = "nixbook"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
 
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
 
  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = ["1.1.1.1" "9.9.9.9"];
 
  # Set your time zone.
  time.timeZone = "Australia/Perth";
 
  # Select internationalisation properties.
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
 
  # Enable the X11 windowing system.
  services.xserver.enable = true;
 
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services.desktopManager.plasma6.enable = true;

 
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
 
  # Enable CUPS to print documents.
  services.printing.enable = true;
 
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
    jack.enable = true;
 
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Stop OOM killer from eating my shit
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024;
  }];

  # NVIDIA 
  # Make sure opengl is enabled
  hardware.graphics.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:01:0:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.scabbage = {
    isNormalUser = true;
    description = "Scabbage";
    extraGroups = [ "networkmanager" "wheel" "openrazer" "docker" "audio" "plugdev" "fuse" "dialout"];
    packages = with pkgs; [
      firefox
      chromium
      kate
    #  thunderbird
    ];
  };

  # Dynamic libraries
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
  ];

  # Shell aliases
  programs.bash.shellAliases = {
    l = "eza -alh";
    #cd = "z ";
    cds = "pushd . > /dev/null && z "; # cd, save the last directory
    b = "popd > /dev/null || popd -n"; # go back to the last dir in the stack
    cdi = "zi ";
    #cfg = "nvim $HOME/nixos/blade/configuration.nix";
    #nbs = "sudo nixos-rebuild switch -I nixos-config=$HOME/nixos/blade/configuration.nix";
    cfg = "pushd . && cd $HOME/nixos/blade/ && vi ./configuration.nix && popd";
    nbs = "pushd . && cd $HOME/nixos/blade/ && sudo nixos-rebuild switch --flake . && popd";
    nuf = "pushd . && cd $HOME/nixos/blade/ && nix flake update && popd";
    np = "nix-shell -p ";
    ns = "nix-shell";
    vi = "nvim ";
    vd = "WINIT_UNIX_BACKEND=x11 neovide ";
    vw = "WINIT_UNIX_BACKEND=x11 neovide . &";
    lg = "lazygit";
    cr = "clear";
    sd = "pwd > ~/.local/jmp/location.txt";
    jd = "JMP_DIR=`cat ~/.local/jmp/location.txt` && cd $JMP_DIR && pwd";
    nvo = "~/projects/nvidia-offload/nvidia-offload.sh ";
    pl = "pijul";
  };

 
  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "scabbage";
 
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.max-jobs = 8;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Flatpak 
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [

    # Tools
    neovim
    neovim-remote
    tmux
    ghostty
    kitty
    git
    git-lfs
    pijul
    wget
    bash
    curl
    unzip
    bat # better cat
    eza # better ls
    fzf
    yazi
    tldr
    gnumake
    #gcc
    cmake
    zoxide
    qpwgraph
    dig
    dos2unix
    qemu_full
    ascii
    entr
    wmctrl

    yabridge
    yabridgectl
    wine64
    bitwarden
    barrier
    ffmpeg_6-full 
    mpv
    fuse
    openjdk17-bootstrap
    #rstudio
    stow
    lazygit
    zig
    zig_0_13
    cargo
    gopls
    ripgrep
    nodejs_22
    nodePackages.typescript-language-server
    tree-sitter
    pkg-config
    cmake
    libgcc
    gcc9

    (python311.withPackages (p: with p; [
        pip
        pyserial
        #torch
        hexdump
    ]))
    libGL
    libglibutil
    btop
    wl-clipboard
    tinycc
    qbe
    fusuma
    (fortune.override {
      withOffensive = true;
    })
    usbutils

    # Apps
    neovide
    polychromatic
    skypeforlinux
    signal-desktop
    (discord.override {
      withVencord = true;
    })
    vscode
    reaper
    freecad
    prusa-slicer
    inkscape
    freecad
    steam-run
    gparted
    prismlauncher
    glava
    jamesdsp
    xournalpp
    gimp
    peek
    kooha
    obs-studio
    qalculate-qt
    unityhub
    vlc
    xdg-desktop-portal-kde
    xdg-desktop-portal-gtk

    # CSharp
    omnisharp-roslyn
    dotnet-sdk_8
    dotnet-runtime_8

    # Go
    go
    gopls

    arduino
    arduino-cli

    # Haskell
    ghc

    # Drivers n shit
    ntfs3g
    exfatprogs

    # Prowl dependencies
    assimp
    imagemagick

    # Touchpad
    touchegg

    openrazer-daemon
 
    # VM
    qemu
    virt-manager
    virt-viewer
    dnsmasq
    vde2
    iproute2
    netcat-openbsd
    libguestfs
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  environment.variables = {
    MOZ_USE_XINPUT2="1";
    EDITOR="nvim";
    XCURSOR_SIZE="24";
  };
 
  # Razer Support
  hardware.openrazer.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
 
  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    fira-code-symbols
    jetbrains-mono
    #nerdfonts
    helvetica-neue-lt-std
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
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
 
  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
 
}
