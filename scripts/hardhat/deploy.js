async function main() {
  const PriceFeed = await ethers.getContractFactory("PriceFeed");

  const decimals = 8;
  const owner = process.env.OWNER;

  const priceFeedWBFT = await PriceFeed.deploy("WBFT/USD", decimals, 1, owner);
  console.log("WBFT/USD PriceFeed deployed to:", priceFeedWBFT.target);

  const priceFeedICP = await PriceFeed.deploy("ICP/USD", decimals, 1, owner);
  console.log("ICP/USD PriceFeed deployed to:", priceFeedICP.target);

  const priceFeedCKUSDC = await PriceFeed.deploy(
    "CKUSDC/USD",
    decimals,
    1,
    owner
  );
  console.log("CKUSDC/USD PriceFeed deployed to:", priceFeedCKUSDC.target);

  const priceFeedCKBTC = await PriceFeed.deploy(
    "CKBTC/USD",
    decimals,
    1,
    owner
  );
  console.log("CKBTC/USD PriceFeed deployed to:", priceFeedCKBTC.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
