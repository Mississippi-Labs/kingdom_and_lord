#[cfg(test)]
mod tests {
    use core::result::ResultTrait;
    use kingdom_lord::interface::IKingdomLordDispatcherTrait;
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::get_caller_address;
    use starknet::testing::{set_caller_address, set_block_timestamp};

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    use kingdom_lord::tests::utils::{setup_world, increase_time};
    use kingdom_lord::tests::upgrade_info::{city_wall_level1_proof, city_wall_level2_proof};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordTestDispatcherImpl, IKingdomLordTest,IKingdomLordLibraryDispatcherImpl, Error
    };
    use kingdom_lord::models::building_kind::BuildingKind;

    #[test]
    #[available_gas(300000000000)]
    fn test_city_wall() {
        // deploy world with models
        let context = setup_world();
        let caller = get_caller_address();

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        let (attack_power, defense_power) = context.kingdom_lord.get_city_wall_power(caller);
        assert(attack_power == 0, 'attack power should be 0');
        assert(defense_power == 0, 'defense power should be 0');
        let err = context
            .kingdom_lord_test
            .start_upgrade_test(18, 12, 1, 110, 160, 70, 60, 0, 2000, 8002, city_wall_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(50);

        context
            .kingdom_lord_test
            .start_upgrade_test(18, 12, 1, 110, 160, 70, 60, 0, 2000, 8002, city_wall_level1_proof()).expect('upgrade city wall');

        increase_time(2000);

        context.kingdom_lord_test.finish_upgrade_test().unwrap();
        let (attack_power, defense_power) = context.kingdom_lord.get_city_wall_power(caller);
        assert(attack_power == 8, 'attack power should be 8');
        assert(defense_power == 2, 'defense power should be 2');

        context
            .kingdom_lord_test
            .start_upgrade_test(18, 12, 2, 140, 205, 90, 75, 0, 2620, 16005, city_wall_level2_proof())
            .expect('start upgrade level 2 ');

        increase_time(2620);
        context.kingdom_lord_test.finish_upgrade_test().unwrap();
        let (attack_power, defense_power) = context.kingdom_lord.get_city_wall_power(caller);
        assert(attack_power == 16, 'attack power should be 16');
        assert(defense_power == 5, 'defense power should be 5');
    }


    #[test]
    #[available_gas(300000000000)]
    #[should_panic]
    fn test_invalid_building_id_city_wall(){
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        increase_time(50);
        let err = context
            .kingdom_lord_test
            .start_upgrade_test(20, 12, 1, 110, 160, 70, 60, 0, 2000, 8002, city_wall_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
    }
}
