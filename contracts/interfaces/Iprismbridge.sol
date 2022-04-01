pragma solidity ^0.8.0;

interface IPrismBridge {
    function depositFRA(bytes32 _to) public payable ;
    function depositFRC20(address _frc20, bytes32 _to, uint256 _value) public;
}