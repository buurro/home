{ config, lib, ... }:
{
  options = {
    modules.hyprland.enable = lib.mkEnableOption (lib.mdDoc "Hyprland");
  };

  config = lib.mkIf config.modules.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
