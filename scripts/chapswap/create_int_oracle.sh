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
                target_address = \"0xCB56529771a42efadcA3030C95E846301EF0D08a\";
                method = \"getReserves\";
            }
        },
        60,
        record {
            contract = \"0x8fB5F54dAEB90e124D3EDc0Ba3132Fe03af0a0De\";
            provider = record {
                chain_id = 355113;
                hostname = \"https://testnet.bitfinity.network\";
            }
        }
    )"

    dfx canister call oracular create_oracle "$oracle_args"
}

create_oracle_evm
