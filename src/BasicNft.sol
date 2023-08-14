// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
   uint256 private s_tokenCounter;
   mapping(uint256 tokenId => string tokenUri) private s_tokenIdToUri;

   error BasicNft__TokenUriNotFound();

   modifier tokenIdExist(uint256 tokenId) {
      if (!_exists(tokenId)) {
         revert BasicNft__TokenUriNotFound();
      }

      _;
   }

   constructor() ERC721("Dogie", "DOG") {
      s_tokenCounter = 0;
   }

   function mintNft(string memory tokenUri) public {
      uint256 tokenCounter = s_tokenCounter;
      s_tokenIdToUri[tokenCounter] = tokenUri;
      _safeMint(msg.sender, tokenCounter);
      s_tokenCounter++;
   }

   function tokenURI(
      uint256 tokenId
   ) public view override tokenIdExist(tokenId) returns (string memory) {
      return s_tokenIdToUri[tokenId];
   }

   function getTokenCounter() public view returns (uint256) {
      return s_tokenCounter;
   }
}
