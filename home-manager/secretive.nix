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

  # Create public key file for jujutsu (needs a file path, not just the key string)
  home.file.".ssh/secretive_signing_key.pub".text = secretiveFingerprint;

  programs = {
    git = {
      enable = true;
      signing = {
        format = lib.mkForce "ssh";
        key = lib.mkForce "key::${secretiveFingerprint}";
        signByDefault = true;
      };
      settings = {
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
