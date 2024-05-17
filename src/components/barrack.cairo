use core::traits::Into;
use starknet::ContractAddress;
use super::super::models::resource::{Food, Resource};
use kingdom_lord::models::level::Level;
use kingdom_lord::models::building::{BuildingUpgradeResource};
use kingdom_lord::models::level::{LevelTrait, LevelUpTrait, LevelImpl};
use kingdom_lord::models::army::{ArmyGroup};


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
    army: ArmyGroup,
}

#[derive(Model, Copy, Drop, Serde)]
struct BarrackUnderTraining{
    #[key]
    address: ContractAddress,
    current_training_id: u64,
    soldier_kind: u64,
    start_time: u64,
    end_time: u64,
    is_finished: bool,
    amount: u64
}

#[derive(Model, Copy, Drop, Serde)]
struct BarrackWaitingToTrain{
    #[key]
    address: ContractAddress,
    #[key]
    training_id: u64,
    soldier_kind: u64,
    required_time: u64,
    is_planned: bool,
    amount: u64
}



fn new_wait_to_train(address: ContractAddress, training_id: u64) -> BarrackWaitingToTrain{
    BarrackWaitingToTrain{
        address: address,
        training_id: training_id,
        soldier_kind: 0,
        required_time: 0,
        is_planned: false,
        amount: 0
    }
}


impl BarrackLevelTrait of LevelUpTrait<Barrack, (u64, u64)>{
    fn level_up(ref self: Barrack, value: (u64, u64)){
        self.level.level_up(());
        let (bonus, population) = value;
        self.population += population;
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
    use super::{BarrackLevelTrait, BarrackGetLevel, Barrack, BarrackUnderTraining,  Troops, BarrackWaitingToTrain};
    use kingdom_lord::constants::{UNDER_TRAINING_COUNT};
    use kingdom_lord::interface::Error;
    use kingdom_lord::models::time::get_current_time;
    use kingdom_lord::models::army::{SoldierKind};

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
        fn get_under_training(self: @ComponentState<TContractState>, player: ContractAddress) -> BarrackUnderTraining {
            let world = self.get_contract().world();
            let training: BarrackUnderTraining = get!(world, (player), (BarrackUnderTraining));

            training
        }

        fn get_waiting_to_train(self: @ComponentState<TContractState>, player: ContractAddress) -> Array<BarrackWaitingToTrain> {
            let world = self.get_contract().world();
            let mut trainings = array![];
            let mut index = 0;
            loop {
                if index == UNDER_TRAINING_COUNT {
                    break;
                }
                let training: BarrackWaitingToTrain = get!(world, (player, index), (BarrackWaitingToTrain));
                if !training.is_planned {
                    trainings.append(training);
                }
                index += 1;
            };

            trainings
        }
        fn start_training(self: @ComponentState<TContractState>,            
            soldier_kind: SoldierKind,
            required_time: u64,
            amount: u64
        )-> Result<u64, Error>{
            let world = self.get_contract().world();
            let current_time = get_current_time();
            let player = get_caller_address();
            let barrack: Barrack = get!(world, (player), (Barrack));
            let mut under_training = get!(world, (player), (BarrackUnderTraining));

            let required_time = (barrack.bonus * required_time / 100) * amount;
            if barrack.population == 0{
                return Result::Err(Error::NoTargetBuildingConstructed);
            }
            let mut res: Result<u64, Error> = Result::Err(Error::UnknownedError('start training failed'));
            
            if under_training.is_finished{
                under_training.is_finished = false;
                under_training.start_time = current_time;
                under_training.end_time = current_time + required_time;
                under_training.soldier_kind = soldier_kind.into();
                under_training.amount = amount;
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
                    let mut train: BarrackWaitingToTrain = get!(world, (player, index), (BarrackWaitingToTrain));
                    if !train.is_planned {
                        train.training_id = index;
                        train.soldier_kind = soldier_kind.into();
                        train.required_time = required_time;
                        train.is_planned = true;
                        train.amount = amount;
 
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
            let mut training = get!(world, (player), (BarrackUnderTraining));
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
                        troops.army.millitia += training.amount;
                    },
                    SoldierKind::Guard => {
                        troops.army.guard += training.amount;
                    },
                    SoldierKind::HeavyInfantry => {
                        troops.army.heavy_infantry += training.amount;
                    },
                    SoldierKind::Scouts => {
                        troops.army.scouts += training.amount;
                    },
                    SoldierKind::Knights => {
                        troops.army.knights += training.amount;
                    },
                    SoldierKind::HeavyKnights => {
                        troops.army.heavy_knights += training.amount;
                    }
                }

                let mut next_upgrade_id = training.current_training_id + 1;
                if next_upgrade_id == UNDER_TRAINING_COUNT{
                    next_upgrade_id = 0;
                }
                let mut next_train: BarrackWaitingToTrain = get!(world, (player, next_upgrade_id), (BarrackWaitingToTrain));
                if next_train.is_planned{
                    next_train.is_planned = false;
                    training.current_training_id = next_upgrade_id;
                    training.soldier_kind = next_train.soldier_kind;
                    training.start_time = current_time;
                    training.end_time = current_time + next_train.required_time;
                    training.is_finished = false;
                    training.amount = next_train.amount;
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