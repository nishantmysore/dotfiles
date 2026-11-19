{ pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # Enable SSH with root key access
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHwtRheBIL0sgGv+Y0uL7ndgvqUtAc0mSwb4r4qx+9aN nishraptor@Nishants-MacBook-Pro"
  ];

  # DHCP for automatic network
  networking.useDHCP = true;

  system.stateVersion = "24.11";
}
