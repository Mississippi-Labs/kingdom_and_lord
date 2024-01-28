use kingdom_lord::models::building_kind::BuildingKind;
use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct BuildingAreaInfo {
    #[key]
    player: ContractAddress,
    #[key]
    building_id: u64,
    building_kind: u64,
}


#[starknet::component]
mod universal_component {
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::BuildingAreaInfo;
    use kingdom_lord::constants::{CITY_HALL_START_INDEX, WAREHOUSE_START_INDEX, BARN_START_INDEX};
    use kingdom_lord::models::building::BuildingUpgradeInfo;
    use kingdom_lord::models::building_kind::BuildingKind;
    use kingdom_lord::components::city_hall::{CityHall};
    use kingdom_lord::components::city_building::{CityBuilding};
    use kingdom_lord::components::warehouse::{Warehouse};
    use kingdom_lord::components::barn::{Barn};
    use kingdom_lord::components::barrack::{Barrack, BarrackLevelTrait, BarrackGetLevel};
    use kingdom_lord::models::level::{LevelTrait, LevelUpTrait, Level, LevelExtentionTraitsImpl};

    #[storage]
    struct Storage {}


    #[generate_trait]
    impl UniversalInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of UniversalInternalTrait<TContractState> {
        fn building_kind(self: @ComponentState<TContractState>, building_id: u64) -> BuildingKind {
            let world = self.get_contract().world();
            let player = get_caller_address();
            let info: BuildingAreaInfo = get!(world, (player, building_id), (BuildingAreaInfo));
            info.building_kind.into()
        }


        fn is_next_level_valid(
            self: @ComponentState<TContractState>,
            building_id: u64,
            building_kind: BuildingKind,
            next_level: Level
        ) -> bool {
            let world = self.get_contract().world();
            let player = get_caller_address();
            match building_kind {
                BuildingKind::None => panic!("None building could be found"),
                BuildingKind::WoodBuilding => {
                    let city_building = get!(world, (player, building_id), (CityBuilding));
                    return city_building.is_next_level_valid(next_level);
                },
                BuildingKind::BrickBuilding => {
                    let city_building = get!(world, (player, building_id), (CityBuilding));
                    return city_building.is_next_level_valid(next_level);
                },
                BuildingKind::SteelBuilding => {
                    let city_building = get!(world, (player, building_id), (CityBuilding));
                    return city_building.is_next_level_valid(next_level);
                },
                BuildingKind::FoodBuilding => {
                    let city_building = get!(world, (player, building_id), (CityBuilding));
                    return city_building.is_next_level_valid(next_level);
                },
                BuildingKind::CityHall => {
                    let city_hall = get!(world, (player, building_id), (CityHall));
                    return city_hall.is_next_level_valid(next_level);
                },
                BuildingKind::Warehouse => {
                    let warehouse = get!(world, (player, building_id), (Warehouse));
                    return warehouse.is_next_level_valid(next_level);
                },
                BuildingKind::Barn => {
                    let barn = get!(world, (player, building_id), (Barn));
                    return barn.is_next_level_valid(next_level);
                },
                BuildingKind::Barrack => {
                    let barrack = get!(world, (player, building_id), (Barrack));
                    return barrack.is_next_level_valid(next_level);
                },
            }
        }

        fn level_up(self: @ComponentState<TContractState>, building_id: u64, building_kind: BuildingKind, value: (u64, u64)) {
            let world = self.get_contract().world();
            let player = get_caller_address();
            match building_kind {
                BuildingKind::None => panic!("None building could be found"),
                BuildingKind::WoodBuilding => {
                    let mut city_building = get!(world, (player, building_id), (CityBuilding));
                    city_building.level_up(value);
                    set!(world, (city_building));
                },
                BuildingKind::BrickBuilding => {
                    let mut city_building = get!(world, (player, building_id), (CityBuilding));
                    city_building.level_up(value);
                    set!(world, (city_building));
                },
                BuildingKind::SteelBuilding => {
                    let mut city_building = get!(world, (player, building_id), (CityBuilding));
                    city_building.level_up(value);
                    set!(world, (city_building));
                },
                BuildingKind::FoodBuilding => {
                    let mut city_building = get!(world, (player, building_id), (CityBuilding));
                    city_building.level_up(value);
                    set!(world, (city_building));
                },
                BuildingKind::CityHall => {
                    let mut city_hall = get!(world, (player, building_id), (CityHall));
                    city_hall.level_up(value);
                    set!(world, (city_hall));
                },
                BuildingKind::Warehouse => {
                    let mut warehouse = get!(world, (player, building_id), (Warehouse));
                    warehouse.level_up(value);
                    set!(world, (warehouse));
                },
                BuildingKind::Barn => {
                    let mut barn = get!(world, (player, building_id), (Barn));
                    barn.level_up(value);
                    set!(world, (barn));
                },
                BuildingKind::Barrack => {
                    let mut barrack = get!(world, (player, building_id), (Barrack));
                    barrack.level_up(value);
                    set!(world, (barrack));
                },
            }
        }

        fn get_total_food_consume_rate(self: @ComponentState<TContractState>, player: ContractAddress){

        }
    }
}
