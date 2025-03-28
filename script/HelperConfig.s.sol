//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "./test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{
  
  NetworkConfig public activeNetworkConfig;
  uint8 public constant DECIMALS = 8;
  uint256 public constant INITIAL_PRICE = 200e8;


  constructor(){
    if(block.chainid === 11155111){
      activeNetworkConfig = getSepoliaEthConfig();
    }else{
       activeNetworkConfig = getOrCreateAnvilEthConfig();
    } 
  }

  struct NetworkConfig{
    address priceFeed;
  }
  
  function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
    NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: });
    return sepoliaConfig;
  }

  function getOrCreateAnvilEthConfig() (NetworkConfig memory){

    if(activeNetworkConfig.priceFeed != address(0)){
      return activeNetworkConfig;
    }

    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
    vm.stopBroadcast();

    NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
    return anvilConfig;
  }
}