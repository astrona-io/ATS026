---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Summary

An IngressClass is a cluster-scoped object whose `spec.controller` string names the controller that owns it. An Ingress selects a class with `spec.ingressClassName`. The API server accepts an Ingress that names a class without a running controller, and nothing handles that Ingress. The controller program, not Kubernetes, decides which Ingresses it serves.

The annotation `ingressclass.kubernetes.io/is-default-class: "true"` makes one class the default. The API server writes the default class into an Ingress when the Ingress is created without a class. It does not change Ingresses that already exist, and two default classes block the creation of Ingresses without a class. Whether a controller also serves Ingresses with no class at all is a controller setting.

Host and path decide the rule. A host rule compares the Host header exactly, and a wildcard host covers exactly one label in front of its suffix. `Exact` compares the whole path. `Prefix` compares whole path elements, so `/app` matches `/app/home` and does not match `/apple`. `ImplementationSpecific` belongs to the controller. When several paths match, the longest one wins, and an `Exact` path wins over a `Prefix` path of the same length.

The default backend answers requests that no rule matches. Rewrites, middleware and other annotations belong to one controller and are ignored by another. The Ingress API does not rewrite paths, so the backend receives the path that the client sent.

When an Ingress does not work, the evidence comes from three places: the class that the API server stored, the response body that shows who answered, and the controller log. The `ADDRESS` column of an Ingress is only a hint.

Key facts to remember:

- Mark at most one IngressClass as the default.
- The default class applies at creation time only.
- `Prefix` works on path elements, not on characters.
- The longest matching path wins, and `Exact` wins a tie.

<!-- astrona:playground:destroy -->
