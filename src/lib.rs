pub mod canister;
pub mod constants;
mod context;
pub mod error;
pub mod http;
pub mod log;
mod memory;
mod parser;
pub mod provider;
pub mod state;

use candid::pretty::candid::compile;

pub fn idl() -> String {
    use crate::canister::Oracular;

    let oracle_idl = Oracular::idl();

    compile(&oracle_idl.env.env, &Some(oracle_idl.actor))
}
