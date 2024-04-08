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
    use kingdom_lord::tests::utils::{setup_world, increase_time, TestContext};
    use kingdom_lord::tests::upgrade_info::{
        cityhall_level1_proof, cityhall_level2_proof, warehouse_level2_proof, barn_level1_proof,
        barn_level2_proof, warehouse_level1_proof, wood_level1_proof
    };
    use starknet::ContractAddress;
    use kingdom_lord::interface::{IKingdomLord, IKingdomLordLibraryDispatcherImpl, IKingdomLordTestDispatcherImpl, IKingdomLordTest, Error};

    fn assert_under_upgrading(
        context: TestContext,
        player: ContractAddress,
        upgrade_id: u64,
        building_id: u64,
        start_time: u64,
        end_time: u64,
        target_level: u64,
        is_new_building: bool,
        is_finished: bool
    ) {
        let upgrading = context.kingdom_lord.get_under_upgrading(player);
        assert!(
            upgrading.current_upgrade_id == upgrade_id,
            "current upgrade id should be {} got {}",
            upgrade_id,
            upgrading.current_upgrade_id
        );
        assert!(
            upgrading.building_id == building_id,
            "building id should be {} got {}",
            building_id,
            upgrading.building_id
        );
        assert!(
            upgrading.start_time == start_time,
            "start time should be {} got {}",
            start_time,
            upgrading.start_time
        );
        assert!(
            upgrading.end_time == end_time,
            "end time should be {} got {}",
            end_time,
            upgrading.end_time
        );
        assert!(
            upgrading.target_level == target_level.into(),
            "target level should be {} got {}",
            target_level,
            upgrading.target_level.level
        );
        assert!(
            upgrading.is_new_building == is_new_building,
            "is new building should be {} got {}",
            is_new_building,
            upgrading.is_new_building
        );
        assert!(
            upgrading.is_finished == is_finished,
            "upgrading status should be {} got {}",
            is_finished,
            upgrading.is_finished
        );
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_upgrade() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        let caller = get_caller_address();
        let err = context
            .kingdom_lord_test
            .start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(25);
        let res = context
            .kingdom_lord_test
            .start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level1_proof());
        let upgrade_id = res.unwrap();
        assert(upgrade_id == 1, 'first upgrade id is 1');

        increase_time(4);
        let upgrade = context.kingdom_lord.get_under_upgrading(caller);

        assert(upgrade.current_upgrade_id == 1, 'upgrade id should be 1');
        assert(upgrade.start_time == 25, 'end block should be 25');
        assert(upgrade.end_time == 285, 'end block should be 285');

        increase_time(260);

        context.kingdom_lord_test.finish_upgrade_test().unwrap();

        // double finish should failed
        context.kingdom_lord_test.finish_upgrade_test().unwrap_err();

        let (wood_growth_rate, _steel_growth_rate, _brick_growth_rate, _food_growth_rate) = context
            .kingdom_lord
            .get_growth_rate(caller);
        assert(wood_growth_rate.into() == 19_u64, 'wood growth rate should be 19');
        let levels = context.kingdom_lord.get_buildings_levels(caller);
        assert(*levels.at(0) == 1_u64.into(), '0 should be 1');
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_upgrade_invalid_proof() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord_test.spawn_test().expect('spawn works');

        increase_time(25);
        let res = context
            .kingdom_lord_test
            .start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, array![0x1]);
        let err = res.unwrap_err();
        assert(err == Error::InvalidProof, 'invalid proof');
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_upgrade_sequence() {
        // deploy world with models
        let context = setup_world();
        let caller = get_caller_address();
        context.kingdom_lord_test.spawn_test().expect('spawn works');

        increase_time(100);
        context
            .kingdom_lord_test
            .start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level1_proof())
            .expect('upgrading 0 works');
        context
            .kingdom_lord_test
            .start_upgrade_test(1, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level1_proof())
            .expect('upgrading 1 works');
        context
            .kingdom_lord_test
            .start_upgrade_test(2, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level1_proof())
            .expect('upgrading 2 works');
        context
            .kingdom_lord_test
            .start_upgrade_test(3, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level1_proof())
            .expect('upgrading 3 works');
        context
            .kingdom_lord_test
            .start_upgrade_test(20, 5, 1, 70, 40, 60, 20, 2, 2500, 100, cityhall_level1_proof())
            .expect('start 18 works');
        context
            .kingdom_lord_test
            .start_upgrade_test(21, 6, 1, 130, 160, 90, 40, 1, 2000, 1200, warehouse_level1_proof())
            .expect('start 19 works');
        let res = context
            .kingdom_lord_test
            .start_upgrade_test(22, 6, 1, 130, 160, 90, 40, 1, 2000, 1200, warehouse_level1_proof());
        assert!(res.unwrap_err() == Error::UpgradingListFull, "upgrade list full");

        assert_under_upgrading(context, caller, 1, 0, 100, 360, 1, false, false);
        increase_time(260);
        assert_under_upgrading(context, caller, 1, 0, 100, 360, 1, false, false);

        context.kingdom_lord_test.finish_upgrade_test().expect('finish upgrading 0');
        assert_under_upgrading(context, caller, 2, 1, 360, 620, 1, false, false);

        let res = context.kingdom_lord_test.finish_upgrade_test().unwrap_err();
        assert!(res == Error::UpgradeNotFinished, "upgrade not finish");

        increase_time(260);
        context.kingdom_lord_test.finish_upgrade_test().expect('finish upgrading 1');
        assert_under_upgrading(context, caller, 3, 2, 620, 880, 1, false, false);

        increase_time(260);
        context.kingdom_lord_test.finish_upgrade_test().expect('finish upgrading 2');
        assert_under_upgrading(context, caller, 4, 3, 880, 1140, 1, false, false);

        context
            .kingdom_lord_test
            .start_upgrade_test(22, 6, 1, 130, 160, 90, 40, 1, 2000, 1200, warehouse_level1_proof())
            .expect('start 20 works');

        context
            .kingdom_lord_test
            .start_upgrade_test(23, 6, 1, 130, 160, 90, 40, 1, 2000, 1200, warehouse_level1_proof())
            .expect('start 21 works');

        context
            .kingdom_lord_test
            .start_upgrade_test(24, 6, 1, 130, 160, 90, 40, 1, 2000, 1200, warehouse_level1_proof())
            .expect('start 22 works');

        let res = context
            .kingdom_lord_test
            .start_upgrade_test(25, 6, 1, 130, 160, 90, 40, 1, 2000, 1200, warehouse_level1_proof());
        assert!(res.unwrap_err() == Error::UpgradingListFull, "upgrade list full");

        increase_time(260);
        context.kingdom_lord_test.finish_upgrade_test().expect('finish upgrading 3');
        assert_under_upgrading(context, caller, 5, 20, 1140, 3640, 1, true, false);

        increase_time(2500);
        context.kingdom_lord_test.finish_upgrade_test().expect('finish upgrading 18');
    }
}
