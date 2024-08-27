# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; forge test -vvv

# Common
common-flags := --ledger --mnemonic-indexes $(MNEMONIC_INDEX) --sender $(LEDGER_SENDER) --verify -vvvv --broadcast --slow
deploy-pk := --sender $(SENDER) --private-key ${PRIVATE_KEY} --verify -vvvv --slow --broadcast

# Deploy
deploy-weeth-mainnet :; forge script scripts/DeployEthereum.s.sol:DeployWeEthEthereum --rpc-url mainnet $(common-flags)
deploy-usde-mainnet :; forge script scripts/DeployEthereum.s.sol:DeployUSDeEthereum --rpc-url mainnet $(common-flags)
deploy-weeth-arbitrum :; forge script scripts/DeployArbitrumWeEth.s.sol:DeployWeEthArbitrum --rpc-url arbitrum $(common-flags)
deploy-weeth-scroll :; forge script scripts/DeployScroll.s.sol:DeployWeEthScroll --rpc-url scroll $(common-flags)
deploy-weeth-base :; forge script scripts/DeployBase.s.sol:DeployWeEthBase --rpc-url base $(deploy-pk)

deploy-oseth-mainnet :; forge script scripts/DeployEthereum.s.sol:DeployOsEthEthereum --rpc-url mainnet $(common-flags)

deploy-ethx-mainnet :; forge script scripts/DeployEthereum.s.sol:DeployEthXEthereum --rpc-url mainnet $(common-flags)

deploy-susde-mainnet :; forge script scripts/DeployEthereum.s.sol:DeploySUSDeEthereum --rpc-url mainnet $(common-flags)

deploy-bnbx-bnb :; forge script scripts/DeployBNB.s.sol:DeployBnbXBNB --rpc-url bnb $(common-flags)

# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@npx prettier ${before} ${after} --write
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md
