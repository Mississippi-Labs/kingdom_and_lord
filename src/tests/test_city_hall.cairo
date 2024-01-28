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
    use kingdom_lord::tests::utils::{setup_world, city_hall_level2_proof, city_hall_level3_proof};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl, Error
    };

    #[test]
    #[available_gas(300000000000)]
    fn test_city_hall() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn();
        let caller = get_caller_address();

        let err = context
            .kingdom_lord
            .start_upgrade(18, 5, 2, 90, 50, 75, 25, 1, 2620, 104, city_hall_level2_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        set_block_number(50);

        let res = context
            .kingdom_lord
            .start_upgrade(18, 5, 2, 90, 50, 75, 25, 1, 2620, 104, city_hall_level2_proof());
        let upgrade_id = res.unwrap();
        assert(upgrade_id == 0, 'first upgrade id is 0');

        set_block_number(2670);

        let finishe_upgrade = context.kingdom_lord.get_complete_upgrading(caller);
        assert(finishe_upgrade.len() == 1, 'finished should be 1');

        let upgrade = finishe_upgrade.at(0);
        assert(*upgrade.upgrade_id == 0, 'upgrade id should be 0');
        // city hall should be level up
        context.kingdom_lord.finish_upgrade(0_u64).unwrap();

        let res = context
            .kingdom_lord
            .start_upgrade(18, 5, 3, 115, 65, 100, 35, 1, 3220, 108, city_hall_level3_proof());
        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);

        let upgrade = under_upgrade.at(0);
        // 3220 - 3220 * 104 /10000 + 2670
        // let compute: u64 = 3220_u64 - 3220_u64 * 104_u64 /10000_u64 + 2670_u64;
        assert(*upgrade.end_time == 5857, 'end block should be 5857');
    }
}
