
use starknet::ContractAddress;
use kingdom_lord::models::level::Level;

#[derive(Drop, starknet::Event)]
struct NewPlayerSpawnEvent{
    #[key]
    player: ContractAddress,
    time: u64
}

#[derive(Drop, starknet::Event)]
struct StartUpgradeEvent{
    #[key]
    player: ContractAddress,
    #[key]
    building_id: u64,
    upgrade_id: u64,
    level: Level, 
}

#[derive(Drop, starknet::Event)]
struct UpgradeNotEnoughResourceEvent{
    #[key]
    player: ContractAddress,
    #[key]
    building_id: u64,
}

#[derive(Drop, starknet::Event)]
struct UpgradeCompleteEvent{
    #[key]
    player: ContractAddress,
    upgrade_id: u64,
    building_next: bool
}

#[derive(Drop, starknet::Event)]
struct UpgradeNotFinishedEvent{
    #[key]
    player: ContractAddress,
}

#[derive(Drop, starknet::Event)]
struct AlreadySpawnedEvent{
    #[key]
    player: ContractAddress
}


#[derive(Drop, starknet::Event)]
struct PayToFinishedUpgradeEvent{
    #[key]
    player: ContractAddress,
    upgrade_id: u64,
    #[key]
    building_id: u64,
    level: Level
}


#[derive(Drop, starknet::Event)]
struct StartTrainingEvent{
    #[key]
    player: ContractAddress,
    training_id: u64,
    soldier_kind: u64, 
    start_time: u64,
    end_time:u64
}



#[derive(Drop, starknet::Event)]
struct TrainingFinishedEvent{
    #[key]
    player: ContractAddress,
    training_id: u64,
}

