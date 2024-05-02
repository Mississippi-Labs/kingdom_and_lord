use starknet::ContractAddress;
use kingdom_lord::models::army::ArmyGroup;

#[derive(Model, Copy, Drop, Serde)]
struct AmbushInfo {
    #[key]
    ambush_hash: felt252,
    player: ContractAddress,
    army: ArmyGroup,
    created_time: u64,
    is_revealed: bool
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
    use kingdom_lord::components::barrack::{Troops};
    use kingdom_lord::models::army::{ArmyGroup, ArmyGroupExtensionImpl, soldier_info, SoldierKind};
    use kingdom_lord::components::globe::{GlobeLocation, LocationKind};

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
            let current = get_current_time();
            let mut troops = get!(world, (player), Troops);
            match troops.army.split_group(millitia, guard, heavy_infantry, scouts, knights, heavy_knights){
                Result::Err(_) => Result::Err(Error::NotEnoughSoldier),
                Result::Ok(new_group) => {
                    let ambush_info = AmbushInfo {
                        ambush_hash,
                        player,
                        army: new_group,
                        created_time: current,
                        is_revealed: false
                    };
                    set!(world, (troops));
                    set!(world, (ambush_info));
                    Result::Ok(())
                }
            }
        }

        fn reveal_ambush(
            self: @ComponentState<TContractState>,
            hash: felt252,
            x: u64,
            y: u64,
            time: u64,
            nonce: u64
        ) -> bool {
            let world = self.get_contract().world();
            let mut ambush_info = get!(world, (hash), AmbushInfo);
            let data: Array<felt252> = array![
                ambush_info.army.millitia.into(),
                ambush_info.army.guard.into(),
                ambush_info.army.heavy_infantry.into(),
                ambush_info.army.scouts.into(),
                ambush_info.army.knights.into(),
                ambush_info.army.heavy_knights.into(),
                x.into(),
                y.into(),
                time.into(),
                nonce.into()
            ];
            let hash = core::poseidon::poseidon_hash_span(data.span());

            let is_valid_revealed = hash == ambush_info.ambush_hash;
            if is_valid_revealed {
                ambush_info.is_revealed = true;
                set!(world, (ambush_info));
            }

            is_valid_revealed
        }

        fn reveal_attack(
            self: @ComponentState<TContractState>,
            hash: felt252,
            x: u64,
            y: u64,
            time: u64,
            nonce: u64,
            target_x: u64,
            target_y: u64,
            is_robbed: bool
        ) -> Result<(), Error> {
            let is_valid_reveal = self.reveal_ambush(hash, x, y, time, nonce);
            if !is_valid_reveal {
                return Result::Err(Error::InvalidReveal);
            };
            let world = self.get_contract().world();
            let mut ambush_info = get!(world, (hash), AmbushInfo);
            let player = get_caller_address();
            assert!(ambush_info.player == player, "You can only use your own ambush");

            let target_enemy_village = get!(world, (target_x, target_y), GlobeLocation);

            match target_enemy_village.kind{
                LocationKind::Village(enemy_player) =>{
                    let mut enemy_troops = get!(world, (enemy_player), Troops);
                    ambush_info.army.fight(ref enemy_troops.army);

                    ambush_info.is_revealed = true;
                    let mut self_troops = get!(world, (player), Troops);
                    self_troops.army.merge_army(ref ambush_info.army);

                    set!(world, (enemy_troops));
                    set!(world, (self_troops));
                    set!(world, (ambush_info));
                    return Result::Ok(());
                },
                _ => {return Result::Err(Error::LocationNotVillage);}
            }

        }


        fn reveal_hide(
            self: @ComponentState<TContractState>,
            origin_hash: felt252,
            origin_x: u64,
            origin_y: u64,
            origin_time: u64,
            origin_nonce: u64,
            new_hash: felt252,
        ) -> Result<(), Error> {
            let is_valid_reveal = self
                .reveal_ambush(origin_hash, origin_x, origin_y, origin_time, origin_nonce);
            if !is_valid_reveal {
                return Result::Err(Error::InvalidReveal);
            }
            let world = self.get_contract().world();
            let mut ambush_info = get!(world, (origin_hash), AmbushInfo);
            ambush_info.is_revealed = true;
            let new_ambush_info = AmbushInfo {
                ambush_hash: new_hash,
                player: ambush_info.player,
                army: ambush_info.army,
                created_time: get_current_time(),
                is_revealed: false
            };
            set!(world, (ambush_info));
            set!(world, (new_ambush_info));
            Result::Ok(())
        }
    }
}
