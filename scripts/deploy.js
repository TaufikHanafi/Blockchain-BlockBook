// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

// scripts/deploy.js
 
async function main() {

  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // We get the contract to deploy
  const AdminContract = await hre.ethers.getContractFactory("AdminContract");
  const PubliserContract = await hre.ethers.getContractFactory("PubliserContract");
  const WriterContract = await hre.ethers.getContractFactory("WriterContract");
  const UserContract = await hre.ethers.getContractFactory("UserContract");
  const BookContract = await hre.ethers.getContractFactory("BookContract");
  const BookTransactionContract = await hre.ethers.getContractFactory("BookTransactionContract");
  
  console.log("Deploying Smart Contract...");

  const admin = await AdminContract.deploy();
  await admin.waitForDeployment();
  
  const publiser = await PubliserContract.deploy();
  await publiser.waitForDeployment();

  const writer = await WriterContract.deploy();
  await writer.waitForDeployment();
  
  const user = await UserContract.deploy();
  await user.waitForDeployment();

  const book = await BookContract.deploy(await publiser.getAddress(), await writer.getAddress(), await admin.getAddress(), await user.getAddress());
  await book.waitForDeployment();
  
  const booktrans = await BookTransactionContract.deploy(await book.getAddress(), await publiser.getAddress(), await writer.getAddress(), await user.getAddress());
  await booktrans.waitForDeployment();

  await publiser.connect(deployer).setBookContract(await book.getAddress());
  await publiser.connect(deployer).setBookTransactionContract(await booktrans.getAddress());

  await writer.connect(deployer).setBookContract(await book.getAddress());
  await writer.connect(deployer).setBookTransactionContract(await booktrans.getAddress());

  await user.connect(deployer).setBookTransactionContract(await booktrans.getAddress());
  await user.connect(deployer).setBookContract(await booktrans.getAddress());

  await book.connect(deployer).setBookTransactionContract(await booktrans.getAddress());

  console.log("All contracts deployed. Admin: ", await admin.getAddress(), " Publiser: ", await publiser.getAddress() , " Writer: ", await writer.getAddress() , " User: ", await user.getAddress() , " Book: ", await book.getAddress(), " BookTransaction: ", await booktrans.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
      console.error(error);
      process.exit(1);
  });
