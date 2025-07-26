{ pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    package = pkgs.gnupg;
    settings = {
      # The default key to sign with. If this option is not used, the default key is
      # the first key found in the secret keyring
      default-key = "0x1BD38BE8D0653A7A";

      # This is an implementation of the Riseup OpenPGP Best Practices
      # https://help.riseup.net/en/security/message-security/openpgp/best-practices

      # UTF-8
      charset = "utf8";

      # Disable inclusion of the version string in ASCII armored output
      no-emit-version = true;

      # Disable comment string in clear text signatures and ASCII armored messages
      no-comments = true;

      # Disable greetings
      no-grettings = true;

      # Display long key IDs
      keyid-format = "0xlong";

      # List all keys (or the specified ones) along with their fingerprints
      with-fingerprint = true;

      # Display the calculated validity of user IDs during key listings
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";

      # Cross-certify subkeys are present and valid
      require-cross-certification = true;

      # Enforce memory locking to avoid accidentally swapping GPG memory to disk
      require-secmem = true;

      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = true;

      # Try to use the GnuPG-Agent. With this option, GnuPG first tries to connect to
      # the agent before it asks for a passphrase.
      use-agent = true;

      # Output ASCII instead of binary
      armor = true;

      # Disable recipient key ID in messages (WARNING: breaks Mailvelope)
      throw-keyids = true;

      # This is the server that --recv-keys, --send-keys, and --search-keys will
      # communicate with to receive keys from, send keys to, and search for keys on
      keyserver = "hkps://keys.openpgp.org/";

      # Set the proxy to use for HTTP and HKP keyservers - default to the standard
      # local Tor socks proxy
      # It is encouraged to use Tor for improved anonymity. Preferrably use either a
      # dedicated SOCKSPort for GnuPG and/or enable IsolateDestPort and
      # IsolateDestAddr
      #keyserver-options = "http-proxy=socks5-hostname://127.0.0.1:9050";

      # When using --refresh-keys, if the key in question has a preferred keyserver
      # URL, then disable use of that preferred keyserver to refresh the key from
      # When searching for a key with --search-keys, include keys that are marked on
      # the keyserver as revoked
      keyserver-options = "no-honor-keyserver-url include-revoked";

      # list of personal digest preferences. When multiple digests are supported by
      # all recipients, choose the strongest one
      personal-cipher-preferences = "AES256 AES192 AES";

      # list of personal digest preferences. When multiple ciphers are supported by
      # all recipients, choose the strongest one
      personal-digest-preferences = "SHA512 SHA384 SHA256";

      # message digest algorithm used when signing a key
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cypher-algo = "AES256";

      # list of personal compression preferences. When multiple ciphers are supported by
      # all recipients, choose the strongest one
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";

      # This preference list is used for new keys and becomes the default for
      # "setpref" in the edit menu
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
    };
  };
  home.file.".gnupg/sshcontrol".text = ''
    # List of allowed ssh keys.  Only keys present in this file are used
    # in the SSH protocol.  The ssh-add tool may add new entries to this
    # file to enable them; you may also add them manually.  Comment
    # lines, like this one, as well as empty lines are ignored.  Lines do
    # have a certain length limit but this is not serious limitation as
    # the format of the entries is fixed and checked by gpg-agent. A
    # non-comment line starts with optional white spaces, followed by the
    # keygrip of the key given as 40 hex digits, optionally followed by a
    # caching TTL in seconds, and another optional field for arbitrary
    # flags.   Prepend the keygrip with an '!' mark to disable it.

    # Ed25519 key added on: 2025-07-17 05:42:17
    # Fingerprints:  MD5:79:3e:91:ae:d6:16:d3:88:70:cf:1c:f5:a1:73:1a:de
    #                SHA256:zxjyh+oQcda6RGYiZ3ExckqUFVD+gHP0BTayR3x/mEQ
    F46DFA972751E36823457138030656AA7AD3DE17 0
  '';

  services.gpg-agent = {
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
  };
}
