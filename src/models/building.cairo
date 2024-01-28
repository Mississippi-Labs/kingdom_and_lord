use core::clone::Clone;
use starknet::ContractAddress;
use super::level::Level;
use super::resource::{Resource, Wood, Brick, Steel, Food};
use super::growth::{Growth, GrowthRate};
use kingdom_lord::constants::BASE_GROW_RATE;

trait Minable<T, R> {
    fn get_minable(self: @T, last_time: u64, current_time: u64) -> R;
    fn mine(self: @T, last_time: u64, current_time: u64) -> R;
}


#[derive(Drop, Introspect, Copy, Serde, Default)]
struct BuildingUpgradeResource {
    wood: Resource<Wood>,
    brick: Resource<Brick>,
    steel: Resource<Steel>,
    food: Resource<Food>,
}

#[derive(Drop, Introspect, Copy, Serde, Default)]
struct BuildingUpgradeInfo {
    required_resource: BuildingUpgradeResource,
    required_time: u64,
    next_level: Level,
    building_id: u64,
}
