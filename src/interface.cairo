use kingdom_lord::models::building::BuildingUpgradeInfo;
use kingdom_lord::models::resource::{ Brick, Wood, Steel,Food, Resource};
use kingdom_lord::models::growth::{GrowthRate};
use kingdom_lord::models::level::Level;
use kingdom_lord::components::city_hall::city_hall_component::{UnderUpgrading, WaitingToUpgrade};
use kingdom_lord::components::barrack::{BarrackUnderTraining, Troops, BarrackWaitingToTrain};
use starknet::ContractAddress;

#[derive(Debug, Serde, Drop, Copy, PartialEq)]
enum Error{
    ResourceNotEnough,
    UpgradeNotFinished,
    AlreadySpawned,
    UpgradingListFull,
    UnknownedError: felt252,
    PayToUpgradeError,
    InvalidProof,
    TrainingNotFinished,
    TrainingListFull,
    NoTargetBuildingConstructed,
    TrainingPrerequirementNotMatch,
    StorageBuildingNotMaxLevel,
    CityConfirmAlreadyExist,
    CityConfirmNotStarted,
    CityAlreadyCreated
}

#[starknet::interface]
trait IKingdomLord<TState>{
    // read function
    fn get_resource(self: @TState, player: ContractAddress) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>, Resource<Food>);
    fn get_growth_rate(self: @TState, player: ContractAddress) -> (GrowthRate<Wood>, GrowthRate<Brick>, GrowthRate<Steel>, GrowthRate<Food>);
    fn get_under_upgrading(self: @TState, player: ContractAddress) -> UnderUpgrading;
    fn get_waiting_upgrading(self: @TState, player: ContractAddress) -> Array<WaitingToUpgrade>;
    fn get_buildings_levels(self: @TState, player: ContractAddress) -> Array<Level>;
    fn get_under_training(self: @TState, player: ContractAddress) -> BarrackUnderTraining;
    fn get_waiting_to_train(self: @TState, player: ContractAddress) -> Array<BarrackWaitingToTrain>;
    fn get_troops(self: @TState, player: ContractAddress) -> Troops;
    fn get_total_population(self: @TState, player: ContractAddress) -> u64;
    fn get_city_wall_power(self: @TState, player: ContractAddress) -> (u64, u64);
    fn get_ally_amount(self: @TState, player: ContractAddress) -> u64;

    // write function
    fn spawn(self: @TState) -> Result<(), Error>;
    fn start_upgrade(
            self: @TState,
            building_id: u64,
            building_kind: u64,
            next_level: u64,
            req_wood: u64,
            req_brick: u64,
            req_steel: u64,
            req_food: u64,
            population: u64,
            required_time: u64,
            value: u64,
            proof: Array<felt252>
        ) -> Result<u64, Error>;
    fn finish_upgrade(self: @TState) -> Result<(), Error>;
    fn start_training(
            self: @TState,
            soldier_kind: u64,
        ) -> Result<u64, Error>;
    fn finish_training(self: @TState, is_barrack: bool) -> Result<u64, Error>;
    // fn pay_to_finish_upgrade(ref self: TState, upgrade_id: u64) -> Result<(), Error>;
}

#[starknet::interface]
trait IKingdomLordAdmin<TState>{
    fn set_config(self: @TState, erc20_addr: ContractAddress, amount: u256, receiver: ContractAddress, level_root_merkle: felt252) ;
    // fn set_barn_max_storage(self: @TState, addr: ContractAddress, max_storage: u64);
    // fn set_warehouse_max_storage(self: @TState, addr: ContractAddress, max_storage: u64);

}

#[starknet::interface]
trait IKingdomLordTest<ContractState>{
        fn spawn_test(self: @ContractState) -> Result<(), Error>;
        fn start_upgrade_test(
            self: @ContractState,
            building_id: u64,
            building_kind: u64,
            next_level: u64,
            req_wood: u64,
            req_brick: u64,
            req_steel: u64,
            req_food: u64,
            population: u64,
            required_time: u64,
            value: u64,
            proof: Array<felt252>
        ) -> Result<u64, Error>;
        fn finish_upgrade_test(self: @ContractState) -> Result<(), Error>;
        fn start_training_test(
            self: @ContractState,
            soldier_kind: u64,
        ) -> Result<u64, Error>;
        fn finish_training_test(self: @ContractState, is_barrack: bool) -> Result<u64, Error>;
}