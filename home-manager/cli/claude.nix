{ ... }:

{
  programs.claude-code = {
    enable = true;
    settings = {
      includeCoAuthoredBy = false;
      permissions = {
        additionalDirectories = [
          "../docs/"
        ];
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
  };
}
