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
          "Bash(git diff:*)"
          "Edit"
        ];
        ask = [
          "Bash(git push:*)"
        ];
        deny = [
          "WebFetch"
          "Bash(curl:*)"
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
