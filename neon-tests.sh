#!/bin/sh

set -e

wget -O docker-compose-test.yml https://raw.githubusercontent.com/neonlabsorg/proxy-model.py/develop/proxy/docker-compose-test.yml

# Run Neon
export REVISION=v0.12.0
export NEON_EVM_COMMIT=v0.12.0
export FAUCET_COMMIT=v0.12.0
docker-compose -f docker-compose-test.yml up -d --quiet-pull

# Run tests
MNEMONIC_PHRASE="slide clip fancy range predict resource stuff once all insect sniff acid"
docker run --rm --network host -e MNEMONIC_PHRASE="$MNEMONIC_PHRASE" \
  ghcr.io/inc4/yearn-vaults:master \
  bash -c " \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie run scripts/neon_faucet.py --network neon && \
    brownie test -v \
      tests/integration \
      tests/functional/registry \
      tests/functional/strategy \
      tests/functional/wrappers \
    --network neon"

# Stop Neon
docker-compose -f docker-compose-test.yml down
