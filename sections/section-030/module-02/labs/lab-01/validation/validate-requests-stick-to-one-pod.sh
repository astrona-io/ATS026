#!/usr/bin/env bash
set -uo pipefail
names=""
for attempt in 1 2 3 4 5 6 7 8 9 10 11 12; do
  name=$(kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O- http://probe/ 2>/dev/null | grep -o '"hostname": *"[^"]*"')
  if [ -z "$name" ]; then echo "FAIL: request $attempt to http://probe/ gave no answer"; exit 1; fi
  names="$names
$name"
done
distinct=$(echo "$names" | sed '/^$/d' | sort -u | wc -l | tr -d ' ')
if [ "$distinct" = "1" ]; then echo "PASS: twelve requests reached one probe Pod"; else echo "FAIL: requests reached $distinct different Pods"; exit 1; fi
