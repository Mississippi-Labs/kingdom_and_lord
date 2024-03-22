#[dojo::contract]
mod kingdom_lord_controller {
    use kingdom_lord::components::barn::{barn_component, Barn};
    use kingdom_lord::components::barn::barn_component::BarnInternalImpl;
    use kingdom_lord::components::warehouse::{warehouse_component, Warehouse};
    use kingdom_lord::components::outer_city::{outer_city_component, OuterCity};
    use kingdom_lord::components::outer_city::outer_city_component::{OuterCityInternalImpl};
    use kingdom_lord::helpers::contract_address::FmtContractAddr;
    use kingdom_lord::components::city_hall::{
        city_hall_component, UnderUpgrading, new_under_upgrading, CityHall, CityHallGetLevel
    };
    use kingdom_lord::components::city_building::{
        CityBuilding, new_city_building, CityBuildingGetLevelImpl
    };
    use kingdom_lord::components::universal::{universal_component, BuildingAreaInfo};
    use kingdom_lord::components::barrack::{
        barrack_component, Barrack, Troops, UnderTraining, SoldierKind, new_under_training,
        soldier_info
    };
    use kingdom_lord::components::barrack::barrack_component::BarrackInternalImpl;
    use kingdom_lord::components::universal::universal_component::UniversalInternalImpl;
    use kingdom_lord::models::building::{BuildingUpgradeResource, BuildingUpgradeInfo};
    use kingdom_lord::events::{
        NewPlayerSpawnEvent, StartUpgradeEvent, UpgradeNotEnoughResourceEvent, UpgradeCompleteEvent,
        UpgradeNotFinishedEvent, AlreadySpawnedEvent, PayToFinishedUpgradeEvent,
        TrainingFinishedEvent, StartTrainingEvent
    };
    use starknet::ContractAddress;
    use kingdom_lord::interface::{IKingdomLord, Error};
    use kingdom_lord::models::resource::{Wood, Brick, Steel, Food, Resource};
    use kingdom_lord::models::level::{Level, LevelExtentionTraitsImpl};
    use kingdom_lord::models::growth::GrowthRate;
    use kingdom_lord::models::building_kind::BuildingKind;
    use kingdom_lord::components::config::{Config, verify_proof};
    use kingdom_lord::constants::{
        WOOD_BUILDING_COUNT, BRICK_BUILDING_COUNT, STEEL_BUILDING_COUNT, FOOD_BUILDING_COUNT,
        BASE_GROW_RATE, INITIAL_MAX_STORAGE, UNDER_UPGRADING_COUNT, CITY_HALL_START_INDEX,
        WAREHOUSE_START_INDEX, BARN_START_INDEX, CONFIG_ID, BRICK_BUILDING_START_INDEX,
        STEEL_BUILDING_START_INDEX, FOOD_BUILDING_START_INDEX, BARRACK_START_INDEX, UNDER_TRAINING_COUNT
    };
    use starknet::get_caller_address;
    use kingdom_lord::models::time::get_current_time;
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherImpl};

    component!(path: barn_component, storage: barn, event: BarnEvent);
    component!(path: warehouse_component, storage: warehouse, event: WarehouseEvent);
    component!(path: outer_city_component, storage: outer_city, event: OuterCityEvent);
    component!(path: city_hall_component, storage: city_hall, event: CityHallEvent);
    component!(path: universal_component, storage: universal, event: UniversalEvent);
    component!(path: barrack_component, storage: barrack, event: BarrackEvent);

    #[derive(Model, Serde, Drop)]
    struct SpawnStatus {
        #[key]
        player: ContractAddress,
        already_spawned: bool
    }

    #[storage]
    struct Storage {
        #[substorage(v0)]
        barn: barn_component::Storage,
        #[substorage(v0)]
        warehouse: warehouse_component::Storage,
        #[substorage(v0)]
        outer_city: outer_city_component::Storage,
        #[substorage(v0)]
        city_hall: city_hall_component::Storage,
        #[substorage(v0)]
        universal: universal_component::Storage,
        #[substorage(v0)]
        barrack: barrack_component::Storage,
    }


    #[event]
    #[derive(Copy, Drop, starknet::Event)]
    enum Event {
        BarnEvent: barn_component::Event,
        WarehouseEvent: warehouse_component::Event,
        OuterCityEvent: outer_city_component::Event,
        CityHallEvent: city_hall_component::Event,
        UniversalEvent: universal_component::Event,
        BarrackEvent: barrack_component::Event,
        // custom
        NewPlayerSpawnEvent: NewPlayerSpawnEvent,
        StartUpgradeEvent: StartUpgradeEvent,
        UpgradeNotEnoughResourceEvent: UpgradeNotEnoughResourceEvent,
        UpgradeCompleteEvent: UpgradeCompleteEvent,
        UpgradeNotFinishedEvent: UpgradeNotFinishedEvent,
        AlreadySpawnedEvent: AlreadySpawnedEvent,
        PayToFinishedUpgradeEvent: PayToFinishedUpgradeEvent,
        StartTrainingEvent: StartTrainingEvent,
        TrainingFinisedEvent: TrainingFinishedEvent,
    }

    impl KLBarnImpl = barn_component::BarnInternalImpl<ContractState>;

    impl KLWarehouseImpl = warehouse_component::WarehouseInternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl KLOuterCityImpl = outer_city_component::OuterCityTraitImpl<ContractState>;

    impl KLCityHallImpl = city_hall_component::CityHallInternalImpl<ContractState>;

    impl KLBarrackImpl = barrack_component::BarrackInternalImpl<ContractState>;

    #[abi(embed_v0)]
    impl KingdomLordImpl of IKingdomLord<ContractState> {
        fn spawn(ref self: ContractState) -> Result<(), Error> {
            let world = self.world_dispatcher.read();

            let player = get_caller_address();
            let spawn_status = get!(world, (player), (SpawnStatus));
            if spawn_status.already_spawned {
                self.emit(AlreadySpawnedEvent { player });
                return Result::Err(Error::AlreadySpawned);
            }
            let time = get_current_time();
            set!(
                world,
                (
                    Warehouse {
                        player,
                        building_id: WAREHOUSE_START_INDEX,
                        level: 0_u64.into(),
                        wood: 0_u64.into(),
                        steel: 0_u64.into(),
                        bricks: 0_u64.into(),
                        max_storage: INITIAL_MAX_STORAGE,
                        population: 0_u64.into()
                    },
                    BuildingAreaInfo {
                        player,
                        building_id: WAREHOUSE_START_INDEX,
                        building_kind: BuildingKind::Warehouse.into()
                    },
                    Barn {
                        player,
                        building_id: BARN_START_INDEX,
                        level: 0_u64.into(),
                        food: 0_u64.into(),
                        max_storage: INITIAL_MAX_STORAGE,
                        population: 0_u64.into()
                    },
                    BuildingAreaInfo {
                        player,
                        building_id: BARN_START_INDEX,
                        building_kind: BuildingKind::Barn.into()
                    },
                    OuterCity { player, last_mined_time: time },
                )
            );

            // initialize outer city buildings
            let mut index = 0;
            let max_index = WOOD_BUILDING_COUNT
                + BRICK_BUILDING_COUNT
                + STEEL_BUILDING_COUNT
                + FOOD_BUILDING_COUNT;
            loop {
                if index == max_index {
                    break;
                }
                if index < BRICK_BUILDING_START_INDEX {
                    set!(
                        world,
                        (new_city_building(
                            player, BuildingKind::WoodBuilding, BASE_GROW_RATE, 0_u64.into(), index
                        ))
                    );
                    set!(
                        world,
                        (BuildingAreaInfo {
                            player,
                            building_id: index,
                            building_kind: BuildingKind::WoodBuilding.into()
                        })
                    );
                } else if index >= BRICK_BUILDING_START_INDEX
                    && index < STEEL_BUILDING_START_INDEX {
                    set!(
                        world,
                        (new_city_building(
                            player, BuildingKind::BrickBuilding, BASE_GROW_RATE, 0_u64.into(), index
                        ))
                    );
                    set!(
                        world,
                        (BuildingAreaInfo {
                            player,
                            building_id: index,
                            building_kind: BuildingKind::BrickBuilding.into()
                        })
                    );
                } else if index >= STEEL_BUILDING_START_INDEX && index < FOOD_BUILDING_START_INDEX {
                    set!(
                        world,
                        (new_city_building(
                            player, BuildingKind::SteelBuilding, BASE_GROW_RATE, 0_u64.into(), index
                        ))
                    );
                    set!(
                        world,
                        (BuildingAreaInfo {
                            player,
                            building_id: index,
                            building_kind: BuildingKind::SteelBuilding.into()
                        })
                    );
                } else if index < max_index {
                    set!(
                        world,
                        (new_city_building(
                            player, BuildingKind::FoodBuilding, BASE_GROW_RATE, 0_u64.into(), index
                        ))
                    );
                    set!(
                        world,
                        (BuildingAreaInfo {
                            player,
                            building_id: index,
                            building_kind: BuildingKind::FoodBuilding.into()
                        })
                    );
                } else {
                    panic!("index not valid")
                }
                index += 1
            };

            // initialize upgrading list
            index = 0;
            loop {
                set!(world, (new_under_upgrading(player, index)));
                if index == UNDER_UPGRADING_COUNT {
                    break;
                }
                index += 1
            };
            let city_hall = CityHall {
                player, building_id: CITY_HALL_START_INDEX, level: 1_u64.into(), bonus: 0_u64, population: 0_u64
            };
            set!(world, (city_hall));
            set!(
                world,
                (BuildingAreaInfo {
                    player,
                    building_id: CITY_HALL_START_INDEX,
                    building_kind: BuildingKind::CityHall.into()
                })
            );

            // initialize barrack
            set!(
                world,
                (Barrack {
                    player, building_id: BARRACK_START_INDEX, level: 0_u64.into(), bonus: 100_u64, population: 0_u64
                })
            );
            set!(
                world,
                (Troops {
                    player,
                    millitia: 0,
                    guard: 0,
                    heavy_infantry: 0,
                    scouts: 0,
                    knights: 0,
                    heavy_knights: 0
                })
            );

            // initialize upgrading list
            index = 0;
            loop {
                set!(world, (new_under_training(player, index)));
                if index == UNDER_TRAINING_COUNT {
                    break;
                }
                index += 1
            };

            set!(world, (SpawnStatus { player, already_spawned: true }));
            self.emit(NewPlayerSpawnEvent { player, time });
            Result::Ok(())
        }

        fn get_total_population(self: @ContractState, player: ContractAddress) -> u64{
            self.universal.get_total_population(player)
        }

        fn get_resource(
            self: @ContractState, player: ContractAddress,
        ) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>, Resource<Food>) {
            let (wood, brick, steel, food) = self.outer_city.get_minable_resource(player);
            let remain_food = self.barn.get_food(player);
            let (remain_wood, remain_brick, remain_steel) = self.warehouse.get_resource(player);
            let warehouse_max_storage = self.warehouse.get_max_storage(player);
            let barn_max_storage = self.barn.get_max_storage(player);

            let mut wood_sum = wood + remain_wood;
            if wood_sum > warehouse_max_storage.into() {
                wood_sum = warehouse_max_storage.into();
            }

            let mut brick_sum = brick + remain_brick;
            if brick_sum > warehouse_max_storage.into() {
                brick_sum = warehouse_max_storage.into();
            }

            let mut steel_sum = steel + remain_steel;
            if steel_sum > warehouse_max_storage.into() {
                steel_sum = warehouse_max_storage.into();
            }

            let mut food_sum = food + remain_food;
            if food_sum > barn_max_storage.into() {
                food_sum = barn_max_storage.into();
            }

            (wood_sum, brick_sum, steel_sum, food_sum)
        }

        fn get_growth_rate(
            self: @ContractState, player: ContractAddress,
        ) -> (GrowthRate<Wood>, GrowthRate<Brick>, GrowthRate<Steel>, GrowthRate<Food>) {
            self.outer_city.get_growth_rate(player)
        }

        fn start_upgrade(
            ref self: ContractState,
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
        ) -> Result<u64, Error> {
            let caller_address = get_caller_address();
            let data: Array<felt252> = array![
                building_kind.into(),
                next_level.into(),
                req_wood.into(),
                req_brick.into(),
                req_steel.into(),
                req_food.into(),
                population.into(),
                required_time.into(),
                value.into()
            ];

            let building_kind: BuildingKind = building_kind.into();
            let next_level: Level = next_level.into();
            let building_kind = self.universal.building_kind(building_id);

            if building_kind != building_kind && building_kind != BuildingKind::None {
                return Result::Err(Error::UnknownedError('invalid building kind'));
            }

            if !self.universal.is_next_level_valid(building_id, building_kind, next_level) {
                return Result::Err(Error::UnknownedError('next level is not valid'));
            }

            let req_wood = req_wood.into();
            let req_brick = req_brick.into();
            let req_steel = req_steel.into();
            let req_food = req_food.into();
            let (wood, brick, steel, food) = self.get_resource(caller_address);
            if wood < req_wood || brick < req_brick || steel < req_steel || food < req_food {
                self.emit(UpgradeNotEnoughResourceEvent { player: caller_address, building_id });
                return Result::Err(Error::ResourceNotEnough);
            }

            let world = self.world_dispatcher.read();
            let config = get!(world, (CONFIG_ID), (Config));
            if !verify_proof(config, data.span(), proof.span()) {
                return Result::Err(Error::InvalidProof);
            }

            let res = self
                .city_hall
                .start_upgrade(building_id, next_level.into(), required_time, value, population);
            match res {
                Result::Ok(under_upgrading) => {
                    self.mine();
                    self.warehouse.remove_resource(req_wood, req_brick, req_steel);
                    self.barn.remove_food(req_food);
                    self
                        .emit(
                            StartUpgradeEvent {
                                player: caller_address,
                                upgrade_id: under_upgrading.upgrade_id,
                                building_id: under_upgrading.building_id,
                                level: under_upgrading.target_level,
                                start_time: under_upgrading.start_time,
                                end_time: under_upgrading.end_time,
                            }
                        );
                    Result::Ok(under_upgrading.upgrade_id)
                },
                Result::Err(err) => Result::Err(err)
            }
        }

        fn finish_upgrade(
            ref self: ContractState, upgrade_id: u64
        ) -> Result<UnderUpgrading, Error> {
            let res = self.city_hall.finish_upgrade(upgrade_id);
            let player = get_caller_address();
            match res {
                Result::Ok(under_upgrade) => {
                    let world = self.world_dispatcher.read();
                    let building_id: u64 = under_upgrade.building_id;
                    let building_kind = self.universal.building_kind(building_id);
                    self.universal.level_up(building_id, building_kind, (under_upgrade.value, under_upgrade.population));
                    self.mine();
                    self
                        .emit(
                            UpgradeCompleteEvent {
                                player, upgrade_id, building_id, level: under_upgrade.target_level
                            }
                        );
                },
                Result::Err(err) => { self.emit(UpgradeNotFinishedEvent { player, upgrade_id }) }
            }
            res
        }

        fn pay_to_finish_upgrade(ref self: ContractState, upgrade_id: u64) -> Result<(), Error> {
            let caller = starknet::get_caller_address();
            
            let world = self.world_dispatcher.read();
            let config = get!(world, (CONFIG_ID), (Config));
            let erc20_dispatcher = IERC20Dispatcher { contract_address: config.erc20_addr };
            let res = erc20_dispatcher.transfer_from(caller, config.receiver, config.amount);
            if res {
                let result = self.city_hall.pay_to_finish_upgrade(upgrade_id);
                match result {
                    Result::Ok(under_upgrade) => {
                        let caller = get_caller_address();
                        self
                            .emit(
                                PayToFinishedUpgradeEvent {
                                    player: caller,
                                    upgrade_id,
                                    building_id: under_upgrade.building_id,
                                    level: under_upgrade.target_level
                                }
                            );
                        Result::Ok(())
                    },
                    Result::Err(_) => { panic!("pay to finish upgrade error") }
                }
            } else {
                Result::Err(Error::PayToUpgradeError)
            }
        }

        fn get_under_upgrading(
            self: @ContractState, player: ContractAddress,
        ) -> Array<UnderUpgrading> {
            self.city_hall.get_under_upgrading(player)
        }

        fn get_complete_upgrading(
            self: @ContractState, player: ContractAddress,
        ) -> Array<UnderUpgrading> {
            self.city_hall.get_complete_upgrading(player)
        }
        fn get_troops(self: @ContractState, player: ContractAddress) -> Troops {
            self.barrack.get_troops(player)
        }

        fn start_training(ref self: ContractState, barrack_kind: u64,) -> Result<u64, Error> {
            let caller_address = get_caller_address();
            let soldier_info = soldier_info(barrack_kind.into());
            let req_wood = soldier_info.req_wood.into();
            let req_brick = soldier_info.req_brick.into();
            let req_steel = soldier_info.req_steel.into();
            let req_food = soldier_info.req_food.into();
            let (wood, brick, steel, food) = self.get_resource(caller_address);
            if wood < req_wood || brick < req_brick || steel < req_steel || food < req_food {
                return Result::Err(Error::ResourceNotEnough);
            }

            self.mine();
            self.warehouse.remove_resource(req_wood, req_brick, req_steel);
            self.barn.remove_food(req_food);
            let soldier_kind: SoldierKind = barrack_kind.into();
            let res = self.barrack.start_training(soldier_kind, soldier_info.required_time);
            match res {
                Result::Ok(under_training) => {
                    self
                        .emit(
                            StartTrainingEvent {
                                player: caller_address,
                                training_id: under_training.training_id,
                                soldier_kind: under_training.soldier_kind,
                                start_time: under_training.start_time,
                                end_time: under_training.end_time,
                            }
                        );
                    Result::Ok(under_training.training_id)
                },
                Result::Err(err) => Result::Err(err)
            }
        }

        fn finish_training(
            ref self: ContractState, training_id: u64
        ) -> Result<UnderTraining, Error> {
            let res = self.barrack.finish_training(training_id);
            match res {
                Result::Ok(traning_res) => {
                    self.mine();
                    let player = get_caller_address();
                    self.emit(TrainingFinishedEvent { player, training_id });
                },
                Result::Err(err) => {}
            }
            res
        }

        fn get_under_training(
            self: @ContractState, player: ContractAddress,
        ) -> Array<UnderTraining> {
            self.barrack.get_under_training(player)
        }

        fn get_complete_training(
            self: @ContractState, player: ContractAddress,
        ) -> Array<UnderTraining> {
            self.barrack.get_complete_training(player)
        }

        fn get_buildings_levels(self: @ContractState, player: ContractAddress) -> Array<Level> {
            let world = self.world_dispatcher.read();
            let mut res = array![];
            let mut index = 0_u64;
            loop {
                if index == 18 {
                    break;
                }
                let building = get!(world, (player, index), (CityBuilding));
                res.append(building.get_level());
                index += 1;
            };
            let city_hall = get!(world, (player, CITY_HALL_START_INDEX), (CityHall));
            res.append(city_hall.get_level());
            res
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
