# Home Server

This is my home server configs in NixOS.

## Hosts

I have 2 hosts configured as hardened secure servers:

- `bitcoin`: a nixOS machine running a bitcoin full node.
- `monero`: a nixOS machine running a monero full node.

## To deploy

I have configured several `just` commands to deploy the configs to the hosts.

```bash
$ just              
Available recipes:
    bitcoin-logs        # Show Bitcoin service logs since last boot
    bitcoin-status      # Show Bitcoin service status
    default             # List all commands
    disko *host         # Automated disk partitioning with disko
    install *host       # Install the NixOS configuration for a specific host
    list-hosts          # List all hosts
    reclaim-storage     # Reclaim storage
    update *host        # Update the NixOS flake inputs and rebuild the host
    update-flake-inputs # Update flake inputs
```

For example, to deploy the configs to the `bitcoin` host, you can run:

```bash
just install bitcoin
```

## Automated disk partitioning

I'm using the `disko` tool to partition the disks.
Every host has a `disko.nix` file that describes the disk layout.

For example, to partition the disk for the `bitcoin` host, you can run:

```bash
just disko bitcoin
```

## LICENSE

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
