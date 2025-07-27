set positional-arguments

# List all commands
default:
  @just --list

# List all hosts
list-hosts:
  @ls hosts/ | grep -v common | grep -v default.nix

# Install the NixOS configuration for a specific host (run after disko)
install *host:
  sudo nixos-install --root /mnt --no-root-passwd --flake .#{{host}}

# Install with impure flag if restricted mode issues occur (run after disko)
install-impure *host:
  sudo nixos-install --root /mnt --no-root-passwd --impure --flake .#{{host}}

# Update the NixOS flake inputs and rebuild the host
update *host: update-flake-inputs reclaim-storage
  doas nixos-rebuild boot --flake .#{{host}}

# Automated disk partitioning with disko
disko *host:
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount hosts/{{host}}/disko.nix

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
