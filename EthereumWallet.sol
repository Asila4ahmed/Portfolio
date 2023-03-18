// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EthereumWallet{
    address payable public owner; //meaning that this owner can receive money

    constructor(){
        owner = payable (msg.sender); 

    }
     receive() external payable{}

     //create a getBalance function
     function getBalance() public view returns(uint){
         return address(this).balance;
     }
     //create a withdraw function for only the owner of the contract
     function withdraw( uint _amount) public{
         require(msg.sender == owner, "Thief! you are not the owner");

         //to transfer the funds to only the owner
         payable(msg.sender).transfer(_amount);
     }
       //create a withdraw function for anybody
     function AnybodyCanWithdraw(uint _amount, address payable _to) public{
         _to.transfer(_amount);

     }
     
}
