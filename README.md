# arbfreeswap
Crypto swapping service that protects liquidity providers from arbitrage and divergence loss using chainlink oracles

# Why it's needed
Excellent tools like Uniswap allow provisioning liquidity and on-chain price discovery through interaction with buyers and sellers and using demand and supply to deterministically set the price. The fatal flaw here is that real world demand and supply changes create opportunities for arbitrageurs to open a position at a better price than what Uniswap offers, and then close on Uniswap. This makes the price consistent and reflect the real world from the perspective of the consumers of Uniswap, but the liquidity providers (LPs) leak value via imperment loss to these arbitragers.

Off chain price discovery can protect LPs (and Uniswap) from offering an unfavourable price, while maintaining competitiveness on the price offered to swappers.

## What it does
Shows you the better price of the one provided by the LP demand-supply balance and the one from external price feeds, funded by the swap fees.

# See it in action
https://remix.ethereum.org/#gist=043802bbfd3b92f858ea8468f0f1d134

# How it works
Chainlink provides price feeds, and these can become the floor (+slippage) for the price offered by the swap contract.
_Eventually we can move to bid-ask spreads via APIs from Oracles, in turn from public APIs of traditional bid-ask quoted orderbook exchanges._

Part of what would become LPs fees is used to run the price oracles.

For now, it only supports one pair. Must fork Uniswap or SushiSwap (or even [1inch](https://app.1inch.io)?) for mainnet implementation, with core innovation being the algorithm for offered price. Of course, without market penetration any of these projects can re-implement this themselves.

## Challenges we ran into
Understanding and adding this functionality to a uniswap fork is hard!

## Accomplishments that we're proud of
Implementing price based on both the LP demand-supply equation and the price feed for one pair, verifying that better price is displayed.


# Finance and sustainability
Plan is to dynamically evolve fees extracted from the swaps to equal pay for capex/opex of the maintaining and improving the codebase. Contributors will get shares. Details not fleshed out.

If this is going to be hard to sustainably monetize and hold its own economic water, I'll look into merging this into Uniswap. Perhaps that's the best way to distribute this regardless.
