use starknet::ContractAddress;
use kingdom_lord::models::resource::{Food, Resource};
use super::city_building::{CityBuilding, CityBuildingLevelImpl};
use kingdom_lord::models::level::Level;
use kingdom_lord::models::building::{BuildingUpgradeResource};
use kingdom_lord::models::level::{LevelTrait, LevelUpTrait};

#[derive(Model, Drop, Copy, Serde, Debug)]
struct UnderUpgrading {
    #[key]
    player: ContractAddress,
    building_id: u64,
    building_kind: u64,
    target_level: Level,
    start_time: u64,
    end_time: u64,
    is_new_building: bool,
    is_finished: bool,
    value: u64,
    population:u64,
    current_upgrade_id: u64
}


#[derive(Drop, Copy, Serde)]
struct FinishedBuildingInfo{
    upgrade_id: u64,
    building_id: u64,
    is_new_building: bool,
    building_kind: u64,
    building_next: bool,
    value: u64,
    population: u64,
}

#[derive(Model, Drop, Copy, Serde, Debug)]
struct WaitingToUpgrade {
    #[key]
    address: ContractAddress,
    #[key]
    upgrade_id: u64,
    building_id: u64,
    building_kind: u64,
    target_level: Level,
    required_time: u64,
    is_planned: bool,
    is_new_building: bool,
    value: u64,
    population:u64,
}

fn new_waiting_upgrading( player: ContractAddress, upgrade_id:u64) -> WaitingToUpgrade{
    WaitingToUpgrade{
        address: player,
        upgrade_id,
        building_id: 0_u64,
        building_kind: 0_u64,
        target_level: 0_u64.into(),
        required_time: 0_u64,
        is_planned: false,
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
    use kingdom_lord::constants::{WAITING_UPGRADING_COUNT};
    use super::{UnderUpgrading, Level, CityBuilding, CityBuildingLevelImpl, CityHall, WaitingToUpgrade, FinishedBuildingInfo};
    use kingdom_lord::interface::Error;

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl CityHallInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of CityHallInternalTrait<TContractState> {
        fn get_under_upgrading(self: @ComponentState<TContractState>, player: ContractAddress) -> UnderUpgrading{
            let world = self.get_contract().world();
            let upgrading: UnderUpgrading = get!(world, (player), (UnderUpgrading));

            upgrading
        }

        fn get_waiting_upgrading(self: @ComponentState<TContractState>, player: ContractAddress) -> Array<WaitingToUpgrade>{
            let world = self.get_contract().world();
            let mut upgradings = array![];
            let mut index = 0;
            loop {
                if index == WAITING_UPGRADING_COUNT {
                    break;
                }
                let upgrading: WaitingToUpgrade = get!(world, (player, index), (WaitingToUpgrade));
                if !upgrading.is_planned {
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
        ) -> Result<u64, Error> {
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let city_hall = get!(world, (player), (CityHall));
            let required_time = required_time - city_hall.bonus * required_time / 10000;
            let mut upgrading: UnderUpgrading = get!(world, (player), UnderUpgrading);
            let mut res: Result<u64, Error> = Result::Err(Error::UnknownedError('start upgrading failed'));
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
                let mut next_upgrading_id = upgrading.current_upgrade_id + 1;
                if next_upgrading_id == WAITING_UPGRADING_COUNT{
                    next_upgrading_id = 0;
                }
                upgrading.current_upgrade_id = next_upgrading_id;
                set!(world, (upgrading));
                res = Result::Ok(upgrading.current_upgrade_id);
            } else {
                let mut touch_end = false;
                let start_index = upgrading.current_upgrade_id;
                let mut index = upgrading.current_upgrade_id + 1;
                // this println could fix https://github.com/dojoengine/dojo/issues/1747
                println!("start_index: {}", start_index);
                loop {
                    if index == WAITING_UPGRADING_COUNT && !touch_end{
                        index = 0;
                        touch_end =true
                    }
                    if index == start_index {
                        res = Result::Err(Error::UpgradingListFull);
                        break;
                    }
                    let mut upgrade: WaitingToUpgrade = get!(world, (player, index), (WaitingToUpgrade));
                    if !upgrade.is_planned {
                        upgrade.upgrade_id = index;
                        upgrade.building_id = building_id;
                        upgrade.building_kind = building_kind;
                        upgrade.target_level = next_level;
                        upgrade.required_time = required_time;
                        upgrade.is_planned = true;
                        upgrade.is_new_building = is_new_building;
                        upgrading.value = value;
                        upgrading.population = population;

                        set!(world, (upgrade));
                        res = Result::Ok(index);
                        break;
                    }

                    index += 1;
                };
            }
            res


        }

        fn finish_upgrade(
            ref self: ComponentState<TContractState>
        ) -> Result<FinishedBuildingInfo, Error> {
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let mut upgrading = get!(world, (player), (UnderUpgrading));

            if upgrading.end_time <= current_time && !upgrading.is_finished{
                upgrading.is_finished = true;

                let mut finished_building_info = FinishedBuildingInfo{
                    upgrade_id: upgrading.current_upgrade_id,
                    building_id: upgrading.building_id,
                    is_new_building: upgrading.is_new_building,
                    building_kind: upgrading.building_kind,
                    building_next: false,
                    value: upgrading.value,
                    population: upgrading.population,
                };
                // line next waiting into under upgrading
                let mut next_upgrade_id = upgrading.current_upgrade_id + 1;
                if next_upgrade_id == WAITING_UPGRADING_COUNT{
                    next_upgrade_id = 0;
                }
                let mut next_upgrade: WaitingToUpgrade = get!(world, (player, next_upgrade_id), (WaitingToUpgrade));
                if next_upgrade.is_planned {
                    upgrading.building_id = next_upgrade.building_id;
                    upgrading.building_kind = next_upgrade.building_kind;
                    upgrading.is_finished = false;
                    upgrading.start_time = current_time;
                    upgrading.end_time = current_time + next_upgrade.required_time;
                    upgrading.target_level = next_upgrade.target_level;
                    upgrading.is_new_building = next_upgrade.is_new_building;
                    upgrading.value = next_upgrade.value;
                    upgrading.population = next_upgrade.population;
                    upgrading.current_upgrade_id = next_upgrade_id; 

                    finished_building_info.building_next = true;
                     
                    next_upgrade.is_planned = false;
                    set!(world, (next_upgrade));
                }

                set!(world, (upgrading));

                return Result::Ok(finished_building_info);
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

    }
}
