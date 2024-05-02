use kingdom_lord::models::building::BuildingUpgradeInfo;
use kingdom_lord::models::resource::{ Brick, Wood, Steel,Food, Resource};
use kingdom_lord::models::growth::{GrowthRate};
use kingdom_lord::models::level::Level;
use kingdom_lord::components::city_hall::city_hall_component::{UnderUpgrading, WaitingToUpgrade};
use kingdom_lord::components::barrack::{BarrackUnderTraining, Troops, BarrackWaitingToTrain};
use kingdom_lord::components::globe::{globe_component, VillageConfirm};
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
    VillageConfirmAlreadyExist,
    VillageConfirmNotStarted,
    VillageAlreadyCreated,
    VillagePositionAlreadyTaken,
    LocationNotVillage,
    NotEnoughSoldier,
    InvalidReveal
}

#[starknet::interface]
trait IKingdomLord<ContractState>{
    // read function
    fn get_resource(self: @ContractState, player: ContractAddress) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>, Resource<Food>);
    fn get_growth_rate(self: @ContractState, player: ContractAddress) -> (GrowthRate<Wood>, GrowthRate<Brick>, GrowthRate<Steel>, GrowthRate<Food>);
    fn get_under_upgrading(self: @ContractState, player: ContractAddress) -> UnderUpgrading;
    fn get_waiting_upgrading(self: @ContractState, player: ContractAddress) -> Array<WaitingToUpgrade>;
    fn get_buildings_levels(self: @ContractState, player: ContractAddress) -> Array<Level>;
    fn get_under_training(self: @ContractState, player: ContractAddress) -> BarrackUnderTraining;
    fn get_waiting_to_train(self: @ContractState, player: ContractAddress) -> Array<BarrackWaitingToTrain>;
    fn get_troops(self: @ContractState, player: ContractAddress) -> Troops;
    fn get_total_population(self: @ContractState, player: ContractAddress) -> u64;
    fn get_city_wall_power(self: @ContractState, player: ContractAddress) -> (u64, u64);
    fn get_ally_amount(self: @ContractState, player: ContractAddress) -> u64;
    fn get_village_location(self: @ContractState, player: ContractAddress) -> (u64, u64);

    // write function
    fn spawn(self: @ContractState) -> Result<(), Error>;
    fn start_upgrade(
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
    fn finish_upgrade(self: @ContractState) -> Result<(), Error>;
    fn start_training(
            self: @ContractState,
            soldier_kind: u64,
        ) -> Result<u64, Error>;
    fn finish_training(self: @ContractState, is_barrack: bool) -> Result<u64, Error>;
    // fn pay_to_finish_upgrade(ref self: ContractState, upgrade_id: u64) -> Result<(), Error>;

    fn create_village_confirm(
        self: @ContractState
    ) -> Result<VillageConfirm, Error>;

    fn create_village_reveal(self: @ContractState) -> Result<(), Error>;

    fn create_ambush(
        self: @ContractState,
        ambush_hash: felt252,
        millitia: u64,
        guard: u64,
        heavy_infantry: u64,
        scouts: u64,
        knights: u64,
        heavy_knights: u64
    ) -> Result<(), Error>;

    fn reveal_attack(
        self: @ContractState,
        hash: felt252,
        x: u64,
        y: u64,
        time: u64,
        nonce: u64,
        target_x: u64,
        target_y: u64,
        is_robbed: bool
    ) -> Result<bool, Error>;

    fn reveal_hide(
        self: @ContractState,
        origin_hash: felt252,
        origin_x: u64,
        origin_y: u64,
        origin_time: u64,
        origin_nonce: u64,
        new_hash: felt252,
    )-> Result<(), Error>;
}

#[starknet::interface]
trait IKingdomLordAdmin<ContractState>{
    fn set_config(self: @ContractState, erc20_addr: ContractAddress, amount: u256, receiver: ContractAddress, level_root_merkle: felt252) ;
    // fn set_barn_max_storage(self: @ContractState, addr: ContractAddress, max_storage: u64);
    // fn set_warehouse_max_storage(self: @ContractState, addr: ContractAddress, max_storage: u64);

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
        
        fn create_village_confirm_test(
            self: @ContractState
        ) -> Result<VillageConfirm, Error>;

        fn create_village_reveal_test(self: @ContractState) -> Result<(), Error>;

        fn create_ambush_test(
            self: @ContractState,
            ambush_hash: felt252,
            millitia: u64,
            guard: u64,
            heavy_infantry: u64,
            scouts: u64,
            knights: u64,
            heavy_knights: u64
        ) -> Result<(), Error>;
  
        fn reveal_attack_test(
            self: @ContractState,
            hash: felt252,
            x: u64,
            y: u64,
            time: u64,
            nonce: u64,
            target_x: u64,
            target_y: u64,
            is_robbed: bool
        ) -> Result<bool, Error>;
    
        fn reveal_hide_test(
            self: @ContractState,
            origin_hash: felt252,
            origin_x: u64,
            origin_y: u64,
            origin_time: u64,
            origin_nonce: u64,
            new_hash: felt252,
        )-> Result<(), Error>;
}