{ ... }:

{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      github = {
        hostname = "github.com";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
      gitlab = {
        hostname = "gitlab.com";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
      codeberg = {
        hostname = "codeberg.org";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
      sourcehut = {
        hostname = "git.sr.ht";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
      proxmox = {
        hostname = "proxmox.dojo-regulus.ts.net";
        user = "root";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
      bitcoin = {
        hostname = "bitcoin.dojo-regulus.ts.net";
        user = "user";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
      matrix = {
        hostname = "matrix.dojo-regulus.ts.net";
        user = "user";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
      caddy = {
        hostname = "caddy.dojo-regulus.ts.net";
        user = "ubuntu";
        forwardX11 = false;
        forwardX11Trusted = false;
      };
      onion = {
        hostname = "*.onion";
        proxyCommand = "nc -xlocalhost:9050 %h %p";
      };
    };
    extraConfig = ''
      IgnoreUnknown AddKeysToAgent,UseKeychain
      AddKeysToAgent yes
      UseKeychain yes
    '';
  };
  home.file.".ssh/known_hosts".text = ''
    github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
    github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
    github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=

    gist.github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
    gist.github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
    gist.github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=

    gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
    gitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
    gitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=

    codeberg.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVIC02vnjFyL+I4RHfvIGNtOgJMe769VTF1VR4EB3ZB
    codeberg.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL2pDxWr18SoiDJCGZ5LmxPygTlPu+cCKSkpqkvCyQzl5xmIMeKNdfdBpfbCGDPoZQghePzFZkKJNR/v9Win3Sc=
    codeberg.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8hZi7K1/2E2uBX8gwPRJAHvRAob+3Sn+y2hxiEhN0buv1igjYFTgFO2qQD8vLfU/HT/P/rqvEeTvaDfY1y/vcvQ8+YuUYyTwE2UaVU5aJv89y6PEZBYycaJCPdGIfZlLMmjilh/Sk8IWSEK6dQr+g686lu5cSWrFW60ixWpHpEVB26eRWin3lKYWSQGMwwKv4LwmW3ouqqs4Z4vsqRFqXJ/eCi3yhpT+nOjljXvZKiYTpYajqUC48IHAxTWugrKe1vXWOPxVXXMQEPsaIRc2hpK+v1LmfB7GnEGvF1UAKnEZbUuiD9PBEeD5a1MZQIzcoPWCrTxipEpuXQ5Tni4mN

    git.sr.ht ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZvRd4EtM7R+IHVMWmDkVU3VLQTSwQDSAvW0t2Tkj60
    git.sr.ht ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCj6y+cJlqK3BHZRLZuM+KP2zGPrh4H66DacfliU1E2DHAd1GGwF4g1jwu3L8gOZUTIvUptqWTkmglpYhFp4Iy4=
    git.sr.ht ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ+l/lvYmaeOAPeijHL8d4794Am0MOvmXPyvHTtrqvgmvCJB8pen/qkQX2S1fgl9VkMGSNxbp7NF7HmKgs5ajTGV9mB5A5zq+161lcp5+f1qmn3Dp1MWKp/AzejWXKW+dwPBd3kkudDBA1fa3uK6g1gK5nLw3qcuv/V4emX9zv3P2ZNlq9XRvBxGY2KzaCyCXVkL48RVTTJJnYbVdRuq8/jQkDRA8lHvGvKI+jqnljmZi2aIrK9OGT2gkCtfyTw2GvNDV6aZ0bEza7nDLU/I+xmByAOO79R1Uk4EYCvSc1WXDZqhiuO2sZRmVxa0pQSBDn1DB3rpvqPYW+UvKB3SOz

    caddy.dojo-regulus.ts.net ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIXPYCzf13kt5pxQjc3JzIrJryEuCv+/O1zhjFk16t4
    caddy.dojo-regulus.ts.net ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClv2ATc1fFyoRkSPS9WtbHwc0uf9ZN8PuuslvuG9UPoa8tcsnpTVu+9e3mkJmFu0QHDq0BDNSWi/haUUk3/jey3coI2Dzm21w1DAE7M7ThVwB1ffbtEaFy6aVny7nZMX4erfp08nvUvn2xcJxpy/vDxwRKgERsBoYxQzt6fAW5E+c7JKPT7DDE/zo4CfTZY1TZ/LuNZ+a9xOaIhWCZjd3Sl4eQ7Ik6r7rPQmT9m4oZNf0f1ztEN/88+HXI8bMgop7N0PjnQUoSDYmA+bDl2S7GV3tJhv904QZ+HH3nw4Nq8c/G1BdieBgDkjdR8G9R+HEA4xdffrjyk2e1Pq+GeZmi6aOprCee5UiN1Q5Otj5zvFa8+37inSduZtNU8F4kOyXbzLyvpfwBo5OZSznLkEn2wgbGOGiySVHEq6CI4ondk//R1lBD1iiXqY8x7u2bOT0mzrXpfBBo1IK1WViHAmtQwYqBkasvtN4wkaFiG73jta+ZUJ/LKObsHXL1SqTg73U=
    caddy.dojo-regulus.ts.net ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFNehXg4suR8yOOS1MR3tJjHrvsk1FMp0dTlqtLFTJZm4zdnNHRiESG+CAjtVbrMByZa3iWCqaPIVs175XO1sZM=

    matrix.dojo-regulus.ts.net ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJYpUITkxWn4HnSRBOnHyF5JnPu1OSPLENNU173tzxE
    matrix.dojo-regulus.ts.net ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRUI7H+FS15mAeTgjWhp92m1Yt/2PLgm/AvfUmygemli9LczJ8o5Qdd4joMT89Y0QoiPmfDdgVv/q9VvlDMnPTH/9DWnBMfosRepFOJt3iiKVUWM3Hbzq20opMg87RZyFkRML599BsPqsD9qnpPxOrEeEE9FS2tsBwZ8BDN+A7n4T8y7Z8JBcSZuieeXoo18bq7YxMNvaOALwoleBloxAvFigXk3HVVOmaTH9Sjdk6IrcKv85B2orQNArxKn2E6Qqm8Z4q4HGSi+xMcuU+CcgEkLTfsLNsoBBDzz+IWpVAJzlFalPrHdRK3fhAAEp10d32yPWGgZ/QnkEkE5Lc6g2rVO5nnQO9Rl2pajBG3pCK0f15KKB1UPgYxqGIKNFtCLrOBkVHq//3HtYyiWRXClc2ZeLG7tew5+Y0fdibekdNUjOF1aQLmoK8RGWMh6Y416ZEbuZP0VpQj+HRnfYtcprXgq0wJlHb3WtDhSlj6OGKbxZ2iiMrhDOtoe+u/lTP1Bs=
    matrix.dojo-regulus.ts.net ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAxqpGFuIhgZGf4p4LpmfEK17ZxyyceF9rm6R1WxMIuUvF53O+XVM3P/faDDDaHb2lecisnZIUHT2hv5cSHFCsc=

    bitcoin.dojo-regulus.ts.net ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILk695MXh6n+34JoXu+8S0drVYmRLmEt9bzJTFejt87i
    bitcoin.dojo-regulus.ts.net ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCa8MMA4JP6GB7TvVuXjRCB+w+YJDge/SjwQZv3VE6sQNWaf8CWRGLMals+YahId2BteBGQ+9xUYvRYUViq7nMrLFh05/dhYYHGuUTttJOMX0oPlouyiacTFuYE4fwpQyni1CgEWSn/WXIeO2o1qAhG8YCTDnu8l+2r3mRtyNcPDJSdR+O4CUJClazNe+QSK91Ese6GjnkjdV4JpYrbeTFLydgsda/7w0npGJ02zFGrcGHi8tsgntO00WPc9iq/B632KJe7OWEY/OSaOBDsiZnsrAV8MO3cRoAGjPkbxUEtDycMcYRSm25lZNhAM7MyhfsvRkisYicAcUYHPIkdHffcCniEqlUxdmB2uZXTxtgIN08BEcBuHz+P173GVoePjUzOrez5Q+iKH6Uf1LBrNHuoULxsqiyWICf9whjoJSJElDsUAVWUSRTTr12d25oOHQ+IRTHMZhqLtCjm2IdKfo4HqJe0/XGpGwnKALfn4M07hkkdUjxjS9EMsZfh6vS+Heytw1nqo6JjbTB6HEOGO22NUdI0IE4eCmg9ktkmXIDp9VF7deU5NLy7wllezA7qB9malZod12epraih7eQMawGwV1evvivDFOeczKqWNmqhDXakjq33ay14phruarSl2DUWb/dJp71a1f5m5YGyawQCYgw43rRyqZgloBbhokCR6Q==

    proxmox.dojo-regulus.ts.net ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFT/PYeOTs5ncw++BGpr5MlsrSd/icxnNPcJuSiSAKn
    proxmox.dojo-regulus.ts.net ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNv4Moa1zx3q0Pk/53sMaAKrHGSuqAveo7FDDeNptxBC0fwtig2ho6+hEYq+lRMV7JaWdRMuHXyLqcvQ3cN2/8vYPL+uptYoYvU8KEsGnskybaFmOfzUU3fLa8/q6rXS8OZwHtZQbQ8+zCuDGQmOg9giSoT6mlU9DusnXpPRt98vUQzIdy4uiCYY8ZwLmnZWmCMcr6rjpKHCLpifH766AsnMn/E5KP7bonCi5N3NMu2COJwCqELMFqBwrl6ceFUj/KSGgZvd0dSOEI7BbsM4fzWRIW6/4/LN6B7bVnFc5KECpFhTKlLfChkD7v1lHQwAeYswCIfyrQFX6tUdl9YPIS+g1TslUmMIQVPnBqpPDhIvjEnxHvRl8Q43UZiVEM+6+cAZiUhCnaB+nFpSxqzZRvRQQWqVvFX57eT3stscFqtsiMuPO1lamoA7yyc3aLJVfLX9bYo/iYHgEK7D7xZsEWpcLhMJXYQ6YdqIK68ac0NtK2+LmFqM+9Dosa9shPJi8=
    proxmox.dojo-regulus.ts.net ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMVKExfu2JJeuz/zqO9vlpxg8BLMVr3FRuGr0SfzXjx9WQvXRyVMviJJu5KRP+Nm3FA2mh/j6W99vSIhNLw67q0=
  '';
}
