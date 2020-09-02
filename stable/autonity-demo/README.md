## Autonity-demo helm chart
[![Join the chat at https://gitter.im/clearmatics/autonity](https://badges.gitter.im/clearmatics/autonity.svg)](https://gitter.im/clearmatics/autonity?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Introduction
The `autonity-demo` chart extends the [autonity-network](../autonity-network/README.md) chart with other features wich help to demo, understand and test the Autonity Network. At the moment, there is only a metrics server, but there are plans for Blockexplorer to come back into this chart at a later date.

## Prerequisites
For a full list of ceremonies, versions, prerequisites and installation tips, start in the [../autonity/README.md](../autonity/README.md), then the [../autonity-network/README.md](../autonity-network/README.md).

## Installation
1. Add the Clearmatics and the main `stable` Helm chart repositories:
```bash
helm repo add charts-ose.clearmatics.com https://charts-ose.clearmatics.com
helm repo add stable https://kubernetes-charts.storage.googleapis.com
```
1. Create the namespace
```bash
kubectl create namespace autonity-demo
```

### From Helm repositories
To deploy the chart straight from the Helm repositories added above.

1. Deploy the chart
```bash
helm install autonity-demo charts-ose.clearmatics.com/autonity-demo --namespace autonity-demo
```

### From GitHub repositories
Alternatively, to deploy the chart from the this GitHub repository.

1. Clone the repository
```bash
git clone https://github.com/clearmatics/charts-ose.git
```

1. Install the dependencies
```bash
cd ./stable/autonity-demo
helm dependency update
```

1. Deploy the chart
```bash
helm install autonity-demo ./ --namespace autonity-demo
```

## Subcharts
* [autonity-network](../autonity-network) - **Private** Autonity network with set of validators and observers (Enabled by default)
* [Prometheus](https://github.com/helm/charts/tree/master/stable/prometheus) - Metrics system
* [Grafana](https://github.com/helm/charts/tree/master/stable/grafana) - GUI for metrics system

## Configure
- You can change number of validators or observers using helm cli-options like this:
```bash
helm install autonity-demo ./ --namespace autonity-demo --set autonity-network.validators.num=6,autonity-network.observers.num=2
```

- You can enable optional subcharts like:
```bash
helm install autonity-demo ./ --namespace autonity-demo --set global.grafana.enabled=true
```

- You can change any variables in this file [./values.yaml](values.yaml) before installation

## Connect to autonity network
Forward JSON-RPC validator-0 to localhost
```bash
kubectl port-forward svc/validator-0 8545:8545
```

Example JSON-RPC request
```bash
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://localhost:8545
```

## Delete
1. Delete the Helm Chart
```bash
helm delete autonity-demo --namespace autonity-demo
```

1. Delete the namespace
```bash
kubectl delete namespace autonity-demo
```

## Extended values configs
[values_gke_persistent_storage.yaml](./values_gke_persistent_storage.yaml) will install to GKE with:
- persistent storage for autonity validators and observers
- persistent storage for prometheus
- persistent storage for grafana

```bash
helm install charts-ose.clearmatics.com/autonity-demo -f https://raw.githubusercontent.com/clearmatics/charts-ose/master/stable/autonity-demo/values_gke_persistent_storage.yaml --namespace autonity-demo
```
