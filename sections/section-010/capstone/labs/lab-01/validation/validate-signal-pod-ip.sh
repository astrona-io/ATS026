#!/usr/bin/env bash
set -uo pipefail
ip=$(kubectl -n starfleet get pod -l app=signal -o jsonpath='{.items[0].status.podIP}' 2>/dev/null)
[ -n "$ip" ] || { echo 'FAIL: signal Pod has no IP'; exit 1; }
out=$(kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}' http://$ip:8080/ 2>/dev/null)
if [ "$out" = "200" ]; then echo "PASS: http://$ip:8080/ answered 200"; else echo "FAIL: http://$ip:8080/ did not answer 200 (got '$out')"; exit 1; fi
