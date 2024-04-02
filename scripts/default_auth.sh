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

export WORLD_ADDRESS=$(cat ./manifests/deployments/KATANA.json | jq -r '.world.address')

export ACTIONS_ADDRESS=$(cat ./manifests/deployments/KATANA.json| jq -r '.contracts[] | select(.name == "kingdom_lord::actions::kingdom_lord_controller" ).address')

export ADMIN_ADDRESS=$(cat ./manifests/deployments/KATANA.json| jq -r '.contracts[] | select(.name == "kingdom_lord::admin::kingdom_lord_admin" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS 
echo " "
echo actions : $ACTIONS_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COMPONENTS=("SpawnStatus" "Barn" "BarnStorage" "Barrack" "Troops" "BarrackUnderTraining" "BarrackWaitingToTrain" "CityBuilding" "UnderUpgrading" "WaitingToUpgrade" "CityHall" "College" "OuterCity" "Stable" "StableUnderTraining" "StableWaitingToTrain" "BuildingAreaInfo" "Warehouse" "WarehouseStorage")

for component in ${COMPONENTS[@]}; do
    sozo auth grant --world $WORLD_ADDRESS --rpc-url $RPC_URL writer  $component,$ACTIONS_ADDRESS 
    # time out for 1 second to avoid rate limiting
    sleep 1
done

echo "Default authorizations have been successfully set."

echo "Setting pay address for upgrading"

sozo execute --world $WORLD_ADDRESS --rpc-url $RPC_URL \
    $ADMIN_ADDRESS \
    set_config --calldata 0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7,0,100,0x6162896d1d7ab204c7ccac6dd5f8e9e7c25ecd5ae4fcb4ad32e57786bb46e03,0x686c6d5767c7589e969d41aff9ff070fecd03c23aef65128668c36613659e49 \
   
echo "Setting pay address for upgrading done"