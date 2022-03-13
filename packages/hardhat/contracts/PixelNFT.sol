// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";
import {StringUtils} from "./libraries/StringUtils.sol";

// We import another help function
import {Base64} from "./libraries/Base64.sol";

//errors
error Unauthorized();
error AlreadyRegistered();
error InvalidColor(string color);

contract PixelNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter public tokenIds;
    uint public price = 1000000000000000;

    // We'll be storing our NFT images on chain as SVGs
    string svgPartOne =
        '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" style="fill:#';
    string svgPartTwo = '"/></svg>';

    address payable public owner;

    mapping(uint256 => string) public colormap;

    constructor()
        payable
        ERC721("Pixel NFT", "PIXEL")
    {
        owner = payable(msg.sender);
    }

    function mintItem(string calldata color) public payable {

        if (!valid(color)) revert InvalidColor(color);

        require(msg.value >= price, "not enough token paid");

        // Create the SVG (image) for the NFT
        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, color, svgPartTwo)
        );
        uint256 newRecordId = tokenIds.current();

        // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"color": "',
                        color,
                        '", "description": "Composable Pixel NFTs", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log(
            "\n--------------------------------------------------------"
        );
        console.log("Final tokenURI", finalTokenUri);
        console.log(
            "--------------------------------------------------------\n"
        );

        _safeMint(msg.sender, newRecordId);
        colormap[newRecordId] = color;
        _setTokenURI(newRecordId, finalTokenUri);
        tokenIds.increment();
    }

    function valid(string calldata color) public pure returns (bool) {
        return StringUtils.strlen(color) == 6 || StringUtils.strlen(color) == 3;
    }

    // Add this anywhere in your contract body
    function getAllNFTs() public view returns (string[] memory) {
        console.log("Getting all pixel NFT from contract");
        string[] memory allNames = new string[](tokenIds.current());
        for (uint256 i = 0; i < tokenIds.current(); i++) {
            allNames[i] = tokenURI(i);
        }

        return allNames;
    }

    function getNFTCount() public view returns (uint256){
        return tokenIds.current();
    }

    function getColor(uint256 id) public view returns (string memory){
        return colormap[id];
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw Matic");
    }
}
