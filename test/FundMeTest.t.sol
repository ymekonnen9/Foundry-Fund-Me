//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe";

contract FundeMeTest {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
      DeployFundMe defployFundMe = new DeployFundMe();
      fundMe = defployFundMe.run();
      vm.deal(USER, STARTING_BALANCE);        
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSener() public{
      console.log(fundMe.i_owner);
      console.log(funMe.msg.sender);
      assertEq(fundMe.i_owner, msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public{
      uint256 version = fundMe.getVersion();
      assertEq(version,4);
    }

    function testFundFailsWithoutEnoughEth() public{
      vm.expectRevert();
      fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public{
      fundMe.fund{value: 10e18}();

      uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
      assertEq(amountFunded);
    }

    modifier funded {
      vm.prank(USER);
      fundMe.fund{value: SEND_VALUE}();
      _;
    }

    function testAddsFunderToArrayOfFunders()public funded{

      address funder = fundMe.getFunder(0);
      assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw()public funded{

      vm.expectRevert();
      vm.prank(USER);
      fundMe.withdraw();      
    }

    function testWithdDrawWithSingleFunder() public funded{
      uint256 startingOwnerBalance = fundMe.getOwner.balance;
      uint256 startingFunderBalance = address(fundMe).balance;

      vm.prank(fundMe.getOwner());
      fundMe.withdraw();

      uint256 endingOwnerBalance = fundMe.getOwner().balance;
      uint256 endingFunderBalance = address(fundMe).balance;
    }

}

