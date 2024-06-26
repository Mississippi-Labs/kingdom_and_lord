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
        setup_world, assert_resource, increase_time, TestContext,  train_millitia, train_scouts
    };
    use kingdom_lord::tests::upgrade_func::{level1_barrack, level2_barrack, level1_stable, level2_stable };
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordTestDispatcherImpl, IKingdomLordTest,IKingdomLordLibraryDispatcherImpl, Error
    };
    use starknet::ContractAddress;

    fn assert_population(context: TestContext, caller: ContractAddress, population: u64) {
        let result = context.kingdom_lord.get_total_population(caller);
        assert!(result == population, "population is {}, should be {}", result, population);
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_total_population() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        let caller = get_caller_address();

        assert_resource(context, caller, 0, 0, 0, 0);
        
        assert_population(context, caller, 0);
        increase_time(100);
        level1_barrack(context, 21, caller);
        assert_population(context, caller, 4);

        level1_stable(context, 20, caller);
        assert_population(context, caller, 9);

        level2_barrack(context, 21, caller);
        assert_population(context, caller, 11);

        level2_stable(context, 20,caller);
        assert_population(context, caller, 14);
    

        train_millitia(context, 1);
        assert_population(context, caller, 15);

        train_millitia(context, 1);
        assert_population(context, caller, 16);

        train_scouts(context, 1);
        assert_population(context, caller, 18);

        train_scouts(context, 1);
        assert_population(context, caller, 20);
    }
}
