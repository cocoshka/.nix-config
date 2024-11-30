{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
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

    audio.pipewire.enable = true;
    audio.pipewire.virtualDevices = [
      {
        "node.name" = "Mixed-Input";
        "node.description" = "Mixed Input";
        "media.class" = "Audio/Source/Virtual";
        "audio.position" = "MONO";
      }
      {
        "node.name" = "Aux-Input";
        "node.description" = "Aux Input";
        "media.class" = "Audio/Source/Virtual";
        "audio.position" = "MONO";
      }
      {
        "node.name" = "Recording-Output";
        "node.description" = "Recording Output";
        "media.class" = "Audio/Sink";
        "audio.position" = "FL,FR";
      }
      {
        "node.name" = "Monitor-Output";
        "node.description" = "Monitor Output";
        "media.class" = "Audio/Sink";
        "audio.position" = "FL,FR";
        "monitor.channel-volumes" = "true";
      }
    ];

    hardware.tlp.enable = true;
    hardware.razer.enable = true;

    system.fs.enable = true;
    system.utils.enable = true;

    user = {
      extraGroups = ["networkmanager"];
    };

    shell.zsh.enable = true;

    services.printing.enable = true;

    desktop.gnome.enable = true;

    gaming.enable = true;

    virtualisation.qemu.enable = true;
    virtualisation.docker.enable = true;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hardware
  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:35:0:0";
    nvidiaBusId = "PCI:01:0:0";
  };

  # Network
  networking.networkmanager.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.tapping = false;
  services.libinput.touchpad.disableWhileTyping = true;
  services.libinput.touchpad.clickMethod = "buttonareas";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # The Nano editor is installed by default.
    obs-studio
    gtop
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
  };

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
