# Service Types And Endpoint Relationships - Playground

- **Slug:** ats-026-playground-030-01
- **Type:** Astrona playground, clean environment, no task, no grading
- **Status:** UNTESTED. Built and checked statically only. It has not been run.

Playground for the module on Service types, selectors, ports and EndpointSlices. It starts with a `probe` Service whose selector matches no Pod.

## Run it

```sh
astrona run -c .
astrona destroy ats-026-playground-030-01
```
