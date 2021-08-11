# Clearmatics public helm charts repo

## Contributing
[Contributing rules](./CONTRIBUTING.md)

## Deploying a Chart
More details on each specific chart can be found in their respective directories, but for a breif and simplified explaination of how to deploy them, you can follow this document.
### Prerequisites
Before deploying a copy of Autonity, you'll need:
- A Kubernetes Cluster (Basic features have been tested in both Minikube and Kind with extra functionality available in EKS and GKE)
  - Local Clusters
    - [Kind](https://kind.sigs.k8s.io/docs/user/quick-start)
    - [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
  - Cloud Clusters
    - [Amazon EKS](https://eksworkshop.com/prerequisites/self_paced/)
    - [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/docs/quickstart)
- An installation of [Helm 3.2.4](https://github.com/helm/helm/releases/tag/v3.2.4)
- To add [the official](https://helm.sh/docs/intro/quickstart/) `@stable` and Autonity Helm charts repositories
  - ```bash
    helm repo add stable https://charts.helm.sh/stable
    helm repo add charts-ose.clearmatics.com https://charts-ose.clearmatics.com/
    helm repo update
    ```
### Installing the Chart
Once the prerequisits have been met, then you can run one of the following commands to install the Helm chart into the Kubernetes Cluser:
#### Autonity-Network
```bash
kubectl create namespace autonity-network
helm install autonity-network charts-ose.clearmatics.com/autonity-network --namespace autonity-network --version 1.8.0
```

#### Autonity-Demo
```bash
kubectl create namespace autonity-demo
helm install autonity-network charts-ose.clearmatics.com/autonity-demo --namespace autonity-demo --version 1.8.0
```

#### Autonity
```bash
kubectl create namespace autonity
helm install autonity-network charts-ose.clearmatics.com/autonity --namespace autonity --version 1.8.0
```

## Tests
Each chart should contain tests in the `./stable/%CHARTNAME%/templates/tests` directory. The tests are based on [Bash Automated Testing System](https://github.com/bats-core/bats-core) (and use [Bats Docker image](https://github.com/dduportal-dockerfiles/bats) ).

Run the tests:
```bash
helm test autonity-network
```

## Cleanup
```
helm delete autonity-network
```
