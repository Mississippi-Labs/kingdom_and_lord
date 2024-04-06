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
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordTestDispatcherImpl, IKingdomLordTest,IKingdomLordLibraryDispatcherImpl, Error
    };

    #[test]
    #[available_gas(300000000000)]
    fn test_total_population() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        let caller = get_caller_address();

        assert_resource(context, caller, 0, 0, 0, 0);
        
        let population = context.kingdom_lord.get_total_population(caller);
        assert!(population == 0, "initial population is 0")
    }
}
