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
      "cargo-cache"
      "cargo-hack"
      "llvm"
      "rustup"
      {
        name = "tor";
        restart_service = true;
      }
      "torsocks"
      "uv"
    ];

    caskArgs.require_sha = true;

    casks = [
      "android-file-transfer"
      "antigravity"
      "brave-browser"
      "cryptomator"
      "cursor"
      "iina"
      "gitbutler"
      "ledger-wallet"
      "mouseless"
      "netnewswire"
      "obs"
      "obscura-vpn"
      "orbstack"
      "protonvpn"
      "proton-pass"
      "secretive"
      "signal"
      "sparrow"
      "tailscale-app"
      "tor-browser"
      "transmission"
      "wasabi-wallet"
    ];
  };
  environment.variables.HOMEBREW_DOWNLOAD_CONCURRENCY = "auto";
}
