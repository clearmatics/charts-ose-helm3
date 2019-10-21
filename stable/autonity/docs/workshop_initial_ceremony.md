# Initial ceremony

Setup `4` independent environments for `validators Nodes`: `2` on Google Kubernetes Engine (`GKE`) and `2` in Amazon `EKS`


| Actor | env | dns name for Autonity node `fqdn` name| 
|-------|-----|-------------------------------------| 
| Alice | GKE | val-0-workshop.4c621a00-2099-45c8-b50c-f06f95c0bcf3.com. | 
| Alice | GKE | val-1-workshop.4c621a00-2099-45c8-b50c-f06f95c0bcf3.com. | 
| Bob   | EKS | validator2.autonity.online |
| Bob   | EKS | validator3.autonity.online |
| Network operator | `genesis.yaml` file   | |

## Requirements
* `Alice` and `Bob` has:
  * Separated configured k8s clusters
  * Installed and configured tools to interact with their clusters: `kubectl` and `helm`
  * Access to add new DNS records for their domains
  * Added helm repo
  ```shell script
  helm repo add charts-ose.clearmatics.com https://charts-ose.clearmatics.com
  ```
* `Network operator`:
  * Tools to generate eth keys and addresses

## Step 1
* Actor: `Network operator`
* Actions:
  * Generate own eth keys and addresses for `Governance Operator` and receive `eth` address for `Treasury Operator`
  * Provide to all users the same `genesis.yaml` file. For example: https://raw.githubusercontent.com/clearmatics/charts-ose/master/stable/autonity/values.yaml

## Step 2
* Actors: `Alice`, `Bob`
* Actions: Deploy to their own cloud enviroments `autonity` helm chart with `genesis.yaml` options that was provided
by `Network operator` in a [Step 1](##Step 1) for each `Autonity nodes`:


## For environments based on EKS
* Deploy cluster
* Deploy workers EC2 instances with Elastic IPs
* Add rules to accept `incomming` `tcp`  connections to `dst` port `30303` for aws security groups for this node
* Add External Public IP that we will use for validator node to k8s node labels
    ```shell script
    # Get node list and public IPs
    kubectl get nodes -o wide
    # Label node
    kubectl label node ip-10-6-0-243.eu-west-1.compute.internal ext_ip=X.X.X.X
    ```
* Install
    ```shell script
    genesis="https://raw.githubusercontent.com/clearmatics/charts-ose/master/stable/autonity/values.yaml"
    name="??" # Name for Autonity node, for example: "val-2"
    ext_ip="X.X.X.X" # Public IP for Autonity node
    port="30303" # Public IP port for Autonity node. Should be different if you deploy several validator nodes to one cluster    
    helm install --name ${name} --namespace ${name} charts-ose.clearmatics.com/autonity --set aws.validator_0.ext_ip=${ext_ip},aws.validator_0.port=${port} -f ${genesis}
    ```

## For environments based on GKE
* Deploy cluster
* Deploy workers
* Install
    ```shell script
    genesis="https://raw.githubusercontent.com/clearmatics/charts-ose/master/stable/autonity/values.yaml"
    name="???" # Name for Autonity node, for example: "val-2"
    helm install --name ${name} --namespace ${name} charts-ose.clearmatics.com/autonity -f ${genesis}
    ```

## Step 3
* Actors: `Alice`, `Bob`
* Actions (for each own node): 
  * Get enodes for each own Autonity nodes:
  ```shell script
  helm status %chartname%
  ```
  * Add dns records to share it for other users with format provided below:
  
  | type | name | value | TTL |
  |------|-------------------|-------------|---|
  | A    | validator1.example.com      | 203.0.113.1 | 1 min |
  | TXT  | validator1.example.com  |p=30303; k=ad840ab412c026b098291f5ab56f923214469c61d4a8be41334c9a00e2dc84a8ff9a5035b3683184ea79902436454a7a00e966de45ff46dbd118e426edd4b2d0| 1 min |
 
## Step 4
* Actors: `Alice`, `Bob`
* Actions:
  * Wait until records will propagated and network start to mine a blocks.
  * Get 1th mined block hash
  * Send to other `participants` legal notarised message:
  ```shell script
  I am trust the Autonity network that has
      hash of 1th mined block `???` 
  if all of peers from this list trust it: [list of dns names of all autonity nodes]
  ```

## Step 5
* Actor: `Network operator`
* Actions: Get from AFNC new `genesis.yaml` with resolved `enode`s using helm helpers and replace previous `genesis.yaml` with `fqdn`
