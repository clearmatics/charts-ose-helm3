## Ethstats helm chart

This is a visual interface for tracking autonity network status. It uses WebSockets to receive stats from running nodes and output them through an angular interface. It is the front-end implementation for ethstats-client.

https://github.com/goerli/ethstats-server

## Connect to GUI dashboard
```bash
# Forward ethstats dashboard to localhost 
kubectl port-forward svc/ethstats 8080:80

```

Open in local browser http://localhost:8080
