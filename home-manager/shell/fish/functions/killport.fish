function killport
    if test (count $argv) -ne 1
        echo "Usage: killport <PORT>"
        echo ""
        echo "Kill the processes running on <PORT>"
        return 1
    end

    set PORT $argv[1]
    lsof -i "tcp:$PORT" | grep -v PID | awk "{print \$2}" | xargs kill
end
