//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./ERC20Safe.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./interfaces/Iprismbridge.sol";

contract ColumbusRelayer {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Address for address;
    //    bytes32 constant FRA = bytes32(0x00);
    //
    //    address public ledger_contract;

    address public  genericAddress;
    address bridge;
    modifier onlyGeneric() {
        require(genericAddress == _msgSender(), "onlyGeneric");
        _;
    }
    constructor(address _genericAddress, address _bridge) {
        genericAddress = _genericAddress;
        bridge = _bridge;
    }

    function depositFRA(bytes calldata data) external onlyGeneric {
        (bytes32 to, uint256 amount) = abi.decode(data, (bytes32, uint256));
        Address.functionCallWithValue(bridge, abi.encodeWithSignature("depositFRA(bytes32)", to), amount);
    }

    function depositFRC20(bytes calldata data) external onlyGeneric {
        (address token,bytes32 to, uint256 amount) = abi.decode(data, (address, bytes32, uint256));
        IPrismBridge(bridge).depositFRC20(token, to, amount);
    }


}
