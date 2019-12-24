{ pkgs, ... }:
{
  environment = {
    gnome3.excludePackages = with pkgs.gnome3; [ epiphany vinagre gnome-software ];
    systemPackages = with pkgs; [
      gnome3.gnome-tweaks gnomeExtensions.dash-to-panel
      (writeScriptBin "red" ''
        x="$(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled)"
        [ "$x" = "true" ] && x=false || x=true
        echo "Nightlight: $x"
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled $x
      '')
      (writeScriptBin "hidebar" ''
        x="$(dconf read /org/gnome/shell/extensions/dash-to-panel/intellihide)"
        [ "$x" = "true" ] && x=false || x=true
        dconf write /org/gnome/shell/extensions/dash-to-panel/intellihide $x
      '')
    ];
  };
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
    desktopManager.xterm.enable = false;
  };
}
