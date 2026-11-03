#!/usr/bin/env bash
set -uo pipefail
class=$(kubectl -n starfleet get ingress fleet -o jsonpath='{.spec.ingressClassName}' 2>/dev/null)
annotation=$(kubectl -n starfleet get ingress fleet -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}' 2>/dev/null)
if [ -z "$class" ]; then echo "FAIL: the Ingress fleet does not exist or has no stored class"; exit 1; fi
if [ "$class" != "traefik" ]; then echo "FAIL: the stored class is '$class', expected traefik"; exit 1; fi
case "$annotation" in
  *ingressClassName*) echo "FAIL: the manifest sets ingressClassName; the default class must assign it"; exit 1 ;;
esac
echo "PASS: the default class traefik was assigned to the Ingress fleet"
