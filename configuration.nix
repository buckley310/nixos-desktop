{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./local
    ./gnome
  ];

  time.timeZone = "US/Eastern";

  environment = {
    variables.NIXPKGS_ALLOW_UNFREE = "1";
    systemPackages = with pkgs; [
      # CLI tools
      pwgen pv tree tmux psmisc ncdu git file unzip glxinfo sqlite usbutils entr ffmpeg gcc
      python3 steam-run hugo
      # Apps
      firefox brave gimp mpv libreoffice tdesktop retroarch
      gnome3.dconf-editor
      # Security tools
      exiftool dnsutils burpsuite nmap masscan binutils remmina openvpn socat ghidra-bin
      wfuzz gobuster pwndbg
      # Virtualisation
      qemu_kvm kubectl
      # Other
      (callPackage ./binary-ninja-personal {})
      (writeScriptBin "nix-roots" "nix-store --gc --print-roots | grep -v ^/proc/")
      (writeScriptBin "install-flathub"
        "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo")
      (writeScriptBin "zfsram" ''
        #!${pkgs.python3}/bin/python
        for ln in open('/proc/spl/kstat/zfs/arcstats').readlines():
          if ln.startswith('size '):
            print(str(int(ln.split(' ')[-1])/(1024*1024*1024))[:5],'GB')
      '')
      (vim_configurable.customize {
        name="vim";
        vimrcConfig.customRC=''
          syntax enable
          filetype plugin indent on
          set nowrap ruler scrolloff=9 backspace=start,indent
        '';
      })
      (vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.Nix
          ms-python.python
          ms-vscode.cpptools
          ms-azuretools.vscode-docker
        ];
      })
    ];
  };

  programs = {
    wireshark.enable = true;
    wireshark.package = pkgs.wireshark;
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
    flatpak.enable = true;
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
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
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
      extraGroups = [ "wheel" "audio" "video" "networkmanager" "dialout" "input" "wireshark" ];
    };
    test = {
      isNormalUser = true;
      uid = 600;
    };
  };
}
