const {ethers} = require("hardhat")

async function main() {
    const MessengerFactory = await ethers.getContractFactory("Messenger")
    console.log("Deploying Contract....")
    const messenger = await MessengerFactory.deploy()
    await messenger.deployed()
    console.log(`Deployed to: ${messenger.address}`)
}



main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error)
    process.exit(1)
})