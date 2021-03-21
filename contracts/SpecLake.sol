// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./libs/SafeMath.sol";
import "./libs/Math.sol";
import "./StableLake.sol";

contract SpecLake is Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) public balanceOf;
    address public quoteAddress;
    address public sister;
    string  public baseSymbol;
    string  public name;
    string  public quoteSymbol;
    uint256 private _totalSupply;
    uint256 private _quotePrice; 
    address[] private _balanceKeys;
    uint private _balanceKeysLength;    

    event Deposit(address indexed from, uint256 amount);

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

    function refreshSister() internal {
        StableLake(sister).refresh();
        _quotePrice = StableLake(sister).lastPrice();
    }

    function setSister(address _sister) external onlyOwner {
        require(_sister != address(0), 'Invalid Address');
        sister = _sister;
    }

    function deposit() public payable returns (bool) {
        uint256 baseAmount = msg.value;
        refreshSister();
        uint256 _collateral = address(this).balance;
        uint256 supplyAmount;
        if (_collateral == 0 || _totalSupply == 0) {
            for (uint256 i = 0; i < _balanceKeysLength; i++) {
                address key = _balanceKeys[i];
                balanceOf[key] = 0;
            }
            _totalSupply = 0;
            supplyAmount = Math.baseToQuote(_quotePrice, baseAmount);
        } else {
            supplyAmount = Math.baseToSupply(_totalSupply, _collateral, baseAmount);
        }      
        balanceOf[msg.sender] = balanceOf[msg.sender].add(supplyAmount);
        _addToBalanceKeys(msg.sender);        
        _totalSupply = _totalSupply.add(supplyAmount);
        emit Deposit(msg.sender, baseAmount);
        return true;
    }

    function _addToBalanceKeys(address _key) internal {
        for (uint i = 0; i < _balanceKeysLength; i++) {
            if (_balanceKeys[i] == _key) return;
        }
        _balanceKeys.push(_key);
        _balanceKeysLength++;
    }    

}