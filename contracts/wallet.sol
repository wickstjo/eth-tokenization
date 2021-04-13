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

    // SPEND TOKEN BALANCE
    function spend_balance(uint token_amount) public {

        // IF THE SENDER IS THE TOKEN MANAGER
        // IF THE UNRESERVED BALANCE IS HIGH ENOUGH
        require(msg.sender == token_manager, 'permission denied');
        require(balance - reserved >= token_amount, 'unreserved balance not high enough');

        // REDUCE BALANCE
        balance -= token_amount;
    }

    // INCREASE ACCOUNT ALLOWANCE
    function increase_allowance(uint token_amount, address account) public {

        // IF THE SENDER IS THE WALLET OWNER
        // IF THERE ARE ENOUGH UNRESERVED TOKENS
        require(msg.sender == owner, 'you are not the wallet owner');
        require(balance - reserved >= token_amount, 'unreserved balance not high enough');

        // INCREASE ALLOWANCE
        allowances[account] += token_amount;

        // INCREASE RESERVED TOKENS
        reserved += token_amount;
    }

    // SPEND WALLET ACCOUNT ALLOWANCE
    function spend_allowance(uint token_amount, address account) public {

        // IF THE SENDER IS THE WALLET OWNER OR TOKEN MANAGER
        // IF ACCOUNT HAS ENOUGH ALLOWANCE
        require(msg.sender == owner || msg.sender == token_manager, 'permission denied');
        require(allowances[account] >= token_amount, 'account does not have a high enough allowance');

        // REDUCE ALLOWANCE
        allowances[account] -= token_amount;

        // REDUCE BALANCE & RESERVE
        balance -= token_amount;
        reserved -= token_amount;
    }
}