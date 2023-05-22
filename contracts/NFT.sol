// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract NFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string[] public wordValues = [""]; // Add words here

    struct Word {
        string name;
        string description;
        string bgHue;
        string textHue;
        string value;
    }

    mapping(uint256 => Word) public words;

    uint256 public cost = 0.0005 ether;
    uint256 public maxSupply = 10000;
    bool public paused = false;

    constructor() ERC721("__TOKEN_NAME__", "__TOKEN_SYMBOL__") {}

    function mint() public payable {
        uint256 supply = totalSupply();
        require(!paused);
        require(supply + 1 <= maxSupply);

        Word memory newWord = Word(
            string(abi.encodePacked("OCN #", (supply + 1).toString())), // Name
            string(abi.encodePacked("On Chain NFT #", (supply + 1).toString())), // Description
            randomNum(361, block.difficulty, supply).toString(), // Background Hue
            randomNum(361, block.timestamp, 2).toString(), // Text Hue
            wordValues[randomNum(wordValues.length, block.difficulty, supply)] // Value
        );

        if (msg.sender != owner()) {
            require(msg.value >= cost);
        }

        words[supply + 1] = newWord;

        _safeMint(msg.sender, supply + 1);
    }

    function walletOfOwner(
        address _owner
    ) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function randomNum(
        uint256 _mod,
        uint256 _seed,
        uint256 _salt
    ) internal view returns (uint256) {
        uint256 num = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, msg.sender, _seed, _salt)
            )
        ) % _mod;
        return num;
    }

    function buildImage(uint256 _tokenId) public view returns (string memory) {
        Word memory currentWord = words[_tokenId];

        return
            Base64.encode(
                abi.encodePacked(
                    '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">',
                    '<path fill="hsl(',
                    currentWord.bgHue,
                    ', 50%, 25%)" d="M0 0h500v500H0z" />',
                    '<text fill="hsl(',
                    currentWord.textHue,
                    ', 100%, 80%)" text-anchor="middle" font-size="41" y="50%" x="50%" dominant-baseline="middle" font-family="Arial, Helvetica, sans-serif">',
                    currentWord.value,
                    "</text>",
                    "</svg>"
                )
            );
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        Word memory currentWord = words[tokenId];

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                currentWord.name,
                                '", "description":"',
                                currentWord.description,
                                '", "image": "',
                                "data:image/svg+xml;base64,",
                                buildImage(tokenId),
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }
}
