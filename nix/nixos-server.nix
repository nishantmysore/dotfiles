{ config, lib, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nishraptorserver";
  networking.networkmanager.enable = true;

  # Timezone
  time.timeZone = "America/Los_Angeles";

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    fish
  ];

  # Fish shell
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  # User account
  users.users.nishant = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwtRheBIL0sgGv+Y0uL7ndgvqUtAc0mSwb4r4qx+9aN nishraptor@Nishants-MacBook-Pro"
    ];
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # Home Assistant
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.home-assistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = [ "/var/lib/home-assistant:/config" ];
    extraOptions = [ "--network=host" "--privileged" ];
    environment.TZ = "America/Los_Angeles";
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 8123 21064 ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
