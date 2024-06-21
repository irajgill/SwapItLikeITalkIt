// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CustomToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}

contract CustomDex{
    string[] public tokens = ["Tether USD", "USD Coin", "BNB", "stETH", "TRON", "Matic Token" , "SHIBA INU", "Uniswap" ];
    mapping (string => ERC20) public tokenInstanceMap;
    uint256 ethValue = 100000000000000;

    struct History{
        string tokenA;
        string tokenB;
        address userAddress;
        // address recipient;
        uint256 inputValue;
        uint256 outputValue;
        uint256 historyId;
    }

    uint256 public _historyIndex;
    mapping(uint256 => History) private histories;

    constructor(){
        for(uint i = 0; i < tokens.length; i++){
            CustomToken token = new CustomToken(tokens[i], tokens[i]);
            tokenInstanceMap[tokens[i]] = token;
        }
    }


    function getBalance(string memory tokenName, address _address) public view returns (uint256) {
        return tokenInstanceMap[tokenName].balanceOf(_address);
    }

    function getTotalSupply(string memory tokenName) public view returns (uint256) {
        return tokenInstanceMap[tokenName].totalSupply();
    }

    function getName(string memory tokenName) public view returns (string memory) {
        return tokenInstanceMap[tokenName].name();
    }

    function getTokenAddress(string memory tokenName) public view returns (address) {
        return address(tokenInstanceMap[tokenName]);
    }

    function getEthBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function _transactionHistory(string memory tokenName , string memory etherToken, uint256 inputValue, uint256 outputValue) internal{
        _historyIndex++;
        uint256 _historyId = _historyIndex;
        History storage history = histories[_historyId];

        history.historyId = _historyId;
        history.userAddress = msg.sender;
        history.tokenA = tokenName;
        history.tokenB = etherToken;
        history.inputValue = inputValue;
        history.outputValue = outputValue;
        // history.recipient = recipient;
    }

    function swapEthToToken(string memory tokenName) public payable returns(uint256) {
        uint256 inputValue = msg.value;
        uint256 outputValue = inputValue / ethValue;
        outputValue = outputValue * 10 ** 18;
        require(tokenInstanceMap[tokenName].balanceOf(address(this)) >= outputValue, "Insufficient balance in the token instance");
        require(tokenInstanceMap[tokenName].transfer(msg.sender, outputValue));

        string memory etherToken = "Ether";

        _transactionHistory(tokenName, etherToken, inputValue, outputValue);
        return outputValue;
    }

    function swapTokenToEth(string memory tokenName , uint256 _amount) public returns(uint256) {
        uint256 exactAmount = _amount / 10 ** 18;
        uint256 ethToBeTransferred = exactAmount * ethValue;
        require(address(this).balance >= ethToBeTransferred, "Insufficient balance in the Dex contract");
        payable(msg.sender).transfer(ethToBeTransferred);
        require(tokenInstanceMap[tokenName].transferFrom(msg.sender, address(this), _amount));

        string memory etherToken = "Ether";

        _transactionHistory(tokenName, etherToken, exactAmount, ethToBeTransferred);
        return ethToBeTransferred;
    }

    function swapTokenToToken(string memory srcTokenName , string memory destTokenName , uint256 _amount) public {
        require(tokenInstanceMap[srcTokenName].transferFrom(msg.sender, address(this), _amount));
        require(tokenInstanceMap[destTokenName].transfer(msg.sender, _amount));
        _transactionHistory(srcTokenName, destTokenName, _amount, _amount);
    }

    function getAllHistory() public view returns(History[] memory){
        uint256 itemCount = _historyIndex;
        uint256 currentIndex = 0;

        History[] memory items = new History[](itemCount);
        for(uint256 i = 1; i <= itemCount; i++){
            History storage history =  histories[i];
            items[currentIndex] = history;
            currentIndex++;
        }

        return items;
    }
    

}