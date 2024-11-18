#!/usr/bin/env sh
set -e

create_oracle_http() {
    oracle_args="(
        \"0xb29423Ff11d409D6A9fe58b8E97437E4371356a5\",
        variant {
            Http = record {
            url = \"https://api.coinbase.com/v2/prices/BTC-ETH/spot\";
            json_path = \"data.amount\";
        }
        },
        60,
        record {
            contract = \"0x93c52eDAE4d4307703568d213ADbD6Ff0e87a5b8\";
            provider = record {
                chain_id = 355110;
                hostname = \"https://mainnet.bitfinity.network\";
                credential_path = \"\";
            }
        }
    )"

    dfx canister call oracular create_oracle "$oracle_args"
}

create_oracle_http
