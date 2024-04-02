use core::traits::Into;
use starknet::ContractAddress;
use super::super::models::resource::{Food, Resource};
use kingdom_lord::models::level::Level;
use kingdom_lord::models::building::{BuildingUpgradeResource};
use kingdom_lord::models::level::{LevelTrait, LevelUpTrait, LevelImpl};


#[derive(Model, Copy, Drop, Serde)]
struct Barrack{
    #[key]
    player: ContractAddress,
    building_id: u64,
    level: Level,
    bonus: u64,
    population:u64,
}

#[derive(Model, Copy, Drop, Serde)]
struct Troops{
    #[key]
    player: ContractAddress,
    millitia: u64,
    guard: u64,
    heavy_infantry: u64,
    scouts: u64,
    knights: u64,
    heavy_knights: u64
}

#[derive(Model, Copy, Drop, Serde)]
struct UnderTraining{
    #[key]
    address: ContractAddress,
    current_training_id: u64,
    soldier_kind: u64,
    start_time: u64,
    end_time: u64,
    is_finished: bool,
}

#[derive(Model, Copy, Drop, Serde)]
struct WaitingToTrain{
    #[key]
    address: ContractAddress,
    #[key]
    training_id: u64,
    soldier_kind: u64,
    required_time: u64,
    is_planned: bool,
}

#[derive(Model, Copy, Drop, Serde)]
struct Stable{
    #[key]
    player: ContractAddress,
    building_id: u64,
    level: Level,
    bonus: u64,
    population:u64,
}

#[derive(Copy, Drop, Serde)]
struct SoldierInfo{
    attack_power: u64,
    defense_power: u64,
    movement_speed: u64,
    load_capacity: u64,
    req_wood: u64,
    req_brick: u64,
    req_steel: u64,
    req_food: u64,
    population: u64,
    required_time: u64,
}



#[derive(Copy, Drop, Serde)]
enum SoldierKind{
    Millitia,
    Guard,
    HeavyInfantry,
    Scouts,
    Knights,
    HeavyKnights
}

impl SoldierKindIntou64 of Into<u64, SoldierKind>{
    fn into(self: u64) -> SoldierKind{
        let self:felt252 = self.into();
        match self{
            0 => SoldierKind::Millitia,
            1 => SoldierKind::Guard,
            2 => SoldierKind::HeavyInfantry,
            3 => SoldierKind::Scouts,
            4 => SoldierKind::Knights,
            5 => SoldierKind::HeavyKnights,
            _ => panic!("Invalid SoldierKind")
        }
    }
}

impl IntoSoldierKind of Into<SoldierKind, u64>{
    fn into(self: SoldierKind) -> u64{
        match self{
            SoldierKind::Millitia => 0,
            SoldierKind::Guard => 1,
            SoldierKind::HeavyInfantry => 2,
            SoldierKind::Scouts => 3,
            SoldierKind::Knights => 4,
            SoldierKind::HeavyKnights => 5,
        }
    }
}

fn new_wait_to_train(address: ContractAddress, training_id: u64) -> WaitingToTrain{
    WaitingToTrain{
        address: address,
        training_id: training_id,
        soldier_kind: 0,
        required_time: 0,
        is_planned: true
    }
}

fn soldier_info(soldier_kind: SoldierKind) -> SoldierInfo{
    match soldier_kind{
        SoldierKind::Millitia => {
            SoldierInfo{
                attack_power: 40,
                defense_power: 35,
                movement_speed: 6,
                load_capacity: 50,
                req_wood: 120,
                req_brick: 100,
                req_steel: 150,
                req_food: 30,
                population: 1,
                required_time: 1600
            }
        },
        SoldierKind::Guard => {
            SoldierInfo{
                attack_power: 30,
                defense_power: 65,
                movement_speed: 5,
                load_capacity: 20,
                req_wood: 100,
                req_brick: 130,
                req_steel: 160,
                req_food: 70,
                population: 1,
                required_time: 1760
            }
        },
        SoldierKind::HeavyInfantry => {
            SoldierInfo{
                attack_power: 70,
                defense_power: 40,
                movement_speed: 7,
                load_capacity: 50,
                req_wood: 150,
                req_brick: 160,
                req_steel: 210,
                req_food: 80,
                population: 1,
                required_time: 1920
            }
        },
        SoldierKind::Scouts => {
            SoldierInfo{
                attack_power: 0,
                defense_power: 20,
                movement_speed: 16,
                load_capacity: 0,
                req_wood: 140,
                req_brick: 160,
                req_steel: 20,
                req_food: 40,
                population: 2,
                required_time: 1360
            }
        },
        SoldierKind::Knights => {
            SoldierInfo{
                attack_power: 120,
                defense_power: 65,
                movement_speed: 14,
                load_capacity: 100,
                req_wood: 550,
                req_brick: 440,
                req_steel: 320,
                req_food: 100,
                population: 3,
                required_time: 2640
            }
        },
        SoldierKind::HeavyKnights => {
            SoldierInfo{
                attack_power: 180,
                defense_power: 80,
                movement_speed: 10,
                load_capacity: 70,
                req_wood: 550,
                req_brick: 640,
                req_steel: 800,
                req_food: 180,
                population: 4,
                required_time: 3520
            }
        }
    }
}



impl BarrackLevelTrait of LevelUpTrait<Barrack, (u64, u64)>{
    fn level_up(ref self: Barrack, value: (u64, u64)){
        self.level.level_up(());
        let (bonus, population) = value;
        self.population = population;
        self.bonus = bonus;
    }
}

impl BarrackGetLevel of LevelTrait<Barrack>{
    fn get_level(self: @Barrack) -> Level{
        self.level.get_level()
    }
}

#[starknet::component]
mod barrack_component{
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::{BarrackLevelTrait, BarrackGetLevel, Barrack, UnderTraining, SoldierKind, Troops, WaitingToTrain};
    use kingdom_lord::constants::{UNDER_TRAINING_COUNT};
    use kingdom_lord::interface::Error;
    use kingdom_lord::models::time::get_current_time;

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl BarrackInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of BarrackInternalTrait<TContractState> {

        fn get_troops(self: @ComponentState<TContractState>, player:ContractAddress) -> Troops{
            let world = self.get_contract().world();
            get!(world, (player), (Troops))
        }
        fn get_under_training(self: @ComponentState<TContractState>, player: ContractAddress) -> UnderTraining {
            let world = self.get_contract().world();
            let training: UnderTraining = get!(world, (player), (UnderTraining));

            training
        }

        fn get_waiting_to_train(self: @ComponentState<TContractState>, player: ContractAddress) -> Array<WaitingToTrain> {
            let world = self.get_contract().world();
            let mut trainings = array![];
            let mut index = 0;
            loop {
                if index == UNDER_TRAINING_COUNT {
                    break;
                }
                let training: WaitingToTrain = get!(world, (player, index), (WaitingToTrain));
                if !training.is_planned {
                    trainings.append(training);
                }
                index += 1;
            };

            trainings
        }
        fn start_training(self: @ComponentState<TContractState>,            
            soldier_kind: SoldierKind,
            required_time: u64
        )-> Result<u64, Error>{
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let barrack: Barrack = get!(world, (player), (Barrack));
            let mut under_training = get!(world, (player), (UnderTraining));

            let required_time = barrack.bonus * required_time / 100;
            if barrack.population == 0{
                return Result::Err(Error::NoBarrackConstructed);
            }
            let mut res: Result<u64, Error> = Result::Err(Error::UnknownedError('start training failed'));
            
            if under_training.is_finished{
                under_training.is_finished = false;
                under_training.start_time = current_time;
                under_training.end_time = current_time + required_time;
                under_training.soldier_kind = soldier_kind.into();
                let mut next_training_id = under_training.current_training_id + 1;
                if next_training_id == UNDER_TRAINING_COUNT{
                    next_training_id = 0;
                }
                under_training.current_training_id = next_training_id;
                set!(world, (under_training));
                res = Result::Ok(under_training.current_training_id);
            } else {
                let mut touch_end = false;
                let start_index = under_training.current_training_id;
                let mut index = under_training.current_training_id + 1;
                println!("fix bug");
                loop {
                    if index == UNDER_TRAINING_COUNT && !touch_end{
                        index = 0;
                        touch_end =true
                    }
                    if index == start_index {
                        res = Result::Err(Error::TrainingListFull);
                        break;
                    }
                    let mut train: WaitingToTrain = get!(world, (player, index), (WaitingToTrain));
                    if !train.is_planned {
                        train.training_id = index;
                        train.soldier_kind = soldier_kind.into();
                        train.required_time = required_time;
                        train.is_planned = true;
 
                        set!(world, (train));
                        res = Result::Ok(index);
                        break;
                    }

                    index += 1;
                };
            }
            res
        }

        fn finish_training(self: @ComponentState<TContractState>, training_id: u64)  -> Result<UnderTraining, Error>{
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let mut training = get!(world, (player), (UnderTraining));
            if training.is_finished{
                return Result::Err(Error::UnknownedError('Training is already finished'));
            }
            if training.end_time <= current_time&& !training.is_finished{
                training.is_finished = true;
                let mut troops: Troops = get!(world, (player), (Troops));
                let soldier_kind: SoldierKind = training.soldier_kind.into();
                match soldier_kind{
                    SoldierKind::Millitia => {
                        troops.millitia += 1;
                    },
                    SoldierKind::Guard => {
                        troops.guard += 1;
                    },
                    SoldierKind::HeavyInfantry => {
                        troops.heavy_infantry += 1;
                    },
                    SoldierKind::Scouts => {
                        troops.scouts += 1;
                    },
                    SoldierKind::Knights => {
                        troops.knights += 1;
                    },
                    SoldierKind::HeavyKnights => {
                        troops.heavy_knights += 1;
                    }
                }

                let mut next_upgrade_id = training.current_training_id + 1;
                if next_upgrade_id == UNDER_TRAINING_COUNT{
                    next_upgrade_id = 0;
                }
                let mut next_train: WaitingToTrain = get!(world, (player, next_upgrade_id), (WaitingToTrain));
                if next_train.is_planned{
                    next_train.is_planned = false;
                    training.current_training_id = next_upgrade_id;
                    training.soldier_kind = next_train.soldier_kind;
                    training.start_time = current_time;
                    training.end_time = current_time + next_train.required_time;
                    training.is_finished = false;
                    set!(world, (next_train));
                }
                set!(world, (troops));
                set!(world, (training));
                return Result::Ok(training);
            } else {
                return Result::Err(Error::TrainingNotFinished);
            }
        }
    }
}