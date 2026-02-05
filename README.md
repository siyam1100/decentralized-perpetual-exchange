# Decentralized Perpetual Exchange

This repository provides a professional, flat-structured implementation of a Perpetual Futures protocol. It allows users to trade assets with leverage without needing a traditional order book, utilizing a vAMM (virtual AMM) to determine price discovery.

## Features
- **Virtual AMM (vAMM)**: Decouples liquidity from price discovery using a constant product formula.
- **Leverage Engine**: Supports opening long and short positions with customizable leverage ratios.
- **Liquidation Logic**: Automated checks to close under-collateralized positions.
- **Funding Rates**: Built-in mechanism to keep the perpetual price aligned with the underlying index price.

## Technical Overview
The exchange uses the constant product formula to manage the virtual pool:
$$x \times y = k$$

When a trader opens a position, they add margin to the vault, and the vAMM calculates the synthetic asset entry price. The margin ratio ($MR$) must stay above the maintenance margin ($MM$) to avoid liquidation:
$$MR = \frac{\text{Collateral} \pm \text{PnL}}{\text{Position Size}} > MM$$



## License
MIT
