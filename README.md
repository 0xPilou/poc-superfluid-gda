# poc-superfluid-gda

Proof Of Concept Superfluid GDA integration

## Deployment

### MockSuperToken

deploy and verify MockSuperToken (superfluid mock token) :

```sh
forge script script/deploy-MockSuperToken.s.sol:DeployMockSuperToken --rpc-url optimism-goerli --broadcast --verify --etherscan-api-key ${OPTIMISM_ETHERSCAN_API_KEY}
```

simulate deployment :

```sh
forge script script/deploy-MockSuperToken.s.sol:DeployMockSuperToken --rpc-url optimism-goerli
```

### GDAExplo

deploy and verify GDAExplo :

```sh
forge script script/deploy-GDAExplo.s.sol:DeployGDAExplo --rpc-url optimism-goerli --broadcast --verify --etherscan-api-key ${OPTIMISM_ETHERSCAN_API_KEY}
```

simulate deployment :

```sh
forge script script/deploy-GDAExplo.s.sol:DeployGDAExplo --rpc-url optimism-goerli
```
