// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract PNFTToken is ERC20Burnable, Ownable {
    constructor(string memory name, string memory symbol)
        public
        ERC20(name, symbol)
    {
    }
    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }
}
