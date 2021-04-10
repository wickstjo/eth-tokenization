module.exports = {
    networks: {
        development: {
            host: '127.0.0.1',
            port: 8080,
            network_id: '*',
            gas: 5000000,
            websockets: true
        }
    },
    compilers: {
        solc: {
            version: '0.8.3',
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        }
    },
    mocha: {
        useColors: true
    }
}