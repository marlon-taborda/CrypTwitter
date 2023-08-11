// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

struct Tweet {
    address author;
    string text;
    uint timestamp;
    string username;
}

contract CrypTwitter{

    uint public tweetsIndex;

    uint public constant PAGE_SIZE = 10;

    mapping(uint => Tweet) public tweets;

    mapping(address => string) public usernames;

    function setUsername(string calldata name) public {
        usernames[msg.sender] = name;
    }

    function addTweet(string calldata text) public {
        Tweet memory newTweet;
        newTweet.text = text;
        newTweet.author = msg.sender;
        newTweet.timestamp = block.timestamp;

        tweetsIndex++;
        tweets[tweetsIndex] = newTweet;
    }

    function getPageTweets(uint page) public view returns(Tweet[] memory) {
        if(page < 1) page =1;
        uint startIndex = (PAGE_SIZE * (page - 1)) + 1;
        Tweet[] memory pageTweets = new Tweet[](PAGE_SIZE);
        for (uint i = 0; i < PAGE_SIZE; i++) {
            pageTweets[i] = tweets[startIndex + i];
            pageTweets[i].username = usernames[pageTweets[i].author];
        }
        return pageTweets;
    }

    function eraseTweet(uint tweetIndex) public {
        if( tweets[tweetIndex].author == msg.sender ) {
            Tweet memory erasedTweet;
            erasedTweet.text = "This message was erased";
            tweets[tweetsIndex] = erasedTweet;
        }
    }

    function editTweet(uint tweetIndex, string calldata text) public {
        if( tweets[tweetIndex].author == msg.sender ) {
            tweets[tweetsIndex].text = text;
        }
    }

}