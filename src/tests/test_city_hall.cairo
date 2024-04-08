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
    use kingdom_lord::tests::upgrade_info::{
        cityhall_level1_proof, cityhall_level2_proof, warehouse_level2_proof, barn_level1_proof,
        barn_level2_proof, warehouse_level1_proof
    };
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordTestDispatcherImpl, IKingdomLordTest,IKingdomLordLibraryDispatcherImpl, Error
    };
    use kingdom_lord::models::building_kind::BuildingKind;

    #[test]
    #[available_gas(300000000000)]
    fn test_city_hall() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        let caller = get_caller_address();
        let err = context
            .kingdom_lord_test
            .start_upgrade_test(20, 5, 1, 70, 40, 60, 20, 2, 2500, 100, cityhall_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(50);

        let res = context
            .kingdom_lord_test
            .start_upgrade_test(20, 5, 1, 70, 40, 60, 20, 2, 2500, 100, cityhall_level1_proof());
        let upgrade_id = res.unwrap();
        assert(upgrade_id == 1, 'first upgrade id is 1');

        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);
        assert(
            under_upgrade.building_kind == BuildingKind::CityHall.into(),
            'under_upgrade should be 1'
        );
        assert(under_upgrade.current_upgrade_id == 1, 'upgrade id should be 1');

        increase_time(2500);

        // city hall should be level up
        context.kingdom_lord_test.finish_upgrade_test().unwrap();
        context
            .kingdom_lord_test
            .start_upgrade_test(20, 5, 2, 90, 50, 75, 25, 1, 2620, 104, cityhall_level2_proof())
            .expect('start upgrade level 2 ');
        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);

        // 2620 - 2620 * 104 //10000 + 2550
        // let compute: u64 = 3220_u64 - 3220_u64 * 104_u64 /10000_u64 + 2670_u64;
        assert(under_upgrade.end_time == 5144, 'end block should be 5144');

        increase_time(2620);
        context.kingdom_lord_test.finish_upgrade_test().unwrap();
    }
}
