{ ... }:

{
  programs.jjui.enable = true;
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
    };
  };
}
