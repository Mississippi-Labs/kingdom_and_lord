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
    use kingdom_lord::tests::utils::{setup_world, city_hall_level2_proof, city_hall_level1_proof, increase_time};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl, Error
    };
    use kingdom_lord::models::building_kind::BuildingKind;

    #[test]
    #[available_gas(300000000000)]
    fn test_city_hall() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        let caller = get_caller_address();
        let err = context
            .kingdom_lord
            .start_upgrade(18, 5, 1, 70, 40, 60, 20, 2, 2500, 100, city_hall_level1_proof())
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        increase_time(50);

        let res = context
            .kingdom_lord
            .start_upgrade(18, 5, 1, 70, 40, 60, 20, 2, 2500, 100, city_hall_level1_proof());
        let upgrade_id =res.unwrap();
        assert(upgrade_id == 0, 'first upgrade id is 0');

        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);
        assert(under_upgrade.building_kind == BuildingKind::CityHall.into(), 'under_upgrade should be 1');
        assert(under_upgrade.current_upgrade_id == 0, 'upgrade id should be 0');

        increase_time(2500);

        // city hall should be level up
        context.kingdom_lord.finish_upgrade().unwrap();
        context
            .kingdom_lord
            .start_upgrade(18, 5, 2, 90, 50, 75, 25, 1, 2620, 104, city_hall_level2_proof()).expect('start upgrade level 2 ');
        let under_upgrade = context.kingdom_lord.get_under_upgrading(caller);

        // 2620 - 2620 * 104 //10000 + 2550
        // let compute: u64 = 3220_u64 - 3220_u64 * 104_u64 /10000_u64 + 2670_u64;
        assert(under_upgrade.end_time == 5144, 'end block should be 5144');

        increase_time(2620);
        context.kingdom_lord.finish_upgrade().unwrap();
    }
}
