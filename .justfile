set positional-arguments

# List all commands
default:
  @just --list

# List all hosts
list-hosts:
  @ls hosts/ | grep -v common | grep -v default.nix

# Install the NixOS configuration for a specific host (run after `disko`)
install *host:
  sudo nixos-install --root /mnt --no-root-passwd --flake .#{{host}}

# Install with impure flag if restricted mode issues occur (run after `disko`)
install-impure *host:
  sudo nixos-install --root /mnt --no-root-passwd --impure --flake .#{{host}}

# Update the NixOS flake inputs and rebuild the host
update *host: update-flake-inputs reclaim-storage
  doas nixos-rebuild boot --flake .#{{host}}

# Initial setup for macOS with `nix-darwin` (first time only)
setup-darwin *host:
  sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch --flake .#{{host}}

# Update the macOS configuration with `nix-darwin`
update-darwin *host: update-flake-inputs reclaim-storage
  darwin-rebuild switch --flake .#{{host}}

# Automated disk partitioning with `disko`
disko *host:
  sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount hosts/{{host}}/disko.nix

# Generate NixOS hardware configuration (run after `disko`, before `install`)
generate-config:
  sudo nixos-generate-config --no-filesystems --root /mnt

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
