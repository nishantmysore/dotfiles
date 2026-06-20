{ config, pkgs, hostName, ... }:

{
  # System-wide packages (user packages go in home.nix)
  environment.systemPackages = with pkgs; [
    fish
    kitty
  ];

  # Use Fish as default shell (managed by nix, not homebrew)
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    end

    fish_add_path --prepend --move /nix/var/nix/profiles/default/bin /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin
  '';
  environment.variables.PATH = [
    "/nix/var/nix/profiles/default/bin"
    "/etc/profiles/per-user/${config.system.primaryUser}/bin"
    "/run/current-system/sw/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];
  environment.shells = [ pkgs.fish ];
  users.users."nishant.mysore".shell = pkgs.fish;

  # Determinate Nix manages the daemon, so don't let nix-darwin fight it
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hostname
  networking.hostName = hostName;

  # Required for per-user system.defaults options
  system.primaryUser = "nishant.mysore";

  system.activationScripts.setPrimaryUserShell.text = ''
    echo "setting ${config.system.primaryUser} shell to fish..." >&2
    targetShell="/run/current-system/sw/bin/fish"
    currentShell="$(dscl . -read /Users/${config.system.primaryUser} UserShell 2>/dev/null || true)"
    currentShell="''${currentShell#UserShell: }"

    if [ "$currentShell" != "$targetShell" ]; then
      dscl . -create /Users/${config.system.primaryUser} UserShell "$targetShell"
    fi
  '';

  # Show the Dock (don't auto-hide)
  system.defaults.dock.autohide = false;

  # Hide file extensions in Finder
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = false;
  system.defaults.finder.AppleShowAllExtensions = false;

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
