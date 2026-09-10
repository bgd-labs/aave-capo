# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
install:; forge install && pnpm install
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; make unit-test && make adapters-test
unit-test   :; forge test --match-path "tests/unit-tests/*" -vvv
adapters-test   :; forge test --match-path "tests/adapters/*" -vvv

# Lint
lint  :; pnpm run lint:fix

# Deploy

## Common
common-flags := --ledger --mnemonic-indexes $(MNEMONIC_INDEX) --sender $(LEDGER_SENDER) --verify -vvvv --broadcast --slow
common-flags-pk := --sender $(SENDER) --private-key ${PRIVATE_KEY} --verify -vvvv --slow --broadcast
common-flags-acc := --account $(account) --verify -vvvv --slow --broadcast

## Scripts: add new ones if necessary
SCRIPT_mainnet := DeployEthereum
SCRIPT_arbitrum := DeployArbitrum
SCRIPT_base := DeployBase
SCRIPT_linea := DeployLinea
SCRIPT_bnb := DeployBnb
SCRIPT_avalanche := DeployAvalanche
SCRIPT_scroll := DeployScroll
SCRIPT_mantle := DeployMantle
SCRIPT_soneium := DeploySoneium
SCRIPT_ink := DeployInk
SCRIPT_plasma := DeployPlasma
SCRIPT_megaeth := DeployMegaEth
SCRIPT_gnosis := DeployGnosis
SCRIPT_xlayer := DeployXLayer
SCRIPT_monad := DeployMonad
SCRIPT_arc := DeployArc

## Per-chain verifier overrides: chains default to etherscan via --verify; chains on other explorers
## need explicit flags. Empty for any chain without an entry below.
VERIFIER_ink := --verifier blockscout --verifier-url https://explorer.inkonchain.com/api/
VERIFIER_xlayer := --verifier oklink --verifier-url https://www.oklink.com/api/v5/explorer/contract/verify-source-code-plugin/xlayer
VERIFIER_arc := --verifier blockscout --verifier-url https://explorer.arc.io/api/

### usage: make deploy adapter=WeEth chain=mainnet
deploy:
	@if [ -z "$(adapter)" ] || [ -z "$(chain)" ]; then \
		echo "usage: make deploy adapter=WeEth chain=mainnet"; exit 1; fi
	@script="${SCRIPT_$(chain)}"; \
	if [ -z "$$script" ]; then echo "unknown chain: $(chain)"; exit 1; fi; \
	echo "forge script scripts/$$script.s.sol:Deploy$(adapter) --rpc-url $(chain) $(common-flags) ${VERIFIER_$(chain)}"; \
	forge script scripts/$$script.s.sol:Deploy$(adapter) --rpc-url $(chain) $(common-flags) ${VERIFIER_$(chain)}

deploy-pk:
	@if [ -z "$(adapter)" ] || [ -z "$(chain)" ]; then \
		echo "usage: make deploy-pk adapter=WeEth chain=mainnet"; exit 1; fi
	@script="${SCRIPT_$(chain)}"; \
	if [ -z "$$script" ]; then echo "unknown chain: $(chain)"; exit 1; fi; \
	echo "forge script scripts/$$script.s.sol:Deploy$(adapter) --rpc-url $(chain) $(common-flags-pk) ${VERIFIER_$(chain)}"; \
	forge script scripts/$$script.s.sol:Deploy$(adapter) --rpc-url $(chain) $(common-flags-pk) ${VERIFIER_$(chain)}

deploy-acc:
	@if [ -z "$(adapter)" ] || [ -z "$(chain)" ] || [ -z "$(account)" ]; then \
		echo "usage: make deploy-acc adapter=WeEth chain=mainnet account=deployer"; exit 1; fi
	@script="${SCRIPT_$(chain)}"; \
	if [ -z "$$script" ]; then echo "unknown chain: $(chain)"; exit 1; fi; \
	echo "forge script scripts/$$script.s.sol:Deploy$(adapter) --rpc-url $(chain) $(common-flags-acc) ${VERIFIER_$(chain)}"; \
	forge script scripts/$$script.s.sol:Deploy$(adapter) --rpc-url $(chain) $(common-flags-acc) ${VERIFIER_$(chain)}

# Utilities
download :; cast source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@pnpm exec prettier ${before} ${after} --write
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md
