// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Warrior is ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIds;

    mapping (uint256 => uint256) public tokenToLevels;
    // mapping (uint256 => uint256) public tokenToAttack;

    constructor() ERC721("Warrior", "WARRIOR") {}

    // method to genrate character from svg
    function createWarrior(uint256 tokenId) public returns (string memory ){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">'
                '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>'
                '<rect width="100%" height="100%" fill="black" />'
                '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>'
                '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">"Levels: "',getLevels(tokenId),'</text>'
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
    function getLevels(uint256 tokenId) public view returns (string memory){
        return tokenToLevels[tokenId].toString();
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
    tokenToLevels[newItemId] = 1;
    _setTokenURI(newItemId, getTokenURI(newItemId));
    } 

    // train the warrior
    function train (uint256 tokenId) public {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this warrior");
        tokenToLevels[tokenId] = tokenToLevels[tokenId] + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    // function random(uint number) public view returns(uint){
    //     return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
    //     msg.sender))) % number;
    // }
}