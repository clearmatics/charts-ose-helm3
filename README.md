# Clearmatics public helm charts repo

## Contributing
[Contributing rules](./CONTRIBUTING.md)

## Versions
- Kubernetes `>=1.15.11-0`
- Helm [v3.2.4](https://github.com/helm/helm/releases/tag/v3.2.4)

## Usage
Add the relevant repository, and update:
```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add charts-ose.clearmatics.com https://charts-ose.clearmatics.com
helm repo update
```

Search for the Autonity charts:
```bash
helm search repo autonity
```

Install one of the charts:
```yaml
helm install autonity-network charts-ose.clearmatics.com/autonity-network
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
