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
                target_address = \"0xdE509748A1Fd9d2d221b970a9bE2eC9cb90c4da3\";
                method = \"getReserves\";
            }
        },
        60,
        record {
            contract = \"0xcFe2E020E3e4DC28Ee29A601CbE7551364fC7AD4\";
            provider = record {
                chain_id = 355113;
                hostname = \"https://testnet.bitfinity.network\";
            }
        }
    )"

    dfx canister call oracular create_oracle "$oracle_args"
}

create_oracle_evm
