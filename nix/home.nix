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
    uv
    clang-tools
    devenv
    manix
    ninja
    yadm
    pkgs.claude-code
  ];

  # Claude Code configuration
  home.file.".claude/settings.json".text = builtins.toJSON {
    enabledPlugins = {
      "clangd-lsp@claude-plugins-official" = true;
      "pyright-lsp@claude-plugins-official" = true;
    };
    statusLine = {
      type = "command";
      command = "~/.claude/statusline.sh";
    };
  };

  home.file.".claude/statusline.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Tide-inspired powerline statusline for Claude Code

      data=$(cat)

      model=$(echo "$data" | jq -r '.model.display_name // "Claude"')
      cwd=$(echo "$data" | jq -r '.cwd // ""')
      cost_raw=$(echo "$data" | jq -r '.cost.total_cost_usd // 0')
      ctx_pct=$(echo "$data" | jq -r '.context_window.used_percentage // 0')
      vim_mode=$(echo "$data" | jq -r '.vim.mode // empty')

      cwd="''${cwd/#$HOME/~}"
      cost_str=$(printf '%.2f' "$cost_raw")

      SEP=$'\ue0b0'

      # Tide OS segment colors (bg #333333, fg #D6D6D6)
      S1_BG='\033[48;2;51;51;51m'
      S1_FG='\033[38;2;214;214;214m'
      S1_SEP='\033[38;2;51;51;51m'

      # Tide PWD segment colors (bg #3465A4, fg #E4E4E4)
      S2_BG='\033[48;2;52;101;164m'
      S2_FG='\033[38;2;228;228;228m'
      S2_SEP='\033[38;2;52;101;164m'

      # Info segment colors (bg #444444, fg #D6D6D6)
      S3_BG='\033[48;2;68;68;68m'
      S3_FG='\033[38;2;214;214;214m'
      S3_SEP='\033[38;2;68;68;68m'

      # Tide git segment colors for vim mode (bg #4E9A06, fg #000000)
      VM_BG='\033[48;2;78;154;6m'
      VM_FG='\033[38;2;0;0;0m'
      VM_SEP='\033[38;2;78;154;6m'

      RST='\033[0m'

      out=""

      # Vim mode segment (green, like Tide git/vi_mode)
      if [[ -n "$vim_mode" ]]; then
        out+="$VM_BG$VM_FG$vim_mode$S1_BG$VM_SEP$SEP"
      fi

      # Model segment (dark, like Tide OS)
      out+="$S1_BG$S1_FG$model$S2_BG$S1_SEP$SEP"

      # CWD segment (blue, like Tide PWD)
      out+="$S2_BG$S2_FG$cwd$S3_BG$S2_SEP$SEP"

      # Info segment (cost + context %)
      out+="$S3_BG$S3_FG\$$cost_str $ctx_pct%$RST$S3_SEP$SEP$RST"

      printf '%b' "$out"
    '';
  };

  programs = {
    # Fish shell
    fish = {
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
    git = {
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
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd" "cd" ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
    };

    # Kitty terminal
    kitty = {
      enable = true;
      themeFile = "Catppuccin-Mocha";
      font = {
        name = "JetbrainsMono Nerd Font Mono";
        size = 14;
      };
      settings = {
        copy_on_select = "yes";
        enable_audio_bell = false;
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

    gh.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    jq.enable = true;
  };
}
