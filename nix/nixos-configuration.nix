{ pkgs, ... }:

{
  imports = [ ./disko-config.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "nishraptorserver";

  # Timezone & locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking (systemd-networkd)
  networking.useNetworkd = true;
  systemd.network.networks."20-wired" = {
    matchConfig.Name = "enp1s0";
    networkConfig.DHCP = "yes";
    dhcpV4Config.RouteMetric = 10;
  };
  systemd.network.networks."25-wireless" = {
    matchConfig.Name = "wlan0";
    networkConfig.DHCP = "yes";
    dhcpV4Config.RouteMetric = 20;
  };

  # WiFi (iwd)
  networking.wireless.iwd.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
      ListenAddress = "0.0.0.0";
    };
  };

  # Docker
  virtualisation.docker.enable = true;

  # PostgreSQL
  services.postgresql.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Fish shell
  programs.fish.enable = true;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # User
  users.users.nishant = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwtRheBIL0sgGv+Y0uL7ndgvqUtAc0mSwb4r4qx+9aN nishraptor@Nishants-MacBook-Pro"
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    fish
  ];

  system.stateVersion = "24.11";
}
