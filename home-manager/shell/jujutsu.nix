{
  secretiveFingerprint ? null,
  isDarwin ? false,
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

      signing =
        if isDarwin && secretiveFingerprint != null then
          {
            behavior = "own";
            backend = "ssh";
            key = secretiveFingerprint;
            backends = {
              allowed-signers = "~/.ssh/allowed_signers";
            };
          }
        else
          {
            behavior = "own";
            backend = "gpg";
            key = "0x1BD38BE8D0653A7A";
          };

      git = {
        sign-on-push = true;
      };
    };
  };

  programs.jjui.enable = true;
}
