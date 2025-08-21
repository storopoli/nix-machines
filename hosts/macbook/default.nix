{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./brew.nix
  ];

  # System configuration version
  system.stateVersion = 6;

  # Set primary user for homebrew and other user-specific options
  system.primaryUser = username;

  # hostname
  networking.hostName = "macbook";

  # Nix configuration
  nix = {
    # WARN: if Nix was installed with `--determinate`
    #       you need to disable nix.
    #       To find you see if you have `/usr/local/bin/determinate-nixd`
    enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@admin"
        "${username}"
      ];
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # darwin specific packages
    hello
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # User configuration
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
