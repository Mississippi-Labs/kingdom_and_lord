use starknet::ContractAddress;
use kingdom_lord::models::level::Level;

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct NewPlayerSpawnEvent {
    #[key]
    player: ContractAddress,
    time: u64
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct StartUpgradeEvent {
    #[key]
    player: ContractAddress,
    #[key]
    building_id: u64,
    upgrade_id: u64,
    level: Level,
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct UpgradeNotEnoughResourceEvent {
    #[key]
    player: ContractAddress,
    building_id: u64,
}
#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct UpgradeCompleteEvent {
    #[key]
    player: ContractAddress,
    upgrade_id: u64,
    building_next: bool
}
#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct UpgradeNotFinishedEvent {
    #[key]
    player: ContractAddress,
    block: u64,
}
#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct AlreadySpawnedEvent {
    #[key]
    player: ContractAddress,
    block: u64
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct PayToFinishedUpgradeEvent {
    #[key]
    player: ContractAddress,
    upgrade_id: u64,
    #[key]
    building_id: u64,
    level: Level
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct StartTrainingEvent {
    #[key]
    player: ContractAddress,
    training_id: u64,
    soldier_kind: u64,
}

#[derive(Model, Copy, Drop, Serde)]
#[dojo::event]
struct TrainingFinishedEvent {
    #[key]
    player: ContractAddress,
    training_id: u64,
}

