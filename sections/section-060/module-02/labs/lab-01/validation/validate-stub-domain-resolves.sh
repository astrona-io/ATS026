#!/usr/bin/env bash
set -uo pipefail
out=$(kubectl -n starfleet exec deploy/shuttle -- nslookup relic.partner.example. 2>&1)
if echo "$out" | grep -q '192\.0\.2\.10'; then echo "PASS: relic.partner.example resolved to 192.0.2.10"; else echo "FAIL: relic.partner.example did not resolve to 192.0.2.10"; echo "$out" | tail -5; exit 1; fi
