{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    dotnetPackages.Nuget
    icu
    powershell
    vimPlugins.omnisharp-extended-lsp-nvim
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
        pygltflib
    ]))
  ];
}
