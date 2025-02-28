# niks

My nixos config

## Quickstart

Set up a fresh nixos install:

    sudo rm -rf /etc/nixos
    ln -s hosts/<host> /etc/nixos
    sudo nixos-rebuild switch

Set up home manager:

    ln -s home-manager ~/.config/home-manager
    home-manager switch

### wsl setup

Download the latest release.

Create a [WSL release from the tarball]

    wsl --import nixdemo C:\User\martijn.hemeryck\wsl\nixdemo .\<nixosimage>.tar

Start the WSL image

    wsl -d nixdemo

[WSL release from the tarball]: https://learn.microsoft.com/en-us/windows/wsl/use-custom-distro#import-the-tar-file-into-wsl
