# Nix Machines

This is my personal configs in NixOS.
It uses Tailscale to connect the hosts to my Tailscale network.

Note you would probably want to protect your IP with a reverse proxy
in a VPS somewhere and ending the TLS connection there
and forwarding the traffic to your home server using something
like Wireguard or Tailscale.
Or you need to add reverse proxy configs to your NixOS deployments.

## Hosts

I have 1 host configured as a personal computer:

- `desktop`: Nvidia-GPU gaming and programming desktop.
  For Steam games don't forget to prepend the executables with `gamemoderun %command%`
  in the launch options.

I have 3 hosts configured as hardened secure servers:

- `bitcoin`: a bitcoin full node with [`nix-bitcoin`](https://nixbitcoin.org)
- `monero`: a monero full node.
- `matrix`: a matrix home server with [`continuwuity`](https://forgejo.ellis.link/continuwuation/continuwuity)
- `git`: a [`forgejo`](https://forgejo.org) server.

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
