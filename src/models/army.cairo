use core::traits::TryInto;
use alexandria_math::fast_root::fast_sqrt;

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


#[derive(Introspect, Copy, Drop, Serde, Debug)]
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
    fn is_not_enough_solider(
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
        if self.is_not_enough_solider(millitia, guard, heavy_infantry, scouts, knights, heavy_knights) {
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

    fn die(ref self: ArmyGroup) {
        self.millitia = 0;
        self.guard = 0;
        self.heavy_infantry = 0;
        self.scouts = 0;
        self.knights = 0;
        self.heavy_knights = 0;
    }

    fn fight_damage(ref self: ArmyGroup, self_force: u64 , other_force: u64){
        assert!(self_force > other_force, "damage otherwise die");

        let sqrt_self_force: u64 = fast_sqrt(self_force.into(), 10).try_into().expect('sqrt_self_force');
        let sqrt_other_force:u64  = fast_sqrt(other_force.into(), 10).try_into().expect('sqrt_other_force');

        // FIXME
        self.millitia = self.millitia *  other_force / self_force  * sqrt_other_force / sqrt_self_force ;
        self.guard = self.guard *  other_force / self_force * sqrt_other_force / sqrt_self_force ;
        self.heavy_infantry = self.heavy_infantry *  other_force / self_force * sqrt_other_force / sqrt_self_force ;
        self.scouts = self.scouts *  other_force / self_force * sqrt_other_force / sqrt_self_force ;
        self.knights = self.knights *  other_force / self_force * sqrt_other_force / sqrt_self_force ;
        self.heavy_knights = self.heavy_knights *  other_force / self_force * sqrt_other_force / sqrt_self_force ;
    }

    fn rob_damege(ref self: ArmyGroup, ref robed_group: ArmyGroup) -> bool{
        let self_force = self.attack_force();
        let defense_force = robed_group.defense_force();
        let sqrt_self_force: u64 = fast_sqrt(self_force.into(), 10).try_into().expect('sqrt_self_force');
        let sqrt_defense_force:u64  = fast_sqrt(defense_force.into(), 10).try_into().expect('sqrt_other_force');
        if defense_force > self_force {
            let p = self_force *100 / defense_force * sqrt_self_force* 100 / sqrt_defense_force;
            robed_group.millitia = robed_group.millitia * 10000 / (10000 + p);
            robed_group.guard = robed_group.guard * 10000 / (10000 + p);
            robed_group.heavy_infantry = robed_group.heavy_infantry * 10000 / (10000 + p);
            robed_group.scouts = robed_group.scouts * 10000 / (10000 + p);
            robed_group.knights = robed_group.knights * 10000 / (10000 + p);
            robed_group.heavy_knights = robed_group.heavy_knights * 10000 / (10000 + p);

            self.millitia = self.millitia * p/ (10000 + p);
            self.guard = self.guard * p/ (10000 + p);
            self.heavy_infantry = self.heavy_infantry * p/ (10000 + p);
            self.scouts = self.scouts * p/ (10000 + p);
            self.knights = self.knights * p/ (10000 + p);
            self.heavy_knights = self.heavy_knights * p/ (10000 + p);
            false
        } else {
            let p = defense_force *100 / self_force * sqrt_defense_force* 100 / sqrt_self_force;
            self.millitia = self.millitia * 10000 / (10000 + p); 
            self.guard = self.guard * 10000 / (10000 + p);
            self.heavy_infantry = self.heavy_infantry * 10000 / (10000 + p);
            self.scouts = self.scouts * 10000 / (10000 + p);
            self.knights = self.knights * 10000 / (10000 + p);
            self.heavy_knights = self.heavy_knights * 10000 / (10000 + p);

            robed_group.millitia = robed_group.millitia * p/ (10000 + p);
            robed_group.guard = robed_group.guard * p/ (10000 + p);
            robed_group.heavy_infantry = robed_group.heavy_infantry * p/ (10000 + p);
            robed_group.scouts = robed_group.scouts * p/ (10000 + p);
            robed_group.knights = robed_group.knights * p/ (10000 + p);
            robed_group.heavy_knights = robed_group.heavy_knights * p/ (10000 + p);

            true
        }
    }

    fn rob(ref self: ArmyGroup, ref robed_group: ArmyGroup) -> bool{
        let self_force = self.attack_force();
        let defense_force = robed_group.defense_force();
        if self_force > defense_force {
            self.rob_damege(ref robed_group);
            true
        } else {
            self.rob_damege(ref robed_group);
            false
        }
    }

    /// return true if attacker win
    /// return false if defender win
    fn fight(
        ref self: ArmyGroup,
        ref defender: ArmyGroup
    ) -> bool{
        let attack_force = self.attack_force();
        let defense_force = defender.defense_force();
        if attack_force > defense_force {
            self.fight_damage(attack_force, defense_force);
            defender.die();
            true
        } else {
            self.die();
            defender.fight_damage(defense_force, attack_force);
            false
        }
    }

    fn merge_army(ref self: ArmyGroup, ref other: ArmyGroup){
        self.millitia += other.millitia;
        self.guard += other.guard;
        self.heavy_infantry += other.heavy_infantry;
        self.scouts += other.scouts;
        self.knights += other.knights;
        self.heavy_knights += other.heavy_knights;

        other.die()

    }


    fn speed(self: @ArmyGroup) -> u64{
        if *self.guard > 0 {
            return soldier_info(SoldierKind::Guard).movement_speed;
        } else if *self.millitia > 0 {
            return soldier_info(SoldierKind::Millitia).movement_speed;
        } else if *self.heavy_infantry > 0 {
            return soldier_info(SoldierKind::HeavyInfantry).movement_speed;
        } else if *self.heavy_knights > 0 {
            return soldier_info(SoldierKind::HeavyKnights).movement_speed;
        } else if *self.knights > 0 {
            return soldier_info(SoldierKind::Knights).movement_speed;
        } else if *self.scouts > 0 {
            return soldier_info(SoldierKind::Scouts).movement_speed;
        } else {
            return 0;
        }
    }
}


#[cfg(test)]
mod army_test{
    use super::{ArmyGroup, ArmyGroupExtensionImpl};
    use kingdom_lord::tests::utils::assert_armygroup;

    #[test]
    fn test_fight_damage(){
        let mut army1 = ArmyGroup{
            millitia: 10,
            guard: 0,
            heavy_infantry: 0,
            scouts: 10,
            knights: 0,
            heavy_knights: 0
        };

        let mut army2 = ArmyGroup{
            millitia: 8,
            guard: 0,
            heavy_infantry: 0,
            scouts: 8,
            knights: 0,
            heavy_knights: 0
        };

        let res = army1.fight(ref army2);
        assert!(!res, "army1 should lose");
        assert_armygroup(army1, 0, 0, 0 , 0,0,0);
        assert_armygroup(army2, 6, 0,0, 6,0,0)
    }

    #[test]
    fn test_rob_damage(){
        let mut army1 = ArmyGroup{
            millitia: 10,
            guard: 0,
            heavy_infantry: 0,
            scouts: 10,
            knights: 0,
            heavy_knights: 0
        };

        let mut army2 = ArmyGroup{
            millitia: 8,
            guard: 0,
            heavy_infantry: 0,
            scouts: 8,
            knights: 0,
            heavy_knights: 0
        };

        let res = army1.rob(ref army2);
        assert!(!res, "army1 should lose");
        assert_armygroup(army1, 4, 0, 0, 4, 0, 0);
        assert_armygroup(army2, 4, 0, 0, 4, 0, 0);
    }
}