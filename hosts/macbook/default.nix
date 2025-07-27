{ pkgs, username, ... }:
{
  imports = [
    ./brew.nix
  ];

  # System configuration version
  system.stateVersion = 5;

  # Set primary user for homebrew and other user-specific options
  system.primaryUser = username;

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@admin" ];
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # darwin specific packages
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # User configuration
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
