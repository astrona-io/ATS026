# Summary

An `HTTPRoute` chooses what happens to a request in a fixed order. The Gateway selects the route by host name. The controller then selects one rule by match precedence: an exact path beats a prefix, a longer prefix beats a shorter one, and more header tests beat fewer. The list position only breaks the last tie. When the chosen rule has several backends, the proxy picks one by weight, and the weights are shares of the sum, not percentages. A weight of 0 keeps a backend in the route without sending it traffic.

Filters change the request after the rule is chosen. `RequestRedirect` answers with a 301 or 302 response and no backend receives the request. `URLRewrite` changes the path or host name that the backend sees, and the replacement type decides how much of the path changes. `RequestHeaderModifier` sets, adds or removes headers, and a `set` value cannot be overridden by the client. The proxy does the work, and the controller only translates the route into its configuration.

Namespace borders have two separate permission checks. A listener decides which namespaces may attach routes, with `allowedRoutes` set to `Same`, `All` or `Selector`. The owner of a Service decides which routes may use it, with a `ReferenceGrant` in the namespace of the Service. A refusal of the first kind shows in the `Accepted` condition with the reason `NotAllowedByListeners`. A refusal of the second kind shows in the `ResolvedRefs` condition with the reason `RefNotPermitted`.

Key facts:

- Precedence: exact path, longest prefix, method, most header tests, most query tests, oldest route.
- Weight: a share of the sum of the weights in one rule.
- `ReplacePrefixMatch` needs a `PathPrefix` match. `ReplaceFullPath` replaces the whole path.
- `allowedRoutes` controls attachment. `ReferenceGrant` controls Service references. Neither replaces the other.
- The condition and its reason name the owner who must act.

<!-- astrona:playground:destroy -->
