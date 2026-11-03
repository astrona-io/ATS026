#!/usr/bin/env bash
set -uo pipefail
ready=$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=web -o jsonpath='{range .items[*].endpoints[*]}{.conditions.ready}{"\n"}{end}' 2>/dev/null | grep -c '^true$')
if [ "$ready" -ge 1 ]; then echo "PASS: the Service web has $ready ready endpoint(s)"; else echo "FAIL: the Service web has no ready endpoint"; exit 1; fi
