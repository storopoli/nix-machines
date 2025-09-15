{
  pkgs,
  ...
}:

{
  programs.gemini-cli = {
    enable = true;
    package = pkgs.gemini-cli-bin;
    settings = {
      vimMode = true;
      telemetry.enabled = false;
      usageStatisticsEnabled = false;
    };
  };
}
