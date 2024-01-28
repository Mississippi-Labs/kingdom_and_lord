from starknet_py.hash.address import compute_address
from starknet_py.net.account.account import Account
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.models import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair
from starknet_py.net.full_node_client import FullNodeClient
import asyncio
from starknet_py.contract import Contract
from starknet_py.common import create_casm_class, create_compiled_contract
from starknet_py.hash.casm_class_hash import compute_casm_class_hash

with open("target/dev/kingdom_lord_ERC20.contract_class.json", encoding="utf-8") as f:
    compiled_contract = f.read()

with open("target/dev/kingdom_lord_ERC20.compiled_contract_class.json", encoding="utf-8") as f:
    casm = f.read()

async def main():
    node_url = "http://localhost:5050"
    client = FullNodeClient(node_url=node_url)
    chain_id = await client.get_chain_id()
    chain_id = int(chain_id, 16)
    print(chain_id)
    key_pair = KeyPair.from_private_key("0x1c9053c053edf324aec366a34c6901b1095b07af69495bffec7d7fe21effb1b")
    address =int("0x6b86e40118f29ebe393a75469b4d926c7a44c2e2681b6d319520b7c1156d114", 16)
    account = Account(address=address, client=client, key_pair=key_pair, chain=chain_id)
    balance = await account.get_balance("0x49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7")
    print(balance)
    compiled_class_hash=    compute_casm_class_hash(create_casm_class(casm))

    declare_tx = await account.sign_declare_v2(compiled_contract,compiled_class_hash=compiled_class_hash, max_fee=int(1e20))
    print(declare_tx)
    result = await account.client.declare(declare_tx)
    print(result)
    # deploy_result = await Contract.deploy_contract_v3(
    #     account=account,
    #     class_hash="0x02a8846878b6ad1f54f6ba46f5f40e11cee755c677f130b2c4b60566c9003f1f",
    #     abi=[],
    #     constructor_args=[],
    #     max_fee=int(1e16),
    # )

asyncio.run(main())