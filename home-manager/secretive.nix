{
  lib,
  username,
  ...
}:

let
  SSH_AUTH_SOCK = "/Users/${username}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  secretiveId = "2afd121f9b42ffcad4370323f03b63ee";
  secretiveKey = "/Users/${username}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/${secretiveId}.pub";
  secretiveFingerprint = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLqHZrt6LpY13sVkGWbiofJgF+IayppaMwHuEt51chWVFfE7hBt7tN5356+a7ZqU6NaTRN4IIlEvPUm+SUxOp10= ssh@secretive.macbook.local";
in
{
  home.sessionVariables = {
    inherit SSH_AUTH_SOCK;
  };

  home.file.".ssh/allowed_signers".text = "* ${builtins.readFile secretiveKey}";

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
