// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ManualToken} from "../src/ManualToken.sol";
import {DeployManualToken} from "../script/DeployManualToken.s.sol";

contract TestManualmanualToken is Test {
    ManualToken public manualToken;
    DeployManualToken public deployer;

    //These are two testing addresses
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant TRANSFER_BALANCE = 10 ether;

    function setUp() external {
        deployer = new DeployManualToken();
        manualToken = deployer.run();

        //Lets send bob some manualTokens
        vm.prank(msg.sender);
        manualToken.transfer(bob,STARTING_BALANCE);
    }

    //////////////////////
    /// Basic Functions //
    /////////////////////

    function testNameOfmanualToken() public{
        assertEq(manualToken.name(),"ManualToken");
    }

    function testSymbolOfmanualToken() public{
        assertEq(manualToken.symbol(),"MT");
    }

    function testTransfer() public{
        vm.prank(bob);
        manualToken.transfer(alice, TRANSFER_BALANCE);
        assertEq(manualToken.balanceOf(bob),STARTING_BALANCE-TRANSFER_BALANCE);
        assertEq(manualToken.balanceOf(alice),TRANSFER_BALANCE);
    }

    function testTransferFrom() public {
        vm.prank(bob);
        manualToken.approve(alice,TRANSFER_BALANCE);
        uint256 currentAllowance = manualToken.allowance(bob,alice);
        assertEq(currentAllowance,TRANSFER_BALANCE);

        vm.prank(alice);
        manualToken.transferFrom(bob,alice,TRANSFER_BALANCE);
        assertEq(manualToken.balanceOf(alice),TRANSFER_BALANCE);
        assertEq(manualToken.balanceOf(bob),STARTING_BALANCE-TRANSFER_BALANCE);
    }

    function testApprove() public{
        vm.prank(bob);
        manualToken.approve(alice,TRANSFER_BALANCE);
        uint256 currentAllowance = manualToken.allowance(bob,alice);
        assertEq(currentAllowance,TRANSFER_BALANCE);
    }

    function testBurn() public {
        vm.prank(bob);
        manualToken.burn(TRANSFER_BALANCE);
        assertEq(manualToken.balanceOf(bob),STARTING_BALANCE-TRANSFER_BALANCE);
    }

    function testBurnFrom() public{
        vm.prank(bob);
        manualToken.approve(alice,TRANSFER_BALANCE);
        uint256 currentAllowance = manualToken.allowance(bob,alice);
        assertEq(currentAllowance,TRANSFER_BALANCE);

        vm.prank(alice);
        manualToken.burnFrom(bob,TRANSFER_BALANCE);
        assertEq(manualToken.balanceOf(bob),STARTING_BALANCE-TRANSFER_BALANCE);
    }
}