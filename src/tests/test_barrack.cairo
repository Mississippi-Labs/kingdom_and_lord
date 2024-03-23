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
    use kingdom_lord::tests::utils::{setup_world, assert_troop, city_hall_level2_proof, city_hall_level1_proof, assert_resource};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl, Error
    };

    #[test]
    #[available_gas(300000000000)]
    fn test_barrack() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn();
        let caller = get_caller_address();

        let err = context
            .kingdom_lord
            .start_training(0)
            .unwrap_err();
        assert(err == Error::ResourceNotEnough, 'not enough resource');
        set_block_number(100);
        assert_resource(context, caller, 1000,1000,1000,1000);
        let training_id1 = context.kingdom_lord.start_training(0).unwrap();
        assert_resource(context, caller, 880,900,850,970);
        let training_id2 = context.kingdom_lord.start_training(0).unwrap();
        assert_resource(context, caller, 760,800,700,940);
        let training_id3 = context.kingdom_lord.start_training(1).unwrap();
        assert_resource(context, caller, 660,670,540,870);

        set_block_number(150);
        println!("block number");
        let err = context.kingdom_lord.finish_training(training_id1).unwrap_err();
        assert_eq!(err, Error::TrainingNotFinished, "training not finished");
        set_block_number(1700);
        context.kingdom_lord.finish_training(training_id1).unwrap();
        assert_troop(context, caller, 1,0,0,0,0,0);

        context.kingdom_lord.finish_training(training_id2).unwrap();
        assert_troop(context, caller, 2,0,0,0,0,0);
        println!("block number 2");
        let err = context.kingdom_lord.finish_training(training_id3).unwrap_err();
        assert_eq!(err, Error::TrainingNotFinished, "training not finished");
        set_block_number(1860);
        let res = context.kingdom_lord.finish_training(training_id3).unwrap();
        assert_troop(context, caller, 2,1,0,0,0,0);
    }
}