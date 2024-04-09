
use kingdom_lord::models::level::{LevelTrait, Level, LevelUpTrait};
use starknet::ContractAddress;


#[derive(Model, Copy, Drop, Serde)]
struct Embassy{
    #[key]
    player: ContractAddress,
    building_id: u64,
    level: Level,
    population:u64,
    ally_amount: u64,
}


impl EmbassyLevelTrait of LevelUpTrait<Embassy, (u64, u64)>{

    fn level_up(ref self: Embassy, value: (u64, u64)){
        self.level.level_up(());
        let (ally_amount, population) = value;
        self.population += population;

        self.ally_amount = ally_amount;
    }
}


impl EmbassyGetLevel of LevelTrait<Embassy>{
    fn get_level(self: @Embassy) -> Level{
        self.level.get_level()
    }
}