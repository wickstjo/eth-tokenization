pragma solidity ^0.8.3;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT

// TOKEN WALLET
import { Wallet } from './wallet.sol';

contract TokenManager {

    // TOKEN CONTRACTS
    mapping (address => Wallet) public wallets;

    // TOKEN PRICE
    uint public price;

    // TOKEN AVAILABILITY
    uint public capacity;
    uint public sold = 0;

    // INIT STATUS & TASK MANAGER REF
    bool public initialized = false;
    address public task_manager;

    // FETCH TOKEN WALLET
    function fetch(address user) public view returns(Wallet) {
        return wallets[user];
    }

    // CREATE NEW TOKEN WALLET
    function create() public {

        // IF CONTRACT HAS BEEN INITIALIZED
        // IF THE SENDER DOES NOT HAVE A TOKEN WALLET
        require(initialized, 'contracts have not been initialized');
        require(!exists(msg.sender), 'you already have a token wallet');

        // CREATE NEW TOKEN CONTRACT
        Wallet wallet = new Wallet(msg.sender);

        // INDEX & LIST THE SERVICE
        wallets[msg.sender] = wallet;
    }

    // PURCHASE TOKENS
    function purchase(uint amount) public payable {

        // IF THE CONTRACT HAS BEEN INITIALIZED
        // IF THE SENDER HAS A TOKEN CONTRACT
        // IF THE SENDER HAS SUFFICIENT FUNDS
        // IF THE CAPACITY HAS NOT BEEN MET
        require(initialized, 'contract has not been initialized');
        require(exists(msg.sender), 'you do not have a token contract');
        require(msg.value == amount * price, 'insufficient funds provided');
        require(amount + sold <= capacity, 'the token capacity has been met');

        // FIX FOR OVERFLOW ERROR
        uint balance = wallets[msg.sender].balance();
        require(balance + amount >= balance, 'token overflow');

        // INCREASE SENDERS TOKEN BALANCE
        wallets[msg.sender].increase_balance(amount);

        // INCREASE SOLD COUNT
        sold += amount;
    }

    // TODO
    function spend_balance() public {
    }

    // TODO
    function spend_allowance() public {
    }

    // CONSUME TOKENS
    function consume(uint amount, address user) public {

        // IF THE CONTRACT HAS BEEN INITIALIZED
        // IF THE CALLER IS THE TASK MANAGER
        require(initialized, 'contract has not been initialized');
        require(msg.sender == task_manager, 'permission denied');

        // FIX FOR UNDERFLOW ERROR
        uint balance = wallets[user].balance();
        require(balance - amount <= balance, 'token underflow');

        // REDUCE SENDERS TOKEN BALANCE
        wallets[user].reduce_balance(amount);

        // MAKE TOKENS AVAILABLE FOR PURCHASE
        sold -= amount;
    }

    // TRANSFER TOKENS BETWEEN USERS
    function transfer(uint amount, address from, address to) public {

        // IF THE CONTRACT HAS BEEN INITIALIZED
        // IF THE SENDER HAS ENOUGH TOKENS TO TRANSFER
        require(initialized, 'contract has not been initialized');
        require(msg.sender == task_manager, 'permission denied');

        // TOKEN BALANCES
        uint balance_from = wallets[from].balance();
        uint balance_to = wallets[to].balance();

        // FIX FOR OVERFLOW/UNDERFLOW ISSUES
        require(balance_from - amount <= balance_from, 'token underflow');
        require(balance_to + amount >= balance_to, 'token overflow');

        // REDUCE & INCREASE RESPECTIVE BALANCES
        wallets[from].reduce_balance(amount);
        wallets[to].increase_balance(amount);
    }

    // CHECK IF TOKEN CONTRACT EXISTS
    function exists(address user) public view returns(bool) {
        if (address(wallets[user]) != 0x0000000000000000000000000000000000000000) {
            return true;
        } else {
            return false;
        }
    }

    // INITIALIZE THE CONTRACT
    function initialize(uint _price, uint _capacity, address _task_manager) public {

        // IF THE CONTRACT HAS NOT BEEN INITIALIZED BEFORE
        require(!initialized, 'contract has already been initialized');

        // SET TOKEN DETAILS
        price = _price;
        capacity = _capacity;

        // SET TASK MANAGER REF
        task_manager = _task_manager;

        // BLOCK FURTHER MODIFICATIONS
        initialized = true;
    }
}