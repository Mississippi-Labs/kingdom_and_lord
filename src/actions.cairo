#[dojo::contract]
mod kingdom_lord_controller {
    use kingdom_lord::components::barn::{barn_component, Barn, BarnStorage};
    use kingdom_lord::components::barn::barn_component::BarnInternalImpl;
    use kingdom_lord::components::warehouse::{warehouse_component, Warehouse, WarehouseStorage};
    use kingdom_lord::components::outer_city::{outer_city_component, OuterCity};
    use kingdom_lord::components::outer_city::outer_city_component::{OuterCityInternalImpl};
    use kingdom_lord::components::city_hall::{
        city_hall_component, UnderUpgrading, new_waiting_upgrading, CityHall, CityHallGetLevel,
        WaitingToUpgrade
    };
    use kingdom_lord::components::city_hall::city_hall_component::{CityHallInternalTrait, CityHallInternalImpl};
    use kingdom_lord::components::city_wall::{CityWall};
    use kingdom_lord::components::city_building::{
        CityBuilding, new_city_building, CityBuildingGetLevelImpl
    };
    use kingdom_lord::components::universal::{universal_component, BuildingAreaInfo};
    use kingdom_lord::components::barrack::{
        barrack_component, Barrack, Troops, BarrackUnderTraining, new_wait_to_train,
        BarrackWaitingToTrain
    };
    use kingdom_lord::models::army::{SoldierKind, soldier_info, ArmyGroup};
    use kingdom_lord::components::barrack::barrack_component::BarrackInternalImpl;
    use kingdom_lord::components::universal::universal_component::UniversalInternalImpl;
    use kingdom_lord::components::globe::{globe_component, VillageConfirm};
    use kingdom_lord::models::building::{BuildingUpgradeResource, BuildingUpgradeInfo};
    use kingdom_lord::events::{
        NewPlayerSpawnEvent, StartUpgradeEvent, UpgradeNotEnoughResourceEvent, UpgradeCompleteEvent,
        UpgradeNotFinishedEvent, AlreadySpawnedEvent, PayToFinishedUpgradeEvent,
        TrainingFinishedEvent, StartTrainingEvent
    };
    use starknet::ContractAddress;
    use kingdom_lord::interface::{IKingdomLord, Error, IKingdomLordTest};
    use kingdom_lord::models::resource::{Wood, Brick, Steel, Food, Resource};
    use kingdom_lord::models::level::{Level, LevelExtentionTraitsImpl};
    use kingdom_lord::models::growth::GrowthRate;
    use kingdom_lord::models::building_kind::BuildingKind;
    use kingdom_lord::components::embassy::{Embassy};
    use kingdom_lord::components::config::{Config, verify_proof};
    use kingdom_lord::constants::{
        WOOD_BUILDING_COUNT, BRICK_BUILDING_COUNT, STEEL_BUILDING_COUNT, FOOD_BUILDING_COUNT,
        BASE_GROW_RATE, INITIAL_MAX_STORAGE, WAITING_UPGRADING_COUNT, CONFIG_ID,
        BRICK_BUILDING_START_INDEX, STEEL_BUILDING_START_INDEX, FOOD_BUILDING_START_INDEX,
        UNDER_TRAINING_COUNT, CITY_WALL_BUILDING_ID
    };
    use starknet::get_caller_address;
    use kingdom_lord::models::time::get_current_time;
    use kingdom_lord::components::college::{college_component, College};
    use kingdom_lord::components::college::college_component::CollegeInternalTrait;
    use kingdom_lord::components::stable::{stable_component, Stable, new_stable_wait_to_train, StableUnderTraining};
    use kingdom_lord::components::stable::stable_component::StableInternalTrait;
    // use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherImpl};

    component!(path: barn_component, storage: barn, event: BarnEvent);
    component!(path: warehouse_component, storage: warehouse, event: WarehouseEvent);
    component!(path: outer_city_component, storage: outer_city, event: OuterCityEvent);
    component!(path: city_hall_component, storage: city_hall, event: CityHallEvent);
    component!(path: universal_component, storage: universal, event: UniversalEvent);
    component!(path: barrack_component, storage: barrack, event: BarrackEvent);
    component!(path: college_component, storage: college, event: CollegeEvent);
    component!(path: stable_component, storage: stable, event: StableEvent);
    component!(path: globe_component, storage: globe, event: GlobeEvent);
    

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
        #[substorage(v0)]
        college: college_component::Storage,
        #[substorage(v0)]
        stable: stable_component::Storage,
        #[substorage(v0)]
        globe: globe_component::Storage,
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
        CollegeEvent: college_component::Event,
        StableEvent: stable_component::Event,
        GlobeEvent: globe_component::Event,
    }

    impl KLBarnImpl = barn_component::BarnInternalImpl<ContractState>;

    impl KLWarehouseImpl = warehouse_component::WarehouseInternalImpl<ContractState>;

    impl KLOuterCityImpl = outer_city_component::OuterCityTraitImpl<ContractState>;

    impl KLCityHallImpl = city_hall_component::CityHallInternalImpl<ContractState>;

    impl KLBarrackImpl = barrack_component::BarrackInternalImpl<ContractState>;

    impl KLCollegeImpl = college_component::CollegeInternalImpl<ContractState>;

    impl KLStableImpl = stable_component::StableInternalImpl<ContractState>;

    impl KLGlobeImpl = globe_component::GlobeInternalImpl<ContractState>;

    fn panic_on_err<T>(res: Result<T, Error>) -> Result<T, Error>{
        match res {
            Result::Ok(r) => Result::Ok(r),
            Result::Err(err) => {
                panic!("err: {:?}", err);
                Result::Err(err)
            }
        }
    }

    #[abi(embed_v0)]
    impl KingdomLordImpl of IKingdomLord<ContractState> {
        fn get_resource(self: @ContractState, player: ContractAddress) -> (Resource<Wood>, Resource<Brick>, Resource<Steel>, Resource<Food>){
            self._get_resource(player)
        }
        fn get_growth_rate(self: @ContractState, player: ContractAddress) -> (GrowthRate<Wood>, GrowthRate<Brick>, GrowthRate<Steel>, GrowthRate<Food>){
            self.outer_city.get_growth_rate(player)
        }
        fn get_under_upgrading(self: @ContractState, player: ContractAddress) -> UnderUpgrading{
            self.city_hall.get_under_upgrading(player)
        }
        fn get_waiting_upgrading(self: @ContractState, player: ContractAddress) -> Array<WaitingToUpgrade>{
            self.city_hall.get_waiting_upgrading(player)
        }
        fn get_buildings_levels(self: @ContractState, player: ContractAddress) -> Array<Level>{
            self._get_buildings_levels(player)
        }
        fn get_under_training(self: @ContractState, player: ContractAddress) -> BarrackUnderTraining{
            self._get_under_training(player)
        }
        fn get_waiting_to_train(self: @ContractState, player: ContractAddress) -> Array<BarrackWaitingToTrain>{
            self._get_waiting_to_train(player)
        }
        fn get_troops(self: @ContractState, player: ContractAddress) -> Troops{
            self.barrack.get_troops(player)
        }
        fn get_total_population(self: @ContractState, player: ContractAddress) -> u64{
            self.universal.get_total_population(player)
        }

        fn get_city_wall_power(self: @ContractState, player: ContractAddress) -> (u64, u64){
            let world = self.world_dispatcher.read();
            let city_wall = get!(world, (player), (CityWall));
            (city_wall.attack_power, city_wall.defense_power)
        }

        fn get_ally_amount(self: @ContractState, player: ContractAddress) -> u64{
            let world = self.world_dispatcher.read();
            let embassy = get!(world, (player), (Embassy));
            embassy.ally_amount
        }

        fn get_village_location(self: @ContractState, player: ContractAddress) -> (u64, u64){
            self.globe.get_village_location(player)
        }

        // write function
        fn spawn(self: @ContractState) -> Result<(), Error>{
            panic_on_err(self._spawn())
        }
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
            ) -> Result<u64, Error>{
            panic_on_err(self._start_upgrade(
                building_id,
                building_kind,
                next_level,
                req_wood,
                req_brick,
                req_steel,
                req_food,
                population,
                required_time,
                value,
                proof
            ))
            }
        fn finish_upgrade(self: @ContractState) -> Result<(), Error>{
            panic_on_err(self._finish_upgrade())
        }
        fn start_training(
                self: @ContractState,
                soldier_kind: u64,
            ) -> Result<u64, Error>{
            panic_on_err(self._start_training(soldier_kind))
            }
        fn finish_training(self: @ContractState, is_barrack: bool) -> Result<u64, Error>{
            panic_on_err(self._finish_training(is_barrack))
        }

        fn create_village_confirm(
            self: @ContractState
        ) -> Result<VillageConfirm, Error>{
            panic_on_err(self._create_village_confirm())
        }
    
        fn create_village_reveal(self: @ContractState) -> Result<(), Error>{
            panic_on_err(self._create_village_reveal())
        }
    
        fn create_ambush(
            self: @ContractState,
            ambush_hash: felt252,
            millitia: u64,
            guard: u64,
            heavy_infantry: u64,
            scouts: u64,
            knights: u64,
            heavy_knights: u64
        ) -> Result<(), Error>{
            panic_on_err(self._create_ambush_test(
                ambush_hash,
                millitia,
                guard,
                heavy_infantry,
                scouts,
                knights,
                heavy_knights
            ))
        }
        fn reveal_ambush(
            self: @ContractState,
            hash: felt252,
            x: u64,
            y: u64,
            time: u64,
            nonce: u64
        ) -> Result<bool, Error>{
            panic_on_err(self._reveal_ambush_test(
                hash,
                x,
                y,
                time,
                nonce
            ))
        }
    }

    #[abi(embed_v0)]
    impl KingdomLordTestImpl of IKingdomLordTest<ContractState>{

        // write function
        fn spawn_test(self: @ContractState) -> Result<(), Error>{
            self._spawn()
        }
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
        ) -> Result<u64, Error>{
            self._start_upgrade(
                building_id,
                building_kind,
                next_level,
                req_wood,
                req_brick,
                req_steel,
                req_food,
                population,
                required_time,
                value,
                proof
            )
        }
        fn finish_upgrade_test(self: @ContractState) -> Result<(), Error>{
            self._finish_upgrade()
        }
        fn start_training_test(self: @ContractState, soldier_kind: u64) -> Result<u64, Error>{
            self._start_training(soldier_kind)
        }
        fn finish_training_test(self: @ContractState, is_barrack: bool) -> Result<u64, Error>{
            self._finish_training(is_barrack)
        }

        fn create_village_confirm_test(
            self: @ContractState
        ) -> Result<VillageConfirm, Error>{
            self._create_village_confirm()
        }

        fn create_village_reveal_test(self: @ContractState) -> Result<(), Error>{
            self._create_village_reveal()
        }

        fn create_ambush_test(
            self: @ContractState,
            ambush_hash: felt252,
            millitia: u64,
            guard: u64,
            heavy_infantry: u64,
            scouts: u64,
            knights: u64,
            heavy_knights: u64
        ) -> Result<(), Error>{
            self._create_ambush_test(
                ambush_hash,
                millitia,
                guard,
                heavy_infantry,
                scouts,
                knights,
                heavy_knights
            )
        }
        fn reveal_ambush_test(
            self: @ContractState,
            hash: felt252,
            x: u64,
            y: u64,
            time: u64,
            nonce: u64
        ) -> Result<bool, Error>{
            self._reveal_ambush_test(
                hash,
                x,
                y,
                time,
                nonce
            )
        }

    }


    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn mine(self: @ContractState) {
            let (mined_wood, mined_brick, mined_steel, mined_food) = self.outer_city.mine();
            self.warehouse.add_resource(mined_wood, mined_brick, mined_steel);
            self.barn.add_food(mined_food);
        }

        fn _spawn(self: @ContractState) -> Result<(), Error> {
            let world = self.world_dispatcher.read();

            let player = get_caller_address();
            let spawn_status = get!(world, (player), (SpawnStatus));
            let time = get_current_time();
            if spawn_status.already_spawned {
                emit!(world, AlreadySpawnedEvent { player ,block: time});
                return Result::Err(Error::AlreadySpawned);
            }
            set!(
                world,
                (
                    WarehouseStorage {
                        player,
                        wood: 0_u64.into(),
                        steel: 0_u64.into(),
                        bricks: 0_u64.into(),
                        max_storage: INITIAL_MAX_STORAGE,
                    },
                    BarnStorage { player, food: 0_u64.into(), max_storage: INITIAL_MAX_STORAGE, },
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

            // initialize city CityWall
            set!(world,  (BuildingAreaInfo {
                            player,
                            building_id: CITY_WALL_BUILDING_ID,
                            building_kind: BuildingKind::CityWall.into()
                        }));

            // initialize upgrading list
            index = 0;
            loop {
                set!(world, (new_waiting_upgrading(player, index)));
                if index == WAITING_UPGRADING_COUNT {
                    break;
                }
                index += 1
            };

            set!(world, UnderUpgrading{
                player,
                building_id: 0,
                building_kind: 0,
                target_level: 0_u64.into(),
                start_time: 0,
                end_time: 0,
                is_new_building: false,
                is_finished: true,
                value: 0,
                population:0,
                current_upgrade_id: 0
            });

            set!(
                world,
                (Troops {
                    player,
                    army: ArmyGroup{
                        millitia: 0,
                        guard: 0,
                        heavy_infantry: 0,
                        scouts: 0,
                        knights: 0,
                        heavy_knights: 0
                    }
                })
            );

            // initialize upgrading list
            index = 0;
            loop {
                set!(world, (new_wait_to_train(player, index)));
                if index == UNDER_TRAINING_COUNT {
                    break;
                }
                index += 1
            };

            set!(world, BarrackUnderTraining {
                address: player,
                current_training_id: 0,
                soldier_kind: 0,
                start_time: 0,
                end_time: 0,
                is_finished: true
            });

            index = 0;
            loop {
                set!(world, (new_stable_wait_to_train(player, index)));
                if index == UNDER_TRAINING_COUNT {
                    break;
                }
                index += 1
            };

            set!(world, StableUnderTraining {
                address: player,
                current_training_id: 0,
                soldier_kind: 0,
                start_time: 0,
                end_time: 0,
                is_finished: true
            });

            set!(world, (SpawnStatus { player, already_spawned: true }));
            emit!(world, NewPlayerSpawnEvent { player, time });
            Result::Ok(())
        }

        fn _get_resource(
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


        fn _start_upgrade(
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
        ) -> Result<u64, Error> {
            let caller_address = get_caller_address();
            let world = self.world_dispatcher.read();
            let building_kind_num = building_kind;
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
            let curr_building_kind = self.universal.building_kind(building_id);

            if building_kind != curr_building_kind && curr_building_kind != BuildingKind::None {
                // panic!("invalid building kind");
                return Result::Err(Error::UnknownedError('invalid building kind'));
            }
            let is_new_building = curr_building_kind == BuildingKind::None;
            if is_new_building && building_kind == BuildingKind::Warehouse{
                let is_all_max_level = self.universal.check_all_building_reaching_max_level(true);
                if !is_all_max_level {
                    return Result::Err(Error::StorageBuildingNotMaxLevel);
                }
            }

            if is_new_building && building_kind == BuildingKind::Barn{
                let is_all_max_level = self.universal.check_all_building_reaching_max_level(false);
                if !is_all_max_level {
                    return Result::Err(Error::StorageBuildingNotMaxLevel);
                }
            }
            if !self.universal.is_next_level_valid(building_id, building_kind, next_level) {
                // panic!("next level is not valid");
                return Result::Err(Error::UnknownedError('next level is not valid'));
            }

            let req_wood = req_wood.into();
            let req_brick = req_brick.into();
            let req_steel = req_steel.into();
            let req_food = req_food.into();
            let (wood, brick, steel, food) = self.get_resource(caller_address);
            if wood < req_wood || brick < req_brick || steel < req_steel || food < req_food {
                emit!(world, UpgradeNotEnoughResourceEvent { player: caller_address, building_id });
                // panic!("resource not enough");
                return Result::Err(Error::ResourceNotEnough);
            }

            let world = self.world_dispatcher.read();
            let config = get!(world, (CONFIG_ID), (Config));
            if !verify_proof(config, data.span(), proof.span()) {
                // panic!("invalid proof");
                return Result::Err(Error::InvalidProof);
            }

            let res = self
                .city_hall
                .start_upgrade(
                    building_id,
                    building_kind_num,
                    next_level.into(),
                    required_time,
                    value,
                    population,
                    is_new_building
                );
            match res {
                Result::Ok(upgrade_id) => {
                    self.mine();
                    self.warehouse.remove_resource(req_wood, req_brick, req_steel);
                    self.barn.remove_food(req_food);
                    emit!(world, 
                            StartUpgradeEvent {
                                player: caller_address,
                                upgrade_id,
                                building_id: building_id,
                                level: next_level,
                            }
                        );
                    Result::Ok(upgrade_id)
                },
                Result::Err(err) => Result::Err(err)
            }
        }

        fn _finish_upgrade(self: @ContractState) -> Result<(), Error> {
            let res = self.city_hall.finish_upgrade();
            let world = self.world_dispatcher.read();
            let player = get_caller_address();
            match res {
                Result::Ok(finished_building_info) => {
                    self.mine();
                    if finished_building_info.is_new_building {
                        self
                            .universal
                            .new_building(
                                finished_building_info.building_id,
                                finished_building_info.building_kind.into()
                            );
                    } else {
                        self
                            .universal
                            .level_up(
                                finished_building_info.building_id,
                                finished_building_info.building_kind.into(),
                                (finished_building_info.value, finished_building_info.population)
                            );
                    }
                    emit!(world, 
                            UpgradeCompleteEvent {
                                player,
                                upgrade_id: finished_building_info.upgrade_id,
                                building_next: finished_building_info.building_next
                            }
                        );
                    Result::Ok(())
                },
                Result::Err(err) => {
                    let block = get_current_time();
                    emit!(world, UpgradeNotFinishedEvent { player , block});
                    Result::Err(err)
                }
            }
        }

        // fn pay_to_finish_upgrade(ref self: ContractState, upgrade_id: u64) -> Result<(), Error> {
        //     let caller = starknet::get_caller_address();

        //     let world = self.world_dispatcher.read();
        //     let config = get!(world, (CONFIG_ID), (Config));
        //     let erc20_dispatcher = IERC20Dispatcher { contract_address: config.erc20_addr };
        //     let res = erc20_dispatcher.transfer_from(caller, config.receiver, config.amount);
        //     if res {
        //         let result = self.city_hall.pay_to_finish_upgrade(upgrade_id);
        //         match result {
        //             Result::Ok(under_upgrade) => {
        //                 let caller = get_caller_address();
        //                 self
        //                     .emit(
        //                         PayToFinishedUpgradeEvent {
        //                             player: caller,
        //                             upgrade_id,
        //                             building_id: under_upgrade.building_id,
        //                             level: under_upgrade.target_level
        //                         }
        //                     );
        //                 Result::Ok(())
        //             },
        //             Result::Err(_) => { panic!("pay to finish upgrade error") }
        //         }
        //     } else {
        //         Result::Err(Error::PayToUpgradeError)
        //     }
        // }


        fn _start_training(self: @ContractState, soldier_kind: u64) -> Result<u64, Error> {
            let caller_address = get_caller_address();
            let soldier_kind_num = soldier_kind;
            let soldier_kind: SoldierKind = soldier_kind.into();
            let soldier_info = soldier_info(soldier_kind);
            let req_wood = soldier_info.req_wood.into();
            let req_brick = soldier_info.req_brick.into();
            let req_steel = soldier_info.req_steel.into();
            let req_food = soldier_info.req_food.into();
            let (wood, brick, steel, food) = self.get_resource(caller_address);
            if wood < req_wood || brick < req_brick || steel < req_steel || food < req_food {
                return Result::Err(Error::ResourceNotEnough);
            }
            if !self.college.is_solider_allowed(soldier_kind) {
                return Result::Err(Error::TrainingPrerequirementNotMatch);
            }

            self.mine();
            self.warehouse.remove_resource(req_wood, req_brick, req_steel);
            self.barn.remove_food(req_food);

            let res = if soldier_kind_num < 3{
                self.barrack.start_training(soldier_kind, soldier_info.required_time)
            }   else {
                self.stable.start_training(soldier_kind, soldier_info.required_time)
            };
            match res {
                Result::Ok(training_id) => {
                    let world = self.world_dispatcher.read();
                    emit!(world,
                            StartTrainingEvent {
                                player: caller_address,
                                training_id: training_id,
                                soldier_kind: soldier_kind_num,
                            }
                        );
                    Result::Ok(training_id)
                },
                Result::Err(err) => {Result::Err(err)}
            }
        }

        fn _finish_training(
            self: @ContractState, is_barrack: bool,
        ) -> Result<u64, Error> {
            let res = if is_barrack{
                self.barrack.finish_training()
            } else {
                self.stable.finish_training()
            };
            match res {
                Result::Ok(training_id) => {
                    self.mine();
                    let player = get_caller_address();
                    let world = self.world_dispatcher.read();
                    emit!(world, TrainingFinishedEvent { player, training_id });
                },
                Result::Err(_) => {}
            }
            res
        }

        fn _get_under_training(
            self: @ContractState, player: ContractAddress,
        ) -> BarrackUnderTraining {
            self.barrack.get_under_training(player)
        }

        fn _get_waiting_to_train(
            self: @ContractState, player: ContractAddress,
        ) -> Array<BarrackWaitingToTrain> {
            self.barrack.get_waiting_to_train(player)
        }

        fn _get_buildings_levels(self: @ContractState, player: ContractAddress) -> Array<Level> {
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
            let city_hall = get!(world, (player), (CityHall));
            res.append(city_hall.get_level());
            res
        }

        fn _create_village_confirm(self: @ContractState) -> Result<VillageConfirm, Error>{
            self.globe.create_village_confirm()
        }

        fn _create_village_reveal(self: @ContractState) -> Result<(), Error>{
            self.globe.create_village_reveal()
        }

        fn _create_ambush_test(
            self: @ContractState,
            ambush_hash: felt252,
            millitia: u64,
            guard: u64,
            heavy_infantry: u64,
            scouts: u64,
            knights: u64,
            heavy_knights: u64
        ) -> Result<(), Error>{
            Result::Ok(())
        }
        fn _reveal_ambush_test(
            self: @ContractState,
            hash: felt252,
            x: u64,
            y: u64,
            time: u64,
            nonce: u64
        ) -> Result<bool, Error>{
            Result::Ok(true)
        }
    }
}
