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
    use kingdom_lord::tests::utils::{setup_world, city_hall_level2_proof, assert_resource};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl, Error
    };

    #[test]
    #[available_gas(300000000000)]
    fn test_storage() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn();
        let caller = get_caller_address();

        assert_resource(context, caller, 0, 0, 0, 0);

        let err = context
            .kingdom_lord
            .start_upgrade(18, 5, 2, 90, 50, 75, 25, 1, 2620, 104, city_hall_level2_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        set_block_number(1000);
        assert_resource(context, caller, 1000, 1000, 1000, 1000);
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_upgrade_at_max_storage() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn();
        let caller = get_caller_address();

        assert_resource(context, caller, 0, 0, 0, 0);

        let err = context
            .kingdom_lord
            .start_upgrade(18, 5, 2, 90, 50, 75, 25, 1, 2620, 104, city_hall_level2_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        set_block_number(1000);

        let err = context
            .kingdom_lord
            .start_upgrade(18, 5, 2, 90, 50, 75, 25, 1, 2620, 104, city_hall_level2_proof())
            .unwrap();
        assert_resource(context, caller, 910, 950, 925, 975);
    }
}
