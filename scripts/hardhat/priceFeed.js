async function main() {
  const PriceFeed = await ethers.getContractFactory("PriceFeed");

  const pairDiscription = "GLDT/USD";
  const decimals = 8;
  const owner = "0xb29423Ff11d409D6A9fe58b8E97437E4371356a5";
  const version = 1;

  const priceFeedWBFT = await PriceFeed.deploy(
    pairDiscription,
    decimals,
    version,
    owner
  );
  console.log("PriceFeed deployed to:", priceFeedWBFT.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
