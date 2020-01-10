{ config, pkgs, ... }:
{
  imports = [
    ../hardware-configuration.nix
    ../local.nix
    ./gnome
    ./podman
  ];

  time.timeZone = "US/Eastern";
  sound.enable = true;
  fonts.fonts = [ pkgs.ubuntu_font_family ];

  environment = {
    variables.NIXPKGS_ALLOW_UNFREE = "1";
    systemPackages = with pkgs; [
      # CLI tools
      pwgen pv tree tmux psmisc ncdu git file unzip glxinfo sqlite usbutils entr ffmpeg p7zip gcc
      python3 steam-run
      # Apps
      firefox brave vscode steam gimp pavucontrol mpv libreoffice tdesktop retroarch
      gnome3.dconf-editor
      # Security tools
      exiftool dnsutils burpsuite nmap masscan binutils remmina wireshark openvpn socat ghidra-bin
      wfuzz gobuster pwndbg
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

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
      publish.addresses = true;
    };
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
