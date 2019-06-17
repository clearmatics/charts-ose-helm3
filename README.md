# Clearmatics public helm charts repo

# Contributing

[Contributing rules](./CONTRIBUTING.md)

# Usage

Add repo 
```bash
helm repo add clearmatics-ose https://charts-ose.clearmatics.com
```

Search
```bash
helm search autonity
```

Install example
```yaml
helm install clearmatics-ose/autonity-network
```

# Tests
Each chart should contain tests in `./stable/%CHARTNAME%/templates/tests` directory.    
The tests could be based on [Bash Automated Testing System](https://github.com/bats-core/bats-core) (and use [Bats Docker image](https://github.com/dduportal-dockerfiles/bats) )

For run test
1. install chart chart to the cluster
2. Run tests
    ```bash
    helm test --timeout 300 ${CHART_NAME}
    ```
