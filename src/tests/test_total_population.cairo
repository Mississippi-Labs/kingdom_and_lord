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
        setup_world, city_hall_level1_proof, city_hall_level2_proof, warehouse_level1_proof,
        assert_resource, increase_time, warehouse_level2_proof, barn_level1_proof, barn_level2_proof
    };
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
            .start_upgrade(18, 5, 1, 70, 40, 60, 20, 2, 2500, 100, city_hall_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(1000);
        assert_resource(context, caller, 1000, 1000, 1000, 1000);
    }
}
