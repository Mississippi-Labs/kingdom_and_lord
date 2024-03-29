use starknet::ContractAddress;
use kingdom_lord::models::resource::{Food, Resource};
use super::city_building::{CityBuilding, CityBuildingLevelImpl};
use kingdom_lord::models::level::Level;
use kingdom_lord::models::building::{BuildingUpgradeResource};
use kingdom_lord::models::level::{LevelTrait, LevelUpTrait};
use kingdom_lord::helpers::contract_addr::FmtContractAddr;

#[derive(Model, Drop, Copy, Serde)]
struct UnderUpgrading {
    #[key]
    address: ContractAddress,
    #[key]
    upgrade_id: u64,
    building_id: u64,
    building_kind: u64,
    target_level: Level,
    start_time: u64,
    end_time: u64,
    is_finished: bool,
    is_new_building: bool,
    value: u64,
    population:u64, 
}


fn new_under_upgrading( player: ContractAddress, upgrade_id:u64) -> UnderUpgrading{
    UnderUpgrading{
        address: player,
        upgrade_id,
        building_id: 0_u64,
        building_kind: 0_u64,
        target_level: 0_u64.into(),
        start_time: 0_u64,
        end_time: 0_u64,
        is_finished: true,
        is_new_building: false,
        value: 0_u64,
        population: 0_u64,
    }
}


#[derive(Model, Drop, Copy, Serde, Debug)]
struct CityHall {
    #[key]
    player: ContractAddress,
    building_id: u64,
    level: Level,
    bonus: u64,
    population:u64, 
}


impl CityHallLevelTrait of LevelUpTrait<CityHall, (u64, u64)>{

    fn level_up(ref self: CityHall, value: (u64, u64)){
        self.level.level_up(());
        let (bonus, population) = value;
        self.bonus = bonus;
        self.population = population;
    }
}


impl CityHallGetLevel of LevelTrait<CityHall>{
    fn get_level(self: @CityHall) -> Level{
        self.level.get_level()
    }
}


#[starknet::component]
mod city_hall_component {
    use core::traits::Into;
    use core::array::ArrayTrait;
    use starknet::{get_caller_address, ContractAddress, get_contract_address};
    use kingdom_lord::models::time::get_current_time;
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use kingdom_lord::constants::{UNDER_UPGRADING_COUNT};
    use super::{UnderUpgrading, Level, CityBuilding, CityBuildingLevelImpl, CityHall};
    use kingdom_lord::interface::Error;

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl CityHallInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of CityHallInternalTrait<TContractState> {
        fn get_under_upgrading(self: @ComponentState<TContractState>, player: ContractAddress) -> Array<UnderUpgrading> {
            let current_block_time = get_current_time();
            let world = self.get_contract().world();
            let mut upgradings = array![];
            let mut index = 0;
            loop {
                if index == UNDER_UPGRADING_COUNT {
                    break;
                }
                let upgrading: UnderUpgrading = get!(world, (player, index), (UnderUpgrading));
                if !upgrading.is_finished && upgrading.end_time > current_block_time {
                    upgradings.append(upgrading);
                }
                index += 1;
            };

            upgradings
        }

        fn get_complete_upgrading(self: @ComponentState<TContractState>, player: ContractAddress) -> Array<UnderUpgrading> {
            let current_block_time = get_current_time();
            let world = self.get_contract().world();
            let mut upgradings = array![];
            let mut index = 0;
            loop {
                if index == UNDER_UPGRADING_COUNT {
                    break;
                }
                let upgrading: UnderUpgrading = get!(world, (player, index), (UnderUpgrading));
                if !upgrading.is_finished && upgrading.end_time <= current_block_time {
                    upgradings.append(upgrading);
                }
                index += 1;
            };

            upgradings
        }

        fn start_upgrade(
            ref self: ComponentState<TContractState>,
            building_id: u64,
            building_kind: u64,
            next_level: Level,
            required_time: u64,
            value: u64,
            population: u64,
            is_new_building: bool
        ) -> Result<UnderUpgrading, Error> {
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let city_hall = get!(world, (player), (CityHall));
            let required_time = required_time - city_hall.bonus * required_time / 10000;
            let mut index = 0;
            let mut res: Result<UnderUpgrading, Error> = Result::Err(Error::UnknownedError('start upgrading failed'));
            loop {
                if index == UNDER_UPGRADING_COUNT {
                    res = Result::Err(Error::UpgradingListFull);
                    break;
                }
                let mut upgrading: UnderUpgrading = get!(world, (player, index), (UnderUpgrading));
                if upgrading.is_finished {
                    upgrading.building_id = building_id;
                    upgrading.building_kind = building_kind;
                    upgrading.is_finished = false;
                    upgrading.start_time = current_time;
                    upgrading.end_time = current_time + required_time;
                    upgrading.target_level = next_level;
                    upgrading.is_new_building = is_new_building;
                    upgrading.value = value;
                    upgrading.population = population;
                    set!(world, (upgrading));
                    res = Result::Ok(upgrading);
                    break;
                } 
                index += 1;
            };
            res
        }

        fn finish_upgrade(
            ref self: ComponentState<TContractState>, upgrade_id: u64
        ) -> Result<UnderUpgrading, Error> {
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let mut upgrading = get!(world, (player, upgrade_id), (UnderUpgrading));
            if upgrading.end_time <= current_time && !upgrading.is_finished{
                upgrading.is_finished = true;
                set!(world, (upgrading));
                return Result::Ok(upgrading);
            } else {
                return Result::Err(Error::UpgradeNotFinished);
            }
        }

        fn pay_to_finish_upgrade(
            ref self: ComponentState<TContractState>, upgrade_id: u64
        ) -> Result<UnderUpgrading, Error> {
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let mut upgrading = get!(world, (player, upgrade_id), (UnderUpgrading));
            if !upgrading.is_finished{
                upgrading.is_finished = true;
                upgrading.end_time = current_time;
                set!(world, (upgrading));
                return Result::Ok(upgrading);
            } else {
                return Result::Err(Error::PayToUpgradeError);
            }
        }

        // use for pay to finshed upgrade
        fn finish_all_upgrade(ref self: ComponentState<TContractState>){
            let mut index = 0;
            let player = get_caller_address();
            let current_time = get_current_time();
            let world = self.get_contract().world();
            loop {
                if index == UNDER_UPGRADING_COUNT {
                    break;
                }
                let mut upgrading: UnderUpgrading = get!(world, (player, index), (UnderUpgrading));
                if !upgrading.is_finished {
                    upgrading.is_finished = true;
                    upgrading.end_time = current_time;
                    set!(world, (upgrading));
                } 
                index += 1;
            };
        }
    }
}
