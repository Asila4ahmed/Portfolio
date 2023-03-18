pragma solidity ^0.8.0;

 import "./ierc.sol";

 contract ERC20 is IERC20{
     uint public override totalSupply; //override is used to avoid repeatition
     mapping(address => uint) public override balanceOf; //mapping is important in other to be able to use the function balanceOf.
     mapping(address => mapping(address => uint)) public override allowance;
      //this is called nested mapping
     //it is required to able to call the allowance function. it carries two mappings. 
     //1 carries the address of the owner, the other carries spender and the amount 
     string public name = "Noble Token";
     string public symbol = "NBT";
     uint public decimals = 18;


function transfer(address recipient, uint amount) external override returns(bool){
       balanceOf[msg.sender] -= amount; //method 1 to deduct amount from sender
      // balanceOf[msg.sender] = balanceOf[msg.sender] - amount; //method 2 for sender
      balanceOf[recipient] += amount; //balanceOf method for recipient
      
      emit Transfer(msg.sender, recipient, amount);
      return true;
      }

function approve(address spender, uint amount) public override returns(bool){
        allowance[msg.sender][spender] = amount; 
        //[msg.sender] is the address of the owner that is allowing the [spender] to spend an amount from its account
        emit Approval(msg.sender, spender, amount);
        return true;
      }

function transferFrom(address sender, address recipient, uint amount) public override returns(bool){
    //this allows the transfer of an amount from the owner's address to the receipient address but it is called by the address of the spener
    //which has been allowe to spend from the owner's adress
        allowance[sender][msg.sender] -= amount; //first eucting the amount the owner approve to spend
        //[sender] is the address of the owner while [msg.sender] is the address of the spender
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
      }

      //to create money
function mint(uint amount) public{
        balanceOf[msg.sender] += amount; //add amount to the callers balance
        totalSupply += amount; //increasing the total supply of the recipient wallet

        emit Transfer(address(0), msg.sender, amount); 
        //emit keyword implement the event initially declared in the interface
      } 

      //to decrease the total supply, make use of function burn
function burn(uint amount) public{
       balanceOf[msg.sender] -= amount;
       totalSupply -= amount;

       emit Transfer(msg.sender, address(0), amount);

}



 

 }
