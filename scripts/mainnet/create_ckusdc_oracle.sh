#!/usr/bin/env sh
set -e

create_oracle_evm() {
    oracle_args="(
        \"0xb29423Ff11d409D6A9fe58b8E97437E4371356a5\",
        variant {
            Evm = record {
                provider = record {
                    chain_id = 355113;
                    hostname = \"https://testnet.bitfinity.network\";

                };
                target_address = \"0xac7cE1b7032391eABC55BB3438C76f9e6Fb04D43\";
                method = \"getReserves\";
            }
        },
        10,
        record {
            contract = \"0x7beFdBbbf4d686C2c67bcb958cF542f1a2146d91\";
            provider = record {
                chain_id = 355110;
                hostname = \"https://mainnet.bitfinity.network\";
            }
        }
    )"

    dfx canister call oracular create_oracle "$oracle_args"
}

create_oracle_evm
