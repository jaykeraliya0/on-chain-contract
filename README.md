# Onchain NFTs smart contract

This is simple hardhat project for on chain nft (ERC-721) smart contract.

### Contract address to test and interact

```shell
0xd205779A6C4D4Bd0Abf93F290c692AD4AaaCcEe2
```

# How To Deploy

1. Install dependencies

```shell
npm install
```

2. Add Alchemy API key and private key in .env file

3. Test smart contract

```shell
npx hardhat test
```

4. Deploy smart contract on goerli testnet

```shell
npx hardhat run scripts/deploy.ts --network goerli
```

# ⚠️ Disclaimer

```
These contracts were created for learning purposes.
Before using any of the following code for production, kindly review it on your own.
I won't be held responsible in any way for how the code is used.
To the best of the developers' ability, the code has been tested to ensure that it performs as intended.
```

# Credits
Thanks to [Brechtpd](https://github.com/Brechtpd) for Base64.sol contract
