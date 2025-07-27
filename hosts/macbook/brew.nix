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
      "pinentry-mac"
      {
        name = "tor";
        restart_service = true;
      }
      "torsocks"
    ];

    casks = [
      "ghostty"
      "android-file-transfer"
      "cryptomator"
      "iina"
      "obscura-vpn"
      "obs"
      "signal"
      "sparrow"
      "tor-browser"
      "transmission"
    ];
  };
}
