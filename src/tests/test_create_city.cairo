#[cfg(test)]
mod tests {
    use core::result::ResultTrait;
    use kingdom_lord::interface::IKingdomLordDispatcherTrait;
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::get_caller_address;
    use starknet::testing::{set_caller_address, set_block_timestamp, set_transaction_hash};
    use starknet::contract_address_const;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    use kingdom_lord::tests::utils::{setup_world, increase_time};
    use kingdom_lord::tests::upgrade_proof::{
        cityhall_level1_proof, cityhall_level2_proof, warehouse_level2_proof, barn_level1_proof,
        barn_level2_proof, warehouse_level1_proof
    };
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordTestDispatcherImpl, IKingdomLordTest,IKingdomLordLibraryDispatcherImpl, Error
    };
    use kingdom_lord::models::building_kind::BuildingKind;

    #[test]
    fn test_create_city() {
        // deploy world with models
        let context = setup_world();
        // make sure block number is not 0 . block 0 would get some side effects on create_city
        let caller = get_caller_address();
        increase_time(10);

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        
        let city_confirm = context.kingdom_lord_test.create_village_confirm_test().expect('create city confirm should work');
        assert!(city_confirm.block == 10, "block number should be 0");
        assert!(city_confirm.player == caller, "caller should be caller");
        increase_time(11);
        set_block_timestamp(1714457224);
        set_transaction_hash(0x07427f928837d4e0f7bfe798548c2ec0ebbbb16ee7531a2d1c66a978dd441f0c);
        context.kingdom_lord_test.create_village_reveal_test().expect('create city reveal should work');

        let (x, y) = context.kingdom_lord.get_village_location(caller);

        assert!(x == 1, "x should be 73 but got {}", x);
        assert!(y == 92, "y should be 75 but got {}", y);
    }

    #[test]
    fn test_create_city_no_block_increase() {
        // deploy world with models
        let context = setup_world();
        // make sure block number is not 0 . block 0 would get some side effects on create_city
        let caller = get_caller_address();
        increase_time(10);

        context.kingdom_lord_test.spawn_test().expect('spawn works');
        
        let city_confirm = context.kingdom_lord_test.create_village_confirm_test().expect('create city confirm should work');
        assert!(city_confirm.block == 10, "block number should be 0");
        assert!(city_confirm.player == caller, "caller should be caller");

        let res = context.kingdom_lord_test.create_village_reveal_test().unwrap_err();
        assert!(res == Error::VillageConfirmNotStarted)


    }
}
