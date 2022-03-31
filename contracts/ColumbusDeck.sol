//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./ERC20Safe.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ColumDeck {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    address public  genericAddress;
    modifier onlyGeneric() {
        require(genericAddress == _msgSender(), "onlyGeneric");
        _;
    }
    constructor(address _genericAddress) {
        genericAddress = _genericAddress;
    }

    function lockToken(bytes calldata data) external onlyGeneric {
        (address token,address user, uint256 amount) = abi.decode(data, (address, address, uint256));
        IERC20 erc = ERC20Safe(token);
        erc.safeTransferFrom(user, address(this), _amount);
    }

    function releaseToken(bytes calldata data) external onlyGeneric {
        (address token,address to, uint256 amount) = abi.decode(data, (address, address, uint256));
        IERC20 erc = ERC20Safe(token);
        erc.safeTransfer(to, _amount);
    }


    function lockNftToken(bytes calldata data) external onlyGeneric {
        (address token,address owner, uint tokenID) = abi.decode(data, (address, address, uint));
        IERC721 erc = IERC721(token);
        erc.transferFrom(owner, address(this), tokenID);
    }

    function releaseNftToken(bytes calldata data) external onlyGeneric {
        (address token,address to, uint256 tokenID) = abi.decode(data, (address, address, uint));
        IERC721 erc = ERC20Safe(token);
        erc.transferFrom(address(this), to, _amount);
    }
}
