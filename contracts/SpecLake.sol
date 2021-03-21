// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SpecLake is Ownable {

    address public quoteAddress;
    address public sister;
    string  public baseSymbol;
    string  public name;
    string  public quoteSymbol;

    constructor(address _quoteAddress) public {
        quoteAddress = _quoteAddress;
        baseSymbol = "ETH";
        quoteSymbol = "USD";
        name = "EtherLakes: ETH/USD Spec";
    }

    modifier onlySister() {
        require(msg.sender == sister, 'EtherLakes: FORBIDDEN');
        _;
    }

    function setSister(address _sister) external onlyOwner {
        require(_sister != address(0), 'Invalid Address');
        sister = _sister;
    }

}