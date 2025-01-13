{ config, pkgs, ... }:
{
  programs.fish.enable = true;

  # Shell aliases
  programs.fish.shellAliases = {
    l = "eza -alh";
    lg = "lazygit";
    cfg = "pushd . && cd $HOME/.config/nixos/bytebox/ && vi ./configuration.nix && popd";
    #nbs = "sudo nixos-rebuild switch -I nixos-config=$HOME/.config/nixos/bytebox/configuration.nix";
    nbs = "pushd . && cd $HOME/.config/nixos/bytebox/ && sudo nixos-rebuild switch --flake . && popd";
    nuf = "pushd . && cd $HOME/.config/nixos/bytebox/ && nixos update flake && popd";
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

  environment.systemPackages = with pkgs; [
      steam
      steamcmd
      protonplus
      xemu
      r2modman
      gamemode
  ];
}
