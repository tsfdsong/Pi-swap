// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract PAISwap is Ownable {

    using SafeMath for uint256;

    IERC20 private pai;
    IERC20 private pnft;
    constructor(address _paiToken, address _pnftToken) public {
        pai = IERC20(_paiToken);
        pnft = IERC20(_pnftToken);
    }

    function swap( uint256 amount) external {
        address msgSender = msg.sender;
        require(pai.allowance(msgSender,address(this)) >= amount, "PAISwap: token allowance less than approve");

        require(pai.transferFrom(msgSender,address(this),amount),"PAISwap: token transfer failed");

        require(pnft.transferFrom(address(this),msgSender,amount),"PAISwap: token transfer failed");
    }

    function withdraw(uint256 amount) external onlyOwner {
        uint256 totalAmount = pai.balanceOf(address(this));

        require(totalAmount >= amount, "PAISwap: balance not enough");
        require(pai.transferFrom(address(this),owner(),amount),"PAISwap: token transfer failed");
    }
}