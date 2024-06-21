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
                target_address = \"0x5dC876c95929148D11e840A006D6C3d9fC8Add43\";
                method = \"getReserves\";
            }
        },
        60,
        record {
            contract = \"0x52AA7928063b4B685E197c6567D850781498a7d0\";
            provider = record {
                chain_id = 355113;
                hostname = \"https://testnet.bitfinity.network\";
            }
        }
    )"

    dfx canister call oracular create_oracle "$oracle_args"
}

create_oracle_evm
