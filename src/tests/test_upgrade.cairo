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
    use kingdom_lord::tests::utils::{setup_world, wood_level_1_proof, increase_time};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl, Error
    };

    #[test]
    #[available_gas(300000000000)]
    fn test_upgrade() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        let caller = get_caller_address();
        let err = context
            .kingdom_lord
            .start_upgrade(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level_1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(25);
        let res = context.kingdom_lord.start_upgrade(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level_1_proof());
        let upgrade_id = res.unwrap();
        assert(upgrade_id == 0, 'first upgrade id is 0');

        increase_time(4);
        let upgrade = context.kingdom_lord.get_under_upgrading(caller);

        assert(upgrade.current_upgrade_id == 0, 'upgrade id should be 0');
        assert(upgrade.start_time == 25, 'end block should be 25');
        assert(upgrade.end_time == 285, 'end block should be 285');


        increase_time(260);

        context.kingdom_lord.finish_upgrade().unwrap();

        // double finish should failed
        context.kingdom_lord.finish_upgrade().unwrap_err();

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

        context.kingdom_lord.spawn().expect('spawn works');

        increase_time(25);
        let res = context.kingdom_lord.start_upgrade(0, 1, 1, 40, 100, 50, 60, 2, 260, 7,array![0x1]);
        let err = res.unwrap_err();
        assert(err == Error::InvalidProof, 'not enough resource');
    }
}
