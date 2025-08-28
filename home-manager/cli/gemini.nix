{ ... }:

{
  programs.gemini-cli = {
    enable = true;
    settings = {
      vimMode = true;
      preferredEditor = "nvim";
      telemetry.enabled = false;
      usageStatisticsEnabled = false;
    };
  };
}
