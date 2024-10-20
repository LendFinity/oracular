async function main() {
  const [signer] = await hre.ethers.getSigners();
  // const gasPrice = hre.ethers.utils.parseUnits("10", "gwei");
  // const gasLimit = 10000000;

  const MyContract = await hre.ethers.getContractFactory("PriceFeed");

  const contractAddress = "0xcFe2E020E3e4DC28Ee29A601CbE7551364fC7AD4";
  const myContract = MyContract.attach(contractAddress).connect(signer);

  const tx = await myContract.updatePrice(300000000);

  console.log("Function called, result:", tx);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
