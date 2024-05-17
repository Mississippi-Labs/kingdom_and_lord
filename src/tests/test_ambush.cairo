#[cfg(test)]
mod tests {
    use kingdom_lord::interface::IKingdomLordTestDispatcherTrait;
use core::result::ResultTrait;
    use kingdom_lord::interface::IKingdomLordDispatcherTrait;
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::get_caller_address;
    use starknet::testing::{set_caller_address, set_block_timestamp, set_contract_address, set_transaction_hash};

    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    use kingdom_lord::tests::utils::{setup_world, increase_time};
    use starknet::contract_address_const;
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordTestDispatcherImpl, IKingdomLordTest,IKingdomLordLibraryDispatcherImpl, Error
    };
    use kingdom_lord::models::building_kind::BuildingKind;
    use kingdom_lord::tests::upgrade_func::{level1_barrack, level1_stable};
    use kingdom_lord::tests::utils::{full_level_barrack, full_level_stable, train_millitia, train_scouts, assert_troop, assert_resource};

    #[test]
    #[available_gas(300000000000)]
    fn test_ambush() {
        // deploy world with models
        let context = setup_world();

        let player1 = contract_address_const::<'PLAYER1'>();
        let player2 = contract_address_const::<'PLAYER2'>();

        increase_time(10);
    
        set_contract_address(player1);
        set_caller_address(player1);
        context.kingdom_lord_test.spawn_test().expect('spawn works');
        context.kingdom_lord_test.create_village_confirm_test().expect('create city confirm should work');
        increase_time(11);
        set_block_timestamp(1415457224);
        set_transaction_hash(0x07427f928837d4e0f7bfe798548c2ec0ebbbb16ee7531a2d1c66a978dd441f0c);
        context.kingdom_lord_test.create_village_reveal_test().expect('create city reveal should work');
        let (x1, y1) = context.kingdom_lord.get_village_location(player1);
        assert!(x1 == 76, "x should be 76 but got {}", x1);
        assert!(y1 == 90, "y should be 90 but got {}", y1);
        increase_time(100);
        level1_barrack(context, 21, player1);
        level1_stable(context, 22, player1);
        train_millitia(context, 6);
        train_millitia(context, 2);
        train_scouts(context, 6);
        train_scouts(context, 2);
        assert_troop(context, player1, 8,0,0,8,0,0);

        increase_time(10);
        set_contract_address(player2);
        set_caller_address(player2);
        context.kingdom_lord_test.spawn_test().expect('spawn works');
        context.kingdom_lord_test.create_village_confirm_test().expect('create city confirm should work');
        increase_time(11);
        set_block_timestamp(1814323223);
        set_transaction_hash(0x07427f928837d410f7bf1798548c2ec0ebbbb16ee7531a2d1c66a928dd443f0c);
        context.kingdom_lord_test.create_village_reveal_test().expect('create city reveal should work');
        let (x2, y2) = context.kingdom_lord.get_village_location(player2);
        assert!(x2 == 53, "x should be 36 but got {}", x2);
        assert!(y2 == 90, "y should be 99 but got {}", y2);
        increase_time(100);
        level1_barrack(context, 21, player2);
        level1_stable(context, 22, player2);
        train_millitia(context, 6);
        train_millitia(context, 4);
        train_scouts(context, 6);
        train_scouts(context, 4);
        assert_troop(context, player2, 10,0,0,10,0,0);

        let ambush_data = array![
            10,0,0,10,0,0,75, 90, 100000, 1
        ];
        let ambush_hash = core::poseidon::poseidon_hash_span(ambush_data.span());

        context.kingdom_lord_test.create_ambush_test(ambush_hash,10, 0,0,10,0,0).expect('create ambush succeed');
        assert_troop(context, player2, 0,0,0,0,0,0);
        increase_time(100000);
        context.kingdom_lord_test.start_training_test(0, 1).expect('train millitia');
        assert_resource(context, player2, 880, 900, 850, 970);
        assert_resource(context, player1, 1000, 1000, 1000, 1000);
        context.kingdom_lord_test.reveal_attack_test(ambush_hash, 75, 90, 100000, 1, 76,90, true).expect('reveal attack succeed');

        assert_troop(context, player2, 4,0,0,4,0,0);
        assert_troop(context, player1, 4,0,0,4,0,0);

        assert_resource(context, player1, 960, 960, 960, 960);
        assert_resource(context, player2, 920, 940, 890, 1000);
    }
}
