// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract StableLake is Ownable {

    address public quoteAddress;
    address public sister;
    string  public baseSymbol;
    string  public name;
    uint256 public lastPrice;
    string  public quoteSymbol;
    AggregatorV3Interface internal priceFeed;

    constructor(address _quoteAddress) public {
        quoteAddress = _quoteAddress;
        priceFeed = AggregatorV3Interface(_quoteAddress);
        baseSymbol = "ETH";
        quoteSymbol = "USD";
        name = "EtherLakes: ETH/USD Stable";       
    }

    modifier onlySister() {
        require(msg.sender == sister, 'EtherLakes: FORBIDDEN');
        _;
    }

    function setSister(address _sister) external onlyOwner {
        require(_sister != address(0), 'Invalid Address');
        sister = _sister;
    }    

    function refresh() public {
        updatePrice();
        updateCollateral();
    }

    function updatePrice() internal {
        // TODO
    }

    function updateCollateral() internal {
        // TODO
    }

    function getLatestPrice() public view returns (int) {
        (
            /* uint80 roundID */,
            int price,
            /* uint startedAt */,
            /* uint timeStamp */,
            /* uint80 answeredInRound */
        ) = priceFeed.latestRoundData();
        return price;
    }    

}