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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hostname
  networking.hostName = "Nishants-MacBook-Pro";

  # Required for per-user system.defaults options
  system.primaryUser = "nishraptor";

  # Remap "Screenshot area to clipboard" to Ctrl+Shift+S
  # Key 31 = screenshot area to clipboard
  # Parameters: [ASCII code, key code, modifier flags]
  # 115 = 's', 1 = key code for S, 393216 = Ctrl(262144) + Shift(131072)
  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        "31" = {
          enabled = true;
          value = {
            parameters = [ 115 1 393216 ];
            type = "standard";
          };
        };
      };
    };
  };

  # Required: used for backwards compat. Don't change.
  system.stateVersion = 6;
}
