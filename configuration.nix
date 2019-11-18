{ config, pkgs, ... }:
{
  imports = [ /etc/nixos/hardware-configuration.nix /etc/nixos/local.nix ];
  time.timeZone = "US/Eastern";
  sound.enable = true;
  networking.networkmanager.enable = true;

  environment = {
    variables.NIXPKGS_ALLOW_UNFREE = "1";
    gnome3.excludePackages = with pkgs.gnome3; [ epiphany vinagre gnome-software ];
    systemPackages = with pkgs; [
      # CLI tools
      pwgen darkhttpd pv tree tmux psmisc ncdu git file unzip glxinfo sqlite usbutils entr ffmpeg p7zip gcc
      python3 python2
      # Apps
      firefox chromium vscode steam gimp pavucontrol mpv gnome3.dconf-editor libreoffice tdesktop retroarch
      # Security tools
      ettercap exiftool dnsutils burpsuite nmap masscan binutils remmina wireshark openvpn socat ghidra-bin
      # Virtualisation
      qemu_kvm virtmanager kubectl doctl
      # Other
      gnomeExtensions.dash-to-dock
      gnomeExtensions.dash-to-panel
      (callPackage ./gobuster {})
      (callPackage ./wfuzz {})
      (callPackage ./binary-ninja-personal {})
      (writeScriptBin "zfsram" "grep ^size /proc/spl/kstat/zfs/arcstats")
      (writeScriptBin "red" ''
        x="$(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled)"
        [ "$x" = "true" ] && x=false || x=true
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled $x
      '')
      (vim_configurable.customize {
        name="vim";
        vimrcConfig.customRC="set nowrap ruler scrolloff=9 backspace=start,indent";
      })
    ];
  };

  programs = {
    bash.vteIntegration = true;
    bash.interactiveShellInit = ''
      stty -ixon
      echo $XDG_SESSION_TYPE
      alias p=python3
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    retroarch = {
      enableParallelN64 = true;
      enableNestopia = true;
      enableHiganSFC = true;
    };
  };

  virtualisation = {
    docker.enable = true;
    docker.enableOnBoot = false;
  };

  services = {
    avahi = {
      nssmdns = true;
      publish.enable = true;
      publish.addresses = true;
    };
    udev.extraRules = ''
      KERNEL=="uinput", MODE="0666", OPTIONS+="static_node=uinput"

      # 1st gen ds4
      #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
      #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:05C4.*", MODE="0666"

      # 2nd gen ds4
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:09CC.*", MODE="0666"

      # smart card reader
      ATTRS{idVendor}=="04e6", ATTRS{idProduct}=="5116", MODE="0666"
    '';
    xserver = {
      enable = true;
      libinput.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;
      desktopManager.xterm.enable = false;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  boot = {
    #kernelParams = [ "zfs.zfs_arc_max=${toString (1024*1024*1024)}" ];
    loader.timeout = 1;
    cleanTmpDir = true;
    zfs.forceImportAll = false;
    zfs.forceImportRoot = false;
  };

  systemd.user.services."telegram" = {
    # ~/.config/systemd/user/default.target.wants/telegram.service -> /etc/systemd/user/telegram.service
    serviceConfig.Restart="always";
    path = [ "/run/current-system/sw" ];
    script = ''sleep 3; exec telegram-desktop -startintray'';
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    opengl.driSupport32Bit = true;
  };

  users.users = {
    sean = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "audio" "video" "networkmanager" "dialout" "input" ];
    };
    test = {
      isNormalUser = true;
      uid = 600;
    };
  };

  system.stateVersion = "20.03";
}
