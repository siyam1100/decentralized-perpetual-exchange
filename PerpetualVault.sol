// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract PerpetualVault {
    address public owner;
    IERC20 public marginToken;

    struct Position {
        uint256 size;
        uint256 margin;
        uint256 openPrice;
        bool isLong;
    }

    mapping(address => Position) public positions;
    uint256 public constant MAINTENANCE_MARGIN = 500; // 5% in basis points

    event PositionOpened(address indexed trader, uint256 size, uint256 margin, bool isLong);
    event PositionClosed(address indexed trader, uint256 payout);

    constructor(address _marginToken) {
        marginToken = IERC20(_marginToken);
        owner = msg.sender;
    }

    function openPosition(uint256 _margin, uint256 _leverage, bool _isLong) external {
        require(_leverage <= 10, "Max leverage 10x");
        marginToken.transferFrom(msg.sender, address(this), _margin);

        uint256 size = _margin * _leverage;
        // Mock price retrieval for entry
        uint256 entryPrice = 2500 * 1e18; 

        positions[msg.sender] = Position({
            size: size,
            margin: _margin,
            openPrice: entryPrice,
            isLong: _isLong
        });

        emit PositionOpened(msg.sender, size, _margin, _isLong);
    }

    function getMarginRatio(address trader, uint256 currentPrice) public view returns (uint256) {
        Position storage pos = positions[trader];
        require(pos.size > 0, "No active position");

        int256 pnl;
        if (pos.isLong) {
            pnl = int256(pos.size) * (int256(currentPrice) - int256(pos.openPrice)) / int256(pos.openPrice);
        } else {
            pnl = int256(pos.size) * (int256(pos.openPrice) - int256(currentPrice)) / int256(pos.openPrice);
        }

        uint256 remainingMargin = uint256(int256(pos.margin) + pnl);
        return (remainingMargin * 10000) / pos.size;
    }
}
