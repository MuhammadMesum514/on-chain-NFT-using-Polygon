// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract DevSquad is ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIds;

    struct MyWarrior {
       string name;
       uint256 level;
       uint256  attack_won;
       uint256  health;       
    }

    mapping (uint256 => MyWarrior) public tokenToWarrior;

    string[7] nameArray = ["Mesum","Ammad", "Hassan","Arslan","Hammad","Syed Zillay","Gohar"];

    // mapping (uint256 => uint256) public tokenToAttack;

    constructor() ERC721("DevSquad", "DEVSQUAD") {}

    // method to genrate character from svg
    function createWarrior(uint256 tokenId) public returns (string memory ){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">'
                '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>'
                '<rect width="100%" height="100%" fill="black" />'
                '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">"Name: "',getName(tokenId),'</text>'
                '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">"Level: "',getLevel(tokenId),'</text>'
                '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">"Attack Won: "',getAttacks(tokenId),'</text>'
                '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">"Health: "',getHealth(tokenId),'</text>'
                '</svg>'
                
                );
            return string(
                    abi.encodePacked(
                        "data:image/svg+xml;base64,",
                        Base64.encode(svg)
                    )
                );        
    } 

    // method to Return Levels
    function getLevel(uint256 tokenId) public view returns (string memory){
        return tokenToWarrior[tokenId].level.toString();
    } 
    // method to Return Attacks
    function getAttacks(uint256 tokenId) public view returns (string memory){
        return tokenToWarrior[tokenId].attack_won.toString();
    }
    // method to Return Health
    function getHealth(uint256 tokenId) public view returns (string memory){
        return tokenToWarrior[tokenId].health.toString();
    }
    // method to Return Name
    function getName(uint256 tokenId) public view returns (string memory){
        return tokenToWarrior[tokenId].name;
    }

    // method to generate tokenURI
    function getTokenURI(uint256 tokenId) public returns (string memory){
        bytes memory dataURI = 
                    abi.encodePacked(
                        '{',
            '"name": "Warrior #', tokenId.toString(), '",',
            '"description": "Warrior is a game where you can create your own warrior and fight with other warriors.",',
            '"image": "', createWarrior(tokenId), '"',
        '}'
                    );

        return string(abi.encodePacked('data:application/json;base64,', Base64.encode(dataURI)));
    }

    // create the mint function 
    function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    uint256 randomName = random(nameArray.length);
    tokenToWarrior[newItemId] = MyWarrior(nameArray[randomName],random(100),random(100),random(100));
    // tokenToLevels[newItemId] = 1;
     delete nameArray[randomName];
    _setTokenURI(newItemId, getTokenURI(newItemId));
    } 

    // train the warrior
    function train (uint256 tokenId) public {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this warrior");
        
        uint256 currentLevel = tokenToWarrior[tokenId].level;
        uint256 currentAttack = tokenToWarrior[tokenId].attack_won;
        uint256 currentHealth = tokenToWarrior[tokenId].health;
        tokenToWarrior[tokenId].level = currentLevel + random(10);
        tokenToWarrior[tokenId].attack_won = currentAttack + random(100);
        tokenToWarrior[tokenId].health = currentHealth + random(50);

        // tokenToWarrior[tokenId] = MyWarrior(tokenToWarrior[tokenId].name,tokenToWarrior[tokenId].level+1,tokenToWarrior[tokenId].attack_won+5,tokenToWarrior[tokenId].health+3);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function random(uint number) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number;
    }
}
