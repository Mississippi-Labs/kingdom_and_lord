use core::traits::Into;
use starknet::ContractAddress;
use super::super::models::resource::{Food, Resource};
use kingdom_lord::models::level::Level;
use kingdom_lord::models::building::{BuildingUpgradeResource};
use kingdom_lord::models::level::{LevelTrait, LevelUpTrait};

#[derive(Model, Copy, Drop, Serde)]
struct College {
    #[key]
    player: ContractAddress,
    building_id: u64,
    level: Level,
    population: u64
}


#[generate_trait]
impl CollegeImpl of CollegeExtension {
    fn is_guard_allowed(self: @College) -> bool {
        *self.level.level >= 5_u64
    }

    fn is_heavy_infantry_allowed(self: @College) -> bool {
        *self.level.level >= 10_u64
    }

    fn is_knight_allowed(self: @College) -> bool {
        *self.level.level >= 15_u64
    }

    fn is_heavy_knight_allowed(self: @College) -> bool {
        *self.level.level >= 20_u64
    }
}
impl CollegeLevelTrait of LevelUpTrait<College, (u64, u64)> {
    fn level_up(ref self: College, value: (u64, u64)) {
        self.level.level_up(());
        let (_, population) = value;
        self.population += population;
    }
}

impl CollegeGetLevel of LevelTrait<College> {
    fn get_level(self: @College) -> Level {
        self.level.get_level()
    }
}


#[starknet::component]
mod college_component {
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use kingdom_lord::components::barrack::{Barrack, SoldierKind};
    use kingdom_lord::components::stable::Stable;
    use super::{College, CollegeImpl};

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl CollegeInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of CollegeInternalTrait<TContractState> {
        fn is_solider_allowed(
            self: @ComponentState<TContractState>, soldier_kind: SoldierKind
        ) -> bool {
            let player = get_caller_address();
            let world = self.get_contract().world();
            match soldier_kind {
                SoldierKind::Millitia => {
                    let barrack = get!(world, (player), (Barrack));
                    barrack.level.level > 0
                },
                SoldierKind::Guard => {
                    let college = get!(world, (player), (College));
                    let barrack = get!(world, (player), (Barrack));
                    college.is_guard_allowed() && barrack.level.level > 0
                },
                SoldierKind::HeavyInfantry => {
                    let college = get!(world, (player), (College));
                    let barrack = get!(world, (player), (Barrack));
                    college.is_heavy_infantry_allowed() && barrack.level.level > 0
                },
                SoldierKind::Scouts => {
                    let stable = get!(world, (player), (Stable));
                    stable.level.level > 0
                },
                SoldierKind::Knights => {
                    let college = get!(world, (player), (College));
                    let stable = get!(world, (player), (Stable));
                    college.is_knight_allowed() && stable.level.level > 0
                },
                SoldierKind::HeavyKnights => {
                    let college = get!(world, (player), (College));
                    let stable = get!(world, (player), (Stable));
                    college.is_heavy_knight_allowed() && stable.level.level > 0
                },
            }
        }
    }
}
