// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

abstract contract BaseTest is Test {
  uint256 public constant SECONDS_PER_DAY = 86400;

  uint256 public constant RETROSPECTIVE_STEP = 3;
  uint256 public immutable RETROSPECTIVE_DAYS;

  struct ForkParams {
    string network;
    uint256 blockNumber;
  }

  struct CapAdapterParams {
    IACLManager aclManager;
    address baseAggregatorAddress;
    address ratioProviderAddress;
    string pairDescription;
    uint8 ratioDecimals;
    uint48 minimumSnapshotDelay;
    IPriceCapAdapter.PriceCapUpdateParams priceCapParams;
  }

  struct PriceParams {
    int256 sourcePrice;
    int256 referencePrice;
    uint256 blockNumber;
    uint256 timestamp;
  }

  ForkParams public forkParams;
  bytes public deploymentCode;
  string public reportName;
  PriceParams[] prices;

  constructor(
    bytes memory _deploymentCode,
    uint8 _retrospectiveDays,
    ForkParams memory _forkParams,
    string memory _reportName
  ) {
    forkParams = _forkParams;
    deploymentCode = _deploymentCode;
    RETROSPECTIVE_DAYS = _retrospectiveDays;
    reportName = _reportName;
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl(forkParams.network), forkParams.blockNumber);
  }

  function test_latestAnswer() public virtual {
    IPriceCapAdapter adapter = IPriceCapAdapter(GovV3Helpers.deployDeterministic(deploymentCode));

    int256 price = adapter.latestAnswer();
    int256 priceOfReferenceAdapter = adapter.BASE_TO_USD_AGGREGATOR().latestAnswer();

    assertFalse(adapter.isCapped());
    assertGt(
      price,
      priceOfReferenceAdapter,
      'lst price is not greater than the reference adapter price'
    );
  }

  function test_latestAnswerRetrospective() public virtual {
    uint256 finishBlock = forkParams.blockNumber;

    // get adapter parameters
    CapAdapterParams memory capAdapterParams = _getCapAdapterParams();

    // get start block
    uint256 currentBlock = _getStartBlock(finishBlock);

    IPriceCapAdapter adapter = _createRetrospectiveAdapter(capAdapterParams, currentBlock);

    // persist adapter
    vm.makePersistent(address(adapter));

    // get step
    uint256 step = _getStep();

    while (currentBlock <= finishBlock) {
      vm.createSelectFork(vm.rpcUrl(forkParams.network), currentBlock);

      int256 price = adapter.latestAnswer();
      int256 priceOfReferenceAdapter = adapter.BASE_TO_USD_AGGREGATOR().latestAnswer();

      prices.push(
        PriceParams({
          sourcePrice: price,
          referencePrice: priceOfReferenceAdapter,
          blockNumber: currentBlock,
          timestamp: block.timestamp
        })
      );

      assertFalse(adapter.isCapped());

      currentBlock += step;
    }

    _generateReport(
      adapter.description(),
      ICLSynchronicityPriceAdapter(address(adapter.BASE_TO_USD_AGGREGATOR())).description(),
      adapter.decimals()
    );

    vm.revokePersistent(address(adapter));
    vm.createSelectFork(vm.rpcUrl(forkParams.network), finishBlock);
  }

  function test_cappedLatestAnswer() public virtual {
    // deploy adapter
    IPriceCapAdapter adapter = IPriceCapAdapter(GovV3Helpers.deployDeterministic(deploymentCode));

    // set cap to 1%
    _setCapParametersByAdmin(
      adapter,
      uint104(adapter.getSnapshotRatio()),
      uint48(adapter.getSnapshotTimestamp() + 1),
      uint16(1_00)
    );

    // check is capped
    assertTrue(adapter.isCapped());
  }

  function _getCapAdapterParams() internal returns (CapAdapterParams memory) {
    IPriceCapAdapter adapter = IPriceCapAdapter(GovV3Helpers.deployDeterministic(deploymentCode));

    return
      CapAdapterParams({
        aclManager: adapter.ACL_MANAGER(),
        baseAggregatorAddress: address(adapter.BASE_TO_USD_AGGREGATOR()),
        ratioProviderAddress: adapter.RATIO_PROVIDER(),
        pairDescription: adapter.description(),
        ratioDecimals: adapter.RATIO_DECIMALS(),
        minimumSnapshotDelay: adapter.MINIMUM_SNAPSHOT_DELAY(),
        priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: uint104(adapter.getSnapshotRatio()),
          snapshotTimestamp: uint48(adapter.getSnapshotTimestamp()),
          maxYearlyRatioGrowthPercent: uint16(adapter.getMaxYearlyGrowthRatePercent())
        })
      });
  }

  function _createAdapter(
    CapAdapterParams memory capAdapterParams
  ) internal virtual returns (IPriceCapAdapter) {}

  function _createRetrospectiveAdapter(
    CapAdapterParams memory capAdapterParams,
    uint256 currentBlock
  ) internal returns (IPriceCapAdapter) {
    // save temporary minimum snapshot delay
    uint48 minimumSnapshotDelay = capAdapterParams.minimumSnapshotDelay;

    // get parameters for the adapter, which will be created
    vm.createSelectFork(
      vm.rpcUrl(forkParams.network),
      currentBlock - _getSnapshotDelayInBlocks(capAdapterParams.minimumSnapshotDelay)
    );

    capAdapterParams.priceCapParams.snapshotTimestamp = uint48(block.timestamp);
    capAdapterParams.priceCapParams.snapshotRatio = 1;
    capAdapterParams.minimumSnapshotDelay = 0;

    IPriceCapAdapter adapterTogetratio = _createAdapter(capAdapterParams);
    uint104 currentRatio = uint104(uint256(adapterTogetratio.getRatio()));

    // select current block and create retrospective adapter
    vm.createSelectFork(vm.rpcUrl(forkParams.network), currentBlock);
    capAdapterParams.priceCapParams.snapshotRatio = currentRatio;
    capAdapterParams.minimumSnapshotDelay = minimumSnapshotDelay;
    IPriceCapAdapter adapter = _createAdapter(capAdapterParams);

    return adapter;
  }

  function _setCapParametersByAdmin(
    IPriceCapAdapter adapter,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) internal {
    vm.mockCall(
      address(adapter.ACL_MANAGER()),
      abi.encodeWithSelector(BasicIACLManager.isRiskAdmin.selector),
      abi.encode(true)
    );

    adapter.setCapParameters(
      IPriceCapAdapter.PriceCapUpdateParams({
        snapshotRatio: snapshotRatio,
        snapshotTimestamp: snapshotTimestamp,
        maxYearlyRatioGrowthPercent: maxYearlyRatioGrowthPercent
      })
    );
  }

  function _getStartBlock(uint256 finishBlock) internal view returns (uint256) {
    return finishBlock - RETROSPECTIVE_DAYS * _getBlocksPerDayByNetwork(forkParams.network);
  }

  function _getStep() internal view returns (uint256) {
    return RETROSPECTIVE_STEP * _getBlocksPerDayByNetwork(forkParams.network);
  }

  function _getSnapshotDelayInBlocks(uint48 minimumSnapshotDelay) internal view returns (uint256) {
    return (minimumSnapshotDelay * _getBlocksPerDayByNetwork(forkParams.network)) / SECONDS_PER_DAY;
  }

  function _getBlocksPerDayByNetwork(string memory network) internal pure returns (uint256) {
    if (keccak256(bytes(network)) == keccak256(bytes('mainnet'))) {
      return 7300;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('arbitrum'))) {
      return 340000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('avalanche'))) {
      return 43000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('base'))) {
      return 44000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('bnb'))) {
      return 30000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('optimism'))) {
      return 44000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('polygon'))) {
      return 38000;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('scroll'))) {
      return 25500;
    }

    if (keccak256(bytes(network)) == keccak256(bytes('gnosis'))) {
      return 17000;
    }

    return 7300;
  }

  function _generateReport(
    string memory sourceName,
    string memory referenceName,
    uint8 decimals
  ) internal {
    string memory path = string(abi.encodePacked('./reports/', reportName, '.json'));
    vm.serializeString('root', 'source', sourceName);
    vm.serializeString('root', 'reference', referenceName);
    vm.serializeUint('root', 'decimals', decimals);
    string memory pricesKey = 'prices';
    string memory content = '{}';
    vm.serializeJson(pricesKey, '{}');

    for (uint256 i = 0; i < prices.length; i++) {
      string memory key = vm.toString(prices[i].blockNumber);
      vm.serializeJson(key, '{}');
      vm.serializeUint(key, 'timestamp', prices[i].timestamp);
      vm.serializeInt(key, 'sourcePrice', prices[i].sourcePrice);
      string memory object = vm.serializeInt(key, 'referencePrice', prices[i].referencePrice);
      content = vm.serializeString(pricesKey, key, object);
    }

    string memory output = vm.serializeString('root', pricesKey, content);
    vm.writeJson(output, path);
  }
}
