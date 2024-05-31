use candid::CandidType;
use eth_signer::sign_strategy;
use serde::{Deserialize, Serialize};
use thiserror::Error;

use crate::parser;

#[derive(Debug, CandidType, Serialize, Deserialize, Error, PartialEq, Eq)]
pub enum Error {
    #[error("Internal error: {0}")]
    Internal(String),

    #[error(transparent)]
    EvmError(#[from] did::error::EvmError),

    #[error("ic client error : {0}")]
    IcClient(String),

    #[error("http error : {0}")]
    Http(String),

    #[error("pair not found")]
    OracleNotFound,

    #[error("pair already exists")]
    OracleAlreadyExists,

    #[error(transparent)]
    ParseError(#[from] parser::ParseError),

    #[error("json rpc error : {0}")]
    JsonRpcError(String),

    #[error("user not found")]
    UserNotFound,

    #[error("transaction signer error : {0}")]
    TransactionSignerError(String),
}

impl From<String> for Error {
    fn from(s: String) -> Self {
        Self::Internal(s)
    }
}

pub type Result<T> = std::result::Result<T, Error>;

impl From<ic_canister_client::CanisterClientError> for Error {
    fn from(value: ic_canister_client::CanisterClientError) -> Self {
        Self::IcClient(value.to_string())
    }
}

impl From<serde_json::Error> for Error {
    fn from(value: serde_json::Error) -> Self {
        Self::Internal(value.to_string())
    }
}

impl From<ethers_core::abi::Error> for Error {
    fn from(value: ethers_core::abi::Error) -> Self {
        Self::Internal(value.to_string())
    }
}

impl From<sign_strategy::TransactionSignerError> for Error {
    fn from(value: sign_strategy::TransactionSignerError) -> Self {
        Self::TransactionSignerError(value.to_string())
    }
}
