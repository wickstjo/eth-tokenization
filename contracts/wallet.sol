pragma solidity ^0.8.3;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

contract Wallet {

    // TOKEN BALANCE & CONTRACT OWNER
    uint public balance = 0;
    address owner;

    // TOKEN MANAGER REF
    address public token_manager;

    // WHEN CREATED, SET STATIC PARAMS
    constructor(address _owner) {
        owner = _owner;
        token_manager = msg.sender;
    }

    // INCREASE TOKEN BALANCE
    function increase(uint amount) public {

        // IF THE SENDER IS THE TOKEN MANAGER
        require(msg.sender == token_manager, 'you are not permitted to perform this action');

        // INCREASE BALANCE
        balance += amount;
    }

    // REDUCE TOKEN BALANCE
    function reduce(uint amount) public {

        // IF THE SENDER IS THE TOKEN MANAGER
        require(msg.sender == token_manager, 'you are not permitted to perform this action');

        // INCREASE BALANCE
        balance -= amount;
    }
}