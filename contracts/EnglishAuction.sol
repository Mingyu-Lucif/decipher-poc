// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;


import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EnglishAuction{
  using Counters for Counters.Counter;

    event AuctionCreated(
        uint indexed id,
        address indexed maker
    );
    event AuctionBid(
      uint indexed id,
      address indexed bidder,
      uint price
    );
    event AuctionEnded(
        uint indexed id,
        address indexed maker,
        address indexed taker,
        uint price
    );

    enum Status {
        Created,
        Ended
    }
    struct Auction {
        // Auction Basic Information
        // should updated at Created.
        uint id;
        Status status;
        address maker;

        // Maker Values
        // should take as arguments
        uint startPrice;
        uint startDttm;
        uint endDttm;

        // Taker Values
        // should updated each bid
        address bidder;
        uint highestBid;

        // Auction Result Information
        // should updated at Ended.
        address taker;
        uint price;
    }
    
    Counters.Counter private _id;
    Auction[] private _auctions;

    address public poc;

    constructor(address poc_) {
        poc = poc_;
    }

    function totalAuctionsCount() public view returns (uint) {
        return _id.current();
    }

    function getAuction() public view returns (Auction memory) {
        return _auctions[_id.current() - 1];
    }

    function getAuction(uint id) public view returns (Auction memory) {
        return _auctions[id];
    }

    function createAuction(uint256 startPrice_, uint256 startDttm_, uint256 endDttm_) public returns (uint ) {
        uint currentId = _id.current();


        require(endDttm_ > block.timestamp);

        Auction memory newAuction = Auction(
            currentId,
            Status.Created,
            msg.sender,

            startPrice_,
            startDttm_,
            endDttm_,

            address(0),
            0,

            address(0),
            0
        );
        _auctions.push(newAuction);

        emit AuctionCreated(currentId, msg.sender);

        _id.increment();
        return currentId;
    }

    function bidAuction(uint id, uint price) public {
      Auction storage auction = _auctions[id];

      // 1. Check conditions.
      require(auction.status != Status.Ended);
      require(auction.endDttm > block.timestamp);
      require(price > auction.startPrice);
      require(auction.highestBid < price);

      // 2. Change Auction details
      auction.bidder = msg.sender;
      auction.highestBid = price;
      
      // 3. Events
      emit AuctionBid(
        id, msg.sender, price
      );
    }

    function closeAuction(uint id) public payable {
        Auction storage auction = _auctions[id];

        // 1. Check conditions.
        require(auction.status != Status.Ended);
        require(auction.endDttm < block.timestamp);
        require(msg.sender == auction.bidder);
        require(msg.value >= auction.price);

        // 2. Maker gets {price} amount of Ethers from Taker.(Ethers: Taker → Maker)
        payable(auction.maker).transfer(auction.price);

        // 3. Taker gets 1 POC Token from Maker.(POC: Maker → Taker)
        IERC20(poc).transferFrom(
            auction.maker,
            auction.taker,
            1
        );

        // 4. Update Auction Information
        auction.status = Status.Ended;
        auction.maker = msg.sender;

        // 5. Events
        emit AuctionEnded(id, auction.maker, auction.taker, auction.price);
    }
}