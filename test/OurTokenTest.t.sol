// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is StdCheats, Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;
    uint256 public constant TRANSFER_BALANCE = 10 ether;

    OurToken public ourToken;
    DeployOurToken public deployer;
    address public deployerAddress;
    address bob;
    address alice;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        bob = makeAddr("bob");
        alice = makeAddr("alice");
        

        deployerAddress = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddress);
        ourToken.transfer(bob, BOB_STARTING_AMOUNT);
    }

    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Alice approves Bob to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
       
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
    }
    function testTransfer() public {
        
        uint256 transferAmount = 50;
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
    }

    function testTransferFromWithInsufficientAllowance() public {
        uint256 initialAllowance = 50;
        ourToken.approve(alice, initialAllowance);
        uint256 transferAmount = 100;
        vm.expectRevert();
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
    }

    function testTransferFrom() public {

        vm.prank(bob);
        ourToken.approve(alice,TRANSFER_BALANCE);
        uint256 currentAllowance = ourToken.allowance(bob,alice);
        assertEq(currentAllowance,TRANSFER_BALANCE);

        vm.prank(alice);
        ourToken.transferFrom(bob,alice,TRANSFER_BALANCE);
        assertEq(ourToken.balanceOf(alice),TRANSFER_BALANCE);
        assertEq(ourToken.balanceOf(bob),BOB_STARTING_AMOUNT-TRANSFER_BALANCE);        
    }
    
    function testTransferWithInsufficientBalance() public {
        uint256 initialBalanceBob = ourToken.balanceOf(bob);
        uint256 transferAmount = BOB_STARTING_AMOUNT + 1;

        vm.expectRevert();
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);
    }
}