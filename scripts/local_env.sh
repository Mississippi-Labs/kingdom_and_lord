#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
# echo "dir: $SCRIPT_DIR"
export STARKNET_RPC="http://localhost:5050"
export STARKNET_KEYSTORE="$SCRIPT_DIR/../account.key"

if [[ -z "${DEPLOY_RPC_URL+x}" ]]
then
    export RPC_URL="http://localhost:5050"
else
    export RPC_URL="$DEPLOY_RPC_URL"
fi

if [[ -z "${TARGET_NAME+x}" ]]
then
    export TARGET_NAME="dev"
else
    echo "profile target is $TARGET_NAME"
fi

export WORLD_ADDRESS=$(cat ./manifests/$TARGET_NAME/manifest.json | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat ./manifests/$TARGET_NAME/manifest.json| jq -r '.contracts[] | select(.name == "kingdom_lord::actions::kingdom_lord_controller" ).address')

export ADMIN_ADDRESS=$(cat ./manifests/$TARGET_NAME/manifest.json| jq -r '.contracts[] | select(.name == "kingdom_lord::admin::kingdom_lord_admin" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS 
echo " "
echo actions : $ACTIONS_ADDRESS
echo "---------------------------------------------------------------------------"
