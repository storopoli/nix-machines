{ ... }:

{
  homebrew = {
    # Homebrew Package Manager
    enable = true;

    onActivation = {
      # "zap" removes manually installed brews and casks
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    brews = [
      "llvm"
      "pinentry-mac"
      {
        name = "tor";
        restart_service = true;
      }
      "torsocks"
    ];

    caskArgs.require_sha = true;

    casks = [
      "android-file-transfer"
      "brave-browser"
      "cryptomator"
      "ghostty"
      "iina"
      "netnewswire"
      "obs"
      "obscura-vpn"
      "orbstack"
      "protonvpn"
      "signal"
      "sparrow"
      "tailscale-app"
      "tor-browser"
      "transmission"
    ];
  };
  environment.variables.HOMEBREW_DOWNLOAD_CONCURRENCY = "auto";
}
