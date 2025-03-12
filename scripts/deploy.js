const hre = require("hardhat");

async function main() {
  const OptimizedToken = await hre.ethers.getContractFactory("OptimizedToken");
  const token = await OptimizedToken.deploy("Optimized Token", "OPT");

  await token.deployed();

  console.log("OptimizedToken deployed to:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
