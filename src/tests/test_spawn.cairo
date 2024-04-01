#[cfg(test)]
mod tests {
    use kingdom_lord::interface::{IKingdomLordDispatcherTrait, Error};
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::get_caller_address;
    use starknet::testing::{set_caller_address};

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    use kingdom_lord::tests::utils::{setup_world, assert_resource, increase_time};
    use kingdom_lord::interface::{IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl};

    #[test]
    #[available_gas(300000000000)]
    fn test_spawn() {
        // deploy world with models
        let context = setup_world();
        let caller = get_caller_address();
        increase_time(1_u64);
        context.kingdom_lord.spawn().expect('spawn works');
        assert_resource(context, caller, 0, 0, 0, 0);

        // building levels 4446
        let levels = context.kingdom_lord.get_buildings_levels(caller);
        assert(*levels.at(0) == 0_u64.into(), '0 should be 0');
        assert(*levels.at(1) == 0_u64.into(), '1 should be 0');
        assert(*levels.at(2) == 0_u64.into(), '2 should be 0');
        assert(*levels.at(3) == 0_u64.into(), '3 should be 0');
        assert(*levels.at(4) == 0_u64.into(), '4 should be 0');
        assert(*levels.at(5) == 0_u64.into(), '5 should be 0');
        assert(*levels.at(6) == 0_u64.into(), '6 should be 0');
        assert(*levels.at(7) == 0_u64.into(), '7 should be 0');
        assert(*levels.at(8) == 0_u64.into(), '8 should be 0');
        assert(*levels.at(9) == 0_u64.into(), '9 should be 0');
        assert(*levels.at(10) == 0_u64.into(), '10 should be 0');
        assert(*levels.at(11) == 0_u64.into(), '11 should be 0');
        assert(*levels.at(12) == 0_u64.into(), '12 should be 0');
        assert(*levels.at(13) == 0_u64.into(), '13 should be 0');
        assert(*levels.at(14) == 0_u64.into(), '14 should be 0');
        assert(*levels.at(15) == 0_u64.into(), '15 should be 0');
        assert(*levels.at(16) == 0_u64.into(), '16 should be 0');
        assert(*levels.at(17) == 0_u64.into(), '17 should be 0');


        let (wood_growth_rate, steel_growth_rate, brick_growth_rate, food_growth_rate) = context.kingdom_lord.get_growth_rate(caller);
        assert(wood_growth_rate.into() == 16_u64, 'wood growth rate should be 16');
        assert(steel_growth_rate.into() == 16_u64, 'steel growth rate should be 16');
        assert(brick_growth_rate.into() == 16_u64, 'brick growth rate should be 16');
        assert(food_growth_rate.into() == 24_u64, 'food growth rate should be 24');

        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);
        assert(under_upgrade.is_finished == true, 'under_upgrade is finished');

        let complete_upgrade = context.kingdom_lord.get_waiting_upgrading(caller);
        assert(complete_upgrade.len() == 0_u32, 'waiting upgrading should be 0');


    }

    #[test]
    fn test_dup_spawn() {
        // deploy world with models
        let context = setup_world();
        context.kingdom_lord.spawn().expect('spawn works');

        let res = context.kingdom_lord.spawn().unwrap_err();
        assert(res == Error::AlreadySpawned, 'dup spawned should be error')
    }
}
