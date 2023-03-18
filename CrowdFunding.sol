pragma solidity ^0.8.0;
 
 //CAMPAIGN
 //Crowd Funding
 interface IERC20{
    function transfer(address, uint) external returns(bool);
    function transferFrom(address, address, uint) external returns(bool);

}

contract CrowdFund{
    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );

    event Cancel(
        uint id);

    event Pledge(
        uint indexed id, 
        address indexed caller, 
        uint amount);

    event Unpledge(
        uint indexed id, 
        address indexed caller,
        uint amount);   

    event Claim(
        uint id);

    event Refund(
        uint id, 
        address indexed caller, 
        uint amount);


        struct Campaign{
            //creator of campaign
            address creator;
            //amount of token to raise
            uint goal;
            //total amount pledged
            uint pledged;
            //timestamp to start campaign
            uint startAt;
            //timestamp to end campaign
            uint endAt;
            //true if goal was reached and creator has claimed the token
            bool claimed;
        }
        IERC20 public immutable token;
        //total count of campaign created
        uint public count;
        //is is also used to generate id for new campaigns(any name) through mapping
        mapping (uint => Campaign) public campaigns;
        //mapping for campaign id => pledger => amount pledged
        mapping(uint => mapping(address =>uint)) public pledgedAmount;

        constructor(address _token){
            token = IERC20(_token);
        }

        function launch(uint _goal, uint32 _startAt, uint32 _endAt) external{
            //block.timestamp is the particular time a block was mined
            require (_startAt >= block.timestamp, "startAt < now");
            require (_endAt >= _startAt, "endAt < startAt");
            require (_endAt <= block.timestamp + 90 days, "endAt > maximum duration"); 
            //the number of days depend on the duration of the campaing you wish to create

            count ++;
            campaigns[count] = Campaign(msg.sender, _goal, 0, _startAt, _endAt, false);
            //the above is from the struct according to the order the struct was created, equated to the campains in the mapping
            //by default, when starting a campaign, pledge is 0
            //claimed is faulse because the campaign is not claimed till the goal is achieved
            //eg campaings[1] = campaing(masg.sender, 1000, 0, 2pm, 5pm, false);

            emit Launch(count, msg.sender, _goal, _startAt, _endAt);
            //emit is used to broadcast an event, thus carries the name of the event
            //in other words  you emit an event

        }
        function cancel(uint _id) external{
          Campaign memory campaign = campaigns[_id];  
          //the "campaign" in this case is a variable
          //this is to create access to the struct
          require (campaign.creator == msg.sender, "Not the creator");
          require (block.timestamp < campaign.startAt, "Campaign has started");

          delete campaigns[_id];
          emit Cancel(_id);
        }
        function pledge(uint _id, uint _amount) external{
          Campaign storage campaign = campaigns[_id];
          //storage is necessary when updating a struct
          //ps; the code gives access to the struct
          require (block.timestamp >= campaign.startAt, "Campaign has not started");
          //to pledge into a running campaign not one that is not running
          require(block.timestamp <= campaign.endAt, "Campaign has ended");
          campaign.pledged += _amount;
          pledgedAmount[_id][msg.sender] += _amount;
          //is a mapping of the campaign id and the pledger account i.e msg.sender
          //pledgeAmount takes the total amount pledged by a particular address(pledger)
          token.transferFrom(msg.sender, address(this), _amount);
          //address (this) is the address of the campaign
          //allows the pleger to send token to the campaign contract address
          //without this line of code, it will show that the person has pledged but the funds won't be taken from the pledger's account
          emit Pledge(_id, msg.sender, _amount);
          //_id is the id of the campaign
          //msg.sender is the account (caller) making the pledge
          //_amount is the amount being pledged
        }
        function unpledge(uint _id, uint _amount) external{
          Campaign storage campaign = campaigns[_id];
          require(block.timestamp <= campaign.endAt, "Campaign has ended");
          //as unpledge occurs while the campaign is still ongoing
        
          campaign.pledged -= _amount;
          pledgedAmount[_id][msg.sender] -= _amount;

          token.transfer(msg.sender, _amount);
          emit Unpledge(_id, msg.sender, _amount);
        }
        function claim( uint _id) external{
          Campaign storage campaign = campaigns[_id];
          require(campaign.creator == msg.sender, "Not the creator!");
          require(block.timestamp > campaign.endAt, "Campaign has not ended");
          //as you can only claim frm the campaign if it has ended
          require(campaign.pledged >= campaign.goal, "Pledged < goal. Goal not reached!");
          require(!campaign.claimed, "Campain already claimed!");

          campaign.claimed = true;
          //after the campaign has been claimed

          token.transfer(campaign.creator, campaign.pledged);
          //to allow the transfer of the token from the campaign account to the creator's account
          emit Claim(_id);
        }
        function refund(uint _id) external{
            Campaign memory campaign = campaigns[_id];
            //memory is used here since no record is to be kept after the refund and the struct will not be updated
            require(block.timestamp > campaign.endAt, "Campaign has not ended");
            //as refund can only be gotten after the campaign has ended
            //ps: refund occurs only when the goal has not been reached and the campaign has ended
            require(campaign.pledged < campaign.goal, "pledge >= goal");

            uint bal = pledgedAmount[_id][msg.sender];
            pledgedAmount[_id][msg.sender] = 0;
            token.transfer(msg.sender, bal);

            emit Refund(_id, msg.sender, bal);

        }
        //Create timestamp for startAt and endAt
        function second() public view returns(uint){
            return block.timestamp + 60 seconds; 
        }
        function minute() public view returns(uint){
            return block.timestamp + 5 minutes;
        }
        //can be in hours or days depending on the duration of the campaign





        

}
