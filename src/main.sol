pragma solidity ^0.8.3;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2Pair.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol"

contract PriceConsumerV3 {
    string public message;

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: LINK/ETH
     * Address hardcoded
     */
    constructor(string memory initialMessage) public {
        message = initialMessage;
        priceFeed = AggregatorV3Interface(0xDC530D9457755926550b59e8ECcdaE7624181557);
    }

    function updateMessage(string memory newMessage) public {
        message = newMessage;
    }

    /**
     * Returns the latest price, but how do I get the bid/ask spread?
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
     * 
     * Probably switch to using V2 Oracles with time weighted price for this, using best execution price from https://uniswap.org/docs/v2/javascript-SDK/pricing/
     */
    function getTokenPrice(address pairAddress, uint amount) public view returns(uint) {
        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
        IERC20 token1 = IERC20(pair.token1);
        (uint Res0, uint Res1,) = pair.getReserves();

        // decimals
        uint res0 = Res0*(10**token1.decimals());
        return((amount*res0)/Res1); // return amount of token0 needed to buy token1
    }

    /** Return the higher price among the two (assuming buying), protecting LPs but still offering best price to consumers
     */
    function getBestPrice() public view returns(uint) {
        return(max(getTokenPrice(), getLatestPrice()))
    }
}
