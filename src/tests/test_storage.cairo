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
    use kingdom_lord::tests::utils::{
        setup_world, assert_resource, increase_time, 
    };
    use kingdom_lord::tests::upgrade_info::{cityhall_level1_proof, cityhall_level2_proof, warehouse_level2_proof, barn_level1_proof, barn_level2_proof, warehouse_level1_proof};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl, Error
    };

    #[test]
    #[available_gas(300000000000)]
    fn test_storage() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        let caller = get_caller_address();

        assert_resource(context, caller, 0, 0, 0, 0);

        let err = context
            .kingdom_lord
            .start_upgrade(18, 5, 1, 70, 40, 60, 20, 2, 2500, 100, cityhall_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(1000);
        assert_resource(context, caller, 1000, 1000, 1000, 1000);
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_upgrade_at_max_storage() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        let caller = get_caller_address();

        assert_resource(context, caller, 0, 0, 0, 0);

        let err = context
            .kingdom_lord
            .start_upgrade(18, 5, 1, 70, 40, 60, 20, 2, 2500, 100, cityhall_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(1000);

        context
            .kingdom_lord
            .start_upgrade(18, 5, 1, 70, 40, 60, 20, 2, 2500, 100, cityhall_level1_proof())
            .unwrap();
        assert_resource(context, caller, 930, 960, 940, 980);
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_build_warehouse() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        let caller = get_caller_address();

        assert_resource(context, caller, 0, 0, 0, 0);

        let err = context
            .kingdom_lord
            .start_upgrade(18, 6, 1, 130, 160, 90, 40, 1, 2000, 1200, warehouse_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(100);

        context
            .kingdom_lord
            .start_upgrade(18, 6, 1, 130, 160, 90, 40, 1, 2000, 1200, warehouse_level1_proof())
            .unwrap();

        assert_resource(context, caller, 870, 840, 910, 960);

        increase_time(2000);

        context.kingdom_lord.finish_upgrade().unwrap();

        assert_resource(context, caller, 1000, 1000, 1000, 1000);

        increase_time(100);
        assert_resource(context, caller, 2200, 2200, 2200, 1000);

        context
            .kingdom_lord
            .start_upgrade(18, 6, 2, 165, 205, 115, 50, 1, 2620, 1700, warehouse_level2_proof())
            .expect('start upgrade level 2 failed');

        increase_time(2620);

        context.kingdom_lord.finish_upgrade().unwrap();
        assert_resource(context, caller, 2200, 2200, 2200, 1000);

        increase_time(100);
        assert_resource(context, caller, 2700, 2700, 2700, 1000);
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_build_barn() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        let caller = get_caller_address();

        assert_resource(context, caller, 0, 0, 0, 0);

        let err = context
            .kingdom_lord
            .start_upgrade(18, 7, 1, 80, 100, 70, 20, 1, 1600, 1200, barn_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(100);

        context
            .kingdom_lord
            .start_upgrade(18, 7, 1, 80, 100, 70, 20, 1, 1600, 1200, barn_level1_proof())
            .expect('upgrade barn level 1');

        assert_resource(context, caller, 920, 900, 930, 980);

        increase_time(1600);

        context.kingdom_lord.finish_upgrade().expect('finish upgrade 0');

        assert_resource(context, caller, 1000, 1000, 1000, 1000);

        increase_time(100);
        assert_resource(context, caller, 1000, 1000, 1000, 2200);

        context
            .kingdom_lord
            .start_upgrade(18, 7, 2, 100, 130, 90, 25, 1, 2160, 1700, barn_level2_proof())
            .expect('upgrade barn level 2 failed');

        increase_time(2160);

        context.kingdom_lord.finish_upgrade().expect('finish upgrade level 2');
        assert_resource(context, caller, 1000, 1000, 1000, 2200);

        increase_time(100);
        assert_resource(context, caller, 1000, 1000, 1000, 2700);
    }
}
