// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

import "./libs/SafeMath.sol";
import "./libs/Math.sol";


contract StableLake is Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) public balanceOf;    
    address public quoteAddress;
    address public sister;
    string  public baseSymbol;
    string  public name;
    uint256 public lastPrice;
    string  public quoteSymbol;
    AggregatorV3Interface internal priceFeed;
    address[] private _balanceKeys;
    uint private _balanceKeysLength;    

    event Deposit(address indexed from, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

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

    function deposit() public payable returns (bool) {
        uint256 baseAmount = msg.value;        
        updatePrice();
        updateCollateral();
        uint256 quoteAmount = Math.baseToQuote(lastPrice, baseAmount);
        balanceOf[msg.sender] = balanceOf[msg.sender].add(quoteAmount);
        _addToBalanceKeys(msg.sender);
        emit Deposit(msg.sender, baseAmount);
        return true;
    }        

    function withdraw(uint256 amount) public returns (bool) {
        require(amount > 0, "Amount less than 0");
        updatePrice();
        updateCollateral();
        uint256 quoteAmount = Math.baseToQuote(lastPrice, amount);
        if (quoteAmount > balanceOf[msg.sender]) {
            quoteAmount = balanceOf[msg.sender];
        }
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(quoteAmount);
        uint256 baseAmount = Math.quoteToBase(lastPrice, quoteAmount);
        _safeTransfer(msg.sender, baseAmount);
        emit Withdraw(msg.sender, baseAmount);        
        return true;
    }

    function _addToBalanceKeys(address _key) internal {
        for (uint i = 0; i < _balanceKeysLength; i++) {
            if (_balanceKeys[i] == _key) return;
        }
        _balanceKeys.push(_key);
        _balanceKeysLength++;
    }    

    function _safeTransfer(address _to, uint _value) private {
        (bool _success, /*bytes memory _data*/) = _to.call{value: _value}("");
        require(_success, 'EtherLakes: TRANSFER_FAILED');
    }

}