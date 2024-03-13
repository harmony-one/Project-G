const hre = require("hardhat");

const custodianaddress = "0xD87A3c4b15193a37EE7773De43Cc66f12b768a76";
async function main() {
  const CFNFT = await hre.ethers.getContractFactory("CFNFT");
  console.log('Deploying ChainForce ERC721 token...');
  const nft = await CFNFT.deploy(custodianaddress);

  await nft.waitForDeployment();

  console.log("ChainForce NFT deployed to:", nft.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});