function fish_jj_prompt --description 'Write out the jj prompt'
    # Is jj installed?
    if not command -sq jj
        return 1
    end

    # Are we in a jj repo?
    if not jj root &>/dev/null
        return 1
    end

    # Generate prompt
    set -l info "$(
        set -l op_id (jj op log --ignore-working-copy --no-graph --limit=1 --template 'self.id().short()')
        jj log --ignore-working-copy --no-graph --color=always --revisions=@ --template "
            separate(
                ' ',
                label('operation id', '$op_id'),
                bookmarks.join(', '),
                if(conflict, label('conflict', '×')),
                if(empty, label('empty', '(empty)')),
                if(divergent, label('divergent', '(divergent)')),
                if(hidden, label('hidden', '(hidden)')),
            )
        "
    )"
    or return 1

    if test -n $info
        printf ' (%s)' $info
    else
        return 1
    end
end
