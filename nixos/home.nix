{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    carapace
    cargo
    dprint
    gh
    glab
    go
    git
    gnupg
    helix
    kubectl
    nil
    nixfmt-classic
    nushell
    # oh-my-posh
    pass
    poetry
    python313
    rustc
    tldr
    wl-clipboard
  ];
  # programs.bash.enable = true;

  programs.carapace = { enable = true; };

  programs.git = {
    enable = true;
    userEmail = "martijn.hemeryck@gmail.com";
    userName = "mhemeryck";
    extraConfig.init.defaultBranch = "master";
  };

  programs.go = {
    enable = true;
    goPath = ".go";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "molokai";

      keys.normal = {
        C-l = "jump_view_right";
        C-h = "jump_view_left";
        C-j = "jump_view_down";
        C-k = "jump_view_up";
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
    }];
  };

  # programs.oh-my-posh = {
  #   enable = true;
  #   enableNushellIntegration = true;
  # };

  # services.gpg-agent = {
  #   enable = true;
  # };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
}
