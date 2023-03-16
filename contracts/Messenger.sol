//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

contract Messenger {

  struct FriendRequest {
    address sender;
    address recipient;
    bool accepted;
  }

  struct ChatMessage {
    address sender;
    address recipient;
    uint256 timestamp;
    string message;
  }

  event FriendRequestSent(address sender, address recipient);
  event FriendRequestAccepted(address sender, address recipient);
  event ChatMessageSent(address indexed sender, address indexed recipient, string message);

  mapping(address => mapping(address => bool)) public friends;
  FriendRequest[] public friendRequests;
  ChatMessage[] public chatMessages;

  function sendFriendRequest(address _recipient) public {
    FriendRequest memory newRequest = FriendRequest(msg.sender, _recipient, false);
    friendRequests.push(newRequest);
    emit FriendRequestSent(msg.sender, _recipient);
  }

  function acceptFriendRequest(uint256 _index) public {
    FriendRequest storage request = friendRequests[_index];
    require(request.recipient == msg.sender, "You are not authorized to accept this request.");
    require(!request.accepted, "This request has already been accepted.");
    request.accepted = true;
    friends[request.sender][request.recipient] = true;
    friends[request.recipient][request.sender] = true;
    emit FriendRequestAccepted(request.sender, request.recipient);
  }

  function sendChatMessage(address _recipient, string memory _message) public {
    require(friends[msg.sender][_recipient], "You are not friends with this user.");
    ChatMessage memory newMessage = ChatMessage(msg.sender, _recipient, block.timestamp, _message);
    chatMessages.push(newMessage);
    emit ChatMessageSent(msg.sender, _recipient, _message);
  }

  function getChatMessages(address _recipient) public view returns(ChatMessage[] memory) {
    require(friends[msg.sender][_recipient], "You are not friends with this user.");
    uint256 messageCount = 0;
    for (uint256 i = 0; i < chatMessages.length; i++) {
      if ((chatMessages[i].sender == msg.sender && chatMessages[i].recipient == _recipient) ||
        (chatMessages[i].sender == _recipient && chatMessages[i].recipient == msg.sender)) {
        messageCount++;
      }
    }
    ChatMessage[] memory result = new ChatMessage[](messageCount);
    uint256 index = 0;
    for (uint256 i = 0; i < chatMessages.length; i++) {
      if ((chatMessages[i].sender == msg.sender && chatMessages[i].recipient == _recipient) ||
        (chatMessages[i].sender == _recipient && chatMessages[i].recipient == msg.sender)) {
        result[index] = chatMessages[i];
        index++;
      }
    }
    return result;
  }

}