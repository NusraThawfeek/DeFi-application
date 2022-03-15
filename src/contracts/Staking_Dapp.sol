// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Dummy_Token.sol";
import "./Tether_Token.sol";

contract Staking_Dapp {
    string public name = "Staking dapp";
    address public owner;

    //create instances for both tokens
    Dummy public dummy_token;
    Tether public tether_token;

    //array for contain the list of stakers.
    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasstaked;
    mapping(address => bool) public isstaking;

    constructor(Dummy _dummyToken, Tether _tetherToken) public {
        dummy_token = _dummyToken;
        tether_token = _tetherToken;
        owner = msg.sender;
    }

    //Deposit
    function stakeTokens(uint256 _amount) public {
        //check wther the user staking zero tokens or not.
        require(_amount > 0, "amount cannot be zero");

        //transfer marked tether tokens that we created into this staking dapp.
        //investers addres, addres of this contract, amount
        tether_token.transferfrom(msg.sender, address(this), _amount);
        //update the staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        //added user to the stakers array
        if (!hasstaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        //update the staking status
        isstaking[msg.sender] = true;
        hasstaked[msg.sender] = true;
    }

    //withdraw
    function unstakeToken() public {
        //fetch the balance of staker
        uint256 balance = stakingBalance[msg.sender];

        require(balance > 0, "staking balance is zero");

        //transfer tether token back to the user
        tether_token.transfer(msg.sender, balance);
        stakingBalance[msg.sender] = 0;

        //update the staking status
        isstaking[msg.sender] = false;
    }

    // issue dummy tokens as rewards
    function issuedummy() public {
        require(msg.sender == owner, "caller must be the owner");

        for(uint i=0;i<stakers.length;i++){
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance>0){
                dummy_token.transfer(recipient, balance);
            }


        }
    }

}
