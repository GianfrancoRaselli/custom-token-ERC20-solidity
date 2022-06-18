// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./TokenERC20.sol";

contract CustomTokenERC20 is TokenERC20 {

  address public owner = msg.sender;

  modifier onlyOwner {
    require(msg.sender == owner, "You can not access to this function");
    _;
  }

  constructor(string memory _name, string memory _symbol, uint8 _decimals) TokenERC20(_name, _symbol, _decimals) {}

  function createTokens(address _account) public onlyOwner {
    mint(_account, 1000);
  }

  function burnTokens(uint _amount) public {
    burn(msg.sender, _amount);
  }

}
