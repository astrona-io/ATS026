#!/usr/bin/env bash
set -uo pipefail
count=$(kubectl -n outpost get networkpolicy --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [ "$count" = "0" ]; then echo "PASS: no NetworkPolicy in outpost"; else echo "FAIL: outpost has $count NetworkPolicy objects, the task changes only starfleet"; exit 1; fi
