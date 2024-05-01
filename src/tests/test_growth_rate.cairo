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
    use kingdom_lord::tests::utils::{setup_world, increase_time, TestContext};
    use kingdom_lord::tests::upgrade_proof::{
        cityhall_level1_proof, cityhall_level2_proof, warehouse_level2_proof, barn_level1_proof,
        barn_level2_proof, warehouse_level1_proof, wood_level1_proof, brick_level1_proof
    };
    use starknet::ContractAddress;
    use kingdom_lord::interface::{IKingdomLord, IKingdomLordLibraryDispatcherImpl, IKingdomLordTestDispatcherImpl, IKingdomLordTest, Error};

    fn assert_growth_rate(context: TestContext, player: ContractAddress, wood: u64, brick: u64, steel: u64, food: u64){
        let (wood_fact, brick_fact, steel_fact, food_fact) = context.kingdom_lord.get_growth_rate(player);
        assert!(wood== wood_fact.into(), "wood growth rate should be {} got {}", wood, wood_fact.amount);
        assert!(brick== brick_fact.into(), "brick growth rate should be {} got {}", brick, brick_fact.amount);
        assert!(steel== steel_fact.into(), "steel growth rate should be {} got {}", steel, steel_fact.amount);
        assert!(food== food_fact.into(), "food growth rate should be {} got {}", food, food_fact.amount);
     }

    #[test]
    fn test_upgrade_growth_rate_wrong(){
        // deploy world with models
        let context = setup_world();
        let caller = get_caller_address();
        context.kingdom_lord_test.spawn_test().expect('spawn works');
        increase_time(100);
        context
            .kingdom_lord_test
            .start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level1_proof())
            .expect('upgrading 0 works');
        context
            .kingdom_lord_test
            .start_upgrade_test(5, 2, 1, 80, 40, 80, 50, 2, 220, 7, brick_level1_proof())
            .expect('upgrading 5 works');

        increase_time(260);
        
        context.kingdom_lord_test.finish_upgrade_test().expect('finish upgrading 0');

        assert_growth_rate(context, caller, 19, 16, 16, 24);

        increase_time(220);
        
        context.kingdom_lord_test.finish_upgrade_test().expect('finish upgrading 0');
        assert_growth_rate(context, caller, 19, 19, 16, 24);
    }

}
