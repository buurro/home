{ config, pkgs, inputs, nixos-hardware, ... }:
let
  unstablePkgs = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    "${inputs.self}/modules/hyprland.nix"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "smart-kettle"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.systemd-udevd.restartIfChanged = false;

  environment.systemPackages = with pkgs; [
    chromium
    mpv
    discord
    pavucontrol
    obs-studio
    unstablePkgs.vscode.fhs
    brightnessctl
  ];

  system.stateVersion = "23.05";
}
