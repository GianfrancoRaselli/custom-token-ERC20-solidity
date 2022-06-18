// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface IERC20 {

  event Transfer(address indexed from, address indexed to, uint value);

  event Approval(address indexed owner, address indexed spender, uint value);


  function totalSupply() external view returns (uint);

  function balanceOf(address _account) external view returns (uint);

  function transfer(address _to, uint _amount) external returns (bool);

  function allowance(address _owner, address _spender) external view returns (uint);

  function approve(address _spender, uint _amount) external returns (bool);

  function transferFrom(address _from, address _to, uint _amount) external returns (bool);

}

contract TokenERC20 is IERC20 {

  string private name_;
  string private symbol_;
  uint8 private decimals_;

  uint private totalSupply_;
  mapping(address => uint) private balances;
  mapping(address => mapping(address => uint)) private allowances;


  constructor(string memory _name, string memory _symbol, uint8 _decimals) {
    name_ = _name;
    symbol_ = _symbol;
    decimals_ = _decimals;
  }


  function name() public view virtual returns (string memory) {
    return name_;
  }

  function symbol() public view virtual returns (string memory) {
    return symbol_;
  }

  function decimals() public view virtual returns (uint8) {
    return decimals_;
  }

  function totalSupply() public view virtual override returns (uint) {
    return totalSupply_;
  }

  function balanceOf(address _account) public view virtual override returns (uint) {
    return balances[_account];
  }

  function transfer(address _to, uint _amount) public virtual override returns (bool) {
    transfer_(msg.sender, _to, _amount);
    return true;
  }

  function allowance(address _owner, address _spender) public view virtual override returns (uint) {
    return allowances[_owner][_spender];
  }

  function approve(address _spender, uint _amount) public virtual override returns (bool) {
    approve_(msg.sender, _spender, _amount);
    return true;
  }

  function transferFrom(address _from, address _to, uint _amount) public virtual override returns (bool) {
    spendAllowance(_from, msg.sender, _amount);
    transfer_(_from, _to, _amount);
    return true;
  }

  function increaseAllowance(address _spender, uint _addedValue) public virtual returns (bool) {
    approve_(msg.sender, _spender, allowances[msg.sender][_spender] + _addedValue);
    return true;
  }

  function decreaseAllowance(address _spender, uint _subtractValue) public virtual returns (bool) {
    uint currentAllowance = allowances[msg.sender][_spender];
    require(currentAllowance >= _subtractValue, "ERC20: decrease allowance below zero");
    unchecked {
      approve_(msg.sender, _spender, currentAllowance - _subtractValue);
    }
    return true;
  }

  function transfer_(address _from, address _to, uint _amount) internal virtual {
    require(_from != address(0), "ERC20: transfer from the zero address");
    require(_to != address(0), "ERC20: transfer to the zero address");
    beforeTokenTransfer(_from, _to, _amount);
    uint fromBalance = balances[_from];
    require(fromBalance >= _amount, "ERC20: transfer amount exceeds balance");
    unchecked {
      balances[_from] = fromBalance - _amount;
    }
    balances[_to] += _amount;
    emit Transfer(_from, _to, _amount);
    afterTokenTransfer(_from, _to, _amount);
  }

  function mint(address _account, uint _amount) internal virtual {
    require(_account != address(0), "ERC20: mint to the zero address");
    beforeTokenTransfer(address(0), _account, _amount);
    totalSupply_ += _amount;
    balances[_account] += _amount;
    emit Transfer(address(0), _account, _amount);
    afterTokenTransfer(address(0), _account, _amount);
  }

  function burn(address _account, uint _amount) internal virtual {
    require(_account != address(0), "ERC20: burn from the zero address");
    beforeTokenTransfer(_account, address(0), _amount);
    uint accountBalance = balances[_account];
    require(accountBalance >= _amount, "ERC20: burn amount exceeds balance");
    unchecked {
      balances[_account] = accountBalance - _amount;
    }
    totalSupply_ -= _amount;
    emit Transfer(_account, address(0), _amount);
    afterTokenTransfer(_account, address(0), _amount);
  }

  function approve_(address _owner, address _spender, uint _amount) internal virtual {
    require(_owner != address(0), "ERC20: approve from the zero address");
    require(_spender != address(0), "ERC20: approve to the zero address");
    allowances[_owner][_spender] = _amount;
    emit Approval(_owner, _spender, _amount);
  }

  function spendAllowance(address _owner, address _spender, uint _amount) internal virtual {
    uint currentAllowance = allowance(_owner, _spender);
    if (currentAllowance != type(uint).max) {
      require(currentAllowance >= _amount, "ERC20: insufficient allowance");
      unchecked {
        approve_(_owner, _spender, currentAllowance - _amount);
      }
    }
  }

  function beforeTokenTransfer(address _from, address _to, uint _amount) internal virtual {}

  function afterTokenTransfer(address _from, address _to, uint _amount) internal virtual {}

}
