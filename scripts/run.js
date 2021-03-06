// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const DomainNFT = await hre.ethers.getContractFactory("DomainNFT");
  const domainNFT = await DomainNFT.deploy("celo");

  await domainNFT.deployed();

  console.log("DomainNFT deployed to:", domainNFT.address);

  const price = await domainNFT.price();
  console.log("Price", price);

  let txn = await domainNFT.safeMint("master", {value: hre.ethers.utils.parseEther('0.1')});
  await txn.wait();

  txn = await domainNFT.safeMint("ninja", {value: hre.ethers.utils.parseEther('0.1')});
  await txn.wait();

  txn = await domainNFT.safeMint("domain", {value: hre.ethers.utils.parseEther('0.1')});
  await txn.wait();

  const names = await domainNFT.getAllNames();
  console.log("Name:", names);

  const add = await domainNFT.getAddress("ninja.celo");
  console.log("ninja.celo: " , add);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });