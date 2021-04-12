pragma solidity ^0.8.3;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

contract Wallet {

    // WALLET OWNER
    address owner;

    // TOKEN BALANCE & ALLOWANCE RESERVE
    uint public balance = 0;
    uint public reserved = 0;

    // TOKEN ALLOWANCES
    mapping (address => uint) public allowances;

    // TOKEN MANAGER REF
    address public token_manager;

    // WHEN CREATED, SET STATIC PARAMS
    constructor(address _owner) {
        owner = _owner;
        token_manager = msg.sender;
    }

    // INCREASE TOKEN BALANCE
    function increase_balance(uint amount) public {

        // IF THE SENDER IS THE TOKEN MANAGER
        require(msg.sender == token_manager, 'you are not permitted to perform this action');

        // INCREASE BALANCE
        balance += amount;
    }

    // REDUCE TOKEN BALANCE
    function reduce_balance(uint amount) public {

        // IF THE SENDER IS THE TOKEN MANAGER
        require(msg.sender == token_manager, 'you are not permitted to perform this action');

        // INCREASE BALANCE
        balance -= amount;
    }

    // ADD ALLOWANCE ACCOUNT
    function add_account(address account, uint token_amount) public {

        // IF THE SENDER IS THE WALLET OWNER
        // IF THERE ARE ENOUGH UNRESERVED TOKENS
        require(msg.sender == owner, 'you are not the wallet owner');
        require(balance - reserved >= token_amount, 'not enough unreserved tokens');

        // SET ALLOWANCE
        allowances[account] = token_amount;

        // INCREASE RESERVED TOKENS
        reserved += token_amount;
    }

    // INCREASE ACCOUNT ALLOWANCE
    function increase_allowance() public {
    }

    // REDUCE ACCOUNT ALLOWANCE
    function reduce_allowance() public {
    }

    // SPEND ACCOUNT ALLOWANCE
    function spend_allowance() public {
    }
}