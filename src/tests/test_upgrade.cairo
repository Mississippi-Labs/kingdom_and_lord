#[cfg(test)]
mod tests {
    use core::result::ResultTrait;
    use kingdom_lord::interface::IKingdomLordDispatcherTrait;
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::get_caller_address;
    use starknet::testing::{set_caller_address, set_block_number, set_block_timestamp};

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    use kingdom_lord::tests::utils::{setup_world, wood_level_1_proof};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl, Error
    };

    #[test]
    #[available_gas(300000000000)]
    fn test_upgrade() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn();
        let caller = get_caller_address();
        let err = context
            .kingdom_lord
            .start_upgrade(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level_1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        set_block_number(25);
        let res = context.kingdom_lord.start_upgrade(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level_1_proof());
        let upgrade_id = res.unwrap();
        assert(upgrade_id == 0, 'first upgrade id is 0');

        set_block_number(29);
        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);

        let upgrade = under_upgrade.at(0);
        assert(under_upgrade.len() == 1, 'under_upgrade should be 1');
        assert(*upgrade.upgrade_id == 0, 'upgrade id should be 0');
        assert(*upgrade.start_time == 25, 'end block should be 25');
        assert(*upgrade.end_time == 285, 'end block should be 285');

        let finishe_upgrade = context.kingdom_lord.get_complete_upgrading(caller);
        assert(finishe_upgrade.len() == 0, 'finished should be 0');

        set_block_number(285);

        let finishe_upgrade = context.kingdom_lord.get_complete_upgrading(caller);
        assert(finishe_upgrade.len() == 1, 'finished should be 1');

        let upgrade = under_upgrade.at(0);
        assert(*upgrade.upgrade_id == 0, 'upgrade id should be 0');
        context.kingdom_lord.finish_upgrade(0_u64).unwrap();

        // double finish should failed
        context.kingdom_lord.finish_upgrade(0_u64).unwrap_err();

        let (wood_growth_rate, steel_growth_rate, brick_growth_rate, food_growth_rate) = context
            .kingdom_lord
            .get_growth_rate(caller);
        let w:u64 = wood_growth_rate.into();
        assert(wood_growth_rate.into() == 19_u64, 'wood growth rate should be 19');
        let levels = context.kingdom_lord.get_buildings_levels(caller);
        assert(*levels.at(0) == 1_u64.into(), '0 should be 1');
    }


    #[test]
    #[available_gas(300000000000)]
    fn test_upgrade_invalid_proof() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn();
        let caller = get_caller_address();

        set_block_number(25);
        let res = context.kingdom_lord.start_upgrade(0, 1, 1, 40, 100, 50, 60, 2, 260, 7,array![0x1]);
        let err = res.unwrap_err();
        assert(err == Error::InvalidProof, 'not enough resource');
    }
}
