# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.mhemeryck = {
    isNormalUser = true;
    description = "Martijn Hemeryck";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs;
      [
        #  thunderbird
      ];
    shell = pkgs.nushell;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "24.05"; # Did you read the comment?

  networking.hostName = "tinkerbell";

  environment.systemPackages = with pkgs; [
    bat
    git
    home-manager
    helix
    openssh
    wsl-vpnkit
  ];

  # see https://github.com/sakai135/wsl-vpnkit/blob/5084c6d/wsl-vpnkit.service
  systemd.services.wsl-vpnkit = {
    enable = true;
    description = "wsl-vpnkit";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.wsl-vpnkit}/bin/wsl-vpnkit";
      Restart = "always";
      KillMode = "mixed";
    };
  };
}
