{
  lib,
  username,
  secretiveFingerprint,
  ...
}:

let
  SSH_AUTH_SOCK = "/Users/${username}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
in
{
  home.sessionVariables = {
    inherit SSH_AUTH_SOCK;
  };

  home.file.".ssh/allowed_signers".text = "* ${secretiveFingerprint}";

  programs = {
    git = {
      enable = true;
      extraConfig = {
        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = lib.mkForce "ssh";
        gpg.ssh = {
          allowedSignersFile = lib.mkForce "~/.ssh/allowed_signers";
          defaultKeyCommand = "ssh-add -L";
        };
        user.signingkey = lib.mkForce "key::${secretiveFingerprint}";
      };
    };
    ssh = {
      matchBlocks = {
        "*" = {
          identityAgent = SSH_AUTH_SOCK;
        };
      };
    };
  };
}
