# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; forge test -vvv

# Common
common-flags := --legacy --ledger --mnemonic-indexes $(MNEMONIC_INDEX) --sender $(LEDGER_SENDER) --verify -vvvv --broadcast --slow

# Deploy
deploy-mainnet :; forge script scripts/DeployEthereum.s.sol:DeployEthereum --rpc-url mainnet $(common-flags)
deploy-arbitrum :; forge script scripts/DeployArbitrum.s.sol:DeployArbitrum --rpc-url arbitrum $(common-flags)
deploy-avalanche :; forge script scripts/DeployAvalanche.s.sol:DeployAvalanche --rpc-url avalanche $(common-flags)
deploy-base :; forge script scripts/DeployBase.s.sol:DeployBase --rpc-url base $(common-flags)
deploy-bnb :; forge script scripts/DeployBnb.s.sol:DeployBNB --rpc-url bnb $(common-flags)
deploy-gnosis :; forge script scripts/DeployGnosis.s.sol:DeployGnosis --rpc-url gnosis $(common-flags)
deploy-metis :; forge script scripts/DeployMetis.s.sol:DeployMetis --rpc-url metis $(common-flags)
deploy-optimism :; forge script scripts/DeployOptimism.s.sol:DeployOptimism --rpc-url optimism $(common-flags)
deploy-polygon :; forge script scripts/DeployPolygon.s.sol:DeployPolygon --rpc-url polygon $(common-flags)
deploy-scroll :; forge script scripts/DeployScroll.s.sol:DeployScroll --rpc-url scroll $(common-flags)

deploy-weeth-mainnet :; forge script scripts/DeployEthereumWeEth.s.sol:DeployWeEthEthereum --rpc-url mainnet $(common-flags)


# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@npx prettier ${before} ${after} --write
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md
