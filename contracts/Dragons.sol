// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Dragons is ERC721Enumerable, Ownable {
    using Strings for uint256;
    uint256 maxSupply = 10;
    uint256 cost = 0.001 ether;
    string baseURI = "ipfs://QmbXeFrybyPmmrhZfVesfizZHyoVb1ueCqHjYddrEFZqEJ/";

    constructor() ERC721("Dragons of ENU", "DOE") {}

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireMinted(tokenId);
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : " ";
    }

    function safeMint(address _to) public payable {
        uint256 _currentSupply = totalSupply();
        require(_currentSupply < maxSupply, "You reached max");
        require(msg.value == cost, "Please add amount value");
        _safeMint(_to, _currentSupply);
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}
