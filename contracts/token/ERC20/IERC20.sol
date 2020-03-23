pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 * EIP ERC20的标准接口定义
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.    
     * TOKEN体系供应总量
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     * 获取账户余额
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     * 从当前合约调用账号，转移给定数量的token给目标账号， 并产生交易事件
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     * 返回spender通过{transferFrom}，可以花，或者可以使用的ower的token的数量。此值默认为0；
     * 当调用{approve} or {transferFrom} 时，此值将会改变
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
     * 
     * 设置`spender`允许使用的调用者token的数量。
     * 当操作成功时，返回一个bool值。
     * 需要注意的是：由于不确定的交易， 调用此方法，有可能带来，一些人可能使用旧的或新的allowance（允许的token值）。
     * 一种可能的减缓或者弱化这种分享的解决方式是，首先减少spender的允许使用的token数量，然后
     * 设置需要的值。
     * 
     * 此操作会，产生一个{Approval}事件
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
     *
     * 使用允许机制，从发送者的地址转移给定数量的token，给接受者。
     * 然后从调用者的allowance中扣除给定的数量的token。
     * 如果操作成功，则返回一个bool值
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     * 
     * 当给定数量的token，从一个账户转移另一个token时，将会产生此交易，即调用此方法。
     * 
     * 注意,token的数量可以为0
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     * 当调用{approve}操作，设置`spender允许使用的`owner`的allowance值时，将会产生Approval事件， 
     * 即调用此方法。
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
