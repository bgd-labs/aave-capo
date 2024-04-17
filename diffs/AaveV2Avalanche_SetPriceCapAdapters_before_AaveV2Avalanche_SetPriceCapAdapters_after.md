## Reserve changes

### Reserve altered

#### USDC.e ([0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664](https://snowscan.xyz/address/0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664))

| description | value before | value after |
| --- | --- | --- |
| oracle | [0xF096872672F44d6EBA71458D74fe67F9a77a23B9](https://snowscan.xyz/address/0xF096872672F44d6EBA71458D74fe67F9a77a23B9) | [0xD8277249e871BE9A402fa286C2C5ec16046dC512](https://snowscan.xyz/address/0xD8277249e871BE9A402fa286C2C5ec16046dC512) |
| oracleDescription | USDC / USD | Capped USDC/USD |


#### USDT.e ([0xc7198437980c041c805A1EDcbA50c1Ce5db95118](https://snowscan.xyz/address/0xc7198437980c041c805A1EDcbA50c1Ce5db95118))

| description | value before | value after |
| --- | --- | --- |
| oracle | [0xEBE676ee90Fe1112671f19b6B7459bC678B67e8a](https://snowscan.xyz/address/0xEBE676ee90Fe1112671f19b6B7459bC678B67e8a) | [0x39185f2236A6022b682e8BB93C040d125DA093CF](https://snowscan.xyz/address/0x39185f2236A6022b682e8BB93C040d125DA093CF) |
| oracleDescription | USDT / USD | Capped USDt/USD |


#### DAI.e ([0xd586E7F844cEa2F87f50152665BCbc2C279D8d70](https://snowscan.xyz/address/0xd586E7F844cEa2F87f50152665BCbc2C279D8d70))

| description | value before | value after |
| --- | --- | --- |
| oracle | [0x51D7180edA2260cc4F6e4EebB82FEF5c3c2B8300](https://snowscan.xyz/address/0x51D7180edA2260cc4F6e4EebB82FEF5c3c2B8300) | [0xf82da795727633aFA9BB0f1B08A87c0F6A38723f](https://snowscan.xyz/address/0xf82da795727633aFA9BB0f1B08A87c0F6A38723f) |
| oracleDescription | DAI / USD | Capped DAI.e/USD |


## Raw diff

```json
{
  "reserves": {
    "0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664": {
      "oracle": {
        "from": "0xF096872672F44d6EBA71458D74fe67F9a77a23B9",
        "to": "0xD8277249e871BE9A402fa286C2C5ec16046dC512"
      },
      "oracleDescription": {
        "from": "USDC / USD",
        "to": "Capped USDC/USD"
      }
    },
    "0xc7198437980c041c805A1EDcbA50c1Ce5db95118": {
      "oracle": {
        "from": "0xEBE676ee90Fe1112671f19b6B7459bC678B67e8a",
        "to": "0x39185f2236A6022b682e8BB93C040d125DA093CF"
      },
      "oracleDescription": {
        "from": "USDT / USD",
        "to": "Capped USDt/USD"
      }
    },
    "0xd586E7F844cEa2F87f50152665BCbc2C279D8d70": {
      "oracle": {
        "from": "0x51D7180edA2260cc4F6e4EebB82FEF5c3c2B8300",
        "to": "0xf82da795727633aFA9BB0f1B08A87c0F6A38723f"
      },
      "oracleDescription": {
        "from": "DAI / USD",
        "to": "Capped DAI.e/USD"
      }
    }
  }
}
```