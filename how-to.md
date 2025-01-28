# How to add a new CAPO adapter

This documentation describes the steps required to add a new price cap adapter for LST or stablecoin asset.

As a first step, contact risk providers for recommendations on capo parameters:

- `maxYearlyGrowthPercent` and `minimumSnapshotDelay` parameters in case of an LST asset
- fixed capo value for the stablecoin asset

Deploying a new cap adapter consists of three simple steps:

- (optional) add a specific adapter for the new asset
- write a deployment script
- add and run tests

There are situations, when the sync adapter should be used together with the cap adapter. Detailed description is in the [separate section](#synchronicity-adapters).

## 1. Creating an adapter for LST

Depending on the asset type and data source, two options are possible:

### Native exchange rate

When an LST asset adapter is added and the native contract specifies a rate:

1. Determine which method of which contract provides the rate, and add a simplified version of the interface to the [`interfaces`](/src/interfaces/) folder. For example, for [`weETH`](/src/interfaces/IWeEth.sol) this is the `getRate()` method on the [token contract](https://etherscan.io/token/0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee#readProxyContract#F8), and for [`osETH`] this is `convertToAssets(uint256 shares)` on a separate [vault controller](https://etherscan.io/address/0x2a261e60fb14586b474c208b1b7ac6d0f5000306#readContract#F3).

2. Add the specific adapter contract to the [`lst-adapters`](/src/contracts/lst-adapters/) folder. The contract must inherit from [`PriceCapAdapterBase`](/src/contracts/PriceCapAdapterBase.sol) and implement only one `getRatio()` method.

### Chainlink oracle providing rate

If there is no native contract providing an exchange rate and the Chainlink feed will be used, there is no need to add a new adapter as the generic [`CLRatePriceCapAdapter](src/contracts/CLRatePriceCapAdapter.sol) should be used.

## 2. Deployment

As risk entities only provide growth rate and snapshot delay while `snapshotRatio` and `snapshotTimestamp` are flexible, you need to get them by yourself to use in deployment.

### Get params for the deployment

1. The first option is to use [GetExchangeRatesTest](tests/utils/GetExchangeRatesTest.t.sol):
   - Add a method to get the rate and console log for the corresponding network test. Example for [`osETH`](tests/utils/GetExchangeRatesTest.t.sol#46)
   - set the block number to approximately `now - minimumSnapshotDelay` and run the test contract with output to the console.
2. The second option is to do it any other way you want.

### Script

Alter the appropriate deployment script:

1. Add a function that will return the deployment code to the library. Example for [`weETH`](scripts/DeployEthereum.s.sol#15). The following parameters should be specified:

   - `aclManager`: ACL manager of he pool
   - `baseAggregatorAddress`: the address of the base asset feed, for ETH-based LSTs it should be `ETH / USD` oracle
   - `ratioProviderAddress`: the address of the contract, which provides the exchange ratio
   - `pairDescription`: description of the adapter
   - `minimumSnapshotDelay`: the delay provided by the risk entity, typically 7 or 14 days
   - `snapshotRatio`: the value of the exchange ratio X days ago
   - `snapshotTimestamp`: timestamp of the snapshot ratio
   - `maxYearlyRatioGrowthPercent`: the maximum possible annual LST growth percentage

     1.1 If the adapter is deployed on zkSync network, you'll need to create a function that only returns the encoded parameters above instead of returning the deployment code.

2. Add the deployment script and command to the Makefile.

## 3. Testing

To test the adapter:

1. Add the test to the destination network folder inside `tests`.
2. Inherit it from [`BaseTest`](tests/BaseTest.sol) and implement the simple `_createAdapter()` method, when the specific adapter is created. Or just inherit the test from [CLAdapterBaseTest.sol](tests/CLAdapterBaseTest.sol) when Chainlink oracle is used.

   2.1. If the adapter will be tested against the zksync network:

   - add the `salt` parameter using the `new` keyword for deployment: e.g.: `new CLRatePriceCapAdapter{salt: 'test'}(capAdapterParams)`

3. Specify the following test parameters:
   - adapter code
   - number of days for retrospective testing (default is 90). Check that with the specified parameters the adapter has not been capped for the last X days. A report comparing prices with the base aggregator is also generated.
   - fork parameters: network and block number
   - name for the report (something like `osETH_Ethereum`)

# Adapter for Stablecoin

No need to add a specific adapter, existing [`PriceCapAdapterStable`](src/contracts/PriceCapAdapterStable.sol) should be used.

## Deployment

1. Add a function that will return the deployment code to the library in the appropriate network's deployment script. The following parameters should be specified:

   - `aclManager`: the ACL manager of the pool
   - `assetToUsdAggregator`: the address of the `asset / USD` feed
   - `adapterDescription`: description of the adapter
   - `priceCap`: the value of the price cap, for example for 4% it would be `int256(1.04 * 1e8)`

2. Add the deployment script and command to the Makefile.

## Testing

Base test for stables would be added soon. Stay tuned.

## Sync adapter

When you need to cap the asset which is not pegged to the base asset of the pool (to `USD`), such as `agEUR`, then you need to use a combination of adapters:

1.  Cap adapter for `agEUR / EUR` as `agEUR` should be capped against `EUR`.
2.  [CLSynchronicityPriceAdapterPegToBase](https://github.com/bgd-labs/cl-synchronicity-price-adapter/blob/main/src/contracts/CLSynchronicityPriceAdapterPegToBase.sol) to combine capped adapter with `EUR / USD` feed to create capped `agEUR / EUR / USD`.

[Here is the example](scripts/Example.s.sol).
