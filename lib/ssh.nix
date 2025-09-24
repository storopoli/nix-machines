{
  username,
  ...
}:
let
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKU4O0J7gdU1+0/IoVZUtajfmWGGNmA3TFXTsbnQfpwt"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJxv4Hr9OPL1ZMx+jVm2vp4kjJIJVGVIkpnfBO3+Zr8"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG83q6Dr8kaTFt9nIFN6gaXujSeMGWtRyejTcqFvGDAF"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrqm5G5d/AVqhGhaE20iRzLc1u6fySR9ul2e9RbQVio"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDv682q7hmMYG2iBpgg9fI5TOJbAx/9P1K2KjsL7q16HAAAABHNzaDo="
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEMt3wUpLy0Kx7876EO7CUMGj7BKNeF9wLZPOSR2p4JtAAAABHNzaDo="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGIhKrCL5QLSi8cRUVvf1uAQiEJwc7Ew8TFgjdtvnSqX"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJKBilUg02Tv3rOOxlOVBl1eUMpEpCgTSahQhBY/XTU"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3YtfEbv02sDCJmRIOH8hlhEF93/Ory6IE2OKCkhAk+"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEN7VdD0bF+/Y6dYT+7xoqbWAgTXYaR1pTRcjenw2Px4"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLqHZrt6LpY13sVkGWbiofJgF+IayppaMwHuEt51chWVFfE7hBt7tN5356+a7ZqU6NaTRN4IIlEvPUm+SUxOp10= ssh@secretive.macbook.local"
  ];
in
{
  services = {
    openssh = {
      enable = true;
      settings = {
        # Modern ciphers/MACs
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
          "aes256-ctr"
          "aes192-ctr"
          "aes128-ctr"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];
        # require public key authentication for better security
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;

        # Only for the user `user`
        AllowUsers = [ "${username}" ];
        PermitRootLogin = "yes";

        LogLevel = "INFO";
      };
    };
  };

  users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
  users.users.${username}.openssh.authorizedKeys.keys = authorizedKeys;

  # Open port 22 in Firewall
  networking.firewall.allowedTCPPorts = [
    22
  ];
}
