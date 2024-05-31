use candid::CandidType;
use did::transaction::Signature;
use did::H160;
use eth_signer::ic_sign::{DerivationPath, SigningKeyId};
use eth_signer::sign_strategy::{IcSigner, TransactionSigner, TransactionSignerResult};
use ethers_core::types::transaction::eip2718::TypedTransaction;
use serde::Deserialize;

/// A component that provides the access to the signer
#[derive(Debug, Default, Clone)]
pub struct SignerInfo;

impl SignerInfo {
    pub fn get_oracle_signer(&self, user_address: H160) -> impl TransactionSigner {
        OracleSigner::new(user_address)
    }
}

#[derive(CandidType, Clone, Deserialize, Debug)]
pub struct OracleSigner {
    pub(super) key_id: SigningKeyId,
    pub(super) derivation_path: DerivationPath,
}

impl OracleSigner {
    fn new(address: H160) -> Self {
        let address_to_bytes = address.0.as_bytes().to_vec();
        Self {
            key_id: SigningKeyId::Dfx,
            derivation_path: vec![address_to_bytes],
        }
    }
}

#[async_trait::async_trait(?Send)]
impl TransactionSigner for OracleSigner {
    /// Returns the `sender` address for the given identity
    async fn get_address(&self) -> TransactionSignerResult<H160> {
        let pubkey = IcSigner {}
            .public_key(self.key_id.clone(), self.derivation_path.clone())
            .await?;
        let address: H160 = IcSigner.pubkey_to_address(&pubkey)?.into();

        Ok(address)
    }

    /// Sign the created transaction
    async fn sign_transaction(
        &self,
        transaction: &TypedTransaction,
    ) -> TransactionSignerResult<Signature> {
        let signature = IcSigner {}
            .sign_transaction(
                transaction,
                self.key_id.clone(),
                self.derivation_path.clone(),
            )
            .await?;

        Ok(signature.into())
    }

    /// Sign the given digest
    async fn sign_digest(&self, digest: [u8; 32]) -> TransactionSignerResult<Signature> {
        let address = self.get_address().await?;
        let signature = IcSigner
            .sign_digest(
                &address.into(),
                digest,
                self.key_id.clone(),
                self.derivation_path.clone(),
            )
            .await?;

        Ok(signature.into())
    }
}
