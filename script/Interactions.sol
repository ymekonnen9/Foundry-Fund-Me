//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script}  from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundMe is Script{

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
    }

}

contract WithdrawFunds is Script{

}