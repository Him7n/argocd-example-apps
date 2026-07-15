# multi-namespace-guestbook

Demonstrates that `spec.destination.namespace` is a **fallback**, not a hard constraint.
Resources with an explicit `metadata.namespace` in their manifest land in that namespace,
regardless of what `spec.destination.namespace` says.

## What's deployed

| Manifest | `metadata.namespace` | Actual namespace |
|---|---|---|
| `frontend-deployment.yaml` | (none) | `frontend` ← from `spec.destination.namespace` |
| `cache-deployment.yaml` | `cache-layer` | `cache-layer` ← explicit override |

Both resources appear in the same ArgoCD/Harness GitOps application resource tree, but
they live in different namespaces on the cluster.

## Why this matters for Harness GitOps Web Terminal

When a user opens a terminal into the `guestbook-cache` pod:

- `resourceRef.namespace` in the UI = `cache-layer` ✅ (correct — from ArgoCD live resource tree)
- `spec.destination.namespace` = `frontend` ❌ (wrong — the current backend fallback)

The backend currently sends `TerminalExecRequest{Namespace: "frontend"}` to the agent.
The agent runs `kubectl exec -n frontend <pod>` → pod not found → exec fails.

**Fix tracked in**: `docs/terminal/todo-terminal.md` item #12 — pass `resourceRef.namespace`
from the frontend in the `op:init` WebSocket message.

## Prerequisites

The ArgoCD project must allow the `cache-layer` namespace. Add it to
`spec.destinations` in your AppProject:

```yaml
spec:
  destinations:
    - server: https://kubernetes.default.svc
      namespace: frontend
    - server: https://kubernetes.default.svc
      namespace: cache-layer
```

## Apply

```bash
kubectl apply -f app.yaml
```
