---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Verify TLS Termination And Server Identity

Route HTTPS through the controller and verify both matching and mismatched certificate identities. Use the isolated `starfleet` environment to verify the result.

## Objective

Route HTTPS through the controller and verify both matching and mismatched certificate identities.

## Starting state

The lab includes a working Traefik Ingress controller and healthy application. The required route has not been created.

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-lab-050-01-02)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-lab-050-01-02" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.


## Required result

Create a TLS Ingress `probe` for class `traefik`, host `probe.local`, Prefix path `/` and backend Service `probe` port 80. Use the supplied TLS Secret `probe-tls` and websecure entrypoint. A client trusting the supplied certificate must receive version one for the matching server name and must reject a mismatched server name. Preserve the original application and Service.

## Verify The Result

The grader checks the stated resource fields and live evidence. Wait for controller convergence before submitting. Inspect actual results rather than relying on a sample transcript.
