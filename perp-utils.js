/**
 * Utility functions for calculating PnL and Liquidation prices
 * for the Perpetual Exchange.
 */

const calculatePnL = (size, entryPrice, exitPrice, isLong) => {
    const priceDiff = isLong ? (exitPrice - entryPrice) : (entryPrice - exitPrice);
    return (size * priceDiff) / entryPrice;
};

const checkLiquidation = (marginRatio, maintenanceThreshold) => {
    // marginRatio and maintenanceThreshold in basis points (1/100th of a percent)
    return marginRatio < maintenanceThreshold;
};

module.exports = { calculatePnL, checkLiquidation };
