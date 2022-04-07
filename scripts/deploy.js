const hre = require("hardhat");

async function main() {
  const Pokemon = await hre.ethers.getContractFactory("Pokemon");
  const pokemon = await Pokemon.deploy(
    "0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B",
    "0x01BE23585060835E02B77ef475b0Cc51aA1e0709",
    "0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311",
    "100000000000000000"
  );

  await pokemon.deployed();

  console.log("Pokemon deployed to:", pokemon.address);
}




main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
