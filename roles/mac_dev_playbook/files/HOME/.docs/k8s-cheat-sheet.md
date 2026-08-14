# Kubernetes
## Context & Namespace
```sh
kubectl config current-context
kubectl config set-context --current --namespace=<namespace>
kubectl config get-contexts
```

## Inspect
```sh
kubectl get pods -A                              # all namespaces
kubectl describe pod <pod>
kubectl logs <pod> [-c <container>] [-f]
kubectl exec -it <pod> -- /bin/sh
```

## Deploy
```sh
kubectl apply -f <file.yaml>
kubectl rollout status deployment/<name>
kubectl rollout undo deployment/<name>           # rollback
```

## Service
```sh
kubectl port-forward svc/<name> 8080:80
```

## Secret & ConfigMap
```sh
kubectl create secret generic <name> --from-literal=key=value
kubectl get secret <name> -o jsonpath='{.data.key}' | base64 -d
```

## Cleanup
```sh
kubectl delete pod <pod> --grace-period=0 --force
```
