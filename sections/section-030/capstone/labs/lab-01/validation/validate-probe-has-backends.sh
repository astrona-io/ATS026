#!/usr/bin/env bash
set -uo pipefail
ready=$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{range .items[*].endpoints[*]}{.conditions.ready}{"\n"}{end}' 2>/dev/null | grep -c '^true$')
if [ "$ready" = "3" ]; then echo "PASS: probe has 3 ready endpoints"; else echo "FAIL: probe has $ready ready endpoints, expected 3"; exit 1; fi
