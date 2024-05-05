use starknet::ContractAddress;
use starknet::get_caller_address;
use super::city_building::CityBuilding;
use super::super::models::resource::{Resource, Wood, Brick, Steel, Food};
use super::super::models::growth::{GrowthRate};
use super::super::models::level::Level;
use core::Serde;

#[starknet::interface]
trait OuterCityTrait<TState> {
    fn get_minable_resource(
        self: @TState, player: ContractAddress
    ) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>, Resource<Food>);
    fn get_last_mined_time(self: @TState, player: ContractAddress) -> u64;
}

#[derive(Model, Copy, Drop, Serde)]
struct OuterCity {
    #[key]
    player: ContractAddress,
    last_mined_time: u64
}

#[starknet::component]
mod outer_city_component {
    use starknet::{get_caller_address, ContractAddress};
    use kingdom_lord::models::time::get_current_time;
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::{CityBuilding, Level};
    use super::{Resource, Wood, Brick, Steel, Food};
    use super::super::super::models::building::{Minable};
    use kingdom_lord::constants::{
        WOOD_BUILDING_START_INDEX, STEEL_BUILDING_START_INDEX, BRICK_BUILDING_START_INDEX,
        FOOD_BUILDING_START_INDEX, WOOD_BUILDING_COUNT, BRICK_BUILDING_COUNT,
        STEEL_BUILDING_COUNT, FOOD_BUILDING_COUNT
    };
    use super::super::super::models::growth::Growth;
    use super::{OuterCityTrait, OuterCity};
    use super::{GrowthRate};
    use kingdom_lord::helpers::array::{MinableArrayImpl, GrowthArrayImpl};

    #[storage]
    struct Storage {}


    #[embeddable_as(OuterCityTraitImpl)]
    impl OuterCityImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of OuterCityTrait<ComponentState<TContractState>> {
        fn get_minable_resource(
            self: @ComponentState<TContractState>, player: ContractAddress
        ) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>, Resource<Food>) {
            let outer_city = get!(self.get_contract().world(), player, (OuterCity));
            let current_block_time = get_current_time();
            let wood: Resource<Wood> = self
                .get_wood_building(player)
                .get_minable(outer_city.last_mined_time, current_block_time);
            let brick: Resource<Brick> = self
                .get_brick_building(player)
                .get_minable(outer_city.last_mined_time, current_block_time);
            let steel: Resource<Steel> = self
                .get_steel_building(player)
                .get_minable(outer_city.last_mined_time, current_block_time);
            let food: Resource<Food> = self
                .get_food_building(player)
                .get_minable(outer_city.last_mined_time, current_block_time);
            (wood, brick, steel, food)
        }

        fn get_last_mined_time(
            self: @ComponentState<TContractState>, player: ContractAddress
        ) -> u64 {
            get!(self.get_contract().world(), player, (OuterCity)).last_mined_time
        }
    }

    #[generate_trait]
    impl OuterCityInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of OuterCityInternalTrait<TContractState> {
        fn get_build_with_index_range(
            self: @ComponentState<TContractState>, start: u64, count: u64, player: ContractAddress
        ) -> Array<CityBuilding> {
            let mut res = array![];
            let mut index = start;
            let end_index = start + count;
            loop {
                if end_index == index {
                    break;
                }
                let building = get!(self.get_contract().world(), (player, index), (CityBuilding));
                res.append(building);
                index += 1;
            };
            res
        }

        fn get_wood_building(
            self: @ComponentState<TContractState>, player: ContractAddress
        ) -> Array<CityBuilding> {
            self.get_build_with_index_range(WOOD_BUILDING_START_INDEX, WOOD_BUILDING_COUNT, player)
        }

        fn get_steel_building(
            self: @ComponentState<TContractState>, player: ContractAddress
        ) -> Array<CityBuilding> {
            self.get_build_with_index_range(STEEL_BUILDING_START_INDEX, STEEL_BUILDING_COUNT, player)
        }

        fn get_brick_building(
            self: @ComponentState<TContractState>, player: ContractAddress
        ) -> Array<CityBuilding> {
            self.get_build_with_index_range(BRICK_BUILDING_START_INDEX, BRICK_BUILDING_COUNT, player)
        }

        fn get_food_building(
            self: @ComponentState<TContractState>, player: ContractAddress
        ) -> Array<CityBuilding> {
            self.get_build_with_index_range(FOOD_BUILDING_START_INDEX, FOOD_BUILDING_COUNT, player)
        }

        fn get_growth_rate(
            self: @ComponentState<TContractState>, player: ContractAddress,
        ) -> (GrowthRate<Wood>, GrowthRate<Brick>, GrowthRate<Steel>, GrowthRate<Food>) {
            let wood_growth_rate: GrowthRate<Wood> = self
                .get_wood_building(player)
                .get_growth_rate();
            let brick_growth_rate: GrowthRate<Brick> = self
                .get_brick_building(player)
                .get_growth_rate();
            let steel_growth_rate: GrowthRate<Steel> = self
                .get_steel_building(player)
                .get_growth_rate();
            let food_growth_rate: GrowthRate<Food> = self
                .get_food_building(player)
                .get_growth_rate();
            (wood_growth_rate, brick_growth_rate, steel_growth_rate, food_growth_rate)
        }

        fn mine(
            self: @ComponentState<TContractState>, player: ContractAddress,
        ) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>, Resource<Food>) {
            let world = self.get_contract().world();
            let mut outer_city = get!(world, player, (OuterCity));
            let current_block_time = get_current_time();
            let wood = self
                .get_wood_building(player)
                .mine(outer_city.last_mined_time, current_block_time);
            let brick = self
                .get_brick_building(player)
                .mine(outer_city.last_mined_time, current_block_time);
            let steel = self
                .get_steel_building(player)
                .mine(outer_city.last_mined_time, current_block_time);
            let food = self
                .get_food_building(player)
                .mine(outer_city.last_mined_time, current_block_time);
            outer_city.last_mined_time = current_block_time;
            set!(world, (outer_city));
            (wood, brick, steel, food)
        }
    }
}
