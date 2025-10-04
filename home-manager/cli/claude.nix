{ ... }:

{
  programs.claude-code = {
    enable = true;
    settings = {
      includeCoAuthoredBy = false;
      permissions = {
        allow = [
          "Bash(rg:*)"
          "Bash(grep:*)"
          "Bash(ls:*)"
          "Bash(find:*)"
          "Bash(fd:*)"
          "Bash(git diff:*)"
          "Bash(cargo check:*)"
          "Bash(cargo clippy:*)"
          "Bash(cargo doc:*)"
          "Bash(cargo test:*)"
          "Bash(gh run view:*)"
          "Bash(gh pr diff:*)"
          "Bash(gh pr view:*)"
          "WebFetch(domain:docs.rs)"
          "WebFetch(domain:hackage.haskell.org)"
          "WebFetch(domain:github.com)"
          "WebFetch(domain:raw.githubusercontent.com)"
          "WebFetch(domain:just.systems)"
        ];
        ask = [
          "Edit"
          "WebSearch"
          "Bash(git push:*)"
        ];
        deny = [
          "Read(./.env)"
          "Read(./secrets/**)"
        ];
        disableBypassPermissionsMode = "disable";
      };
      statusLine = {
        command = "input=$(cat); echo \"[$(echo \"$input\" | jq -r '.model.display_name')] 📁 $(basename \"$(echo \"$input\" | jq -r '.workspace.current_dir')\")\"";
        padding = 0;
        type = "command";
      };
      theme = "dark";
      env = {
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
        DISABLE_AUTOUPDATER = 1;
        DISABLE_BUG_COMMAND = 1;
        DISABLE_ERROR_REPORTING = 1;
        DISABLE_TELEMETRY = 1;
      };
    };
    memory.text = ''
      # GitHub `gh` CLI

      If you need to grab stuff from GitHub you can use the `gh` CLI tool.
      Feel free to use it as much as you need

      # Nix environment

      Most of the time there's a flake.nix, or a default.nix or shell.nix,
      in that case you should use nix to run all commands such as `nix develop -c "command"`
      for flakes or `nix-shell --run "command"` for everything else.

      # Commit Messages

      Use the Conventional Commit Messages specification to generate commit messages

      The commit message should be structured as follows:


      ```
      <type>[optional scope]: <description>

      [optional body]

      [optional footer(s)]
      ``` 
      --------------------------------

      The commit contains the following structural elements, to communicate intent to the consumers of your library:

        - fix: a commit of the type fix patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
        - feat: a commit of the type feat introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
        - BREAKING CHANGE: a commit that has a footer BREAKING CHANGE:, or appends a ! after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
        - types other than fix: and feat: are allowed, for example @commitlint/config-conventional (based on the Angular convention) recommends build:, chore:, ci:, docs:, style:, refactor:, perf:, test:, and others.
        - footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
        - Additional types are not mandated by the Conventional Commits specification, and have no implicit effect in Semantic Versioning (unless they include a BREAKING CHANGE). A scope may be provided to a commit’s type, to provide additional contextual information and is contained within parenthesis, e.g., feat(parser): add ability to parse arrays.



      ### Specification Details

      The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119.

      Commits MUST be prefixed with a type, which consists of a noun, feat, fix, etc., followed by the OPTIONAL scope, OPTIONAL !, and REQUIRED terminal colon and space.
      The type feat MUST be used when a commit adds a new feature to your application or library.
      The type fix MUST be used when a commit represents a bug fix for your application.
      A scope MAY be provided after a type. A scope MUST consist of a noun describing a section of the codebase surrounded by parenthesis, e.g., fix(parser):
      A description MUST immediately follow the colon and space after the type/scope prefix. The description is a short summary of the code changes, e.g., fix: array parsing issue when multiple spaces were contained in string.
      A longer commit body MAY be provided after the short description, providing additional contextual information about the code changes. The body MUST begin one blank line after the description.
      A commit body is free-form and MAY consist of any number of newline separated paragraphs.
      One or more footers MAY be provided one blank line after the body. Each footer MUST consist of a word token, followed by either a :<space> or <space># separator, followed by a string value (this is inspired by the git trailer convention).
      A footer’s token MUST use - in place of whitespace characters, e.g., Acked-by (this helps differentiate the footer section from a multi-paragraph body). An exception is made for BREAKING CHANGE, which MAY also be used as a token.
      A footer’s value MAY contain spaces and newlines, and parsing MUST terminate when the next valid footer token/separator pair is observed.
      Breaking changes MUST be indicated in the type/scope prefix of a commit, or as an entry in the footer.
      If included as a footer, a breaking change MUST consist of the uppercase text BREAKING CHANGE, followed by a colon, space, and description, e.g., BREAKING CHANGE: environment variables now take precedence over config files.
      If included in the type/scope prefix, breaking changes MUST be indicated by a ! immediately before the :. If ! is used, BREAKING CHANGE: MAY be omitted from the footer section, and the commit description SHALL be used to describe the breaking change.
      Types other than feat and fix MAY be used in your commit messages, e.g., docs: update ref docs.
      The units of information that make up Conventional Commits MUST NOT be treated as case sensitive by implementors, with the exception of BREAKING CHANGE which MUST be uppercase.
      BREAKING-CHANGE MUST be synonymous with BREAKING CHANGE, when used as a token in a footer.
    '';

  };
}
