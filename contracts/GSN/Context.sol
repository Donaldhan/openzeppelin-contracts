pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 * 
 * Context提供当前执行上下文的交易发送者和相关数据。由于在处理实际应用中的GSN(Gas Station Network)交易时，
 * 发送和执行的交易的不一定为实际的发送者，我们不应该通过msg.sender and msg.data直接访问相关数据。
 * 我们可以通过Context去安全访问。
 * 
 * 此Context合约作为一个中介或代理合约库。
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // 空内部构造，避免错误的部署
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
