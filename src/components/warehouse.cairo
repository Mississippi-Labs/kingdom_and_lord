use starknet::ContractAddress;
use kingdom_lord::models::resource::{Brick, Wood, Steel, Resource};
use kingdom_lord::models::level::Level;
use kingdom_lord::models::building::{BuildingUpgradeResource};
use kingdom_lord::models::level::{LevelTrait, LevelUpTrait};

#[derive(Model, Copy, Drop, Serde)]
struct Warehouse {
    #[key]
    player: ContractAddress,
    #[key]
    building_id: u64,
    level: Level,
    wood: Resource<Wood>,
    bricks: Resource<Brick>,
    steel: Resource<Steel>,
    max_storage: u64,
    food_consume_rate: u64,
}

#[generate_trait]
impl WarehouseExtensionImpl of WarehouseExtension{
    fn get_resource(self:@Warehouse) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>) {
        (self.wood.clone(), self.bricks.clone(), self.steel.clone())
    }

    fn add_resource(ref self:Warehouse, wood: Resource<Wood>, bricks: Resource<Brick>, steel: Resource<Steel>) {
        let new_wood_amount = self.wood + wood;
        if new_wood_amount.amount > self.max_storage {
            self.wood = self.max_storage.into();
        } else {
            self.wood = new_wood_amount;
        }
        let new_brick_amount = self.bricks + bricks;
        if new_brick_amount > self.max_storage.into() {
            self.bricks = self.max_storage.into();
        } else {
            self.bricks = new_brick_amount;
        }
        let new_steel_amount = self.steel + steel;
        if new_steel_amount > self.max_storage.into() {
            self.steel = self.max_storage.into();
        } else {
            self.steel = new_steel_amount;
        }
    }

    fn remove_resource(ref self: Warehouse, wood: Resource<Wood>, bricks: Resource<Brick>, steel: Resource<Steel>) {
        self.wood -= wood;
        self.bricks -= bricks;
        self.steel -= steel;
    }
}

impl WarehouseLeveTrait of LevelUpTrait<Warehouse, (u64, u64)>{
    fn level_up(ref self: Warehouse, value: (u64, u64)){
        self.level.level_up(());
        let (max_storage, food_consume_rate) = value;
        self.max_storage = max_storage;
        self.food_consume_rate = food_consume_rate;
    }
}

impl WarehouseGetLevel of LevelTrait<Warehouse>{
        fn get_level(self: @Warehouse) -> Level{
        self.level.get_level()
    }
}


#[starknet::component]
mod warehouse_component{
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::{Warehouse,  Brick, Wood, Steel, Resource, WarehouseExtension};
    use kingdom_lord::constants::WAREHOUSE_START_INDEX;

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl WarehouseInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of WarehouseInternalTrait<TContractState> {
        fn add_resource(self:@ComponentState<TContractState>, wood: Resource<Wood>, bricks: Resource<Brick>, steel: Resource<Steel>){
            let world = self.get_contract().world();
            let player = get_caller_address();
            let mut warehouse: Warehouse = get!(world, (player, WAREHOUSE_START_INDEX), (Warehouse));
            warehouse.add_resource(wood, bricks, steel);
            set!(world, (warehouse))
        }

        fn remove_resource(self:@ComponentState<TContractState>, wood: Resource<Wood>, bricks: Resource<Brick>, steel: Resource<Steel>){
            let world = self.get_contract().world();
            let player = get_caller_address();
            let mut warehouse: Warehouse = get!(world, (player, WAREHOUSE_START_INDEX), (Warehouse));
            warehouse.remove_resource(wood, bricks, steel);
            set!(world, (warehouse))
        }

        fn get_resource(self:@ComponentState<TContractState>, player: ContractAddress) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>){
            let warehouse = get!(self.get_contract().world(), (player, WAREHOUSE_START_INDEX), (Warehouse));
            warehouse.get_resource()
        }

        fn get_max_storage(self: @ComponentState<TContractState>, player: ContractAddress) -> u64{
            let warehouse = get!(self.get_contract().world(), (player, WAREHOUSE_START_INDEX), (Warehouse));
            warehouse.max_storage
        }
    }
}

