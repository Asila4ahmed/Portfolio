pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721,Ownable{
constructor() ERC721("Noble NFT", "NNT"){

    }
function _baseURI() internal pure override returns(string memory){
return "https://ipfs.io/ipfs/QmeG7Pz9j5GyQTYyd5M9SnHhwgvZ2e8poGX45mct5A2ej7?filename=Noble-NFT.json"; //it's the link to meta data that will be pasted here
        //meta-data describes the NFT and its characteristics
    }
function safeMint(address to, uint256 tokenId) public onlyOwner{
_safeMint(to, tokenId);
        //difference between the mint function in ERC20 & ERC721 id that the function takes address and
        //amount in ERC20 while it takes address and tokenId in ERC721

    }
}
    
