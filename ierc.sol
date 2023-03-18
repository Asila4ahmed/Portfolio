// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 //interface for ERC20-2.sol
 interface IERC20{
     function totalSupply() external view returns(uint);
     function balanceOf(address acount) external view returns(uint);
     function transfer(address recipient, uint amount) external returns(bool);
     function allowance(address owner, address spender) external returns(uint);
     function approve(address spender, uint amount) external returns(bool);
     function transferFrom(address owner, address recipient, uint amount)external returns(bool);

     event Transfer(address indexed from, address indexed to, uint amount);
     event Approval(address indexed owner, address indexed sender, uint amount);


 }
