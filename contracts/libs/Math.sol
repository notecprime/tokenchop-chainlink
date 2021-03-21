// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import './SafeMath.sol';

library Math {
    using SafeMath for uint256;

    function baseToQuote(uint256 price, uint256 amount) internal pure returns (uint256) {
        return Math.mulDiv(amount, price, 10**18);
    }

    function baseToSupply(uint256 totalSupply, uint256 totalCollateral, uint256 baseAmount) internal pure returns (uint256) {
        require(totalCollateral != 0, "totalCollateral must not be 0");
        return Math.mulDiv(baseAmount, totalSupply, totalCollateral);
    }    

    function mulDiv(uint256 value, uint256 numerator, uint256 denominator) internal pure returns (uint256) {
        require(value < 2**128, "Value too large");
        require(numerator < 2**128, "Numerator too large ");
        return value.mul(numerator).div(denominator);
    }

}