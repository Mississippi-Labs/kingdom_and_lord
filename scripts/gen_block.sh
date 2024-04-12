#!/bin/bash

set +xo pipefail
export WORLD_ADDRESS=$(cat ./manifests/dev/manifest.json | jq -r '.world.address')
export ACTIONS_ADDRESS=$(cat ./manifests/dev/manifest.json| jq -r '.contracts[] | select(.name == "kingdom_lord::actions::kingdom_lord_controller" ).address')
while true; do
    sozo execute --world $WORLD_ADDRESS --rpc-url http://localhost:5050 \
    --private-key 0x2bbf4f9fd0bbb2e60b0316c1fe0b76cf7a4d0198bd493ced9b8df2a3a24d68a --account-address 0xb3ff441a68610b30fd5e2abbf3a1548eb6ba6f3559f2862bf2dc757e5828ca \
        $ACTIONS_ADDRESS get_resource --calldata 0x2bbf4f9fd0bbb2e60b0316c1fe0b76cf7a4d0198bd493ced9b8df2a3a24d68a
    sleep 1
done