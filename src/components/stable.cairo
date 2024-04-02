

use core::traits::Into;
use starknet::ContractAddress;
use super::super::models::resource::{Food, Resource};
use kingdom_lord::models::level::Level;
use kingdom_lord::models::building::{BuildingUpgradeResource};
use kingdom_lord::models::level::{LevelTrait, LevelUpTrait, LevelImpl};


#[derive(Model, Copy, Drop, Serde)]
struct Stable{
    #[key]
    player: ContractAddress,
    building_id: u64,
    level: Level,
    bonus: u64,
    population:u64,
}


#[derive(Model, Copy, Drop, Serde)]
struct StableUnderTraining{
    #[key]
    address: ContractAddress,
    current_training_id: u64,
    soldier_kind: u64,
    start_time: u64,
    end_time: u64,
    is_finished: bool,
}

#[derive(Model, Copy, Drop, Serde)]
struct StableWaitingToTrain{
    #[key]
    address: ContractAddress,
    #[key]
    training_id: u64,
    soldier_kind: u64,
    required_time: u64,
    is_planned: bool,
}


fn new_stable_wait_to_train(address: ContractAddress, training_id: u64) -> StableWaitingToTrain{
    StableWaitingToTrain{
        address: address,
        training_id: training_id,
        soldier_kind: 0,
        required_time: 0,
        is_planned: false
    }
}


impl StableLevelTrait of LevelUpTrait<Stable, (u64, u64)>{
    fn level_up(ref self: Stable, value: (u64, u64)){
        self.level.level_up(());
        let (bonus, population) = value;
        self.population = population;
        self.bonus = bonus;
    }
}

impl StableGetLevel of LevelTrait<Stable>{
    fn get_level(self: @Stable) -> Level{
        self.level.get_level()
    }
}

#[starknet::component]
mod stable_component{
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::{StableLevelTrait, StableGetLevel, Stable, StableUnderTraining, StableWaitingToTrain};
    use kingdom_lord::constants::{UNDER_TRAINING_COUNT};
    use kingdom_lord::components::barrack::{Troops,SoldierKind};
    use kingdom_lord::interface::Error;
    use kingdom_lord::models::time::get_current_time;

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl StableInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of StableInternalTrait<TContractState> {

        fn get_under_training(self: @ComponentState<TContractState>, player: ContractAddress) -> StableUnderTraining {
            let world = self.get_contract().world();
            let training: StableUnderTraining = get!(world, (player), (StableUnderTraining));

            training
        }

        fn get_waiting_to_train(self: @ComponentState<TContractState>, player: ContractAddress) -> Array<StableWaitingToTrain> {
            let world = self.get_contract().world();
            let mut trainings = array![];
            let mut index = 0;
            loop {
                if index == UNDER_TRAINING_COUNT {
                    break;
                }
                let training: StableWaitingToTrain = get!(world, (player, index), (StableWaitingToTrain));
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
            let stable: Stable = get!(world, (player), (Stable));
            let mut under_training = get!(world, (player), (StableUnderTraining));

            let required_time = stable.bonus * required_time / 100;
            if stable.population == 0{
                return Result::Err(Error::NoTargetBuildingConstructed);
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
                    let mut train: StableWaitingToTrain = get!(world, (player, index), (StableWaitingToTrain));
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

        fn finish_training(self: @ComponentState<TContractState>)  -> Result<u64, Error>{
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let mut training = get!(world, (player), (StableUnderTraining));
            if training.is_finished{
                return Result::Err(Error::UnknownedError('Training is already finished'));
            }
            if training.end_time <= current_time&& !training.is_finished{
                training.is_finished = true;
                let mut troops: Troops = get!(world, (player), (Troops));
                let soldier_kind: SoldierKind = training.soldier_kind.into();
                let origin_training_id = training.current_training_id;
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
                let mut next_train: StableWaitingToTrain = get!(world, (player, next_upgrade_id), (StableWaitingToTrain));
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
                return Result::Ok(origin_training_id);
            } else {
                return Result::Err(Error::TrainingNotFinished);
            }
        }
    }
}