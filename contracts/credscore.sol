// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CredScore {
    address public owner;

    struct User {
        uint256 score;
        uint256 tokens;
        bool exists;
    }

    mapping(address => User) public users;

    event UserRegistered(address user);
    event ScoreUpdated(address user, uint256 newScore);
    event TokensAwarded(address user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier userExists(address _user) {
        require(users[_user].exists, "User not registered");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerUser(address _user) external onlyOwner {
        require(!users[_user].exists, "User already registered");
        users[_user] = User(0, 0, true);
        emit UserRegistered(_user);
    }

    function updateScore(address _user, uint256 _newScore) external onlyOwner userExists(_user) {
        users[_user].score = _newScore;
        emit ScoreUpdated(_user, _newScore);
    }

    function awardTokens(address _user, uint256 _amount) external onlyOwner userExists(_user) {
        users[_user].tokens += _amount;
        emit TokensAwarded(_user, _amount);
    }

    function getUser(address _user) external view returns (uint256 score, uint256 tokens) {
        require(users[_user].exists, "User not registered");
        User memory u = users[_user];
        return (u.score, u.tokens);
    }
}
