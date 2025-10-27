{
  pkgs,
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
        default-command = [ "status" ];
        pager = "${pkgs.delta}/bin/delta";
        diff-editor = ":builtin";
        diff-formatter = ":git";
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

      revset-aliases = {
        "user(x)" = "author(x) | committer(x)";
        "mine()" = "user('jose@storopoli.com') | user('jose@alpenlabs.io')";

        "wip()" = "description(glob:'wip:*')";
        "private()" = "description(glob:'private:*')";

        # stack(x, n) is the set of mutable commits reachable from 'x',
        # with 'n' parents. 'n' is often useful to customize the display
        # and return set for certain operations. 'x' can be used to target
        # the set of 'roots' to traverse, e.g. @ is the current stack.
        "stack()" = "stack(@)";
        "stack(x)" = "stack(x, 2)";
        "stack(x, n)" = "ancestors(reachable(x, mutable()), n)";

        "open()" = "stack(mine() | @, 1)";
        "ready()" = "open() ~ descendants(wip() | private())";

        "uninterested()" = "::remote_bookmarks() | tags()";
        "interested()" = "mine() ~ uninterested()";

        "closest_pushable(to)" = "heads(::to & mutable() & ~description(exact:'') & (~empty() | merges()))";
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
      };

      template-aliases = {
        "in_branch(commit)" = ''commit.contained_in("immutable_heads()..bookmarks()")'';
      };

      aliases = {
        l = [ "log" ];

        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "@-"
        ];

        pr = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
            ${pkgs.gh}/bin/gh pr create --head ''$(jj log -r 'closest_bookmark(@)' -T 'bookmarks' --no-graph | cut -d ' ' -f 1)
          ''
        ];
        init = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
            jj git init --colocate
            # only track origin branches, not upstream or others
            jj bookmark track 'glob:*@origin'
          ''
        ];
        pull = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
            closest="''$(jj log -r 'closest_bookmark(@)' -n 1 -T 'bookmarks' --no-graph | cut -d ' ' -f 1)"
            closest="''${closest%\\*}"
            jj git fetch
            jj log -n 1 -r "''${closest}" 2>&1 > /dev/null && jj rebase -d "''${closest}" || jj rebase -d 'trunk()'
            jj log -r 'stack()'
          ''
        ];
        push = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
            tuggable="''$(jj log -r 'closest_bookmark(@)..closest_pushable(@)' -T '"n"' --no-graph)"
            [[ -n "''$tuggable" ]] && jj tug
            pushable="''$(jj log -r 'remote_bookmarks(remote=origin)..@' -T 'bookmarks' --no-graph)"
            [[ -n "''$pushable" ]] && jj git push --allow-new || echo "Nothing to push."
            closest="''$(jj log -r 'closest_bookmark(@)' -n 1 -T 'bookmarks' --no-graph | cut -d ' ' -f 1)"
            closest="''${closest%\\*}"
            tracked="''$(jj bookmark list -r ''${closest} -t -T 'if(remote == "origin", name)')"
            [[ "''$tracked" == "''$closest" ]] || jj bookmark track "''${closest}@origin"
          ''
        ];
        z = [ "fuzzy_bookmark" ];
        za = [
          "bookmark"
          "list"
          "-a"
        ];
        fuzzy_bookmark = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          ''
            if [ "x''$1" = "x" ]; then
              jj bookmark list
            else
              jj bookmark list -a -T 'separate("@", name, remote) ++ "\n"' 2> /dev/null | sort | uniq | ${pkgs.fzf}/bin/fzf -f "''$1" | head -n1 | xargs jj new
            fi
          ''
          ""
        ];
      };
    };
  };

  programs.jjui.enable = true;

  home = {
    packages = with pkgs; [
      lazyjj
    ];
    shellAliases = {
      lj = "lazyjj";
    };
  };
}
