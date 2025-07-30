function compress
    tar -czf "$argv[1].tar.gz" "$argv[1]"
end
