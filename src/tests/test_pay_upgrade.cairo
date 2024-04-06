#[cfg(test)]
mod tests {
    use core::result::ResultTrait;
    use kingdom_lord::interface::IKingdomLordDispatcherTrait;
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::get_caller_address;
    use starknet::testing::{set_caller_address, set_block_timestamp, set_contract_address};
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    use kingdom_lord::tests::utils::{setup_world, OWNER, PLAYER, wood_level_1_proof, increase_time};
    use kingdom_lord::interface::{IKingdomLord, IKingdomLordDispatcher,IKingdomLordTest, IKingdomLordTestDispatcherImpl, IKingdomLordLibraryDispatcherImpl, Error};
    use kingdom_lord::components::city_hall::UnderUpgrading;
    use openzeppelin::token::erc20::interface::IERC20DispatcherImpl;

    #[test]
    #[available_gas(300000000000)]
    fn test_pay_to_upgrade() {
        // deploy world with models
        let context = setup_world();
        let owner = OWNER();
        let player = PLAYER();
        set_contract_address(owner);

        let res = context.erc20_dispatcher.transfer(player, 2000);
        assert(res, 'transfer works');

        set_contract_address(player);
        set_caller_address(player);

        context.erc20_dispatcher.approve(context.kingdom_lord.contract_address, 200_u256);
        context.kingdom_lord_test.spawn_test().expect('spawn works');
        let caller = get_caller_address();

        let err = context.kingdom_lord_test.start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level_1_proof()).unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(25);
        let res = context.kingdom_lord_test.start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level_1_proof());
        let upgrade_id = res.unwrap();
        assert(upgrade_id == 0, 'first upgrade id is 0');

        increase_time(4);
        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);
        let upgrade = under_upgrade.at(0);
        assert(under_upgrade.len() == 1, 'under_upgrade should be 1');
        assert(*upgrade.upgrade_id == 0, 'upgrade id should be 0');
        assert(*upgrade.start_time == 25, 'end block should be 25');
        assert(*upgrade.end_time == 285, 'end block should be 285');
        let finishe_upgrade = context.kingdom_lord.get_complete_upgrading(caller);
        assert(finishe_upgrade.len() == 0, 'finished should be 0');

        context.kingdom_lord.pay_to_finish_upgrade_test(0_u64).unwrap();

        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);
        assert(under_upgrade.len() == 0, 'under_upgrade should be 0 ');
        let finishe_upgrade = context.kingdom_lord.get_complete_upgrading(caller);
        assert(finishe_upgrade.len() == 0, 'finished should be 0');

        let levels = context.kingdom_lord.get_buildings_levels(caller);
        assert(*levels.at(0) == 0_u64.into(), '1 should be 1');

        

    }


    #[test]
    #[available_gas(300000000000)]
    #[should_panic(expected: ('u256_sub Overflow', 'ENTRYPOINT_FAILED', 'ENTRYPOINT_FAILED'))]
    fn test_pay_to_upgrade_not_enough() {
        // deploy world with models
        let context = setup_world();
        let player = PLAYER();

        set_caller_address(player);
        set_contract_address(player);
        context.kingdom_lord_test.spawn_test().expect('spawn works');
        
        let err = context.kingdom_lord_test.start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level_1_proof()).unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(25);
        let res = context.kingdom_lord_test.start_upgrade_test(0, 1, 1, 40, 100, 50, 60, 2, 260, 7, wood_level_1_proof());
        let upgrade_id = res.unwrap();
        assert(upgrade_id == 0, 'first upgrade id is 0');

        increase_time(4);
        let under_upgrade = context.kingdom_lord.get_under_upgrading(player);
        assert(under_upgrade.len() == 1, 'under_upgrade should be 1');

        let upgrade = under_upgrade.at(0);
        assert(*upgrade.upgrade_id == 0, 'upgrade id should be 0');
        assert(*upgrade.start_time == 25, 'end block should be 25');
        assert(*upgrade.end_time == 285, 'end block should be 285');

        let finishe_upgrade = context.kingdom_lord.get_complete_upgrading(player);
        assert(finishe_upgrade.len() == 0, 'finished should be 0');
        context.kingdom_lord.pay_to_finish_upgrade_test(0_u64).expect('panic');

    }
}
