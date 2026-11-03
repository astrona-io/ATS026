#!/usr/bin/env bash
set -uo pipefail
kubectl -n starfleet rollout status deployment/auditor --timeout=60s >/dev/null 2>&1 || { echo "FAIL: the auditor rollout is not complete"; exit 1; }
partner=$(kubectl -n starfleet get service partner-dns -o jsonpath='{.spec.clusterIP}')
policy=$(kubectl -n starfleet get deployment auditor -o jsonpath='{.spec.template.spec.dnsPolicy}')
servers=$(kubectl -n starfleet get deployment auditor -o jsonpath='{.spec.template.spec.dnsConfig.nameservers[*]}')
if [ "$policy" != "None" ]; then echo "FAIL: dnsPolicy must be None (got '$policy')"; exit 1; fi
if [ "$servers" != "$partner" ]; then echo "FAIL: nameservers must be only '$partner' (got '$servers')"; exit 1; fi
resolv=$(kubectl -n starfleet exec deploy/auditor -- cat /etc/resolv.conf 2>&1)
if ! echo "$resolv" | grep -Eq 'ndots:1([[:space:]]|$)'; then echo "FAIL: /etc/resolv.conf in auditor does not contain ndots:1"; exit 1; fi
out=$(kubectl -n starfleet exec deploy/auditor -- nslookup relic.partner.example. 2>&1)
if echo "$out" | grep -q '192\.0\.2\.10'; then echo "PASS: auditor resolves relic.partner.example through partner-dns"; else echo "FAIL: auditor did not resolve relic.partner.example to 192.0.2.10"; exit 1; fi
