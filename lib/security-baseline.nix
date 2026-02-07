{
  lib,
  username,
  ...
}:
{
  users = {
    # Keep account state declarative and avoid drift from manual edits.
    mutableUsers = false;

    # Keys-only access model: disable password logins for both accounts.
    users.root.hashedPassword = lib.mkForce "!";
    users.${username}.hashedPassword = lib.mkForce "!";
  };

  services.openssh.settings = {
    PermitRootLogin = lib.mkDefault "no";
    PasswordAuthentication = lib.mkDefault false;
    KbdInteractiveAuthentication = lib.mkDefault false;
    PermitEmptyPasswords = lib.mkDefault false;
    LoginGraceTime = lib.mkDefault "30s";
    MaxAuthTries = lib.mkDefault 3;
    MaxSessions = lib.mkDefault 4;
    X11Forwarding = lib.mkDefault false;
  };

  networking.firewall = {
    allowPing = lib.mkDefault false;
    logRefusedConnections = lib.mkDefault true;
  };

  # Conservative hardening that is safe for server workloads.
  boot.kernel.sysctl = {
    # Use explicit override priority so we don't conflict with NixOS defaults
    # while still allowing host-specific non-default overrides.
    "kernel.kptr_restrict" = lib.mkOverride 900 2;
    "kernel.dmesg_restrict" = lib.mkOverride 900 1;
    "kernel.yama.ptrace_scope" = lib.mkOverride 900 1;
    "net.ipv4.conf.all.accept_redirects" = lib.mkOverride 900 0;
    "net.ipv4.conf.default.accept_redirects" = lib.mkOverride 900 0;
    "net.ipv4.conf.all.send_redirects" = lib.mkOverride 900 0;
    "net.ipv4.conf.default.send_redirects" = lib.mkOverride 900 0;
    "net.ipv4.conf.all.rp_filter" = lib.mkOverride 900 1;
    "net.ipv4.conf.default.rp_filter" = lib.mkOverride 900 1;
    "net.ipv4.tcp_syncookies" = lib.mkOverride 900 1;
  };
}
