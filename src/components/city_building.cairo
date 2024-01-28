use core::clone::Clone;
use starknet::ContractAddress;
use kingdom_lord::models::level::{Level,  LevelTrait, LevelUpTrait, LevelExtentionTraitsImpl, LevelImpl, LevelUpTraitImpl};
use kingdom_lord::models::resource::{Resource, Wood, Brick, Steel, Food};
use kingdom_lord::models::growth::{Growth, GrowthRate};
use kingdom_lord::models::building::{ Minable, BuildingUpgradeResource};
use kingdom_lord::models::building_kind::BuildingKind;

#[derive(Model, Copy, Drop, Serde)]
struct CityBuilding {
    #[key]
    player: ContractAddress,
    #[key]
    building_id: u64,
    building_kind: u64,
    level: Level,
    growth_rate: u64,
    food_consume_rate: u64,
}

fn new_city_building(
    player: ContractAddress, building_kind: BuildingKind, growth_rate: u64, level: Level, index: u64
) -> CityBuilding {
    CityBuilding {
        player,
        building_id: index,
        building_kind: building_kind.into(),
        level,
        growth_rate, 
        food_consume_rate: 0,
    }
}
impl CityBuildingGetLevelImpl of LevelTrait<CityBuilding> {
    fn get_level(self: @CityBuilding) -> Level {
        self.level.clone()
    }
}

impl CityBuildingGrowthRate<T> of Growth<CityBuilding, T> {
    fn get_growth_rate(self: @CityBuilding) -> GrowthRate<T> {
        GrowthRate{ amount: *self.growth_rate }
    }
}

impl CityBuildingLevelImpl of LevelUpTrait<CityBuilding, (u64, u64)> {
    fn level_up(ref self: CityBuilding, value:(u64, u64)) {
        self.level.level_up(());
        let (growth_rate, food_consume_rate) = value;
        self.growth_rate = growth_rate;
        self.food_consume_rate = food_consume_rate;
    }
}

impl CityBuildingMinableImpl<R> of Minable<CityBuilding, Resource<R>> {
    fn get_minable(
        self: @CityBuilding, last_time: u64, current_time: u64
    ) -> Resource<R> {
        (*self.growth_rate * (current_time - last_time)).into()
    }

    fn mine(self: @CityBuilding, last_time: u64, current_time: u64) -> Resource<R> {
        self.get_minable(last_time, current_time)
    }
}

