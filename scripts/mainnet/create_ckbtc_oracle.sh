#!/usr/bin/env sh
set -e

create_oracle_canister() {
    oracle_args="(
        \"0xb29423Ff11d409D6A9fe58b8E97437E4371356a5\",
        variant {
            Canister = record {
            pair = \"ckBTC/USD\";
        }
        },
        10,
        record {
            contract = \"0x14895FeF32DC208443F2C2A097E0608f4479809e\";
            provider = record {
                chain_id = 355110;
                hostname = \"https://mainnet.bitfinity.network\";
            }
        }
    )"

    dfx canister call oracular create_oracle "$oracle_args" --playground
}

create_oracle_canister
