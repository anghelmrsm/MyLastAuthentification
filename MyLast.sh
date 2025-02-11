#!/bin/bash

afis_utilizare(){
    echo "Scriptul se poate utiliza prin folosirea urmatoarelor comenzi:"
    echo "./MyLast.sh [-n NUM] [-p USER] [-s START] [-t END]"
    echo "Argumente posibile:"
    echo "-n NUM -> Afiseaza ultimele NUM intrari"
    echo "-p USER -> Afiseaza intrarile user-ului dat"
    echo "-s START -> Afiseaza intrarile dupa o anumita data"
    echo "-t END -> Afiseaza intrarile pana la o anumita data"
    echo 'Pentru -s -t data are formatul: "YYYY-MM-DDTHH-MM-SS" '
    
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