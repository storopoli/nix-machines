# Nix Machines

This is my personal configs in NixOS.
It uses Tailscale to connect the hosts to my Tailscale network.

> [!NOTE]
> For the server deployments, you would probably want
> to protect your IP with a reverse proxy
> in a VPS somewhere and ending the TLS connection there
> and forwarding the traffic to your home server using something
> like Wireguard or Tailscale.
> Or you need to add reverse proxy configs to your NixOS deployments.

## Nix Machines

- `bitcoin`: a bitcoin full node with [`nix-bitcoin`](https://nixbitcoin.org)
- `monero`: a monero full node.
- `matrix`: a matrix home server with [`continuwuity`](https://forgejo.ellis.link/continuwuation/continuwuity).
- `git`: a [`forgejo`](https://forgejo.org) server.

## To deploy

I have configured several `just` commands to deploy the configs to the hosts.

```bash
$ just
Available recipes:
    [bitcoin]
    bitcoin-logs         # Show Bitcoin service logs since last boot
    bitcoin-status       # Show Bitcoin service status

    [install]
    disko *host          # Automated disk partitioning with `disko`
    generate-config      # Generate NixOS hardware configuration (run after `disko`, before `install`)
    install *host        # Install NixOS configuration for a specific host (run after `disko`)
    install-impure *host # Install with impure flag if restricted mode issues occur (run after `disko`)

    [maintenance]
    rebuild *host        # Rebuild the host
    reclaim-storage      # Reclaim storage by removing old generations
    update *host         # Update NixOS flake inputs and rebuild the host
    update-flake-inputs  # Update flake inputs to latest versions

    [misc]
    default              # List all commands
    fix-doas-permission  # Fix `doas` permissions when deploying from a normal user
    format               # Format all Nix files
    list-hosts           # List all available hosts in the hosts/ directory
```

For a **fresh installation** on the `bitcoin` host, you would run:

```bash
just disko bitcoin        # Partition and mount the disk
just generate-config      # Generate hardware configuration
just install bitcoin      # Install NixOS to /mnt
```

> [!IMPORTANT]
> The `generate-config` step is crucial - it creates the hardware configuration
> without filesystem conflicts since disko handles the filesystem setup.

> [!WARNING]
> The generated hardware configuration may conflict with the existing host-specific
> hardware configuration. Review `/mnt/etc/nixos/hardware-configuration.nix` and
> `hosts/{host}/hardware-configuration.nix` to determine which settings to keep
> for your actual hardware.

For **updating an existing system**, use:

```bash
just update bitcoin
```

## Tailscale

By default [`tailscale`](https://tailscale.com) is enabled for all hosts.
Uncomment the

```nix
# authKeyFile = /tmp/tailscale.key;
```

in the `lib/tailscale.nix` file.

It will read a key from `/tmp/tailscale.key` so make sure to create this file
and add your tailnet authorization key.

## Automated disk partitioning

> [!WARNING]
> The `disko` command will **DESTROY** all data on the target disk!
> Make sure you have backups and are targeting
> the correct device before running these commands.

I'm using the `disko` tool to partition the disks.
Every host has a `disko.nix` file that describes the disk layout with parameterized disk configuration.

Each host's `disko.nix` accepts a `disks` parameter with sensible defaults (e.g., `[ "/dev/sda" ]`).
You can customize the disk devices by passing different values when needed.

For example, to partition the disk for the `bitcoin` host, you can run:

```bash
just disko bitcoin
```

## LICENSE

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
