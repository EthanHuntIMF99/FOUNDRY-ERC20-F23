// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {ManualToken} from "../src/ManualToken.sol";

contract DeployManualToken is Script{
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether;

    function run() external returns(ManualToken){
        vm.startBroadcast();
        ManualToken mt = new ManualToken(INITIAL_SUPPLY,"ManualToken","MT");
        vm.stopBroadcast();
        return mt;
    }
}