{
  pkgs,
  ...
}:

with pkgs;
let
  # Taken from <https://github.com/helix-editor/helix/discussions/12045#discussioncomment-14200899>
  blame_file = writeShellScriptBin "blame_file_pretty" ''
    #!${runtimeShell}
    # Utility for Helix: open the patch for the commit that last touched the current line.
    # If the line isn’t committed yet, it shows the working-tree diff for THIS file only.
    # The script writes the diff to /tmp and prints the absolute path to stdout
    # Adjust `context` to see more/fewer unchanged lines around the change (default: 3).
    #
    # usage: blame_file_pretty.sh <file> <line> [context_lines]
    # Helix mapping example:
    # G = ':open %sh{ ~/.config/helix/utils/blame_file_pretty.sh "%{buffer_name}" %{cursor_line} 3 }'
    file="$1"
    line="$2"
    ctx="''${3:-3}"

    # blame the exact line
    porc="$(${git}/bin/git blame -L "$line",+1 --porcelain -- "$file")" || exit 1
    sha="$(${uutils-coreutils-noprefix}/bin/printf '%s\n' "$porc" | ${gawk}/bin/awk 'NR==1{print $1}')"
    commit_path="$(${uutils-coreutils-noprefix}/bin/printf '%s\n' "$porc" | ${gawk}/bin/awk '/^filename /{print substr($0,10); exit}')"

    out="/tmp/hx-blame_$(basename "$file")_''${sha:-wt}.diff"

    if [ -z "$sha" ] || [ "$sha" = 0000000000000000000000000000000000000000 ] || [ "$sha" = "^" ]; then
      # uncommitted line → working tree diff for this file
      ${git}/bin/git --no-pager diff --no-color -U"$ctx" -- "$file" >"$out"
    else
      # committed line → only this file’s patch in that commit
      ${git}/bin/git --no-pager show --no-color -M -C -U"$ctx" "$sha" -- "''${commit_path:-$file}" >"$out"
    fi

    # "return" the path for :open %sh{…}
    ${uutils-coreutils-noprefix}/bin/printf '%s' "$out"
  '';

  # Taken from <https://github.com/helix-editor/helix/discussions/12045#discussioncomment-14200899>
  blame_line = writeShellScriptBin "blame_line_pretty" ''
    #!${runtimeShell}
    # Utility for Helix: pretty-print blame info for the line under the cursor.
    # Quite basic.
    #
    # usage: blame_line_pretty <file> <line>
    # Helix mapping example:
    # B = ":run-shell-command ~/.config/helix/utils/blame_line_pretty.sh %{buffer_name} %{cursor_line}"
    file="$1"
    line="$2"
    out="$(${git}/bin/git blame -L "$line",+1 --porcelain -- "$file")" || return 1

    sha="$(${uutils-coreutils-noprefix}/bin/printf '%s\n' "$out" | ${gawk}/bin/awk 'NR==1{print $1}')"
    author="$(${uutils-coreutils-noprefix}/bin/printf '%s\n' "$out" | ${gawk}/bin/awk -F'author ' '/^author /{print $2; exit}')"
    epoch="$(${uutils-coreutils-noprefix}/bin/printf '%s\n' "$out" | ${gawk}/bin/awk '/^author-time /{print $2; exit}')"
    # dd-mm-yyyy (macOS `date -r`; fallback to gdate if present)
    date="$((date -r "$epoch" +%d-%m-%Y\ %H:%M 2>/dev/null) || (${coreutils}/bin/gdate -d "@$epoch" +%d-%m-%Y\ %H:%M 2>/dev/null) || ${uutils-coreutils-noprefix}/bin/printf '%s' "$epoch")"
    summary="$(${uutils-coreutils-noprefix}/bin/printf '%s\n' "$out" | ${gawk}/bin/awk -F'summary ' '/^summary /{print $2; exit}')"
    change="$(${uutils-coreutils-noprefix}/bin/printf '%s\n' "$out" | ${uutils-coreutils-noprefix}/bin/tail -n 1)"

    ${uutils-coreutils-noprefix}/bin/printf "%s\n%s\n%s\n%s\n%s\n" "$sha" "$author" "$date" "$summary" "$change"
  '';

  # Taken from <https://github.com/helix-editor/helix/discussions/12045#discussioncomment-14200899>
  git_hunk = writeShellScriptBin "git_hunk" ''
    #!${runtimeShell}
    # Utility function to use in Helix Editor to be able to see git hunks inline.
    # Adjust `context` to a higher/lower number to see more/fewer lines of unmodified code
    # before and after the modified lines (I believe 3 lines gives perfect context and is the default).
    #
    # usage: git-hunk <file> <line> <context_lines>
    # Helix mapping example:
    # :run-shell-command ~/.config/helix/utils/git_hunk.sh %{buffer_name} %{cursor_line} 3
    file="$1"
    line="$2"
    context="''${3:-3}"

    base_command='${git}/bin/git --no-pager diff --no-color HEAD'

    # Print only the hunk whose +start,len covers $line
    eval "$base_command" -U"$context" -- "$file" |
      ${gawk}/bin/awk -v ln="$line" '
      BEGIN { have=0; buf=""; out="" }
      /^@@ /{
    # stash the first matching hunk
       if (have && out=="") { out=buf }
        buf = $0 ORS
        have = 0
        # Extract +start[,len] from header
        header = $0
        sub(/^.*\+/, "", header)
        sub(/ .*/, "", header)
        n = split(header, parts, ",")
        s = parts[1] + 0
        l = (n >= 2 ? parts[2] + 0 : 1)
        have = (l == 0 ? (ln == s) : (ln >= s && ln < s + l))
        next
      }
      { if (buf != "") buf = buf $0 ORS }
      END {
        if (have && out=="") out=buf
        if (out != "") print out; else print "No hunk under cursor"
      }
    '
  '';
in

{
  home.packages = [
    blame_file
    blame_line
    git_hunk
  ];
}
