// MANAGER CONTRACTS
manager_contracts = [
    'Token',
]

// DEPLOY
module.exports = deployer => {
    manager_contracts.forEach(contract => {
        deployer.deploy(
            artifacts.require('./contracts/' + contract + 'Manager.sol')
        )
    })
}