#!/bin/bash
set -xo pipefail

source "$(dirname "$0")/local_env.sh"

pushd $(dirname "$0")/..

# enable system -> component authorizations
COMPONENTS=("SpawnStatus" "Barn" "BarnStorage" "Barrack" "Troops" "BarrackUnderTraining" "BarrackWaitingToTrain" "CityBuilding" "UnderUpgrading" "WaitingToUpgrade" "CityHall" "College" "OuterCity" "Stable" "StableUnderTraining" "StableWaitingToTrain" "BuildingAreaInfo" "Warehouse" "WarehouseStorage" "CityWall" "Embassy" "PlayerVillage" "GlobeLocation" "VillageConfirm" "AmbushInfo")

for component in ${COMPONENTS[@]}; do
    sozo auth grant --world $WORLD_ADDRESS --rpc-url $RPC_URL writer  $component,$ACTIONS_ADDRESS 
    # time out for 1 second to avoid rate limiting
    sleep 1
done

echo "Default authorizations have been successfully set."

echo "Setting pay address for upgrading"


sozo execute --world $WORLD_ADDRESS --rpc-url $RPC_URL \
    $ADMIN_ADDRESS \
   set_config --calldata 0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7,0,100,0x6162896d1d7ab204c7ccac6dd5f8e9e7c25ecd5ae4fcb4ad32e57786bb46e03,0x608f06197fc3aab41e774567c8e4b7e8fa5dae821240eda6b39f22939315f8c
echo "Setting pay address for upgrading done"