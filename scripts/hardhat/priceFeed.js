async function main() {
  const PriceFeed = await ethers.getContractFactory("PriceFeed");

  const decimals = 8;
  const owner = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";

  const priceFeedWBFT = await PriceFeed.deploy("MNX/USD", decimals, 1, owner);
  console.log("WBFT/USD PriceFeed deployed to:", priceFeedWBFT.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
