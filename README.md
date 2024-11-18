# Oracular Canister

This is a canister which can be used to deploy oracles and update their values.

## Addresses (Testnet)

### ChapSwap Contracts

- MULTICALL - `0xa40b978a9F6650bC654f475FA73D83d2B9AdDb74`
- ROUTER - `0xD82d333a2BeB122842094459652107F9154E7745`
- FACTORY - `0x9945f4a1eC4C4FC74a70276CCf60b8b1B2DE1F4A`

### Tokens

- USDT `0xbd9A5c1d9fBbBEC84633ec9Cb046C01fB79809f2`
- CHAP `0x9581aa53E089F4E8f0B3c566f00121DF7c83c83B`
- WBFT `0x7938ACd297d53bD743c3926E3C24e7262C18AEc3`
- CAL `0xaFD885e805B78C13DF22118695ef3F4dc582656D`
- COD `0xc489778CD7DB9427a730F30BD66a57762DE96628`
- CVA `0x42AbC7B10224E2e7Ea721FC5e002BAe561BA6659`
- CYN `0x1bBB2533Dcd95D7E347bC278c5b6398b5f7c83EC`
- FNS `0xD89E302C8ac7AbAa4eC6016961e04692cccb6039`
- INT `0xa9449C8E42D5D49a2B5031A843747B342816dC13`

### Pairs

- CHAP/USDT `0xdE509748A1Fd9d2d221b970a9bE2eC9cb90c4da3`
- WBFT/USDT `0xac7cE1b7032391eABC55BB3438C76f9e6Fb04D43`
- CAL/USDT `0xEe85A4dff3a923F0Aba6241549E7d94186938838`
- COD/USDT `0xaD619532EBb0B20d9807F9F823Fa3d2ed3453967`
- CVA/USDT `0x5dC876c95929148D11e840A006D6C3d9fC8Add43`
- CYN/USDT `0xd90919E8eBe090de9C2A2D6E8A92037eEdc7AaD2`
- FNS/USDT `0xc8174931E8020b80D0A8141F91146FB95cf843a7`
- INT/USDT `0xCB56529771a42efadcA3030C95E846301EF0D08a`

### Price Feeds

- CHAP/USDT `0xcFe2E020E3e4DC28Ee29A601CbE7551364fC7AD4`
- WBFT/USDT `0x7beFdBbbf4d686C2c67bcb958cF542f1a2146d91`
- CAL/USDT `0x17a8dED9bAC8CB69aeCF8BF44Dc5A16f2eB1bf03`
- COD/USDT `0x886A8673bF39d258F0bF494c5F4ff4D34ac27657`
- CVA/USDT `0x52AA7928063b4B685E197c6567D850781498a7d0`
- CYN/USDT `0x6865D26541F3582028C6596194bBBE77aD296847`
- FNS/USDT `0x8F1A47187e07f3fadC561f40f82eb4FE20468bb8`
- INT/USDT `0x8fB5F54dAEB90e124D3EDc0Ba3132Fe03af0a0De`

## Steps

1. Fork Oracular

Fork [Oracular](https://github.com/bitfinity-network/oracular), Bitfinity's SDK to create oracle canisters.

2. Deploy Price Feed Smart Contracts

Deploy a price feed smart contract for each token (e.g., WBFT/USD, CHAP/USD). Use [Remix](https://remix.ethereum.org/) to deploy contracts/core/PriceFeed.sol. Record the contract addresses as they will be needed later.

3. Create Oracle Scripts

For each token, create a script to set up the desired oracles. To get the token prices from ChapSwap's LPs, call the getReserves() method from PancakePair.sol to calculate the price.

Example Script (`create_token_oracle.sh`):

```bash
#!/usr/bin/env sh
set -e

create_oracle_evm() {
    oracle_args="(
        <DEPLOYER_ADDRESS>,
        variant {
            Evm = record {
                provider = record {
                    chain_id = 355113;
                    hostname = \"https://testnet.bitfinity.network\";

                };
                target_address = <PAIR_ADDRESS>;
                method = \"getReserves\";
            }
        },
        10,
        record {
            contract = <PRICE_FEED_ADDRESS>;
            provider = record {
                chain_id = 355113;
                hostname = \"https://testnet.bitfinity.network\";
            }
        }
    )"

    dfx canister call oracular create_oracle "$oracle_args"
}

create_oracle_evm
```

4. Create a Script to Call All Oracle Scripts

Create a master script to call all individual oracle creation scripts.

Example Script (`deploy_oracles.sh`):

```bash
#!/bin/bash

scripts/chapswap/create_cal_oracle.sh
scripts/chapswap/create_chap_oracle.sh
scripts/chapswap/create_cod_oracle.sh
scripts/chapswap/create_cva_oracle.sh
scripts/chapswap/create_cyn_oracle.sh
scripts/chapswap/create_fns_oracle.sh
scripts/chapswap/create_int_oracle.sh
scripts/chapswap/create_wbft_oracle.sh
```

5. Update `canister.rs` for Price Calculation

Modify the code to allow calling the getReserves function and calculate the price based on the current pair.

Add a Struct for the Response:

```rust
#[derive(Deserialize, Debug)]
#[allow(non_snake_case)]
struct Response {
    _reserve0: U256,
    _reserve1: U256,
    _blockTimestampLast: U256,
}
```

Update `Origin::Evm` section of the `send_transaction` function:

```rust
Origin::Evm(EvmOrigin {
    ref provider,
    ref target_address,
    ref method,
}) => {
    let data = provider::function_selector(method, &[]).encode_input(&[])?;

    let data_hex = did::Bytes::from(data).to_hex_str();
    let params = serde_json::json!([{
        "to": target_address,
        "data": data_hex,
    }, "latest"]);

    let res =
        http::call_jsonrpc(&provider.hostname, "eth_call", params, Some(80000)).await?;

    let result = res.as_str().ok_or("Failed to get result 1--")?;
    let decoded_result = hex::decode(&result[2..])?;

    let response = Response {
        _reserve0: U256::from_big_endian(&decoded_result[0..32]),
        _reserve1: U256::from_big_endian(&decoded_result[32..64]),
        _blockTimestampLast: U256::from_big_endian(&decoded_result[64..96]),
    };

    // 10^8
    let big_value: U256 = U256::from(100_000_000u64);

    // multiply 10^18 with reserve 0
    let reserve1_mul: U256 = response
        ._reserve1
        .checked_mul(&big_value)
        .ok_or(Error::Internal("Multiplication overflow".to_string()))?;

    // divide reserve0_mul with reserve 1
    let big_price: U256 = reserve1_mul
        .checked_div(&response._reserve0)
        .ok_or(Error::Internal("Multiplication overflow".to_string()))?;

    big_price
}
```

6. Add New Errors to `error.rs`

Add the necessary error handling.

```rust
use ethers_core::abi::ethereum_types::FromDecStrErr;

// ...

impl From<&str> for Error {
    fn from(error: &str) -> Self {
        Self::Internal(error.to_string())
    }
}

impl From<FromDecStrErr> for Error {
    fn from(error: FromDecStrErr) -> Self {
        Self::Internal(error.to_string())
    }
}
impl From<hex::FromHexError> for Error {
    fn from(error: hex::FromHexError) -> Self {
        Self::Internal(error.to_string())
    }
}
```

7. Log Signer's Address

Update the `get_transaction` method in `provider.rs` to log the signer's address.

```rust
let signer = {
    let context = context.borrow();
    let signer = context.get_state().signer.get_oracle_signer(user_address);

    log::info!("Signer {:?}", signer.get_address().await?);

    signer
};
```

8. Fix Typo in provider.rs

Correct the type from `Int` to `Uint` in `UPDATE_PRICE` in `provider.rs` and in `canister.rs`.

9. Build and Run the Canister

Build and run the canister, then create the oracles.

Build the canister:

```bash
./scripts/build.sh
```

Run the canister:

```bash
./scripts/dfx/deploy_local.sh create
```

Create the oracles:

```bash
./scripts/chapswap/deploy_oracles.sh
```

10. Fund the Signer's Address

Retrieve the signer's address from the logs and fund it. After funding, your oracles should be running fine.
