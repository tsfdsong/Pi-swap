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

        require(pai.transferFrom(msgSender,address(this),amount),"PAISwap: token transferFrom failed");

        require(pnft.transfer(msgSender,amount),"PAISwap: token transfer failed");
    }

    function withdraw(uint256 amount,address to) external onlyOwner {
        uint256 totalAmount = pai.balanceOf(address(this));

        require(totalAmount >= amount, "PAISwap: balance not enough");
        require(pai.transfer(to,amount),"PAISwap: token transfer failed");
    }

    function swapPI(uint256 amount) public payable {
        require(msg.value >= amount, "PAISwap: PI balance not enough");
        (bool sent, ) = address(this).call{value: amount}("");
        require(sent, "PAISwap: send PI failed");

        require(pnft.transfer(msg.sender,amount),"PAISwap: PNFT transfer failed");
    }

    function withdrawPI(uint256 amount,address payable to) external onlyOwner {
        require(amount <= address(this).balance, "PAISwap: balance not enough");
        to.transfer(amount);
    }

    receive() external payable {}
}