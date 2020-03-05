# Changelog
All notable changes to this chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
## [1.5.9] - 2020-03-05
### Updated
- Autonity to dev-0.3.2
- Genesis changes
- Add Telegraf and IndluxDB support

## [1.5.8] - 2020-01-13
### Updated
- Autonity to  dev-0.3.0-fix2
- Add Telegraf and IndluxDB support

## [1.5.7] - 2019-11-15
### Updated
- Autonity to v0.3.0

## [1.5.6] - 2019-10-23
### Updated
- add the ability to whitelist ip ranges rather than individual ip addresses

## [1.5.5] - 2019-10-23
### Updated
- update `ibft-genesis-configurator` to v1.0.4 to wait a keys generation

## [1.5.4] - 2019-10-23
### Updated
- helm hook for init_ibft_genesis_configurator from `hook-succeeded` to `before-hook-creation`

## [1.5.3] - 2019-10-23
### Added
- `tendermint` to API
### Updated
- Fixed wrong key for `operator` in genesis.json
- requirements to `helm` > v2.15.0

## [1.5.2] - 2019-09-30
### Updated
- Allow for specifying of LB source ranges

## [1.5.1] - 2019-09-30
### Updated
- Up `autonity` to `v0.2.1`

## [1.5.0] - 2019-09-27
### Updated
- Up `autonity` to `v0.2.0-rc`
- New variables for `genesis.json`is avalable: `stake`, `mingasprice`, `gaslimit`, `balance`
-  `istanbul` concensus is deprecated

## [1.4.0] - 2019-09-26
### Add
- Add toleration for role: validators taint on validator nodes
- Add support for binding to availability zones and nodepools

## [1.3.4] - 2019-09-24
### Add
- Refactoring `treasure` --> `treasury`

## [1.3.3] - 2019-09-24
### Add
- `operator-governance` and `operator-treasure` to keys generation

## [1.3.2] - 2019-09-23
### Add
- autonity option `NetworkID`

## [1.3.1] - 2019-09-20
### Updated
- Enable CORS for rpc

## [1.3.0] - 2019-09-20
### Updated
- feed genesis job with names rather than ip addresses (if defined)


## [1.2.0] - 2019-09-18
### Updated
- Change keys and passwords to be taken in as base64 encoded strings by via options: `rpc.tls_crt`, `rpc.tls_key`, `rpc.tls_dhparam`, and `htpasswd`


## [1.1.2] - 2019-09-17
### Updated
- Add `petersburgBlock` to `genesis.json`

## [1.1.1] - 2019-09-17
### Updated
- Fixed `genesis.json` default options

## [1.1.0] - 2019-09-17
### Updated
- Using external LoadBalancer as option

## [1.0.0] - 2019-09-16
### Updated
- Switch to native prometheus metrics. Option `global.prometheus.enabled` is deprecated
    - Metrics port changed to `6060`
    - deleted sidecar `prometheus-exporter`
    - metrics enabled by default
## [0.3.7] - 2019-09-16
### Updated
- Up docker images:
    - autonity to v0.1.6
    - autonity-init to v0.1.1

## [0.3.6] - 2019-09-13
### Updated
- Optional persistent storage for blockchain (AWS and GCP support)

## [0.3.5] - 2019-09-04
### Updated
- autonity to dev-v0.1.5, autonity-init to v0.0.8

## [0.3.4] - 2019-08-26
### Added
- WebSockets over SSL/TLS and HTTP Basic Auth support for autonity validators and observers

## [0.3.3] - 2019-08-20
### Added
- https support for autonity RPC

## [0.3.2] - 2019-08-20
### Added
- http basic auth support for autonity RPC (for observers)
- autonity version update to v0.1.5

## [0.3.1] - 2019-08-19
### Added
- http basic auth support for autonity RPC (for validators only)

## [0.3.0] - 2019-08-13
### Changed
- Add Tendermint consensus algorithm (defult)

## [0.2.10] - 2019-06-20
### Changed
- Update chart description and app version

## [0.2.9] - 2019-06-13
### Added
- Tests for RPC
