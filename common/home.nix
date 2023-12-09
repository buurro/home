{ config, pkgs, userInfo, inputs, ... }:

{
  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
    substituters = [
      "https://cache.nixos.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    # builders = [
    #   "ssh://marco@blender.marco.ooo x86_64-linux /Users/marco/.ssh/id_rsa - - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSU9nMkxKSUp2ajdpMEE1TFIxWGc0eG4vSWhwRWRaVTFOMnJEdGxmSVgxeTkgcm9vdEBuaXhvcwo="
    # ];
    # builders-use-substitutes = true;
  };

  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    ansible
    ansible-lint
    argocd
    asciinema
    bat
    bottom
    cachix
    cheat
    cmctl
    duf
    file
    fluxcd
    gh
    htop
    httpie
    iftop
    iperf3
    jq
    kubectl
    kubeseal
    lazydocker
    lazygit
    neofetch
    nix-tree
    nixpkgs-fmt
    ookla-speedtest
    poetry
    ranger
    rename
    ripgrep
    rnix-lsp
    sshfs
    wget
    yt-dlp
  ];

  home.shellAliases = {
    c = "code .";
    lg = "lazygit";
    p = "poetry run";
    s = "ssh";

    # Since sudo doesn't preserve user PATH,
    # everything installed via nix isn't accessible. This fixes that.
    sudoo = "sudo env \"PATH=$PATH\"";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "/nix/var/nix/profiles/default/bin"
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" "z" "docker" "composer" "vagrant" "rsync" ];
    };
    initExtra = ''
      ### Fix slowness of pastes with zsh-syntax-highlighting.zsh
      pasteinit() {
        OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
        zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
      }

      pastefinish() {
        zle -N self-insert $OLD_SELF_INSERT
      }
      zstyle :bracketed-paste-magic paste-init pasteinit
      zstyle :bracketed-paste-magic paste-finish pastefinish
      ### Fix slowness of pastes

      # iterm2 integration
      if [ -f $HOME/.iterm2_shell_integration.zsh ]; then
        source $HOME/.iterm2_shell_integration.zsh
      fi

      run() {
        _pkg=$1
        shift
        nix run "nixpkgs/${inputs.nixpkgs.rev}#$_pkg" -- $*
        unset _pkg
      }

      shell() {
        nix shell "nixpkgs/${inputs.nixpkgs.rev}#$1"
      }
    '';
  };

  programs = {
    starship.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

    neovim = {
      enable = true;
      vimAlias = true;
    };

    broot = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "Marco Burro";
      userEmail = "marcoburro98@gmail.com";
      difftastic.enable = false;
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    tmux = {
      enable = true;
      extraConfig = ''
        set -g default-terminal "xterm-256color"
      '';
      plugins = [ pkgs.tmuxPlugins.pain-control ];
    };
  };

  home.file.".config/starship.toml".source = ./config/starship.toml;
  home.file.".config/nvim".source = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "v3.28.3";
    sha256 = "0jzhiyjlnzwvfvqyxzskhy2paf4ys6vfbdyxfd2fm1dbzp6d4a7a";
  };
  home.file.".iterm2_shell_integration.zsh".source = ./config/iterm2_shell_integration.zsh;
}
