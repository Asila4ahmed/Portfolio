//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tec4dev{
    event deposite(uint amount);
    event withdraw(uint amount);

    address public owner = msg.sender;

    //fallback function
    receive() external payable{
        emit deposite(msg.value);
    }
    function Withdraw() public {
        require(msg.sender == owner, "you are not the owner");
        emit withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}
