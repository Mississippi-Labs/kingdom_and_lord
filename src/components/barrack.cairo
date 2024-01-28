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
    #[key]
    building_id: u64,
    level: Level,
    bonus: u64,
    food_consume_rate:u64
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
    #[key]
    training_id: u64,
    soldier_kind: u64,
    start_time: u64,
    end_time: u64,
    is_finished: bool,
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
    food_consume_rate: u64,
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

fn new_under_training(address: ContractAddress, training_id: u64) -> UnderTraining{
    UnderTraining{
        address: address,
        training_id: training_id,
        soldier_kind: 0,
        start_time: 0,
        end_time: 0,
        is_finished: true
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
                food_consume_rate: 1,
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
                food_consume_rate: 1,
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
                food_consume_rate: 1,
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
                food_consume_rate: 2,
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
                food_consume_rate: 3,
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
                food_consume_rate: 4,
                required_time: 3520
            }
        }
    }
}



impl BarrackLevelTrait of LevelUpTrait<Barrack, (u64, u64)>{
    fn level_up(ref self: Barrack, value: (u64, u64)){
        self.level.level_up(());
        let (bonus, food_consume_rate) = value;
        self.food_consume_rate = food_consume_rate;
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
    use super::{BarrackLevelTrait, BarrackGetLevel, Barrack, UnderTraining, SoldierKind, Troops};
    use kingdom_lord::constants::{UNDER_TRAINING_COUNT,BARRACK_START_INDEX};
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
        fn get_under_training(self: @ComponentState<TContractState>, player: ContractAddress) -> Array<UnderTraining> {
            let current_block_time = get_current_time();
            let world = self.get_contract().world();
            let mut trainings = array![];
            let mut index = 0;
            loop {
                if index == UNDER_TRAINING_COUNT {
                    break;
                }
                let training: UnderTraining = get!(world, (player, index), (UnderTraining));
                if !training.is_finished && training.end_time > current_block_time {
                    trainings.append(training);
                }
                index += 1;
            };

            trainings
        }

        fn get_complete_training(self: @ComponentState<TContractState>, player: ContractAddress) -> Array<UnderTraining> {
            let current_block_time = get_current_time();
            let world = self.get_contract().world();
            let mut trainings = array![];
            let mut index = 0;
            loop {
                if index == UNDER_TRAINING_COUNT {
                    break;
                }
                let training: UnderTraining = get!(world, (player, index), (UnderTraining));
                if !training.is_finished && training.end_time <= current_block_time {
                    trainings.append(training);
                }
                index += 1;
            };

            trainings
        }
        fn start_training(self: @ComponentState<TContractState>,            
            soldier_kind: SoldierKind,
            required_time: u64
        )-> Result<UnderTraining, Error>{
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let barrack = get!(world, (player, BARRACK_START_INDEX), (Barrack));
            let required_time = barrack.bonus * required_time / 100;
            let mut index = 0;
            let mut res: Result<UnderTraining, Error> = Result::Err(Error::UnknownedError('start upgrading failed'));
            loop {
                if index == UNDER_TRAINING_COUNT {
                    res = Result::Err(Error::TrainingListFull);
                    break;
                }
                let mut training: UnderTraining = get!(world, (player, index), (UnderTraining));
                if training.is_finished {
                    training.soldier_kind = soldier_kind.into();
                    training.is_finished = false;
                    training.start_time = current_time;
                    training.end_time = current_time + required_time;

                    set!(world, (training));
                    res = Result::Ok(training);
                    break;
                } 
                index += 1;
            };
            res
        }

        fn finish_training(self: @ComponentState<TContractState>, training_id: u64)  -> Result<UnderTraining, Error>{
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let mut training = get!(world, (player, training_id), (UnderTraining));
            if training.is_finished{
                return Result::Err(Error::UnknownedError('Training is already finished'));
            }
            if training.end_time <= current_time{
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
                set!(world, (troops));
                set!(world, (training));
                return Result::Ok(training);
            } else {
                return Result::Err(Error::TrainingNotFinished);
            }
        }
    }
}