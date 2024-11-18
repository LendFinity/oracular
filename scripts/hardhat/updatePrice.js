async function main() {
  const [signer] = await hre.ethers.getSigners();

  const MyContract = await hre.ethers.getContractFactory("PriceFeed");

  const contractAddress = "0x14895FeF32DC208443F2C2A097E0608f4479809e";
  const myContract = MyContract.attach(contractAddress).connect(signer);

  const tx = await myContract.updatePrice(9095300000000);

  console.log("Function called, result:", tx);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
