function cleanrust
    if command -q -v fd >/dev/null 2>&1
        fd -It d -g target -X rm -rf
    end
end
