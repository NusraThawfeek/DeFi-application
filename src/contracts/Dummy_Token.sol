// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Dummy {
    string public name = "dummy token";
    string public symbol = "dumToken";
    uint256 public totalsupply = 1000000000000000000000000;
    uint256 public decimal = 18;

    //token needs to be transfer from one address to another address
    event Transfer(
        address indexed _from, 
        address indexed _to, 
        uint256 _value
        );
        
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

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        //check sender has sufficient amount to transfer
        require(balance[msg.sender] >= _value);
        balance[msg.sender] -= _value;
        balance[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        //map sender address to  spenders address and assign the value to be spend
        emit Approve(msg.sender, _spender, _value);
        return true;
    }

    // function for spender, who is spending tokens on behalf of the owner
    function transferfrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        //check the sufficient balance of senders address
        require(_value <= balance[_from]);
        //check if the spender allow to spend the value or not
        require(_value <= allowance[_from][msg.sender]);
        balance[_from] -= _value;
        balance[_to] += _value;

        //deduct the value of the promisable amount that the spender is allowed to spend
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;

    }
}
