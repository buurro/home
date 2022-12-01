{ config, pkgs, userInfo, ... }:

{
  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
  };

  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    asciinema
    bat
    bottom
    cachix
    cheat
    duf
    gh
    htop
    httpie
    iperf3
    lazygit
    neofetch
    nixpkgs-fmt
    nodejs-19_x
    poetry
    rnix-lsp
    wget
  ];

  home.shellAliases = {
    c = "code .";
    p = "poetry run";
    s = "ssh";

    what-shell = "readlink /proc/$$/exe";
    shell = "$(readlink /proc/$$/exe)";
    shell-switch = "home-manager switch --flake 'github:buurro/shell#marco'";
    local-shell-switch = "home-manager switch --flake '.#marco'";
    local-mac-switch = "darwin-rebuild switch --flake .";

    # Since sudo doesn't preserve user PATH,
    # everything installed via nix isn't accessible. This fixes that.
    sudoo = "sudo env \"PATH=$PATH\"";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" "z" "docker" "composer" "vagrant" ];
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
    };
  };

  home.file.".config/starship.toml".source = ./config/starship.toml;
  home.file.".config/nvim".source = pkgs.fetchFromGitHub
    {
      owner = "AstroNvim";
      repo = "AstroNvim";
      rev = "v2.6.1";
      sha256 = "04kdsf5v5msdb9vygh3l2f92sakkrsh7n4nxjb8sads9xg1j4qkr";
    };
}
