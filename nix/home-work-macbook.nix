{ pkgs, lib, ... }:

{
  imports = [ ./home-darwin.nix ];

  # Work laptop-only packages go here.
  home.packages = with pkgs; [
    (lib.lowPrio arm-toolchain-for-embedded)
    gcc-arm-embedded
    segger-jlink
  ];

  programs.fish.shellAliases.rebuild = "sudo nix run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --flake ~/Documents/dotfiles/nix#work-macbook";
}
