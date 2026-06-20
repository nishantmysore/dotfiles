{ pkgs, lib, ... }:

{
  imports = [ ./home-common.nix ];

  home.username = "nishant.mysore";
  home.homeDirectory = lib.mkForce "/Users/nishant.mysore";

  home.packages = with pkgs; [
    vscode
  ];

  # macOS-specific direnv override
  programs.direnv.package = pkgs.direnv.overrideAttrs (old: {
    env = (old.env or { }) // { CGO_ENABLED = "1"; };
    ldflags = builtins.filter (f: f != "-linkmode=external") (old.ldflags or [ ]);
  });

  # macOS-specific shell config
  programs.fish.shellAbbrs.work = "ssh -i ~/.ssh/gcp_x86_key Nishant@136.111.205.91";

  # Kitty terminal (macOS only)
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "JetbrainsMono Nerd Font Mono";
      size = 14;
    };
    settings = {
      copy_on_select = "yes";
      enable_audio_bell = false;
      shell = "/run/current-system/sw/bin/fish";
      window_margin_width = 10;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{index}: {title}";
      background_tint = "0.97";
      background_tint_gaps = "-10.0";
      background_opacity = "0.95";
      background_blur = 20;
      hide_window_decorations = "titlebar-only";
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
      strip_trailing_spaces = "smart";
      allow_remote_control = "yes";
      macos_option_as_alt = "yes";
      macos_traditional_fullscreen = false;
    };
    keybindings = {
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
      "cmd+d" = "launch --location=vsplit --cwd=current";
      "cmd+shift+d" = "launch --location=hsplit --cwd=current";
      "cmd+]" = "next_window";
      "cmd+[" = "previous_window";
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";
    };
  };
}
