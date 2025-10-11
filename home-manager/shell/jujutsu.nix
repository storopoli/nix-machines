{
  secretiveFingerprint,
  ...
}:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Jose Storopoli";
        email = "jose@storopoli.com";
      };

      ui = {
        default-command = "log";
        diff-editor = "nvim -d";
      };

      signing = {
        behavior = "own";
        backend = "ssh";
        key = secretiveFingerprint;
        backends = {
          allowed-signers = "~/.ssh/allowed_signers";
        };
      };

      git = {
        sign-on-push = true;
      };
    };
  };

  programs.jjui.enable = true;
}
