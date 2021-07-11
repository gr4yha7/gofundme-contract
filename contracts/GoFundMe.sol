//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract GoFundMe {
  address public owner;
  uint public totalFunds;

  struct Funder {
    address id;
    string name;
    uint amount;
  }
  
  mapping(address => Funder) funders;
  
  constructor() {
    owner = msg.sender;
  }
  
  event FundReceived(address indexed);
  event FundsWithdrawn(address indexed);
  
  modifier onlyOwner {
    require(msg.sender == owner, "Chief, you're not the owner of this contract");
    _;
  }
  
  modifier isNotFundee {
    require(msg.sender != owner, "Chairman, you wan fund yourself?");
    require((msg.sender != address(0)) && (msg.sender != address(this)));
    _;
  }
  
  modifier checkValue {
    require(msg.value > 0, "Boss, at all at all na hin bad pass. Drop something");
    _;
  }
  
  // modifier isEOA(address x) {
  //     uint size;
  //     assembly {
  //         size := extcodesize(x)
  //     }
  //     require(size > 0, "Caller is a contract address");
  //     require(x != address(0), "Zero address detected");
  //     _;
  // }
  
  function fund(string memory name) public payable isNotFundee checkValue {
    Funder storage funder = funders[msg.sender];
    funder.id = msg.sender;
    funder.name = name;
    funder.amount = msg.value;
    // funders[msg.sender] = Funder(msg.sender, name, msg.value);
    totalFunds += msg.value;
    emit FundReceived(msg.sender);
  }
  
  function cashout() public onlyOwner {
    uint amount = totalFunds;
    totalFunds = 0;
    payable(owner).transfer(amount);
    emit FundsWithdrawn(msg.sender);
  }
    
}