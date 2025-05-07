// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../src/interfaces/IPriceCapAdapter.sol';
import {BaseTest, BlockUtils} from './BaseTest.sol';

abstract contract BaseTestSvr is BaseTest {
  struct SvrComparativeParams {
    int256 regularAdapterPrice;
    int256 svrAdapterPrice;
    int256 ratio;
    uint256 blockNumber;
    uint256 timestamp;
  }

  IPriceCapAdapter public currentAdapter;
  SvrComparativeParams[] comparative;

  constructor(
    address _currentAdapter,
    bytes memory _deploymentCodeOrParamsSvr,
    uint8 _retrospectiveDays,
    ForkParams memory _forkParams,
    string memory _reportName
  ) BaseTest(_deploymentCodeOrParamsSvr, _retrospectiveDays, _forkParams, _reportName) {
    currentAdapter = IPriceCapAdapter(_currentAdapter);
  }

  /// @dev Compares latestAnswer from current feeds and svr feeds
  function test_latestAnswerComparative() public virtual {
    uint256 finishBlock = forkParams.blockNumber;

    IPriceCapAdapter.CapAdapterParams memory capAdapterParams = _getCapAdapterParams();

    uint256 currentBlock = BlockUtils.getStartBlock(
      finishBlock,
      RETROSPECTIVE_DAYS,
      forkParams.network
    );

    IPriceCapAdapter svrAdapter = _createRetrospectiveAdapter(capAdapterParams, currentBlock);

    uint256 snapshotDelayDays = uint256(svrAdapter.MINIMUM_SNAPSHOT_DELAY()) / SECONDS_PER_DAY;

    vm.makePersistent(address(svrAdapter));

    // get step
    uint256 step = BlockUtils.getStep(RETROSPECTIVE_STEP, forkParams.network);
    uint256 i = 0;

    while (currentBlock <= finishBlock) {
      vm.createSelectFork(vm.rpcUrl(forkParams.network), currentBlock);

      // get current svr and current lst prices
      int256 svrPrice = svrAdapter.latestAnswer();
      int256 currentPrice = currentAdapter.latestAnswer();

      // get ratio (equal on both adapters);
      int256 ratio = svrAdapter.getRatio();

      comparative.push(
        SvrComparativeParams({
          regularAdapterPrice: currentPrice,
          svrAdapterPrice: svrPrice,
          ratio: ratio,
          blockNumber: currentBlock,
          timestamp: block.timestamp
        })
      );

      currentBlock += step;
      i++;
    }
    _generateSvrPriceComparativeReport(
      svrAdapter.description(),
      svrAdapter.decimals(),
      snapshotDelayDays
    );

    vm.revokePersistent(address(svrAdapter));
    vm.createSelectFork(vm.rpcUrl(forkParams.network), finishBlock);
  }

  function _generateSvrPriceComparativeReport(
    string memory sourceName,
    uint8 decimals,
    uint256 snapshotDelayDays
  ) internal {
    string memory path = _generateSvrJsonReport(sourceName, decimals, snapshotDelayDays);
    _generateSvrMdReport(path);

    string[] memory inputs = new string[](2);
    inputs[0] = 'rm';
    inputs[1] = path;
    vm.ffi(inputs);
  }

  function _generateSvrJsonReport(
    string memory sourceName,
    uint8 decimals,
    uint256 snapshotDelayDays
  ) internal returns (string memory) {
    string memory path = string(abi.encodePacked('./reports/', reportName, '.json'));
    vm.serializeString('root', 'sourceName', sourceName);
    vm.serializeUint('root', 'decimals', decimals);
    vm.serializeUint('root', 'minSnapshotDelay', snapshotDelayDays);
    string memory comparativeKey = 'comparative';
    string memory content = '{}';
    vm.serializeJson(comparativeKey, '{}');

    for (uint256 i = 0; i < comparative.length; i++) {
      string memory key = vm.toString(comparative[i].blockNumber);
      vm.serializeJson(key, '{}');
      vm.serializeInt(key, 'regularAdapterPrice', comparative[i].regularAdapterPrice);
      vm.serializeInt(key, 'svrAdapterPrice', comparative[i].svrAdapterPrice);
      string memory object = vm.serializeUint(key, 'timestamp', comparative[i].timestamp);
      content = vm.serializeString(comparativeKey, key, object);
    }

    string memory output = vm.serializeString('root', comparativeKey, content);
    vm.writeJson(output, path);

    return path;
  }

  function _generateSvrMdReport(string memory sourcePath) internal {
    string memory outPath = string(abi.encodePacked('./reports/', reportName, '.md'));

    string[] memory inputs = new string[](7);
    inputs[0] = 'npx';
    inputs[1] = '@bgd-labs/aave-cli';
    inputs[2] = 'capo-svr-report';
    inputs[3] = sourcePath;
    inputs[5] = '-o';
    inputs[6] = outPath;
    vm.ffi(inputs);
  }
}
