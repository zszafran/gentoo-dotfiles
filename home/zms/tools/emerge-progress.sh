tail -n 50 /var/log/emerge.log | \
    tac | \
    grep -v "Starting retry" | \
    grep -iE '([0-9]* of [0-9]*)' -o -m 1 | \
    sed -e 's/\(.*\) of \(.*\)/\1 \2/' | \
    awk '{print 100.0*$1/$2}'
