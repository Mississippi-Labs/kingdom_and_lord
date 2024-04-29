use starknet::ContractAddress;


#[derive(Model, Copy, Drop, Serde)]
struct AmbushInfo {
    #[key]
    player: ContractAddress,
    #[key]
    ambush_hash: felt252,
    millitia: u64,
    guard: u64,
    heavy_infantry: u64,
    scouts: u64,
    knights: u64,
    heavy_knights: u64,
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
    use kingdom_lord::components::barrack::{Troops, soldier_info, SoldierKind};

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
            let mut troops = get!(world, (player), Troops);
            if millitia > troops.millitia
                && guard > troops.guard
                && heavy_infantry > troops.heavy_infantry
                && scouts > troops.scouts
                && knights > troops.knights
                && heavy_knights > troops.heavy_knights {
                return Result::Err(Error::NotEnoughSoldier);
            }
            let ambush_info = AmbushInfo {
                player,
                ambush_hash,
                millitia,
                guard,
                heavy_infantry,
                scouts,
                knights,
                heavy_knights,
                is_revealed: false
            };

            troops.millitia -= millitia;
            troops.guard -= guard;
            troops.heavy_infantry -= heavy_infantry;
            troops.scouts -= scouts;
            troops.knights -= knights;
            troops.heavy_knights -= heavy_knights;

            set!(world, (troops));
            set!(world, (ambush_info));
            Result::Ok(())
        }

        fn reveal_ambush(
            self: @ComponentState<TContractState>,
            hash: felt252,
            x: u64,
            y: u64,
            time: u64,
            nonce: u64
        ) -> Result<bool, Error> {
            let player = get_caller_address();
            let world = self.get_contract().world();
            let mut ambush_info = get!(world, (player, hash), AmbushInfo);
            let data: Array<felt252> = array![
                ambush_info.millitia.into(),
                ambush_info.guard.into(),
                ambush_info.heavy_infantry.into(),
                ambush_info.scouts.into(),
                ambush_info.knights.into(),
                ambush_info.heavy_knights.into(),
                x.into(), y.into(), time.into(), nonce.into()
            ];
            let hash = core::poseidon::poseidon_hash_span(data.span());

            let is_valid_revealed = hash == ambush_info.ambush_hash;
            if is_valid_revealed {
                ambush_info.is_revealed = true;
                set!(world, (ambush_info));
            }

            Result::Ok(is_valid_revealed)
        }

        fn attack(self: @ComponentState<TContractState>, mut attacker: AmbushInfo, mut defender: Troops) {
            let world = self.get_contract().world();
            let attack_power = attacker.millitia * soldier_info(SoldierKind::Millitia).attack_power
                + attacker.guard * soldier_info(SoldierKind::Guard).attack_power 
                + attacker.heavy_infantry * soldier_info(SoldierKind::HeavyInfantry).attack_power 
                + attacker.scouts * soldier_info(SoldierKind::Scouts).attack_power 
                + attacker.knights * soldier_info(SoldierKind::Knights).attack_power 
                + attacker.heavy_knights * soldier_info(SoldierKind::HeavyKnights).attack_power;
            
            let defender_power = defender.millitia * soldier_info(SoldierKind::Millitia).defense_power
                + defender.guard * soldier_info(SoldierKind::Guard).defense_power 
                + defender.heavy_infantry * soldier_info(SoldierKind::HeavyInfantry).defense_power 
                + defender.scouts * soldier_info(SoldierKind::Scouts).defense_power 
                + defender.knights * soldier_info(SoldierKind::Knights).defense_power 
                + defender.heavy_knights * soldier_info(SoldierKind::HeavyKnights).defense_power;
            
            if attack_power > defender_power{
                defender.millitia = 0;
                defender.guard = 0;
                defender.heavy_infantry = 0;
                defender.scouts = 0;
                defender.knights = 0;
                defender.heavy_knights = 0;

            } else {
                attacker.millitia = 0;
                attacker.guard = 0;
                attacker.heavy_infantry = 0;
                attacker.scouts = 0;
                attacker.knights = 0;
                attacker.heavy_knights = 0;
            }

            set!(world, (attacker));
            set!(world, (defender));
            
        }
        fn reveal_attack(self: @ComponentState<TContractState>) {}
        fn reveal_hide(self: @ComponentState<TContractState>) {}
    }
}
