sudo nix-collect-garbage --delete-older-than 5d
nix-collect-garbage --delete-older-than 5d
echo $RANDOM > /tmp/nix-wallpaper-seed
sudo nixos-rebuild switch -I nixos-config=./configuration.nix
