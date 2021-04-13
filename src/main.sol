pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';


contract ArbFreeSwap {
    string public message;

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: BAT/ETH
     * Address hardcoded from https://data.chain.link/link-eth
     */
    constructor(string memory initialMessage) public {
        message = initialMessage;
        priceFeed = AggregatorV3Interface(0x0e4fcEC26c9f85c3D714370c98f43C4E02Fc35Ae);
    }

    function updateMessage(string memory newMessage) public {
        message = newMessage;
    }

    /**
     * Returns the latest off-chain price, but how do I get the bid/ask spread across all orderbook exchanges?
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }

    /**
     * calculate price based on pair reserves
     * https://ethereum.stackexchange.com/a/94173/
     * BAT/ETH pair address hardcoded
     * BAT: 0x482dC9bB08111CB875109B075A40881E48aE02Cd
     * ETH: 0xd0A1E359811322d97991E03f863a0C30C2cF029C
     * Factory address on all networks 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
     */
    function getTokenBidPrice() public view returns(uint) {
        (uint256 ResA, uint256 ResB) = UniswapV2Library.getReserves(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0x482dC9bB08111CB875109B075A40881E48aE02Cd,  0xd0A1E359811322d97991E03f863a0C30C2cF029C);
        return (ResB*(10**18)/ResA);
    }

    function getTokenAskPrice() public view returns(uint) {
        (uint256 ResA, uint256 ResB) = UniswapV2Library.getReserves(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0x482dC9bB08111CB875109B075A40881E48aE02Cd,  0xd0A1E359811322d97991E03f863a0C30C2cF029C);
        return (ResA/ResB/(10**18));
    }

     /** Return the lower price among the two (assuming consumer is selling), protecting LPs but still offering best price to consumers
      * This assumes orderbook based markets are more accurately priced, since they can price in between the 15s windows.
      */
    function getBestBid() public view returns(uint) {
        uint256 x = getTokenBidPrice();
        uint256 y = uint256(getLatestPrice());
        return x < y ? x : y;
    }

    function getBestAsk() public view returns(uint) {
        uint256 x = getTokenAskPrice();
        uint256 y = uint256(getLatestPrice());
        return x > y ? x : y;
    }
}
