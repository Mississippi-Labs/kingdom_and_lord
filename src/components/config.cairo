use starknet::ContractAddress;
use kingdom_lord::merkle::merkle_tree::{MerkleTreeImpl, MerkleTree, Hasher};
use kingdom_lord::merkle::merkle_tree::poseidon::PoseidonHasherImpl;

#[derive(Model, Copy, Drop, Serde)]
struct Config {
    #[key]
    id_config: u64,
    erc20_addr: ContractAddress,
    amount: u256,
    receiver: ContractAddress,
    merkle_root: felt252
}

fn verify_proof(config: Config, data: Span<felt252>, proof: Span<felt252>) -> bool{

    let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeImpl::<_, PoseidonHasherImpl>::new();
    let leaf = core::poseidon::poseidon_hash_span(data);
    MerkleTreeImpl::<
        _, PoseidonHasherImpl
    >::verify(ref merkle_tree,  config.merkle_root, leaf, proof)
}