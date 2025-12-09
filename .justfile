set positional-arguments

# List all commands
[group('misc')]
default:
  @just --list

# List all available hosts in the hosts/ directory
[group('misc')]
list-hosts:
  @ls hosts/ | grep -v common | grep -v default.nix

# Format all Nix files
[group('misc')]
format:
  nix fmt

# Fix `doas` permissions when deploying from a normal user
[group('misc')]
fix-doas-permission:
  doas git config --global --add safe.directory $(pwd)

# Update NixOS flake inputs and rebuild the host
[group('maintenance')]
update *host: update-flake-inputs reclaim-storage
  doas nixos-rebuild boot --flake .#{{host}}

# Rebuild the host
[group('maintenance')]
rebuild *host:
  doas nixos-rebuild switch --flake .#{{host}}

# Automated disk partitioning with `disko`
[group('install')]
disko *host:
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount hosts/{{host}}/disko.nix

# Generate NixOS hardware configuration (run after `disko`, before `install`)
[group('install')]
generate-config:
  sudo nixos-generate-config --no-filesystems --root /mnt

# Install NixOS configuration for a specific host (run after `disko`)
[group('install')]
install *host:
  sudo nixos-install --root /mnt --no-root-passwd --option download-buffer-size 524288000 --flake .#{{host}}

# Install with impure flag if restricted mode issues occur (run after `disko`)
[group('install')]
install-impure *host:
  sudo nixos-install --root /mnt --no-root-passwd --option download-buffer-size 524288000 --impure --flake .#{{host}}

# Show Bitcoin service status
[group('bitcoin')]
bitcoin-status:
  systemctl status bitcoind

# Show Bitcoin service logs since last boot
[group('bitcoin')]
bitcoin-logs:
  journalctl -b -u bitcoind

# Show Ethereum consensus client service status
[group('ethereum')]
lighthouse-status:
  systemctl status lighthouse-beacon-mainnet

# Show Ethereum consensus client service logs since last boot
[group('ethereum')]
lighthouse-logs:
  journalctl -b -u lighthouse-beacon-mainnet

# Show Ethereum execution client service status
[group('ethereum')]
geth-status:
  systemctl status geth-mainnet

# Show Ethereum execution client service logs since last boot
[group('ethereum')]
geth-logs:
  journalctl -b -u geth-mainnet

# Update flake inputs to latest versions
[group('maintenance')]
update-flake-inputs:
  nix flake update

# Reclaim storage by removing old generations
[group('maintenance')]
reclaim-storage:
  nix-collect-garbage -d
