#!/bin/bash
set -xo pipefail
pushd $(dirname "$0")/..

echo "Setting pay address for upgrading"
export ADMIN_ADDRESS=$(cat ./target/$TARGET_NAME/manifest.json | jq -r '.contracts[] | select(.name == "kingdom_lord::admin::kingdom_lord_admin" ).address')
sozo execute 0x17acb0793d3bfdf9b8058d6ba25215bed0df3949007d0b7676ad335736e444f \
   set_config --calldata 0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7,0,100,0x6162896d1d7ab204c7ccac6dd5f8e9e7c25ecd5ae4fcb4ad32e57786bb46e03,0x608f06197fc3aab41e774567c8e4b7e8fa5dae821240eda6b39f22939315f8c \
   --rpc-url http://localhost:5050
echo "Setting pay address for upgrading done"