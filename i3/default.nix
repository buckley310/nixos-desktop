{ pkgs, ... }:
{
  services.gvfs.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    gnome3.networkmanagerapplet gnome3.file-roller
    mate.mate-terminal xfce.thunar i3status xfce.thunar-archive-plugin
  ];
  services.xserver = {
    enable = true;
    libinput.enable = true;
    windowManager.i3.enable = true;
    desktopManager.xterm.enable = false;
  };
}
