set positional-arguments

# List all commands
[group('misc')]
default:
  @just --list

# List all available hosts in the hosts/ directory
[group('misc')]
list-hosts:
  @ls hosts/ | grep -v common | grep -v default.nix

# Update NixOS flake inputs and rebuild the host
[group('maintenance')]
update *host: update-flake-inputs reclaim-storage
  doas nixos-rebuild boot --flake .#{{host}}

# Update macOS configuration with `nix-darwin`
[group('maintenance')]
update-darwin *host: update-flake-inputs reclaim-storage
  darwin-rebuild switch --flake .#{{host}}

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
  sudo nixos-install --root /mnt --no-root-passwd --flake .#{{host}}

# Install with impure flag if restricted mode issues occur (run after `disko`)
[group('install')]
install-impure *host:
  sudo nixos-install --root /mnt --no-root-passwd --impure --flake .#{{host}}

# Initial setup for macOS with `nix-darwin` (first time only)
[group('install')]
setup-darwin *host:
  sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch --flake .#{{host}}

# Show Bitcoin service status
[group('bitcoin')]
bitcoin-status:
  systemctl status bitcoind

# Show Bitcoin service logs since last boot
[group('bitcoin')]
bitcoin-logs:
  journalctl -b -u bitcoind

# Update flake inputs to latest versions
[group('maintenance')]
update-flake-inputs:
  nix flake update

# Reclaim storage by removing old generations
[group('maintenance')]
reclaim-storage:
  nix-collect-garbage -d
