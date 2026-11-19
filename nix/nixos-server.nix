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
    extraGroups = [ "wheel" "networkmanager" "docker" "transmission" "dialout" ];
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

  # mDNS (required for Home Assistant to discover ESPHome/HomeKit devices,
  # and for the HomeKit bridge to be discoverable by the iOS Home app)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Tailscale (exit node)
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Swap for Vitis/Vivado builds targeting the VEK280 (VE2802): v++ --link can need
  # 32-48 GB; this host has 15 GB RAM. 48 GB swapfile on the 470 GB SSD.
  swapDevices = [ { device = "/var/lib/swapfile"; size = 48 * 1024; } ];

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

  # Plex Media Server
  services.plex = {
    enable = true;
    openFirewall = true;
    group = "transmission";
  };

  # Jellyfin (free alternative to Plex; no remote-streaming paywall, works over
  # Tailscale node sharing). Web UI on :8096. In the transmission group so it can
  # read /var/lib/transmission/Downloads.
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "transmission";
  };

  # Transmission (torrent client)
  # NOTE: RPC is bound to 0.0.0.0 with both whitelists disabled, so the web UI
  # is reachable unauthenticated from anything that can route to this host.
  services.transmission = {
    enable = true;
    openRPCPort = true;
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;
      download-dir = "/var/lib/transmission/Downloads";
    };
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 8123 21064 ];
  # 4002: Govee LAN API replies (govee_light_local integration)
  networking.firewall.allowedUDPPorts = [ 5353 4002 21064 ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
