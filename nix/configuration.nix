{ pkgs, ... }:

{
  # System-wide packages (user packages go in home.nix)
  environment.systemPackages = with pkgs; [
    fish
  ];

  # Use Fish as default shell (managed by nix, not homebrew)
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    fish_add_path --prepend --move /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin
  '';
  environment.shells = [ pkgs.fish ];
  users.users.nishraptor.shell = pkgs.fish;

  # Determinate Nix manages the daemon, so don't let nix-darwin fight it
  nix.enable = false;

  # macOS system defaults
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowAllExtensions = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hostname
  networking.hostName = "Nishants-MacBook-Pro";

  # Required for per-user system.defaults options
  system.primaryUser = "nishraptor";

  # Required: used for backwards compat. Don't change.
  system.stateVersion = 6;
}
