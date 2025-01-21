{ config, pkgs, ... }:
{
  # Dotnet 6 is EOL
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
    "olm-3.2.16"
  ];

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
    roslyn
    roslyn-ls
    dotnet-sdk_9
    #omnisharp-roslyn
    #dotnet-runtime_8
    #dotnet-runtime
    #dotnetPackages.Nuget
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
        svgwrite
        pydbus
        pygobject3
        gobject-introspection
    ]))
  ];
}
