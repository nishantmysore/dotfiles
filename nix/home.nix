{ pkgs, lib, ... }:

{
  home.username = "nishraptor";
  home.homeDirectory = lib.mkForce "/Users/nishraptor";
  home.stateVersion = "24.11";

  # Packages managed per-user (CLI tools, etc.)
  home.packages = with pkgs; [
    bat
    eza
    neovim
    yadm
  ];

  # Fish shell
  programs.fish = {
    enable = true;
    shellAbbrs = {
      python = "python3";
      work = "ssh -i ~/.ssh/gcp_x86_key Nishant@136.111.205.91";
    };
    shellAliases = {
      vim = "nvim";
      cat = "bat";
      ls = "eza";
      rebuild = "sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ~/nix";
      claude-personal = "CLAUDE_CONFIG_DIR=~/.claude-personal claude";
    };
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
  };

  # Git
  programs.git = {
    enable = true;
    ignores = [
      "**/.claude/settings.local.json"
    ];
    settings = {
      user = {
        name = "Nishant Mysore";
        email = "nishantmysore0@gmail.com";
      };
      alias = {
        check = "checkout";
        d = "diff --cached";
        de = "diff";
        s = "status";
        stat = "status";
        tree = "log --graph --decorate --oneline --all -n 25";
        treel = "log --graph --decorate --oneline --all";
      };
      push.autoSetupRemote = true;
      credential.helper = "store";
    };
  };

  # Ripgrep
  programs.ripgrep.enable = true;

  # fd
  programs.fd.enable = true;

  # jq
  programs.jq.enable = true;
}
