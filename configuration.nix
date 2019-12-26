{ config, pkgs, ... }:
{
  imports = [
    ../hardware-configuration.nix
    ../local.nix
    ./i3
  ];
  time.timeZone = "US/Eastern";
  sound.enable = true;
  networking.networkmanager.enable = true;

  environment = {
    variables.NIXPKGS_ALLOW_UNFREE = "1";
    #gnome3.excludePackages = with pkgs.gnome3; [ epiphany vinagre gnome-software ];
    systemPackages = with pkgs; [
      # CLI tools
      pwgen darkhttpd pv tree tmux psmisc ncdu git file unzip glxinfo sqlite usbutils entr ffmpeg p7zip gcc
      python3 python2
      # Apps
      firefox brave vscode steam gimp pavucontrol mpv libreoffice tdesktop retroarch
      gnome3.dconf-editor
      # Security tools
      exiftool dnsutils burpsuite nmap masscan binutils remmina wireshark openvpn socat ghidra-bin
      wfuzz gobuster
      # Virtualisation
      qemu_kvm virtmanager kubectl doctl
      # Other
      yaru-theme
      (callPackage ./binary-ninja-personal {})
      (writeScriptBin "zfsram" "grep ^size /proc/spl/kstat/zfs/arcstats")
      (vim_configurable.customize {
        name="vim";
        vimrcConfig.customRC="set nowrap ruler scrolloff=9 backspace=start,indent";
      })
    ];
  };

  fonts.fonts = [ pkgs.ubuntu_font_family ];

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
      enable = true;
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
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  boot = {
    loader.timeout = 1;
    cleanTmpDir = true;
    zfs.forceImportAll = false;
    zfs.forceImportRoot = false;
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
