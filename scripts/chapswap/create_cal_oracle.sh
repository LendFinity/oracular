#!/usr/bin/env sh
set -e

create_oracle_evm() {
    oracle_args="(
        \"0xcb0e6F3a6F65c2360bD4324f747859E780bd8FB3\",
        variant {
            Evm = record {
                provider = record {
                    chain_id = 355113;
                    hostname = \"https://testnet.bitfinity.network\";

                };
                target_address = \"0xEe85A4dff3a923F0Aba6241549E7d94186938838\";
                method = \"getReserves\";
            }
        },
        60,
        record {
            contract = \"0x17a8dED9bAC8CB69aeCF8BF44Dc5A16f2eB1bf03\";
            provider = record {
                chain_id = 355113;
                hostname = \"https://testnet.bitfinity.network\";
            }
        }
    )"

    dfx canister call oracular create_oracle "$oracle_args"
}

create_oracle_evm
