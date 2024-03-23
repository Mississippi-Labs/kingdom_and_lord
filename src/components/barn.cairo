use core::traits::Into;
use starknet::ContractAddress;
use super::super::models::resource::{Food, Resource};
use kingdom_lord::models::level::Level;
use kingdom_lord::models::building::{BuildingUpgradeResource};
use kingdom_lord::models::level::{LevelTrait, LevelUpTrait};
#[derive(Model, Copy, Drop, Serde)]
struct Barn{
    #[key]
    player: ContractAddress,
    #[key]
    building_id: u64,
    level: Level,
    max_storage: u64,
    population: u64
}

#[derive(Model, Copy, Drop, Serde)]
struct BarnStorage{
    #[key]
    player: ContractAddress,
    food: Resource<Food>,
    max_storage: u64,
}

#[generate_trait]
impl BarnTraitImpl of BarnStorageExtension{
    fn get_food(self: @BarnStorage) -> Resource<Food>{
        self.food.clone()
    }

    fn add_food(ref self: BarnStorage, food: Resource<Food>){
        let new_amount = self.food + food;
        if new_amount > self.max_storage.into(){
            self.food = self.max_storage.into();
        } else {
            self.food = new_amount;
        }
    }

    fn remove_food(ref self: BarnStorage, food: Resource<Food>){
        self.food -= food;
    }
}


impl WarehouseLeveTrait of LevelUpTrait<Barn, (u64, u64)>{
    fn level_up(ref self: Barn, value: (u64, u64)){
        self.level.level_up(());
        let (max_storage, population) = value;
        self.max_storage = max_storage;
        self.population = population;
    }
}

impl WarehouseGetLevel of LevelTrait<Barn>{
        fn get_level(self: @Barn) -> Level{
        self.level.get_level()
    }
}


#[starknet::component]
mod barn_component{
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::{Barn, Food, Resource, BarnStorageExtension, BarnStorage};

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl BarnInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of BarnInternalTrait<TContractState> {
        fn add_food(self: @ComponentState<TContractState>, food: Resource<Food>){
            let world = self.get_contract().world();
            let player = get_caller_address();
            let mut barn = get!(world, (player), (BarnStorage));
            barn.add_food(food);
            set!(world, (barn))
        }

        fn remove_food(self: @ComponentState<TContractState>, food: Resource<Food>){
            let world = self.get_contract().world();
            let player = get_caller_address();
            let mut barn = get!(world, (player), (BarnStorage));
            barn.remove_food(food);
            set!(world, (barn))
        }

        fn get_food(self: @ComponentState<TContractState>, player: ContractAddress) -> Resource<Food>{
            let barn = get!(self.get_contract().world(), (player), (BarnStorage));
            barn.get_food()
        }

        fn get_max_storage(self: @ComponentState<TContractState>, player: ContractAddress) -> u64{
            let barn = get!(self.get_contract().world(), (player), (BarnStorage));
            barn.max_storage
        }
    }
}