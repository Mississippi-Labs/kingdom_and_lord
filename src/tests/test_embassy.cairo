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
    use kingdom_lord::tests::upgrade_info::{embassy_level1_proof, embassy_level2_proof, embassy_level3_proof};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordTestDispatcherImpl, IKingdomLordTest,IKingdomLordLibraryDispatcherImpl, Error
    };
    use kingdom_lord::models::building_kind::BuildingKind;

    #[test]
    #[available_gas(300000000000)]
    fn test_embassy() {
        // deploy world with models
        let context = setup_world();
        let caller = get_caller_address();

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        let ally_amount = context.kingdom_lord.get_ally_amount(caller);
        assert(ally_amount == 0, 'ally amount  should be 0');
        let err = context
            .kingdom_lord_test
            .start_upgrade_test(20, 11, 1, 180, 130, 150, 80, 3, 2000, 0, embassy_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(50);

        context
            .kingdom_lord_test
            .start_upgrade_test(20, 11, 1, 180, 130, 150, 80, 3, 2000, 0,  embassy_level1_proof()).expect('start upgrade embassy');

        increase_time(2000);

        context.kingdom_lord_test.finish_upgrade_test().unwrap();
        let ally_amount = context.kingdom_lord.get_ally_amount(caller);
        assert(ally_amount == 0, 'ally amount  should be 0');

       context
            .kingdom_lord_test
            .start_upgrade_test(20, 11, 2, 230, 165, 190, 100, 2, 2620, 0,  embassy_level2_proof()).expect('start upgrade embassy 2');

        increase_time(2620);

        context.kingdom_lord_test.finish_upgrade_test().unwrap();
        let ally_amount = context.kingdom_lord.get_ally_amount(caller);
        assert(ally_amount == 0, 'ally amount  should be 0');

        context
            .kingdom_lord_test
            .start_upgrade_test(20,11, 3, 295, 215, 245, 130, 2, 3340, 9,  embassy_level3_proof()).expect('finish upgrde embassy');

        increase_time(3340);

        context.kingdom_lord_test.finish_upgrade_test().unwrap();
        let ally_amount = context.kingdom_lord.get_ally_amount(caller);
        assert(ally_amount == 9, 'ally amount  should be 9');
    }
}
