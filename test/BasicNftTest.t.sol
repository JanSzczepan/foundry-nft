// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {MintBasicNft} from "../src/Interactions.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
   string public constant NFT_NAME = "Dogie";
   string public constant NFT_SYMBOL = "DOG";
   string public constant PUG_URI =
      "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
   address public constant USER = address(1);
   DeployBasicNft public deployer;
   BasicNft public basicNft;

   modifier mintNft() {
      vm.prank(USER);
      basicNft.mintNft(PUG_URI);

      _;
   }

   function setUp() external {
      deployer = new DeployBasicNft();
      basicNft = deployer.run();
   }

   function testInitializedCorrectly() public view {
      assert(
         keccak256(abi.encodePacked(basicNft.name())) == keccak256(abi.encodePacked((NFT_NAME)))
      );
      assert(
         keccak256(abi.encodePacked(basicNft.symbol())) == keccak256(abi.encodePacked((NFT_SYMBOL)))
      );
   }

   function testCanMintAndHaveABalance() public mintNft {
      assert(basicNft.balanceOf(USER) == 1);
   }

   function testTokenURIIsCorrect() public mintNft {
      assert(
         keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG_URI))
      );
   }

   function testMintWithScript() public {
      uint256 startingTokenCounter = basicNft.getTokenCounter();
      MintBasicNft mintBasicNft = new MintBasicNft();
      mintBasicNft.mintBasicNft(address(basicNft));
      assert(basicNft.getTokenCounter() == startingTokenCounter + 1);
   }
}
