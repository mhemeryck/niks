{ pkgs, ... }:

rec {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mhemeryck";
  home.homeDirectory = "/home/mhemeryck";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    awscli2
    bat
    carapace
    cargo
    direnv
    dprint
    (google-cloud-sdk.withExtraComponents
      [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    gh
    git
    git-crypt
    glab
    go
    gopls
    gnupg
    helix
    jdt-language-server
    kubectl
    nodejs
    markdown-oxide
    maven
    nil
    nixfmt-classic
    nufmt
    nushell
    oh-my-posh
    pass
    pinentry-curses
    poetry
    python313
    pyright
    ruff
    rustc
    terraform
    terraform-ls
    tldr
    trash-cli
    wl-clipboard
    zig
    zip
    zls
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".dprint.json".text = builtins.toJSON {
      json = { };
      markdown = { };
      toml = { };
      dockerfile = { };
      excludes = [ "**/*-lock.json" ];
      plugins = [
        "https://plugins.dprint.dev/json-0.19.4.wasm"
        "https://plugins.dprint.dev/markdown-0.17.8.wasm"
        "https://plugins.dprint.dev/toml-0.6.4.wasm"
        "https://plugins.dprint.dev/dockerfile-0.3.2.wasm"
      ];
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mhemeryck/etc/profile.d/hm-session-vars.sh
  #

  nixpkgs.config.allowUnfree = true;

  programs.carapace = { enable = true; };

  programs.git = {
    enable = true;
    ignores = [ ".envrc" ];
    userEmail = "martijn.hemeryck@gmail.com";
    userName = "mhemeryck";
    signing = {
      key = "F9DB1494AE92FE2B";
      signByDefault = true;
    };
    extraConfig = {
      init.defaultBranch = "master";
      # "url.git@gitlab.com:".insteadOf = "https://gitlab.com";
      pull.rebase = "true";
    };
  };

  programs.go = {
    enable = true;
    # goPath = ".go";
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
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
        }
        {
          name = "nu";
          auto-format = true;
          formatter.command = "${pkgs.nufmt}/bin/nufmt";
        }
        {
          name = "markdown";
          auto-format = true;
          formatter = {
            command = "${pkgs.dprint}/bin/dprint";
            args = [ "fmt" "--stdin" "markdown" ];
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [ "pyright" "ruff" ];
          formatter = {
            command = "ruff";
            args = [ "format" "-" ];
          };
        }
      ];
      language-server = {
        pyright.config.python.analysis.typeCheckingMode = "basic";
        ruff = {
          command = "ruff";
          args = [ "server" ];
          config.settings.args = [ "ignore" "E501" ];
        };
      };
    };
  };

  programs.nushell = {
    enable = true;
    environmentVariables = {
      EDITOR = "hx";
      COLORTERM = "truecolor";
      GOPATH = "${home.homeDirectory}/.go";
      GOPRIVATE = "gitlab.com/codabox";
    };
    extraConfig = ''
      $env.config.show_banner = false
      $env.config.edit_mode = "vi"
      $env.config.hooks.pre_prompt = (
        $env.config.hooks.pre_prompt | append ({ ||
            if (which direnv | is-empty) {
                return
            }

            direnv export json | from json | default {} | load-env
        })
      )
      $env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)
    '';
  };

  programs.oh-my-posh.enable = true;

  programs.gpg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableNushellIntegration = true;
    sshKeys = [ "247DB8BA660674C13007DDF77FD555EE09A5438C" ];
    pinentryPackage = pkgs.pinentry-curses;
    grabKeyboardAndMouse = false;
  };
}
