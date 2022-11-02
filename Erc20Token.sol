// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "./SafeMath.sol";

// Name: Gerald Nwankwo.

contract GeraldToken{
    // Mapping that holds the token balance of each address.
    mapping(address => uint256) public balances;
    // Mapping of the accounts approved to withdraw from a particular account and the amount allowed for each.
    mapping(address => mapping(address => uint256)) public allowed;

    using SafeMath for uint256;


    // Setting the token name, symbol and number of ICO at contract deployment using the constructor.
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    
    // define our construct to accept input of variable type uint256
    constructor(string memory name, string memory symbol, uint256 totalTokens) {
        // set name of token
        _name = name;
        // set symbol of token
        _symbol = symbol;
        // set total supply of tokens
        _totalSupply = totalTokens;
        // make the contract owner the holder of the total supply of tokens
        balances[msg.sender]= _totalSupply;
    }

    // function to return the total supply of tokens by the contract regardless of the owner.
    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }

    // function to return the balance of a token owner identified by the owners address.
    function balanceOf(address tokenOwner) public view returns(uint){
        return balances[tokenOwner];
    }

    // Create an event in order to store arguments from the transfer function in order to log transactions happening in the blockchain.
    event Transfer(address indexed owner, address indexed reciever, uint numTokens);

    // function to transfer tokens from one token address holder to another.
    function transfer(address reciever, uint numTokens) public returns(bool){
        // confirm that the sender who initaited this function has more or the same number of tokens to be transfered
        require(balances[msg.sender] >= numTokens);
        // subtract the number of tokens to be transfered from the address of the sender
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        // add the number of tokens to be transfered to the address of the reciever
        balances[reciever] = balances[reciever].add(numTokens);
        // Show users the completed transaction.
        emit Transfer(msg.sender, reciever, numTokens);
        return true;
    }
    
    // Event to log approval transactions on the blockchain.
    event Aproval(address indexed owner, address indexed foreign, uint numTokens);

    // function for token onwer to allow another user withdraw from the token owner.
    function approveForeign(address foreign, uint numTokens) public returns (bool) {
        // Add the foreign address to the list of addresses that can withdraw from a particular addreess;
        allowed[msg.sender][foreign] = numTokens;
        // Show users thre completed transaction.
        emit Aproval(msg.sender, foreign, numTokens);
        return true;
    }

    // function to get the approved number of tokens approved for withdrawwal for a foreigner.
    function allowance(address owner, address foreign)public view returns(uint) {
        return allowed[owner][foreign];
    }

    // function to allow foreigners approved for withdrawal to send tokens from the owner to a third party address.
    function transferFrom(address owner, address buyer, uint numTokens)public returns (bool) {
        // require that the token balance of the owner is greater than or equal to the number of tokens to be transfered.
        require(balances[owner] >= numTokens);
        // confirm that the foreigner has approval for the same or more Tokens  than the number of tokens for that particular transaction.
        require(allowed[owner][msg.sender] >= numTokens);
        // subtract the number of tokens from the balance of the owner.
        balances[owner] = balances[owner].sub(numTokens);
        // reduce the  allowed withdrawable number of tokens from the owner for the foreign account.
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        // add the number of tokens to the balance of the owner.
        balances[buyer] = balances[buyer].add(numTokens);
        // show the users the complete transaction.
        emit Transfer(msg.sender, buyer, numTokens);
        return true;
    }    

}

