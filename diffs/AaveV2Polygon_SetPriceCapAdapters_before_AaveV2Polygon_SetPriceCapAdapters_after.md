## Reserve changes

### Reserve altered

#### USDC ([0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174](https://polygonscan.com/address/0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174))

| description | value before | value after |
| --- | --- | --- |
| oracle | [0xefb7e6be8356cCc6827799B6A7348eE674A80EaE](https://polygonscan.com/address/0xefb7e6be8356cCc6827799B6A7348eE674A80EaE) | [0x7d1c544680897386101446386bCb0E198e5238c2](https://polygonscan.com/address/0x7d1c544680897386101446386bCb0E198e5238c2) |
| oracleDescription | USDC / ETH | Capped USDC / USD / ETH |
| oracleLatestAnswer | 0.000285850962440091 | 0.000284364774687508 |


#### DAI ([0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063](https://polygonscan.com/address/0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063))

| description | value before | value after |
| --- | --- | --- |
| oracle | [0xFC539A559e170f848323e19dfD66007520510085](https://polygonscan.com/address/0xFC539A559e170f848323e19dfD66007520510085) | [0x2Aa1fAa55A9362007406917C7c5A55761a93270C](https://polygonscan.com/address/0x2Aa1fAa55A9362007406917C7c5A55761a93270C) |
| oracleDescription | DAI / ETH | Capped DAI / USD / ETH |
| oracleLatestAnswer | 0.000286415527324459 | 0.000284364220180079 |


#### USDT ([0xc2132D05D31c914a87C6611C10748AEb04B58e8F](https://polygonscan.com/address/0xc2132D05D31c914a87C6611C10748AEb04B58e8F))

| description | value before | value after |
| --- | --- | --- |
| oracle | [0xf9d5AAC6E5572AEFa6bd64108ff86a222F69B64d](https://polygonscan.com/address/0xf9d5AAC6E5572AEFa6bd64108ff86a222F69B64d) | [0xCA68438c62fc58Ef7c0eFdceF808B6C0ff5dCFfc](https://polygonscan.com/address/0xCA68438c62fc58Ef7c0eFdceF808B6C0ff5dCFfc) |
| oracleDescription | USDT / ETH | Capped USDT / USD / ETH |
| oracleLatestAnswer | 0.000285469597487867 | 0.0002843155543332 |


## Raw diff

```json
{
  "reserves": {
    "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174": {
      "oracle": {
        "from": "0xefb7e6be8356cCc6827799B6A7348eE674A80EaE",
        "to": "0x7d1c544680897386101446386bCb0E198e5238c2"
      },
      "oracleDescription": {
        "from": "USDC / ETH",
        "to": "Capped USDC / USD / ETH"
      },
      "oracleLatestAnswer": {
        "from": 285850962440091,
        "to": 284364774687508
      }
    },
    "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063": {
      "oracle": {
        "from": "0xFC539A559e170f848323e19dfD66007520510085",
        "to": "0x2Aa1fAa55A9362007406917C7c5A55761a93270C"
      },
      "oracleDescription": {
        "from": "DAI / ETH",
        "to": "Capped DAI / USD / ETH"
      },
      "oracleLatestAnswer": {
        "from": 286415527324459,
        "to": 284364220180079
      }
    },
    "0xc2132D05D31c914a87C6611C10748AEb04B58e8F": {
      "oracle": {
        "from": "0xf9d5AAC6E5572AEFa6bd64108ff86a222F69B64d",
        "to": "0xCA68438c62fc58Ef7c0eFdceF808B6C0ff5dCFfc"
      },
      "oracleDescription": {
        "from": "USDT / ETH",
        "to": "Capped USDT / USD / ETH"
      },
      "oracleLatestAnswer": {
        "from": 285469597487867,
        "to": 284315554333200
      }
    }
  }
}
```