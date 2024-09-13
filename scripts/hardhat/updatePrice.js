async function main() {
  const [signer] = await hre.ethers.getSigners();
  // const gasPrice = hre.ethers.utils.parseUnits("10", "gwei");
  // const gasLimit = 10000000;

  const MyContract = await hre.ethers.getContractFactory("PriceFeed");

  const contractAddress = "0xCC4699e54c5D98b82702305e63835B50e6B5Bfb5";
  const myContract = MyContract.attach(contractAddress).connect(signer);

  const tx = await myContract.updatePrice(100000000);

  console.log("Function called, result:", tx);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
