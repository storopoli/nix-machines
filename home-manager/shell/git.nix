{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs = {
    git = {
      enable = true;
      userName = "Jose Storopoli";
      userEmail = "jose@storopoli.com";
      signing = {
        key = "0x1BD38BE8D0653A7A";
        signByDefault = true;
      };
      ignores = [
        # Vim/Emacs
        "*~"
        ".*.swp"

        # Mac
        ".DS_Store"
        ".fseventsd"
        ".Spotlight-V100"
        ".TemporaryItems"
        ".Trashes"

        # Helix
        ".helix/"

        # Zed
        ".zed/"

        # VSCode Workspace Folder
        ".vscode/"

        # Haskell
        ".stack-work/"
        "dist-newstyle/"

        # Rust
        "debug/"
        "target/"

        # Nix
        "result"
        "result-*"

        # Python
        "*.pyc"
        "*.egg"
        "*.out"
        "venv/"
        "**/**/__pycache__/"

        # direnv
        ".direnv"
        ".envrc"

        # NodeJS/Web dev
        ".env/"
        "node_modules"
        ".sass-cache"

        # Claude
        "**/.claude/settings.local.json"
      ];
      aliases = {
        acp = ''!f() { git add . && git commit -m "$@" && git push origin HEAD; }; f'';
        a = "add";
        br = "branch";
        bl = "branch -l";
        c = "commit";
        co = "checkout";
        d = "diff";
        f = "push --force-with-lease";
        g = "grep";
        m = "merge";
        p = "pull";
        pu = ''!"git fetch origin -v; git fetch upstream -v; git merge upstream/master"'';
        rv = "revert";
        s = "status";
        st = "status";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        last = "log -1 HEAD";
        w = "whatchanged";
        # https://stackoverflow.com/a/11688523/472927
        ss = "!f() { git stash show stash^{/$*} -p; }; f";
        sa = "!f() { git stash apply stash^{/$*}; }; f";
        sl = "stash list";
        tag = "tag -s";
        # https://docs.gitignore.io/install/command-line
        ig = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
      };
      extraConfig = {
        init.defaultBranch = "main";
        tag = {
          gpgsign = true;
          forceSignAnnotated = true;
        };
        format.signOff = "yes";
        color.ui = true;
        core = {
          autocrlf = "input";
          safecrlf = true;
        };
        pull.ff = "only";
        fetch.prune = true;
        push = {
          default = "current";
          autoSetupRemote = true;
          useForceIfIncludes = true;
          followtags = true;
        };
        filter.lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
        help.autocorrect = "1";
        status.submoduleSummary = true;
        submodule.recurse = true;
        github.user = "storopoli";
        diff = {
          algorithm = "histogram";
          compactionHeuristic = true;
          submodule = "log";
          colorMoved = "default";
        };
        protocol.version = "2";
        commit.gpgsign = true;
        branch.sort = "-committerdate";
        credential.helper = "cache";
        merge.conflictstyle = "diff3";
        log.date = "iso";
        rebase = {
          autosquash = true;
          autostash = true;
          updateRefs = true;
        };
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        # avoids corruption
        transfer.fsckobjects = true;
        fetch.fsckobjects = true;
        receive.fsckObjects = true;
      };
      delta = {
        enable = true;
        options = {
          navigate = true; # use n and N to move between diff sections
          true-color = "always";
          syntax-theme = "gruvbox-dark";
          features = "decorations";
          whitespace-error-style = "22 reverse";
          line-numbers = true;
          light = false;
          file-style = "blue";
          minus-style = ''syntax "#43242B"'';
          minus-non-emph-style = ''syntax "#43242B"'';
          minus-emph-style = ''"#1F1F28" "#C34043"'';
          minus-empty-line-marker-style = ''normal "#43242B"'';
          zero-style = "syntax";
          plus-style = ''syntax "#2B3328"'';
          plus-non-emph-style = ''syntax "#2B3328"'';
          plus-emph-style = ''"#1F1F28" "#76946A"'';
          plus-empty-line-marker-style = ''normal "#2B3328"'';
          line-numbers-plus-style = "green";
          line-numbers-minus-style = "red";
          line-numbers-left-format = ''"{nm:>4}┊"'';
          line-numbers-right-format = ''"{np:>4}┊"'';
          line-numbers-left-style = "red";
          line-numbers-right-style = "green";
        };
      };
    };
  };

  programs.gh.enable = true;
}
