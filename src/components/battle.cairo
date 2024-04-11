use starknet::ContractAddress;


#[derive(Model, Copy, Drop, Serde)]
struct AmbushInfo {
    #[key]
    player: ContractAddress,
    ambush_hash: felt252,
    millitia: u64,
    guard: u64,
    heavy_infantry: u64,
    scouts: u64,
    knights: u64,
    heavy_knights: u64
}


#[starknet::component]
mod battle_component {
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::{AmbushInfo};
    use kingdom_lord::models::time::get_current_time;
    use kingdom_lord::interface::Error;

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl BattleInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of BattleInternalTrait<TContractState> {
        fn create_ambush(
            self: @ComponentState<TContractState>,
            ambush_hash: felt252,
            millitia: u64,
            guard: u64,
            heavy_infantry: u64,
            scouts: u64,
            knights: u64,
            heavy_knights: u64
        ) -> Result<(), Error> {
            let player = get_caller_address();
            let world = self.get_contract().world();
            let ambush_info = AmbushInfo {
                player,
                ambush_hash,
                millitia,
                guard,
                heavy_infantry,
                scouts,
                knights,
                heavy_knights
            };

            set!(world, (ambush_info));
            Result::Ok(())
        }

        fn reveal_ambush(self: @ComponentState<TContractState>, x: u64, y: u64, time: u64, nonce: u64) -> Result<bool, Error>{
            let player = get_caller_address();
            let world = self.get_contract().world();
            let ambush_info = get!(world, (player), AmbushInfo);
            let data: Array<felt252> = array![ambush_info.millitia.into(), ambush_info.guard.into(), ambush_info.heavy_infantry.into(), ambush_info.scouts.into(), ambush_info.knights.into(), ambush_info.heavy_knights.into(), time.into(), nonce.into()];
            let hash = core::poseidon::poseidon_hash_span(data.span());

            Result::Ok(hash == ambush_info.ambush_hash)
        }

        fn attack(self: @ComponentState<TContractState>){}
        fn reveal_attach(self: @ComponentState<TContractState>){}
        fn reveal_hide(self: @ComponentState<TContractState>){}
    }
}
