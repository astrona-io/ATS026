#!/usr/bin/env bash
# Starting state for "Publish An Application Through An Ingress With TLS". Environment only: it creates the
# controller, the applications, a self-signed certificate Secret and the broken Ingress. It does not repair
# anything the task asks the learner to fix.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# The client Pod mounts the Secret, so the Secret must exist before the Pod starts.
kubectl create namespace starfleet --dry-run=client -o yaml | kubectl apply -f -
CERT_DIR="$(mktemp -d)"
trap 'rm -rf "$CERT_DIR"' EXIT
openssl req -x509 -newkey rsa:2048 -nodes -days 2 \
  -keyout "$CERT_DIR/portal.key" -out "$CERT_DIR/portal.crt" \
  -subj "/CN=portal.local" -addext "subjectAltName=DNS:portal.local" >/dev/null 2>&1
kubectl -n starfleet create secret tls portal-tls --cert="$CERT_DIR/portal.crt" --key="$CERT_DIR/portal.key" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n ingress-system rollout status deployment/traefik --timeout=180s
for name in web api shuttle; do
  kubectl -n starfleet rollout status "deployment/$name" --timeout=180s
done
echo "[lab] Ready."
