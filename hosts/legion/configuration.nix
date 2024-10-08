{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  imports = lib.flatten [
    (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-hidpi
      common-pc-laptop
      common-pc-laptop-ssd
    ])

    outputs.nixosModules
  ];

  modules = {
    general.enable = true;

    gpu.amd.enable = true;
    gpu.nvidia = {
      enable = true;
      hybrid = true;
    };

    desktop.gnome.enable = true;

    gaming.enable = true;

    virtualisation.qemu.enable = true;

    user = {
      extraGroups = ["networkmanager"];
      shell = pkgs.zsh;
    };
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hardware
  services.thermald.enable = true;
  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:35:0:0";
    nvidiaBusId = "PCI:01:0:0";
  };

  # Network
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [epson-escpr];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.tapping = false;
  services.libinput.touchpad.disableWhileTyping = true;
  services.libinput.touchpad.clickMethod = "buttonareas";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # The Nano editor is installed by default.
    nil
    nixd
    alejandra
    curl
    wget
    pciutils
    sbctl
    epsonscan2
    gnumake
    python3
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
