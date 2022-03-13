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

contract CanvasNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter public tokenIds;
    uint256 public price = 1000000000000000;

    // We'll be storing our NFT images on chain as SVGs
    string svgPartOne =
        '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200">';
    string svgPartTwo = "</svg>";

    address payable public owner;

    mapping(uint256 => mapping(uint256 => string)) private canvas;
    string public canvasImage;

    constructor() payable ERC721("Canvas NFT", "CANVAS") {
        owner = payable(msg.sender);
        for (uint256 i = 0; i < 5; i++) {
            for (uint256 j = 0; j < 5; j++) {
                canvas[i][j] = "FFFFFF";
            }
        }

        canvasImage = string(abi.encodePacked(svgPartOne, svgPartTwo));
        canvasImage = string(
            abi.encodePacked(
                'data:image/svg+xml;base64,',
                Base64.encode(bytes(canvasImage))
            )
        );
    }

    function placePixel(
        uint256 x,
        uint256 y,
        string calldata color,
        address nftAddr,
        uint256 tokenId
    ) public {
        // approve in UI ~ basically 2 transaction
        // set approval for all ~ true
        require(valid(x, y), "please select correct pixel coordinate");

        ERC721 nft = ERC721(nftAddr);
        require(nftAddr != address(this), "nice try haha!");
        nft.transferFrom(msg.sender, address(this), tokenId);
        require(nft.ownerOf(tokenId) == address(this), "NFT not transferred");

        canvas[x][y] = color;

        string memory pixels = "";
        for (uint256 i = 0; i < 5; i++) {
            for (uint256 j = 0; j < 5; j++) {
                string memory newpixel = string(
                    abi.encodePacked(
                        '<rect width="40" height="40"',
                        ' x="',
                        uint2str(i * 40),
                        '"',
                        ' y="',
                        uint2str(j * 40),
                        '"',
                        ' style="fill:#',
                        canvas[i][j],
                        '" />'
                    )
                );
                pixels = string(abi.encodePacked(pixels, newpixel));
            }
        }

        pixels = string(abi.encodePacked(svgPartOne, pixels, svgPartTwo));
        canvasImage = string(
            abi.encodePacked(
                'data:image/svg+xml;base64,',
                Base64.encode(bytes(pixels))
            )
        );
        console.log(canvasImage);
    }

    function getCanvasImage() public view returns (string memory) {
        return canvasImage;
    }

    function mintItem(string calldata uri) public payable {
        require(msg.value >= price, "not enough token paid");
        uint256 newRecordId = tokenIds.current();
        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, uri);
        tokenIds.increment();
    }

    function valid(uint256 x, uint256 y) public pure returns (bool) {
        return x < 5 && y < 5;
    }

    function getNFTCount() public view returns (uint256) {
        return tokenIds.current();
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

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
