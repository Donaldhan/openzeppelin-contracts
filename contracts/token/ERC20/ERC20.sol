pragma solidity ^0.6.0;

import "../../GSN/Context.sol";
import "./IERC20.sol";
import "../../math/SafeMath.sol";

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
 * 
 * IERC20接口的实现。
 * token创建方式的实现时不可知的。这就意味着一个供应机制可以天骄到在一个使用使用{_mint}的派生合约中。
 * 挖矿版的ERC20可以查看ERC20Mintable。
 * 
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 * 
 * 如何实现ERC20的token供应机制，可以参考如上的连接。
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 * 
 * 我们遵循OpenZeppelin的指导建议：使用功能回滚，替代在失败时返回false。
 * 这种行为尽管不符合习惯，但与ERC20的应用的期望不冲突。
 * 
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 * 
 * 另外在调用transferFrom时，Approval事件将会产生。这种机制运行应用根据监听到的事件重新构建
 * 账户的allowance。因为这个不是强制性的规范，其他的EIP实现可能不会产生这些事件。
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 * 
 * 最后，{decreaseAllowance} 和 {increaseAllowance}功能，用于缓解著名的allowances设置问题。
 * 
 */
contract ERC20 is Context, IERC20 {
    //引入uint256的安全算法库SafeMath
    using SafeMath for uint256;
    //合约账户余额，key为账户地址，value为账户余额
    mapping (address => uint256) private _balances;
    /* 目标账户可以允许使用源账户的token数；
     key为源账户， value为一个Map<目标账户，目标账户允许使用的源账户的token数量>， 此模型类型与BTC的UXTO模型 
     */
    mapping (address => mapping (address => uint256)) private _allowances;
    //token供应量
    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}. ERC20 token的中供应量
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.  获取给定账户余额
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     * 从合约调用者的账户转移amount数量的token给接受者recipient。
     * 接收者的地址不能为0地址，同时调用者的账户余额必须足够，即大于amount。
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     * 获取目标账户允许使用的源账户的token数量
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
     * 设置目标账户允许使用的源账户的token数量， 目标账户地址不能为0地址
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        //设置源账户允许使用源账户的token数量，为原值减去交易值。
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
        //增加目标账户允许使用源账户的token数量
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
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
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
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
        //检查交易关联者地址
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        //触发转账hook  
        _beforeTokenTransfer(sender, recipient, amount);
        //减少转账账户的余额
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        //增加接收账户的余额
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     * 创建给定数量的token给指定账户，并增加供应量。
     * Emits a {Transfer} event with `from` set to the zero address.
     * 产生交易事件，时间的from地址为0地址。
     * Requirements
     *
     * - `to` cannot be the zero address. to地址不能为0地址。
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        //触发转账hook  
        _beforeTokenTransfer(address(0), account, amount);
        //先增加总的供应量
        _totalSupply = _totalSupply.add(amount);
        //增加账户余额
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     * 销毁给定数量的token，并减少供应量。
     * Emits a {Transfer} event with `to` set to the zero address.
     * 产生交易时间，事件to地址为0地址。
     * Requirements
     *
     * - `account` cannot be the zero address. 账户地址必须为非0地址。
     * - `account` must have at least `amount` tokens. 账户的余额必须足够。
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        //触发转账hook
        _beforeTokenTransfer(account, address(0), amount);
        //销毁指定账户的给定数量的token
        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        //减少总供应量
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
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
        //设置spender允许使用的owner账户的token数量为amount
        _allowances[owner][spender] = amount;
        //产生Approval事件
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     * 在功能为token转移调用时的HOOK。包括挖矿和销毁。
     * Calling conditions:
     * 调用条件
     * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of `from`'s tokens will be burned.
     * - `from` and `to` are never both zero.
     * 当from和to的地址都为非零时，将从from的地址转账amount个token到to账户。
     * 如果from地址为0， 则amout数量的token将会被to账户挖的。
     * 如果to地址为0，则amout数量的token将会被销毁。
     * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
