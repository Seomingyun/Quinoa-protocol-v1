// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
 
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

interface IProduct is IERC20, IERC20Metadata {

    struct AssetParams {
        address assetAddress;
        address oracleAddress; // for chainlink price feed
        uint256 targetWeight; // TODO type 조정 필요, 소숫점 관리 어떻게 할지 논의 필요. if targetWeight 25 => 이후 로직에서 100으로 항상 나눠줘야 함.
        uint256 currentPrice; // when rebalancing -> update
    }

    struct StrategyParams {
        address strategyAddress;
        address assetAddress;
        uint256 assetBalance;
    }

    // MUST be emitted when tokens are deposited into the vault via the mint and deposit methods
    event Deposit(
        address indexed sender,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    // MUST be emitted when shares are withdrawn from the vault by a depositor in the redeem or withdraw methods.
    event Withdraw(
        address indexed sender,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 share
    );

    // TODO add more argument;
    event Rebalance(
        uint256 time
    );

    // function totalSupply() external view returns (uint256); // erc20 function
    // function balanceOf(address owner) external view returns (uint256); // erc20 function

    function totalFloat() external view returns (uint256); 
    function balanceOfAsset(address assetAddress) external view returns(uint256);
    function addAsset(address newAssetAddress) external;
    function updateWeight(AssetParams[] memory newParams) external; 
    function currentWeight() external returns(AssetParams[] memory); 
    function checkAsset(address assetAddress) external returns (bool isExist); 
    function getPortfolioValue() external view returns(uint256);

    function maxDeposit(address receiver) external view returns (uint256); // for deposit
    function maxWithdraw(address owner) external view returns (uint256); // for withdraw

    function withdraw(address assetAddress, uint256 assetAmount, address receiver, address owner) external returns (uint256 shares); 
    function deposit(address assetAddress, uint256 assetAmount, address receiver) external returns (uint256 shares); 
    function rebalance() external;

    // strategy와 상호작용
    function depositIntoStrategy(address strategyAddress, uint256 assetAmount) external; 
    function redeemFromStrategy(address strategyAddress, uint256 assetAmount) external; 


    // 보류
    function convertToShares(uint256 assetAmount) external view returns(uint256 shareAmount);
    function convertToAssets(uint256 shareAmount) external view returns (uint256 assetAmount);
    function previewWithdraw(uint256 assetAmount) external view returns (uint256);
    function previewDeposit(uint256 assetAmount) external view returns (uint256);
}