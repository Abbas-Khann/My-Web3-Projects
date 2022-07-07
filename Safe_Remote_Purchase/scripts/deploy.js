const {ethers} = require("hardhat")

const main = async () => {

    const purchaseAgreementContract = await ethers.getContractFactory('Purchase_Agreement');

    const deployedPurchaseAgreementContract = await purchaseAgreementContract.deploy();
    
    await deployedPurchaseAgreementContract.deployed();

    console.log("Contract Address", deployedPurchaseAgreementContract.address)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });