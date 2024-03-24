#!/bin/bash
set -xo pipefail
pushd $(dirname "$0")/..

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

export WORLD_ADDRESS=$(cat ./target/$TARGET_NAME/manifest.json | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat ./target/$TARGET_NAME/manifest.json | jq -r '.contracts[] | select(.name == "kingdom_lord::actions::kingdom_lord_controller" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS 
echo " "
echo actions : $ACTIONS_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COMPONENTS=("Barn" "OuterCity" "Warehouse" "CityBuilding" "SpawnStatus" "UnderUpgrading" "CityHall", "BuildingAreaInfo" "Barrack" "Troops" "UnderTraining")

for component in ${COMPONENTS[@]}; do
    sozo auth writer $component $ACTIONS_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    # time out for 1 second to avoid rate limiting
    sleep 1
done

echo "Default authorizations have been successfully set."

echo "Setting pay address for upgrading"
export ADMIN_ADDRESS=$(cat ./target/$TARGET_NAME/manifest.json | jq -r '.contracts[] | select(.name == "kingdom_lord::admin::kingdom_lord_admin" ).address')
sozo execute 0x17acb0793d3bfdf9b8058d6ba25215bed0df3949007d0b7676ad335736e444f set_config --calldata 0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7,0,100,0x6162896d1d7ab204c7ccac6dd5f8e9e7c25ecd5ae4fcb4ad32e57786bb46e03,0x2e3aa949c5d014218a1194b9d5c84c7457a027fc34826547b8dfe5b52d72220
echo "Setting pay address for upgrading done"