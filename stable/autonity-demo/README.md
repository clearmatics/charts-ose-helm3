## Autonity-demo helm chart

[![Join the chat at https://gitter.im/clearmatics/autonity](https://badges.gitter.im/clearmatics/autonity.svg)](https://gitter.im/clearmatics/autonity?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Introduction

It is umbrella chart `autonity-demo` that include main `autonity-network` subchart for deploy a **private** [Autonity](https://www.autonity.io/) network onto a [Kubernetes](http://kubernetes.io) 
cluster using the [Helm](https://helm.sh) package manager. Also `autonity-demo` can deploy additional charts and connect services inside as one infrastructure.

Autonity is a generalization of the Ethereum protocol based on a fork of go-ethereum. [Autonity Documentation](https://docs.autonity.io)

## Quick start
1. Install [Kubernetes cluster](http://kubernetes.io). You can do it using one of this ways:
   - Install minimal local kubernetes cluster out of box [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) or:
   - Install [Amazon EKS](https://eksworkshop.com/prerequisites/self_paced/) or:
   - Install [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/docs/quickstart)
1. Install packet manager for kubernetes using this [Helm installation guide](https://helm.sh/docs/using_helm/#installing-helm)
1. Configure helm to your cluster
   ```bash
   helm init
   ```
1. Add Clearmatics repository if you do not have it added before
   ```bash
   helm repo add charts-ose.clearmatics.com https://charts-ose.clearmatics.com
   ```
1. Download `autonity-demo` chart and dependencies:
   ```bash
   git clone https://github.com/clearmatics/charts-ose.git
   cd ./stable/autonity-demo
   helm dependency update
   ```
1. Deploy it
   ```bash
   helm install -n autonity-demo ./
   ```
## Prerequisites

* Kubernetes 1.11
* Helm 2.14

## Subcharts

* [autonity-network](../autonity-network) - **private** Autonity network with set of validators and observers (Enabled by default)
* [Ethstats](../ethstats) - Web-dashboard for monitoring Autonity network (Optional)
* [Validator DApp](../validator-dapp) - Validator DApp provides a WEB interface to manage the validator set of nodes.  (Optional)
* [Prometheus](https://github.com/helm/charts/tree/master/stable/prometheus) - Metrics system
* [Grafana](https://github.com/helm/charts/tree/master/stable/grafana) - GUI for metrics system

## Configure

- You can change number of validators or observers using helm cli-options like this:
   ```bash
   helm install -n autonity-demo ./ --set autonity-network.validators.num=6,autonity-network.observers.num=2
   ```
- You can enable optional subcharts like:
   ```bash
   helm install -n autonity-demo ./ --set global.ethstats.enabled=true
   ```
- Also you can change any variables in this file [./values.yaml](values.yaml) before installation

## Connect to autonity network
```bash
# Forward JSON-RPC validator-0 to localhost
kubectl port-forward svc/validator-0 8545:8545

# Example  JSON-RPC request
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://localhost:8545

```

## Delete
```bash
helm delete autonity-demo --purge
```

## Extended values configs

[values_gke_persistent_storage.yaml](./values_gke_persistent_storage.yaml) will install to GKE with:
- persistent storage for autonity validators and observers
- persistent storage for prometheus
- persistent storage for grafana

```shell script
helm install charts-ose.clearmatics.com/autonity-demo -f https://raw.githubusercontent.com/clearmatics/charts-ose/master/stable/autonity-demo/values_gke_persistent_storage.yaml
```
