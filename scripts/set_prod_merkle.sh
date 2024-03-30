#!/bin/bash
set -xo pipefail
pushd $(dirname "$0")/..

echo "Setting pay address for upgrading"
export ADMIN_ADDRESS=$(cat ./target/$TARGET_NAME/manifest.json | jq -r '.contracts[] | select(.name == "kingdom_lord::admin::kingdom_lord_admin" ).address')
sozo execute 0x17acb0793d3bfdf9b8058d6ba25215bed0df3949007d0b7676ad335736e444f \
   set_config --calldata 0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7,0,100,0x6162896d1d7ab204c7ccac6dd5f8e9e7c25ecd5ae4fcb4ad32e57786bb46e03,0x78b9b63bbe5319f132fa94fa01bd90b60739760cb1385b3b3490459e78fd55f \
   --rpc-url http://localhost:5050
echo "Setting pay address for upgrading done"