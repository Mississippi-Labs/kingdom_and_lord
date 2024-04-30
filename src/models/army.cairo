

#[derive(Copy, Drop, Serde)]
struct SoldierInfo{
    attack_power: u64,
    defense_power: u64,
    movement_speed: u64,
    load_capacity: u64,
    req_wood: u64,
    req_brick: u64,
    req_steel: u64,
    req_food: u64,
    population: u64,
    required_time: u64,
}



#[derive(Copy, Drop, Serde)]
enum SoldierKind{
    Millitia,
    Guard,
    HeavyInfantry,
    Scouts,
    Knights,
    HeavyKnights
}

impl SoldierKindIntou64 of Into<u64, SoldierKind>{
    fn into(self: u64) -> SoldierKind{
        let self:felt252 = self.into();
        match self{
            0 => SoldierKind::Millitia,
            1 => SoldierKind::Guard,
            2 => SoldierKind::HeavyInfantry,
            3 => SoldierKind::Scouts,
            4 => SoldierKind::Knights,
            5 => SoldierKind::HeavyKnights,
            _ => panic!("Invalid SoldierKind")
        }
    }
}

impl IntoSoldierKind of Into<SoldierKind, u64>{
    fn into(self: SoldierKind) -> u64{
        match self{
            SoldierKind::Millitia => 0,
            SoldierKind::Guard => 1,
            SoldierKind::HeavyInfantry => 2,
            SoldierKind::Scouts => 3,
            SoldierKind::Knights => 4,
            SoldierKind::HeavyKnights => 5,
        }
    }
}

fn soldier_info(soldier_kind: SoldierKind) -> SoldierInfo{
    match soldier_kind{
        SoldierKind::Millitia => {
            SoldierInfo{
                attack_power: 40,
                defense_power: 35,
                movement_speed: 6,
                load_capacity: 50,
                req_wood: 120,
                req_brick: 100,
                req_steel: 150,
                req_food: 30,
                population: 1,
                required_time: 1600
            }
        },
        SoldierKind::Guard => {
            SoldierInfo{
                attack_power: 30,
                defense_power: 65,
                movement_speed: 5,
                load_capacity: 20,
                req_wood: 100,
                req_brick: 130,
                req_steel: 160,
                req_food: 70,
                population: 1,
                required_time: 1760
            }
        },
        SoldierKind::HeavyInfantry => {
            SoldierInfo{
                attack_power: 70,
                defense_power: 40,
                movement_speed: 7,
                load_capacity: 50,
                req_wood: 150,
                req_brick: 160,
                req_steel: 210,
                req_food: 80,
                population: 1,
                required_time: 1920
            }
        },
        SoldierKind::Scouts => {
            SoldierInfo{
                attack_power: 0,
                defense_power: 20,
                movement_speed: 16,
                load_capacity: 0,
                req_wood: 140,
                req_brick: 160,
                req_steel: 20,
                req_food: 40,
                population: 2,
                required_time: 1360
            }
        },
        SoldierKind::Knights => {
            SoldierInfo{
                attack_power: 120,
                defense_power: 65,
                movement_speed: 14,
                load_capacity: 100,
                req_wood: 550,
                req_brick: 440,
                req_steel: 320,
                req_food: 100,
                population: 3,
                required_time: 2640
            }
        },
        SoldierKind::HeavyKnights => {
            SoldierInfo{
                attack_power: 180,
                defense_power: 80,
                movement_speed: 10,
                load_capacity: 70,
                req_wood: 550,
                req_brick: 640,
                req_steel: 800,
                req_food: 180,
                population: 4,
                required_time: 3520
            }
        }
    }
}


#[derive(Introspect, Copy, Drop, Serde)]
struct ArmyGroup {
    millitia: u64,
    guard: u64,
    heavy_infantry: u64,
    scouts: u64,
    knights: u64,
    heavy_knights: u64
}

#[generate_trait]
impl ArmyGroupExtensionImpl of ArmyGroupExtension {
    fn is_enough_solider(
        self: @ArmyGroup,
        millitia: u64,
        guard: u64,
        heavy_infantry: u64,
        scouts: u64,
        knights: u64,
        heavy_knights: u64
    ) -> bool {
        millitia > *self.millitia
            || guard > *self.guard
            || heavy_infantry > *self.heavy_infantry
            || scouts > *self.scouts
            || knights > *self.knights
            || heavy_knights > *self.heavy_knights
    }

    fn split_group(
        ref self: ArmyGroup,
        millitia: u64,
        guard: u64,
        heavy_infantry: u64,
        scouts: u64,
        knights: u64,
        heavy_knights: u64
    ) -> Result<ArmyGroup, ()> {
        if self.is_enough_solider(millitia, guard, heavy_infantry, scouts, knights, heavy_knights) {
            return Result::Err(());
        }
        self.millitia -= millitia;
        self.guard -= guard;
        self.heavy_infantry -= heavy_infantry;
        self.scouts -= scouts;
        self.knights -= knights;
        self.heavy_knights -= heavy_knights;

        Result::Ok(ArmyGroup {
            millitia,
            guard,
            heavy_infantry,
            scouts,
            knights,
            heavy_knights
        })
    }

    fn total_population(
        self: @ArmyGroup
    ) -> u64{
        let mut population: u64 = 0;
        population += *self.millitia * soldier_info(SoldierKind::Millitia).population;
        population += *self.guard * soldier_info(SoldierKind::Guard).population;
        population += *self.heavy_infantry
            * soldier_info(SoldierKind::HeavyInfantry).population;
        population += *self.scouts * soldier_info(SoldierKind::Scouts).population;
        population += *self.knights * soldier_info(SoldierKind::Knights).population;
        population += *self.heavy_knights * soldier_info(SoldierKind::HeavyKnights).population;
        population

    }

    fn attack_force(self: @ArmyGroup) -> u64{
        *self.millitia * soldier_info(SoldierKind::Millitia).attack_power
                + *self.guard * soldier_info(SoldierKind::Guard).attack_power 
                + *self.heavy_infantry * soldier_info(SoldierKind::HeavyInfantry).attack_power 
                + *self.scouts * soldier_info(SoldierKind::Scouts).attack_power 
                + *self.knights * soldier_info(SoldierKind::Knights).attack_power 
                + *self.heavy_knights * soldier_info(SoldierKind::HeavyKnights).attack_power
    }

    fn defense_force(self: @ArmyGroup) -> u64{
        *self.millitia * soldier_info(SoldierKind::Millitia).defense_power
                + *self.guard * soldier_info(SoldierKind::Guard).defense_power 
                + *self.heavy_infantry * soldier_info(SoldierKind::HeavyInfantry).defense_power 
                + *self.scouts * soldier_info(SoldierKind::Scouts).defense_power 
                + *self.knights * soldier_info(SoldierKind::Knights).defense_power 
                + *self.heavy_knights * soldier_info(SoldierKind::HeavyKnights).defense_power
    }
}
