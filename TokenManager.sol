// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



// File: @openzeppelin/contracts/ownership/Ownable.sol

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}


// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b,"Invalid values");
        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0,"Invalid values");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a,"Invalid values");
        uint256 c = a - b;
        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a,"Invalid values");
        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0,"Invalid values");
        return a % b;
    }
}

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) public excludeFee;


    uint256 private _totalSupply;

    address system;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private taxFee;
    


    event ExcludeFee(address indexed excludeAddress, bool isExcluded);


    modifier onlySystem() {
        require(system == _msgSender(), "ERC20: caller is not the system");
        _;
    }
    
    constructor (string memory name_, string memory symbol_, uint8 decimals_, address _system) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        system = _system;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
    
    function setExcludeFee(address account, bool status) external onlySystem returns(bool) {
        // new_block();
        excludeFee[account] = status;
        emit ExcludeFee(account, status);
        return true;
    }
    
    function setTaxFee(uint256 _fee) external onlySystem returns(bool) {
        require (_fee < 10000);
        taxFee = _fee;
        return true;
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        
        uint256 _taxFee = taxFee;

        if(excludeFee[sender] || excludeFee[recipient]){
              _taxFee = 0;
        }
    
        uint256 _tAmount = amount.mul(_taxFee).div(10000);
        _balances[address(1)] = _balances[address(1)].add(_tAmount);
          
        if(_tAmount > 0)
            emit Transfer(sender, address(1), _tAmount);
            
        // if(isBurn)
         _burn(address(1), _tAmount);
        
        
      
        _balances[sender] =  _balances[sender].sub(amount);
        _balances[recipient] =  _balances[recipient].add(amount.sub(_tAmount));
          
        emit Transfer(sender, recipient, amount.sub(_tAmount));
        
    }


    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
    
    
}




contract ERC20Token is ERC20 {

    uint256 private _tokensSold;
    // bool _onSale;
    uint _tokenPrice;


//   modifier onSale {
//       require(_onSale, "ERC20: Sale of token is not allowed");
//       _;
//   }

    event AccountClaimed (
        address indexed newOwner,
        string tokenName,
        uint256 timestamp
        );
    
    constructor (string memory name_, string memory symbol_, uint8 decimals_, uint256 initialSupply_, address system_, address _escrow)  ERC20(name_,symbol_,decimals_,system_) {
        _tokensSold = 0;
        // _onSale = true;
        _tokenPrice = 0.5*10**2;
        if (initialSupply_ > 0) {
            ERC20._mint(_escrow, initialSupply_*10**decimals_);
        }
    }


    // function contractBalance() public view  returns (uint256) {
    //     return address(this).balance;
    // }

    function tokensSold() external view  returns (uint256) {
        return _tokensSold;
    }
    
    function tokenPrice() external view returns (uint) {
        return _tokenPrice;
    }

    // function resumeSale() external onlyOwner {
    //     _onSale = true;
    // }   
    
    // check condition _amount >= _numberOfTokens*tokenPrice in frontend.
    function buyTokens(address ownerEscrow,uint256 numberOfTokens, address buyer) external onlyOwner returns(bool) {

        // require(msg.value >= amount, "ERC20: msg.Value is not same as amount");
        
        _transfer(ownerEscrow,buyer, numberOfTokens);
        _tokensSold += numberOfTokens;
        return true;

    }
    
    
    
    // function endSale() external onlyOwner {

    //     _onSale = false;
    //     // transfer ether to owner
    //     payable(owner()).transfer(address(this).balance);
    // }
    
    function claimAccount(address newOwner) external onlyOwner returns(bool){
        _transfer(owner(),newOwner,balanceOf(owner()));
        transferOwnership(newOwner);
        
        emit AccountClaimed(newOwner,name(),block.timestamp);
        return true;
    }
    
    
}



// interface IToken {
    
//     function buyTokens(uint256 numberOfTokens) 
//     external
//     returns (bool);
    
//     function tokenPrice() external view returns (uint);

    
// }



interface IBEP20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}



interface IPoolSwapPair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

library TransferHelper {
    function safeApprove(address token, address to, uint256 value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint256 value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint256 value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}

contract Escrow is Ownable {
    
    address tokenManager;

    constructor(address _tokenManager) Ownable() {
        tokenManager = _tokenManager;
    }
    
    function transfer(address token, address to, uint256 amount) external onlyOwner {
        TransferHelper.safeApprove(token,address(this),amount);
        TransferHelper.safeTransferFrom(token, address(this), to, amount);
        
    }
    
    function payVotingFees(address token , address to, uint256 amount) external {
        require(msg.sender == tokenManager,"Escrow : Caller is not tokenManager");
        TransferHelper.safeApprove(token,address(this),amount);
        TransferHelper.safeTransferFrom(token, address(this), to, amount);
    }
    
    function transferToken(address token, address to , uint256 amount) external {
        require(msg.sender == tokenManager,"Escrow : Caller is not tokenManager");
        TransferHelper.safeApprove(token,address(this),amount);
        TransferHelper.safeTransferFrom(token, address(this), to, amount);
    }
}


contract TokenManager is Ownable{
    using SafeMath for uint256;
    // address token;
    // ERC20Token private token;
    mapping(string => ERC20Token) _tokenAddress;
    mapping(string => Escrow) _EscrowAddress;
    mapping(address => Escrow) _Escrows;
    IBEP20 coin;
    
    uint256 voteFees = uint256(49);
    uint256 transferPowerFees = uint256(49);
    
    
    address companyWallet;
    address NFTMarketPlace;
    
    IPoolSwapPair poolContract;
    IPancakeRouter02 bscV2Router;
    // mapping(string => address) _tokenOwner;
    mapping(string => bool) _accountClaimed;
    
    mapping(address => string)  _tokenId;
    
    modifier onlyMarketPlace() {
        require(NFTMarketPlace == _msgSender(), "TokenManager: caller is not the NFT Market Place");
        _;
    }
    

    constructor(address _coin, address _coinEthPool, address _bscV2router, address _companyWallet) {
        coin = IBEP20(_coin);
        poolContract = IPoolSwapPair(_coinEthPool);
        bscV2Router = IPancakeRouter02(_bscV2router);
        companyWallet = _companyWallet;
    }
    
    function coinPrice() public view returns (uint256){
        (uint112 reserve0, uint112 reserve1,) = poolContract.getReserves();
        if(poolContract.token0() == bscV2Router.WETH()){
            return ((reserve1 * (10**18)) /(reserve0));
        } else {
            return ((reserve0 * (10**18)) /(reserve1));
        }
    }
    
    function buyCoins(uint256 amount) external payable {
        // require(msg.value >= amount*coinPrice(), "msg.value is less than total cost");
        // coin.approve(address(this),amount);
        coin.transferFrom(owner(),_msgSender(),amount);
    }
    
    function setNFTMarketPlace(address marketPalce) external onlyOwner returns(bool) {
        NFTMarketPlace = marketPalce;
        return true;
    }
    
    function getNFTMarketPlace() external view returns(address) {
        return NFTMarketPlace;
    }
    
    function createToken(string memory tokenId, string memory symbol) external onlyOwner{
        
        Escrow escrow;
        escrow = new Escrow(address(this));
        ERC20Token token;
        token = new ERC20Token(tokenId,symbol,18,10**8,_msgSender(), address(escrow));
        _tokenAddress[tokenId] = token;
        _EscrowAddress[tokenId] = escrow;
        // _tokenOwner[userId] = owner();
        
    }
    
    function setVoteFees(uint256 _fees) external onlyOwner {
        voteFees = _fees;
    }
    
    function setTransferPowerFees(uint256 _transferPowerFees) external onlyOwner {
        transferPowerFees = _transferPowerFees;
    }
    
    function castVote(address creator,address owner, address voter, uint8 response) external onlyMarketPlace {  // response 1->upvote, 2->downvote
        string memory tokenId = _tokenId[creator];
        uint256 amount = (voteFees.mul(10**18)).div(getTokenPrice(tokenId));
        require(getTokenBalance(tokenId,voter)>=amount, "Insufficient balance to vote");
        if(response == 1) {
            _Escrows[voter].payVotingFees(address(_tokenAddress[tokenId]),address(_Escrows[owner]),amount);
            // _tokenAddress[tokenId].transferFrom(voter,owner,amount);  
        } else if(response ==2) {
            _Escrows[voter].payVotingFees(address(_tokenAddress[tokenId]),companyWallet,amount);
            // _tokenAddress[tokenId].transferFrom(voter,companyWallet,amount);
        }
    }
    
    function transferPower(address account) external onlyMarketPlace {
        uint256 amount = (transferPowerFees.mul(10**18)).div(coinPrice());
        coin.transferFrom(account,owner(),amount);
    }
    
    function sendToken(address tokenOwner,address from, address to, uint256 amount) external onlyMarketPlace{
        string memory tokenId = _tokenId[tokenOwner];
        // _tokenAddress[tokenId].transferFrom(from,to,amount);
        _Escrows[from].transferToken(address(_tokenAddress[tokenId]),to, amount);
        
        
    }
    
    
    
    function _exists(string memory tokenId) internal view returns (bool) {
        require(address(_tokenAddress[tokenId]) != address(0), "Token does not exists");
        return true;
    }
    
    function setTaxFee(string memory tokenId, uint256 _fee) external onlyOwner returns(bool) {
        require (_fee < 10000);
        _tokenAddress[tokenId].setTaxFee(_fee);
        return true;
    }
    
    
    function getTokenAddress(string memory tokenId) external view returns (ERC20Token) {
        return _tokenAddress[tokenId];
    }
    
    function getEscrowAddressByTokenID(string memory tokenId) external view returns (Escrow) {
        return _EscrowAddress[tokenId];
    }
    
    function getEscrowAddressByAccount(address account) external view returns (Escrow) {
        return _EscrowAddress[_tokenId[account]];
    }
    
    
    // check at frontend userId(of caller) == tokenId
    function claimAccount(string memory tokenId) external returns (bool) {
        require(_exists(tokenId), "TokenManager : tokenId does not exists");
        require(_accountClaimed[tokenId] == false, "TokenManager : Account is already claimed");
        _tokenAddress[tokenId].claimAccount(_msgSender());
        _accountClaimed[tokenId] = true;
        _tokenId[_msgSender()] = tokenId;
        
        _EscrowAddress[tokenId].transferOwnership(_msgSender());
        
        _Escrows[_msgSender()] = _EscrowAddress[tokenId];
        return true;
    }
    
    function getTokenOwner(string memory tokenId) external view returns (address) {
        require(_exists(tokenId), "TokenManager : tokenId does not exists");
        return _tokenAddress[tokenId].owner();
    }
    
    
    // returns token price in cents
    function getTokenPrice(string memory tokenId) public view returns (uint256) {
        require(_exists(tokenId), "TokenManager : tokenId does not exists");
        return _tokenAddress[tokenId].tokenPrice();
    }
    
    function buyTokens(string memory tokenId, uint256 numberOfTokens) external {
        require(_exists(tokenId), "TokenManager : tokenId does not exists");
        // purchase can olny start after account is claimed 
        // because every purchase before claiming, will not results in transfer of coin to owner.
        require(_accountClaimed[tokenId], "Account is not claimed yet");
        
        ERC20Token token = _tokenAddress[tokenId];
        uint256 tokenPrice = getTokenPrice(tokenId);
        uint256 amount = numberOfTokens * tokenPrice;
        // require(coin.balanceOf(_msgSender()) >= amount, "msg value is less than amount  ");
        // coin.approve(address(this),amount);
        coin.transferFrom(_msgSender(),token.owner(),amount);
        token.buyTokens(address(_Escrows[token.owner()]),numberOfTokens,address(_Escrows[_msgSender()]));
        // coin.transfer(token.owner(),amount);
        
    }
    
        
    function getTokenBalance(string memory tokenId, address account) public view returns (uint256){
        require(_exists(tokenId), "TokenManager : tokenId does not exists");
        return _tokenAddress[tokenId].balanceOf(address(_Escrows[account]));
    }    
}




