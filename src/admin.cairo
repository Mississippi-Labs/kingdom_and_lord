#[dojo::contract]
mod kingdom_lord_admin {
    use kingdom_lord::interface::IKingdomLordAdmin;
    use kingdom_lord::components::config::Config;
    use kingdom_lord::components::barn::{barn_component, Barn};
    use kingdom_lord::components::warehouse::{warehouse_component, Warehouse};
    use kingdom_lord::components::outer_city::{outer_city_component, OuterCity};
    use starknet::{get_contract_address, ContractAddress};
    use kingdom_lord::components::outer_city::outer_city_component::{OuterCityInternalImpl};
    use kingdom_lord::constants::{
        WOOD_BUILDING_COUNT, BRICK_BUILDING_COUNT, STEEL_BUILDING_COUNT, FOOD_BUILDING_COUNT,
        BASE_GROW_RATE,  UNDER_UPGRADING_COUNT, CITY_HALL_START_INDEX,
        WAREHOUSE_START_INDEX, BARN_START_INDEX, CONFIG_ID
    };
    component!(path: barn_component, storage: barn, event: BarnEvent);
    component!(path: warehouse_component, storage: warehouse, event: WarehouseEvent);
    component!(path: outer_city_component, storage: outer_city, event: OuterCityEvent);

    #[storage]
    struct Storage {
        #[substorage(v0)]
        barn: barn_component::Storage,
        #[substorage(v0)]
        warehouse: warehouse_component::Storage,
        #[substorage(v0)]
        outer_city: outer_city_component::Storage,
    }
    #[event]
    #[derive(Copy, Drop, starknet::Event)]
    enum Event {
        BarnEvent: barn_component::Event,
        WarehouseEvent: warehouse_component::Event,
        OuterCityEvent: outer_city_component::Event,
    }
    impl KLBarnImpl = barn_component::BarnInternalImpl<ContractState>;

    impl KLWarehouseImpl = warehouse_component::WarehouseInternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl KLOuterCityImpl = outer_city_component::OuterCityTraitImpl<ContractState>;

    #[abi(embed_v0)]
    impl KindomLordAdminImpl of IKingdomLordAdmin<ContractState>{
        fn set_config(self: @ContractState, erc20_addr: ContractAddress, amount: u256, receiver: ContractAddress, level_root_merkle: felt252){
            let world = self.world_dispatcher.read();
            let mut config = get!(world, (CONFIG_ID), (Config));
            config.erc20_addr = erc20_addr;
            config.amount = amount;
            config.receiver = receiver;
            config.merkle_root =  level_root_merkle;
            set!(world, (config))
        }

        fn set_barn_max_storage(self: @ContractState, addr: ContractAddress, max_storage: u64){
            let world = self.world_dispatcher.read();
            let mut barn = get!(world, (addr, BARN_START_INDEX), (Barn));
            barn.max_storage = max_storage;
            set!(world, (barn))
        }

        fn set_warehouse_max_storage(self: @ContractState, addr: ContractAddress, max_storage: u64){
            let world = self.world_dispatcher.read();
            let mut warehouse = get!(world, (addr, WAREHOUSE_START_INDEX), (Warehouse));
            warehouse.max_storage = max_storage;
            set!(world, (warehouse))
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn mine(self: @ContractState) {
            let (mined_wood, mined_brick, mined_steel, mined_food) = self.outer_city.mine();
            self.warehouse.add_resource(mined_wood, mined_brick, mined_steel);
            self.barn.add_food(mined_food);
        }

    }
}