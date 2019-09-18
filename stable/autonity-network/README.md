## Autonity-network helm chart

[![Join the chat at https://gitter.im/clearmatics/autonity](https://badges.gitter.im/clearmatics/autonity.svg)](https://gitter.im/clearmatics/autonity?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


## Introduction

This chart deploys a **private** [Autonity](https://www.autonity.io/) network onto a [Kubernetes](http://kubernetes.io) 
cluster using the [Helm](https://helm.sh) package manager.   
Autonity is a generalization of the Ethereum protocol based on a fork of go-ethereum.   
[Autonity Documentation](https://docs.autonity.io)

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
1. Download `autonity-helm` chart:
   ```bash
   git clone https://github.com/clearmatics/charts-ose.git
   ```
1. Deploy it
   ```bash
   cd ./charts-ose/stable/autonity-network
   helm install -n autonity-network ./
   ```
## Prerequisites

* Kubernetes 1.10
* Helm 2.13

## Kubernetes objects
This chart is comprised of 4 components:   
1. `initial jobs` that implement bootstrapping algorithm and run once as a helm hook `post-install`
   1. [init-job01-ibft-keys-generator](https://github.com/clearmatics/ibft-keys-generator) will create keys set
   1. [init-job02-ibft-genesis-configurator](https://github.com/clearmatics/ibft-genesis-configurator) will configure `genesis.json` 
   for autonity network initialisation
1. [autonity init](https://github.com/clearmatics/autonity-init) container for each autonity pod that download keys, 
   configs and prepare chain data
1. pods `validator-X`: nodes that implement [IBFT consensus algorithms](https://docs.autonity.io/IBFT/index.html) 
   [Source](https://github.com/clearmatics/autonity/blob/master/Dockerfile)
1. pods `observer-Y`: node that connected with another validators by p2p and expose JSON-RPC and WebSocket interface 
   [Source](https://github.com/clearmatics/autonity/blob/master/Dockerfile)

## Data storage

1. secret `account-pwd` contain generated account password.
1. secret `validators` or `observers` contain:   
   1. `0.private_key` - private key for account
1. configmap `validators` or `observers` contain:
   1. `0.address` - address
   1. `0.pub_key` - public key
1. Kubernetes [EmptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) for local blockchain of `validators` and `observers`. 
It will be removed if you delete a pod, or move it to another node. In that case the pod should load keys from kubernetes secrets, and download new blockchain from other peers automatically.


## Configure

- You can change number of validators or observers using helm cli-options like this:
   ```bash
   helm install -n autonity ./ --set validators=6,observers=2
   ```
- Also you can change any variables in this file [./values.yaml](values.yaml) before installation
- Configuration of main autonity network options is available in this template [./templates/configmap_genesis_template.yaml](templates/configmap_genesis_template.yaml)   
- all other options in `genesis.json` like: `validators`, `alloc`, `nodeWhiteList` will be generated automaticaly based on validators and observers list.   
You can get result of generating any time after deploy using:   
   ```bash
   kubectl get configmap genesis -o yaml --export=true   
   ```

### JSON-RPC HTTP Basic Auth
By default: `rpc_http_basic_auth_enabled: false`
To enable http Basic Auth:
* generate passwd file to ./file/htpasswd using [htpasswd](https://httpd.apache.org/docs/2.4/programs/htpasswd.html):
   ```shell script
   mkdir ./files
   htpasswd -c ./files/htpasswd user1
   htpasswd ./files/htpasswd user2
   htpasswd ./files/htpasswd user3
   ```
* set var `rpc_http_basic_auth_enabled: true`
   ```shell script
   ```bash
   helm install -n autonity ./ --set rpc_http_basic_auth_enabled=true
   ```

* add content to values.yaml with content of htpasswd, for example in values.yaml: ```
htpasswd: |-
  deployer:$ppr1$4WbnVvcI$cEYnXkBjmiHfT478ghEh70
      ascarborough:$app1$d3UNWQlK$C/MhHZrIgOs2y/j3ueVLd.
```

### HTTPS for JSON-RPC
* Generate keys and certs
    ```shell script
    KEY_FILE=files/tls.key
    CERT_FILE=files/tls.crt
    DH_FILE=files/dhparam.pem
    
    mkdir -p files
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE}
    
    openssl dhparam -out ${DH_FILE} 4096
   ```
* Set variable to `rpc_https_enabled: true`
   ```bash
   helm install -n autonity ./ --set rpc_https_enabled=true
   ```
* add base64 encoded cert variables to yaml file - for example - with the output of `base64 $KEY_FILE`, `base64 $CERT_FILE`, `base64 $DH_FILE`:
  ```
    rpc:
      tls_crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURYVENDQWtXZ0F3SUJBZ0lKQU5Nc1RDTWpmRlVCTUEwR0NTcUdTSWIzRFFFQkN3VUFNRVV4Q3pBSkJnTlYKQkFZVEFrZENNUTh3RFFZRFZRUUlEQVpNYjI1a2IyNHhEekFOQmdOVkJBY01Ca3h2Ym1SdmJqRVVNQklHQTFVRQpDZ3dMUTJ4bFlYSnRZWFJwWTNNd0hoY05NVGt3T1RFM01UUXlOREl5V2hjTk1qQXdPVEUyTVRReU5ESXlXakJGCk1Rc3dDUVlEVlFRR0V3SkhRakVQTUEwR0ExVUVDQXdHVEc5dVpHOXVNUTh3RFFZRFZRUUhEQVpNYjI1a2IyNHgKRkRBU0JnTlZCQW9NQzBOc1pXRnliV0YwYVdOek1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBTUlJQgpDZ0tDQVFFQXpXMTY1V1huWFBoZk0zUHJaOFFiY1ArOFJrTFdkeHpYc3pVZk1UdjMyZzg1cHlvdXlYdVNyU2M0CkRzMlJmOXpDeWIvd2V2OXVTRXdxWUFqWjVMT2RSNFk3OEJsem9NTFN2bmlRNVNVN3lLY3lZd0RCUWlmamh1VGoKQjV4ZDBUbmhQd00xS012Vkc2dHRHSnRtejVRUU5pNkg0MjIrSmVXTWVZeDE3bHpjS3pRbW52M1gzSzRycmdRZApQYWgvSlVrNjBrSlpvWkJhUmJ0ck0zOW92Q3d2VlRYeHZkSFV5Y1IvRllsZ21rdi85cmtPdmI4MXRJSDNrUVNmCk8relM5bXVOdTVJc1YveDNPVHRzMUdWMVJUdy9qbHBsVHBSRjNrYisyM3lyNzRVcExoNnpPaEZOU1hLMGRsRGEKeHVBcDl0YzNIb09BWi9zb0UzUjh4TVAzRHpRaDJ3SURBUUFCbzFBd1RqQWRCZ05WSFE0RUZnUVU0ZHFPTG14RwpnMlhMR2czcGx5OVZoYVptQW9Vd0h3WURWUjBqQkJnd0ZvQVU0ZHFPTG14R2cyWExHZzNwbHk5VmhhWm1Bb1V3CkRBWURWUjBUQkFVd0F3RUIvekFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBY2p6ek9adG1OVVRGWWZCVDllL3MKZ25GT1V4VGxtelZ4dWFsZXBLVHRIeHdabnFXNkN6anlKWGNmV0lVME1OK2pUc2NsaDFxekNybU9SdVc2WjZqMwpGYmt2RlVZaUxRamZic21nUnZxK1lUaGhScVVRbUtLL3UzejlQcjFiaWRURlF5R29hc0NacGJ5Z0hKeWRXbW90CkVmaEpyNWtoMGJidnA4Y2kvWUMweSt5U1g1QnBQSHRPQW1iUFRqSXhTYnRoMGR0ZHdWclFKL1c5MnlkQ3NWU1YKdkdQRkpjSnBiSWZkNTdIM3FacmE5UnBMK1c0dEliN05DNGtHRjZmVW5HR0tqbVBaUkNoTVI0dDZOYWJIZkZSZApnc2tWeC9saCtGUStDRE96RmkzUjYvY0VlVk9mU3lMejJJT3pPQ2dsVVNxcFhOc1UrUUpod3pPRjl4OUdJZWhsCnVRPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
      tls_key: LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRRE5iWHJsWmVkYytGOHoKYyt0bnhCdHcvN3hHUXRaM0hOZXpOUjh4Ty9mYUR6bW5LaTdKZTVLdEp6Z096WkYvM01MSnYvQjYvMjVJVENwZwpDTm5rczUxSGhqdndHWE9nd3RLK2VKRGxKVHZJcHpKakFNRkNKK09HNU9NSG5GM1JPZUUvQXpVb3k5VWJxMjBZCm0yYlBsQkEyTG9mamJiNGw1WXg1akhYdVhOd3JOQ2FlL2RmY3JpdXVCQjA5cUg4bFNUclNRbG1oa0ZwRnUyc3oKZjJpOExDOVZOZkc5MGRUSnhIOFZpV0NhUy8vMnVRNjl2elcwZ2ZlUkJKODc3TkwyYTQyN2tpeFgvSGM1TzJ6VQpaWFZGUEQrT1dtVk9sRVhlUnY3YmZLdnZoU2t1SHJNNkVVMUpjclIyVU5yRzRDbjIxemNlZzRCbit5Z1RkSHpFCncvY1BOQ0hiQWdNQkFBRUNnZ0VBUFlDcWk2V1B1Q2p3TDdKajV5UXlad2xacjl0dzVDWnhlY2pNdHV2U1Q2bkIKUkFnQUMvaUFPSEVHZW9BWE1LWENkNjZNYS9hdmFOdk0wQVcyWHA5YjFqOGRFTXc5N3dLRkg5dHUzZnZnd3pregpmNnFKTWFwSmwyaE5oRWpQV2NXdlp6TXBwallvYm1sTGQxT0hXMXhqNGlUYU1ELzU3dFNqMHZ3M2pvNmtxQllpCnBiTE5Lc1pBODJMMkMyWk9mbXRyMHdGeVZ3bzc4THArRUp2VXhpK252S2ZsaUJWOVpJM1V1amM3aFNiaFRkKzIKdzZlNDNjU3JPSmtTVzFzaFhhajdqUWMwOE1UbGtnZ0NTamQwUDIzY1h2TDNqZXZjRzkxL0dqcm9ZdjFzQXJVagpWRDcrVTREUXJEU0JNUFg0RWZzMW9UMXA2ckhmOXpmTVZKdTA5SnlnVVFLQmdRRHFGRWZuMUhqZzVlQmoxOHdQCmluNDE1T0JCSlBnZkZtWEZHcmlNNDVXL2tmYnRPRU1BZU9vRy9rQmFUVWxxd3AzR1VMQWxnajZWUk5venlSNDcKVVh1eERxZ2ZYSGFmVGVBa29CWGFWQWJjZGhXUklQbEhWdEkrSWUzMUdKMFlwYmZjdWtKOW5EVHZoYmN1ZkZYYwpqQWIxYUtSVndWYTd3bmZXcEZTTGJJakFDUUtCZ1FEZ3FsRjlGMlBCeHdGdU1GbUl5aGNsa04vck5OY2gyUDdMCnhxSDRIb1BwRmIrcE92ckdxdmZCcWV4NzVBQXB3ejluQkZrdGlIK2ZqUVVOa1dWOHhRcXIzWlZwNUdzVVFESDcKdTBNUGoxMm5TNVJMQTQvVFRxUDFTN1pzQnlVSXkwc0I5R0Y3SEcyVnpNVXVMdmdsa2xSNE1KdEs5RnE1UVRkRApWemhhald2RHd3S0JnUURGcE9veDdVMURWOVhuZDhadE9Ocm9WcUNqWUx2QVJBRWFORDJ2ZUZwd3JxWjRGaEU4CnpOdU5uQkJxTHVmV3BRemk3aTVNL1hRcVJVQ1lpVEJsbForREdJVU1OZDVURkVZMXBwWE5DelhmNERURm5ibmQKYW9tS3ZNdFhMN2sxbm5kb2dEeTBJcmp2cFUvT2lGMVhJMFNjNGdZZ0FtZGhrZ250eWtNNGxpUEJRUUtCZ0UxYQp0MFlQMkp3dXpoSkhlWHg4d0syQmpXZXB3T3o1anZsUXdoSHhSOC9vV2g2Rm5UVHNSdlFhY3I5UmlMRFlkaXNkCk55dFRWVVgxUXlraHg4VEcvMTZmbzhOYkQzZGdoeFU2cStOZXBJdG1uWCtha1ZuYk9ON0xtOXJrTnQ4cFNBRTcKU0prZjk2ZGRZd0w4enhuNG9UYmszWU5ZVVNoNkNQSVp4T0NBMHZzTEFvR0FjbDN6czRwcmQyY3lXTmZqVVpxbAp4UDMvME9YdERpM1pwQm0vTkFja2l4bk94aUJFMEtTWEh2Ymhwc1ZBM3FBS3hYbUlMVFNId1VuRjJLd1ZGdlgvCk9kZC81YzMxcWcvUHVIcGVEUkZwdEE5N0FqeHhmY3FJeUxyTVB6QSt6SXVlR1dsTE9sTVp5MnNieDlCUkplMVgKK1gxY0NzekRmUWtXY0t4VzVObDN5cG89Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K
      dhparam_pem: LS0tLS1CRUdJTiBESCBQQVJBTUVURVJTLS0tLS0KTUlJQ0NBS0NBZ0VBMDBCeW1HQmlHazBjWDRSTnZrcGtES2tmeFlXUnhlaGhEK2tJYVordEJ6NjZIaHhmTHhtMgpvNkxsYldjZnhqL1hiU1RVdVJaUHNWM1N0eWhnK2VPY1dKS3FUL0drWE1VaG1kbkMxSmlpbEx5ZkxGMzBhOE1pCmV1UjZ5OUczcDJQald1ZFFQUllKZWZWREJwbXZmWmYxaFI3NmVIM0RNU2dGazhpWlNjTG9YRk9WMldDd1JzdVQKdVhGVEZlVlJLTXpVSWsrLzdVOFBReVJJK1NXSkFrY2dpNDk1ak9nNVVpNjAxMEw3bXRLeWdQOTJBd2Y3ekNhbQp6UkVCNlpabXFOUkt3TFcwNXU0bk92Q09VSUN2MlJJaFV3OTRtU2dlU2ZpcXI0TzRLSW1vcHlubUxQN1lzWVRqCnhqR0NuMlR3RnQxaXpaN3g0Z0VKd1Y5ZDZodTlIYWVhdzBIVEppZEJwLzJIZnBBZ3orZVZldmVnYUxNZTBTcm0KS0dITkZMUGFwTldQQkI2KzNGVlllMXVJS29XLzRhTExoT01UM2tlbGhqYTZzYXdRM3hPazYxZDNkZ1BuZnhENwptTnZwRXRjZ1FqVE04V3c5TlFwV1E2bGdwY2NWNDltbU1UajY1MlRidVpuNVhJNkhtajdCemtoMnJCd3pWbVV3CmNPTi9qVlNYUm5NSmU3QUdGSlJKMnBjRjA2T0liM3lvaXo3Rm5nZnArVDI5ZWVGejFjN1creXV5NFcyY2dwNWgKSU9PVlphTTRMVytlbnBDZURtQlk5ZkI2dWNZWnlrVEtpNUF4dUEyR1dFdHNDVXppb2xqMXllT1pLTXVzSUU1VApwRFRpcnB5SGMwakUxUkxmRG1VNnRIOHNEUXJwa1R2ZVhOODRvOUtQcWsxYk1nNXlQWDZVbTdNQ0FRST0KLS0tLS1FTkQgREggUEFSQU1FVEVSUy0tLS0tCg==
  ```

## Tips (to view available commands)
```bash
helm status autonity
```

## Delete
```bash
helm delete autonity --purge
```