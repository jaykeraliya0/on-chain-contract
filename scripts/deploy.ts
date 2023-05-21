async function main() {
  // @ts-ignore
  const Contract = await ethers.getContractFactory("NFT");

  const NFT = await Contract.deploy();
  console.log("Contract deployed to address:", NFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
