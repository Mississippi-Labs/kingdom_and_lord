#!/bin/bash

set +xo pipefail

while true; do
    sozo execute --private-key 0x2bbf4f9fd0bbb2e60b0316c1fe0b76cf7a4d0198bd493ced9b8df2a3a24d68a --account-address 0xb3ff441a68610b30fd5e2abbf3a1548eb6ba6f3559f2862bf2dc757e5828ca --rpc-url http://localhost:5050 \
        0x1c9c0eac696e8b998fd586792939e7d902312e08ec45b6795de12e52b723e10 get_resource --calldata 0x2bbf4f9fd0bbb2e60b0316c1fe0b76cf7a4d0198bd493ced9b8df2a3a24d68a
    sleep 1
done