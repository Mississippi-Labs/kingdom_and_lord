#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# echo "dir: $SCRIPT_DIR"
export STARKNET_RPC="http://localhost:5050"
export STARKNET_KEYSTORE="$SCRIPT_DIR/../account.key"
