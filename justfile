set positional-arguments

# List all commands
default:
  @just --list

# List all hosts
list-hosts:
  @ls hosts/nixos

# Install the NixOS configuration for a specific host
install *host:
  sudo nixos-install --no-root-passwd --flake .#{{host}}

# Update the NixOS flake inputs and rebuild the host
update *host: update-flake-inputs reclaim-storage
  doas nixos-rebuild boot --flake .#{{host}}

# Automated disk partitioning with disko
disko *host:
  nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hosts/nixos/{{host}}/disko.nix

# Show Bitcoin service status
bitcoin-status:
  systemctl status bitcoind

# Show Bitcoin service logs since last boot
bitcoin-logs:
  journalctl -b -u bitcoind

# Update flake inputs
update-flake-inputs:
  nix flake update

# Reclaim storage
reclaim-storage:
  nix-collect-garbage -d