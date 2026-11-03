#!/usr/bin/env bash
set -uo pipefail
n=$(kubectl get networkpolicy -A --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" = "0" ]; then echo 'PASS: no NetworkPolicy was added'; else echo "FAIL: $n NetworkPolicy objects exist"; exit 1; fi
