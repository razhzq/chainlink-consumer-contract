pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';



contract TradingAPIConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    string public price;

    bytes32 private jobId;
    uint256 private fee;

    event CurrentPriceRequest(bytes32 indexed requestId, uint256 indexed price);

    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setChainlinkOracle(0x12124FDE243Af3Fc62E5D8983dd6C7c5B66d50B5);
        jobId = 'c4c9f009ec40430faf9eedd8c0842e11';
        fee = (1 * LINK_DIVISIBILITY) / 10; 
    }

    function getCurrentPrice() public returns (bytes32 requestId) {
       Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

       req.add('get', 'http://146.190.222.139/crypto/btc');

       req.add('path', '1,BTC/USD');

       return sendChainlinkRequest(req, fee);



    }

    function fulfill(bytes32 _requestId, string memory _price) public recordChainlinkFulfillment(_requestId) {
        emit CurrentPriceRequest(_requestId, _price);

        price = _price;
    }




}