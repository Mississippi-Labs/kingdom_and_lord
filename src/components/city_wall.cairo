
use kingdom_lord::models::level::{LevelTrait, Level, LevelUpTrait};
use starknet::ContractAddress;
#[derive(Model, Copy, Drop, Serde)]
struct CityWall{
    #[key]
    player: ContractAddress,
    building_id: u64,
    level: Level,
    population:u64,
    attack_power: u64,
    defense_power: u64,
}


impl CityWallLevelTrait of LevelUpTrait<CityWall, (u64, u64)>{

    fn level_up(ref self: CityWall, value: (u64, u64)){
        self.level.level_up(());
        let (combined_value, population) = value;
        self.population += population;

        let attack_power = combined_value / 1000;
        let defense_power = combined_value % 1000;
        self.attack_power = attack_power;
        self.defense_power = defense_power;
    }
}


impl CityWallGetLevel of LevelTrait<CityWall>{
    fn get_level(self: @CityWall) -> Level{
        self.level.get_level()
    }
}