{ ... }:

{
  programs.gemini-cli = {
    enable = true;
    settings = {
      vimMode = true;
      telemetry.enabled = false;
      usageStatisticsEnabled = false;
    };
  };
}
