// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract MockQuoteAddress is AggregatorV3Interface {

    int256 public price;

    function decimals() external override view returns (uint8) {
        return 8;
    }

    function description() external override view returns (string memory) {
        return "MockQuoteAddress";
    }

    function version() external override view returns (uint256) {
        return 1;
    }

    function getRoundData(uint80 /*_roundId*/) external override view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (0, 0, 0, 0, 0);
    }

    function latestRoundData() external override view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (uint80(1), price, block.timestamp, block.timestamp, uint80(1));
    }

    function setPrice(int256 _price) public {
        price = _price;
    }
}