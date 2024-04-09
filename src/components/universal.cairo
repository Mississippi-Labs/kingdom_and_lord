use kingdom_lord::models::building_kind::BuildingKind;
use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde)]
struct BuildingAreaInfo {
    #[key]
    player: ContractAddress,
    #[key]
    building_id: u64,
    building_kind: u64,
}


#[starknet::component]
mod universal_component {
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::BuildingAreaInfo;
    use kingdom_lord::constants::{
        OUTER_CITY_BUILDING_AMOUNT, INNER_CITY_BUILDING_AMOUNT, CITY_WALL_BUILDING_ID, MAX_LEVEL
    };
    use kingdom_lord::models::building::BuildingUpgradeInfo;
    use kingdom_lord::models::building_kind::BuildingKind;
    use kingdom_lord::components::city_hall::{CityHall};
    use kingdom_lord::components::city_building::{CityBuilding};
    use kingdom_lord::components::warehouse::{Warehouse, WarehouseStorage};
    use kingdom_lord::components::barn::{Barn, BarnStorage};
    use kingdom_lord::components::college::{College};
    use kingdom_lord::components::barrack::{
        Barrack, BarrackLevelTrait, BarrackGetLevel, Troops, soldier_info, SoldierKind
    };
    use kingdom_lord::components::stable::{Stable, StableLevelTrait, StableGetLevel};
    use kingdom_lord::components::city_wall::{CityWall, CityWallLevelTrait, CityWallGetLevel};
    use kingdom_lord::components::embassy::{Embassy, EmbassyLevelTrait, EmbassyGetLevel};
    use kingdom_lord::models::level::{LevelTrait, LevelUpTrait, Level, LevelExtentionTraitsImpl, LevelIntou64};

    #[storage]
    struct Storage {}


    #[generate_trait]
    impl UniversalInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of UniversalInternalTrait<TContractState> {
        fn building_kind(self: @ComponentState<TContractState>, building_id: u64) -> BuildingKind {
            let world = self.get_contract().world();
            let player = get_caller_address();
            let info: BuildingAreaInfo = get!(world, (player, building_id), (BuildingAreaInfo));
            info.building_kind.into()
        }

        fn check_all_building_reaching_max_level(self: @ComponentState<TContractState>, is_ware_house: bool) -> bool {
            let mut index: u64 = CITY_WALL_BUILDING_ID + 1;
            let player = get_caller_address();
            let max_count = INNER_CITY_BUILDING_AMOUNT + 1;
            let world = self.get_contract().world();
            let mut res = true;
            loop {
                if index == max_count {
                    break;
                }
                let info: BuildingAreaInfo = get!(
                    world, (player, index), (BuildingAreaInfo)
                );
                let building_kind: BuildingKind = info.building_kind.into();
                match building_kind {
                    BuildingKind::None => {},
                    BuildingKind::WoodBuilding => {},
                    BuildingKind::BrickBuilding => {},
                    BuildingKind::SteelBuilding => {},
                    BuildingKind::FoodBuilding => {},
                    BuildingKind::CityHall => {},
                    BuildingKind::Warehouse => {
                        if is_ware_house{
                            let warehouse = get!(world, (player, index), (Warehouse));
                            let level:u64 = warehouse.level.into() ;
                            if level != MAX_LEVEL {
                                res = false;
                                break;
                            }
                        }
                    },
                    BuildingKind::Barn => {
                        if !is_ware_house{
                            let barn = get!(world, (player, index), (Barn));
                            let level:u64 = barn.level.into() ;
                            if level != MAX_LEVEL {
                                res = false;
                                break;
                            }
                        }
                    },
                    BuildingKind::Barrack => {},
                    BuildingKind::Stable => {},
                    BuildingKind::College => {},
                    BuildingKind::Embassy => {},
                    BuildingKind::CityWall => {}
                }
                index += 1;
            };
            res
        }


        fn is_next_level_valid(
            self: @ComponentState<TContractState>,
            building_id: u64,
            building_kind: BuildingKind,
            next_level: Level
        ) -> bool {
            let world = self.get_contract().world();
            let player = get_caller_address();
            match building_kind {
                BuildingKind::None => { return next_level == 1_u64.into(); },
                BuildingKind::WoodBuilding => {
                    let city_building = get!(world, (player, building_id), (CityBuilding));
                    return city_building.is_next_level_valid(next_level);
                },
                BuildingKind::BrickBuilding => {
                    let city_building = get!(world, (player, building_id), (CityBuilding));
                    return city_building.is_next_level_valid(next_level);
                },
                BuildingKind::SteelBuilding => {
                    let city_building = get!(world, (player, building_id), (CityBuilding));
                    return city_building.is_next_level_valid(next_level);
                },
                BuildingKind::FoodBuilding => {
                    let city_building = get!(world, (player, building_id), (CityBuilding));
                    return city_building.is_next_level_valid(next_level);
                },
                BuildingKind::CityHall => {
                    let city_hall = get!(world, (player), (CityHall));
                    return city_hall.is_next_level_valid(next_level);
                },
                BuildingKind::Warehouse => {
                    let warehouse = get!(world, (player, building_id), (Warehouse));
                    return warehouse.is_next_level_valid(next_level);
                },
                BuildingKind::Barn => {
                    let barn = get!(world, (player, building_id), (Barn));
                    return barn.is_next_level_valid(next_level);
                },
                BuildingKind::Barrack => {
                    let barrack = get!(world, (player), (Barrack));
                    return barrack.is_next_level_valid(next_level);
                },
                BuildingKind::Stable => {
                    let stable = get!(world, (player), (Stable));
                    return stable.is_next_level_valid(next_level);
                },
                BuildingKind::College => {
                    let college = get!(world, (player), (College));
                    return college.is_next_level_valid(next_level);
                },
                BuildingKind::Embassy => { 
                    let embassy = get!(world, (player), (Embassy));
                    return embassy.is_next_level_valid(next_level);
                 },
                BuildingKind::CityWall => {
                    assert(building_id == CITY_WALL_BUILDING_ID, 'City wall id is fixed 18');
                    let city_wall = get!(world, (player), (CityWall));
                    return city_wall.is_next_level_valid(next_level);
                }
            }
        }

        fn level_up(
            self: @ComponentState<TContractState>,
            building_id: u64,
            building_kind: BuildingKind,
            value: (u64, u64)
        ) {
            let world = self.get_contract().world();
            let player = get_caller_address();
            match building_kind {
                BuildingKind::None => panic!("None building could be found"),
                BuildingKind::WoodBuilding => {
                    let mut city_building = get!(world, (player, building_id), (CityBuilding));
                    city_building.level_up(value);
                    set!(world, (city_building));
                },
                BuildingKind::BrickBuilding => {
                    let mut city_building = get!(world, (player, building_id), (CityBuilding));
                    city_building.level_up(value);
                    set!(world, (city_building));
                },
                BuildingKind::SteelBuilding => {
                    let mut city_building = get!(world, (player, building_id), (CityBuilding));
                    city_building.level_up(value);
                    set!(world, (city_building));
                },
                BuildingKind::FoodBuilding => {
                    let mut city_building = get!(world, (player, building_id), (CityBuilding));
                    city_building.level_up(value);
                    set!(world, (city_building));
                },
                BuildingKind::CityHall => {
                    let mut city_hall = get!(world, (player), (CityHall));
                    city_hall.level_up(value);
                    set!(world, (city_hall));
                },
                BuildingKind::Warehouse => {
                    let mut warehouse = get!(world, (player, building_id), (Warehouse));
                    let mut warehouse_storage = get!(world, (player), WarehouseStorage);
                    let (max_storage, _population) = value;
                    warehouse_storage.max_storage -= warehouse.max_storage;
                    warehouse_storage.max_storage += max_storage;
                    warehouse.level_up(value);
                    set!(world, (warehouse));
                    set!(world, (warehouse_storage));
                },
                BuildingKind::Barn => {
                    let mut barn = get!(world, (player, building_id), (Barn));
                    let mut barn_storage = get!(world, (player), BarnStorage);
                    let (max_storage, _population) = value;
                    barn_storage.max_storage -= barn.max_storage;
                    barn_storage.max_storage += max_storage;
                    barn.level_up(value);
                    set!(world, (barn));
                    set!(world, (barn_storage));
                },
                BuildingKind::Barrack => {
                    let mut barrack = get!(world, (player), (Barrack));
                    barrack.level_up(value);
                    set!(world, (barrack));
                },
                BuildingKind::Stable => {
                    let mut stable = get!(world, (player), (Stable));
                    stable.level_up(value);
                    set!(world, (stable));
                },
                BuildingKind::College => {
                    let mut college = get!(world, (player), (College));
                    college.level_up(value);
                    set!(world, (college));
                },
                BuildingKind::Embassy => {
                    let mut embassy = get!(world, (player), (Embassy));
                    embassy.level_up(value);
                    set!(world, (embassy));
                },
                BuildingKind::CityWall => {
                    let mut city_wall = get!(world, (player), (CityWall));
                    city_wall.level_up(value);
                    set!(world, (city_wall))
                }
            }
        }

        fn new_building(
            self: @ComponentState<TContractState>, building_id: u64, building_kind: BuildingKind,
        ) {
            let world = self.get_contract().world();
            let player = get_caller_address();
            match building_kind {
                BuildingKind::None => panic!("None building could be found"),
                BuildingKind::WoodBuilding => panic!("WoodBuilding not allow new"),
                BuildingKind::BrickBuilding => panic!("BrickBuilding not allow new"),
                BuildingKind::SteelBuilding => panic!("SteelBuilding not allow new"),
                BuildingKind::FoodBuilding => panic!("FoodBuilding not allow new"),
                BuildingKind::CityHall => {
                    let city_hall = CityHall {
                        player: player,
                        building_id: building_id,
                        level: 1_u64.into(),
                        bonus: 100,
                        population: 2,
                    };
                    let building_area_info = BuildingAreaInfo {
                        player: player,
                        building_id: building_id,
                        building_kind: BuildingKind::CityHall.into(),
                    };
                    set!(world, (city_hall));
                    set!(world, (building_area_info));
                },
                BuildingKind::Warehouse => {
                    let warehouse = Warehouse {
                        player, building_id, level: 1_u64.into(), max_storage: 1200, population: 1,
                    };
                    let building_area_info = BuildingAreaInfo {
                        player: player,
                        building_id: building_id,
                        building_kind: BuildingKind::Warehouse.into(),
                    };
                    let mut warehouse_storage = get!(world, (player), WarehouseStorage);
                    warehouse_storage.max_storage += warehouse.max_storage;
                    set!(world, (warehouse_storage));
                    set!(world, (warehouse));
                    set!(world, (building_area_info));
                },
                BuildingKind::Barn => {
                    let barn = Barn {
                        player, building_id, level: 1_u64.into(), max_storage: 1200, population: 1,
                    };
                    let building_area_info = BuildingAreaInfo {
                        player: player,
                        building_id: building_id,
                        building_kind: BuildingKind::Barn.into(),
                    };
                    let mut barn_storage = get!(world, (player), BarnStorage);
                    barn_storage.max_storage += barn.max_storage;
                    set!(world, (barn_storage));
                    set!(world, (barn));
                    set!(world, (building_area_info));
                },
                BuildingKind::Barrack => {
                    let barrack = Barrack {
                        player, building_id, level: 1_u64.into(), bonus: 100, population: 4,
                    };
                    let building_area_info = BuildingAreaInfo {
                        player: player,
                        building_id: building_id,
                        building_kind: BuildingKind::Barrack.into(),
                    };
                    set!(world, (barrack));
                    set!(world, (building_area_info));
                },
                BuildingKind::Stable => {
                    let stable = Stable {
                        player, building_id, level: 1_u64.into(), bonus: 100, population: 5,
                    };
                    let building_area_info = BuildingAreaInfo {
                        player: player,
                        building_id: building_id,
                        building_kind: BuildingKind::Stable.into(),
                    };
                    set!(world, (stable));
                    set!(world, (building_area_info));
                },
                BuildingKind::College => {
                    let college = College {
                        player, building_id, level: 1_u64.into(), population: 4,
                    };
                    let building_area_info = BuildingAreaInfo {
                        player: player,
                        building_id: building_id,
                        building_kind: BuildingKind::College.into(),
                    };
                    set!(world, (college));
                    set!(world, (building_area_info));
                },
                BuildingKind::Embassy => {
                    let embassy = Embassy {
                        player, building_id, level: 1_u64.into(), population: 3, ally_amount: 0
                    };
                    let building_area_info = BuildingAreaInfo {
                        player: player,
                        building_id: building_id,
                        building_kind: BuildingKind::Embassy.into(),
                    };
                    set!(world, (embassy));
                    set!(world, (building_area_info));
                },
                BuildingKind::CityWall => {
                    let city_wall = CityWall {
                        player,
                        building_id: CITY_WALL_BUILDING_ID,
                        level: 1_u64.into(),
                        population: 0,
                        attack_power: 8,
                        defense_power: 2
                    };
                    set!(world, (city_wall));
                }
            }
        }
        fn get_total_population(
            self: @ComponentState<TContractState>, player: ContractAddress
        ) -> u64 {
            let mut population: u64 = 0;
            let mut index: u64 = 0;
            let max_count = OUTER_CITY_BUILDING_AMOUNT
                + INNER_CITY_BUILDING_AMOUNT
                + 1; // 1 for city wall
            loop {
                if index == max_count {
                    break;
                }
                let info: BuildingAreaInfo = get!(
                    self.get_contract().world(), (player, index), (BuildingAreaInfo)
                );
                let building_kind: BuildingKind = info.building_kind.into();
                match building_kind {
                    BuildingKind::None => {},
                    BuildingKind::WoodBuilding => {
                        let city_building = get!(
                            self.get_contract().world(), (player, index), (CityBuilding)
                        );
                        population += city_building.population;
                    },
                    BuildingKind::BrickBuilding => {
                        let city_building = get!(
                            self.get_contract().world(), (player, index), (CityBuilding)
                        );
                        population += city_building.population;
                    },
                    BuildingKind::SteelBuilding => {
                        let city_building = get!(
                            self.get_contract().world(), (player, index), (CityBuilding)
                        );
                        population += city_building.population;
                    },
                    BuildingKind::FoodBuilding => {
                        let city_building = get!(
                            self.get_contract().world(), (player, index), (CityBuilding)
                        );
                        population += city_building.population;
                    },
                    BuildingKind::CityHall => {
                        let city_hall = get!(self.get_contract().world(), (player), (CityHall));
                        population += city_hall.population;
                    },
                    BuildingKind::Warehouse => {
                        let warehouse = get!(
                            self.get_contract().world(), (player, index), (Warehouse)
                        );
                        population += warehouse.population;
                    },
                    BuildingKind::Barn => {
                        let barn = get!(self.get_contract().world(), (player, index), (Barn));
                        population += barn.population;
                    },
                    BuildingKind::Barrack => {
                        let barrack = get!(self.get_contract().world(), (player), (Barrack));
                        population += barrack.population;
                    },
                    BuildingKind::Stable => {
                        let stable = get!(self.get_contract().world(), (player), (Stable));
                        population += stable.population;
                    },
                    BuildingKind::College => {
                        let college = get!(self.get_contract().world(), (player), (College));
                        population += college.population;
                    },
                    BuildingKind::Embassy => {
                        let embassy = get!(self.get_contract().world(), (player), (Embassy));
                        population += embassy.population;
                    },
                    BuildingKind::CityWall => {
                        let city_wall = get!(self.get_contract().world(), (player), (CityWall));
                        population += city_wall.population;
                    }
                }
                index += 1;
            };
            let troops = get!(self.get_contract().world(), (player), (Troops));

            population += troops.millitia * soldier_info(SoldierKind::Millitia).population;
            population += troops.guard * soldier_info(SoldierKind::Guard).population;
            population += troops.heavy_infantry
                * soldier_info(SoldierKind::HeavyInfantry).population;
            population += troops.scouts * soldier_info(SoldierKind::Scouts).population;
            population += troops.knights * soldier_info(SoldierKind::Knights).population;
            population += troops.heavy_knights * soldier_info(SoldierKind::HeavyKnights).population;

            population
        }
    }
}
