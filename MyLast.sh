#!/bin/bash

afis_utilizare(){
    echo "The script can be used with the following commands:"
    echo "./MyLast.sh [-n NUM] [-p USER] [-s START] [-t END]"
    echo "Possible arguments:"
    echo "-n NUM -> Displays the last NUM entries"
    echo "-p USER -> Displays entries for the specified user"
    echo "-s START -> Displays entries after a specific date"
    echo "-t END -> Displays entries up to a specific date"
    echo 'For -s and -t, the date format is: "YYYY-MM-DDTHH-MM-SS"'
    
    exit 1
}

numar_linii=0
pattern=""
start_time=""
stop_time=""

while getopts "n:p:s:t:h" opt; do
    case $opt in
        n) numar_linii="$OPTARG" ;;
        p) pattern="$OPTARG" ;;
        s) start_time="$OPTARG" ;;
        t) stop_time="$OPTARG" ;;
        h) afis_utilizare ;;
        *) echo "INPUT INVALID"
           afis_utilizare ;;
    esac
done

log_files="/var/log/auth.log /var/log/auth.log.*"
for file in $log_files; do
    if [[ "$file" == *.gz ]]; then
        less "$file" >> /tmp/combined_logs.txt 2>/dev/null
    else
        cat "$file" >> /tmp/combined_logs.txt 2>/dev/null
    fi
done

if [[ ! -s /tmp/combined_logs.txt ]]; then
    echo "Nu s-au gasit log-uri valide."
    exit 1
fi

sort /tmp/combined_logs.txt -o /tmp/combined_logs.txt

result=$(cat /tmp/combined_logs.txt)

if [[ -n $start_time ]] && [[ -n $stop_time ]]; then
    result=$(echo "$result" | awk -v start="$start_time" -v stop="$stop_time" '$0 >= start && $0 <= stop')
elif [[ -n $start_time ]]; then
    result=$(echo "$result" | awk -v start="$start_time" '$0 >= start')
elif [[ -n $stop_time ]]; then
    result=$(echo "$result" | awk -v stop="$stop_time" '$0 <= stop')
fi

if [[ -n $pattern ]]; then
    result=$(echo "$result" | grep "$pattern")
fi

if [[ $numar_linii -gt 0 ]]; then
    result=$(echo "$result" | tail -n "$numar_linii")
fi

echo "$result"

rm -f /tmp/combined_logs.txt
