// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Tether {
    string public name = "dummy Tether";
    string public symbol = "Tether";
    uint256 public totalsupply = 1000000000000000000000000;
    uint256 public decimal = 18;

    //token needs to be transfer from one address to another address
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approve(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balance;
    //owners address mapping spenders address and then the spenders address to the integer value
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        balance[msg.sender] = totalsupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        //check sender has sufficient amount to transfer
        require(balance[msg.sender] >= _value);
        balance[msg.sender] -= _value;
        balance[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}
