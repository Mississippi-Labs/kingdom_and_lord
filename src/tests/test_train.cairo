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
        setup_world, assert_troop, assert_resource, construct_barrack, increase_time, construct_stable
    };
    use kingdom_lord::tests::upgrade_info::{cityhall_level2_proof, cityhall_level1_proof};
    use kingdom_lord::interface::{
        IKingdomLord, IKingdomLordDispatcher, IKingdomLordLibraryDispatcherImpl, Error
    };

    #[test]
    #[available_gas(300000000000)]
    fn test_barrack() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');

        construct_barrack(context);
        let caller = get_caller_address();

        assert_resource(context, caller, 1000, 1000, 1000, 1000);
        context.kingdom_lord.start_training(0).expect('train 0 1 works');
        assert_resource(context, caller, 880, 900, 850, 970);
        context.kingdom_lord.start_training(0).expect('train 0 2 works');
        assert_resource(context, caller, 760, 800, 700, 940);

        increase_time(150);
        let err = context.kingdom_lord.finish_training(true).unwrap_err();
        assert_eq!(err, Error::TrainingNotFinished, "training not finished");
        increase_time(1450);
        context.kingdom_lord.finish_training(true).unwrap();
        assert_troop(context, caller, 1, 0, 0, 0, 0, 0);
        increase_time(1600);
        context.kingdom_lord.finish_training(true).unwrap();
        assert_troop(context, caller, 2, 0, 0, 0, 0, 0);

        // all are finished
        context.kingdom_lord.finish_training(true).unwrap_err();

        context.kingdom_lord.start_training(0).expect('train 0 3 works');
        context.kingdom_lord.start_training(0).expect('train 0 4 works');
        context.kingdom_lord.start_training(0).expect('train 0 5 works');
        context.kingdom_lord.start_training(0).expect('train 0 6 works');
        context.kingdom_lord.start_training(0).expect('train 0 7 works');
        context.kingdom_lord.start_training(0).expect('train 0 8 works');
        increase_time(200);
        context.kingdom_lord.start_training(0).expect('train 0 9 works');
        context.kingdom_lord.start_training(0).expect('train 0 10 works');
        context.kingdom_lord.start_training(0).expect('train 0 11 works');
        context.kingdom_lord.start_training(0).expect('train 0 12 works');
        let err = context.kingdom_lord.start_training(0).unwrap_err();
        assert_eq!(err, Error::TrainingListFull, "training queue full");

        increase_time(1400);
        context.kingdom_lord.finish_training(true).unwrap();
        assert_troop(context, caller,3, 0, 0, 0, 0, 0);
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_stable() {
        // deploy world with models
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');

        construct_stable(context);
        let caller = get_caller_address();

        assert_resource(context, caller, 1000, 1000, 1000, 1000);
        context.kingdom_lord.start_training(3).expect('train 3 1 works');
        assert_resource(context, caller, 860, 840, 980, 960);
        context.kingdom_lord.start_training(3).expect('train 3 2 works');
        assert_resource(context, caller, 720, 680, 960, 920);

        increase_time(150);
        let err = context.kingdom_lord.finish_training(false).unwrap_err();
        assert_eq!(err, Error::TrainingNotFinished, "training not finished");
        increase_time(1450);
        context.kingdom_lord.finish_training(false).unwrap();
        assert_troop(context, caller, 0, 0, 0, 1, 0, 0);
        increase_time(1600);
        context.kingdom_lord.finish_training(false).unwrap();
        assert_troop(context, caller, 0, 0, 0, 2, 0, 0);

        // all are finished
        context.kingdom_lord.finish_training(false).unwrap_err();

        context.kingdom_lord.start_training(3).expect('train 3 3 works');
        context.kingdom_lord.start_training(3).expect('train 3 4 works');
        context.kingdom_lord.start_training(3).expect('train 3 5 works');
        context.kingdom_lord.start_training(3).expect('train 3 6 works');
        context.kingdom_lord.start_training(3).expect('train 3 7 works');
        context.kingdom_lord.start_training(3).expect('train 3 8 works');
        increase_time(200);
        context.kingdom_lord.start_training(3).expect('train 3 9 works');
        context.kingdom_lord.start_training(3).expect('train 3 10 works');
        context.kingdom_lord.start_training(3).expect('train 3 11 works');
        context.kingdom_lord.start_training(3).expect('train 3 12 works');
        let err = context.kingdom_lord.start_training(3).unwrap_err();
        assert_eq!(err, Error::TrainingListFull, "training queue full");

        increase_time(1400);
        context.kingdom_lord.finish_training(false).unwrap();
        assert_troop(context, caller,0, 0, 0, 3, 0, 0);
    }


    #[test]
    #[available_gas(300000000000)]
    fn test_no_barrack_training() {
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        increase_time(100);
        let err = context.kingdom_lord.start_training(0).unwrap_err();
        assert(err == Error::TrainingPrerequirementNotMatch, 'barrack have not built');
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_barrack_training_no_college() {
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        construct_barrack(context);
        let err = context.kingdom_lord.start_training(1).unwrap_err();
        assert(err == Error::TrainingPrerequirementNotMatch, 'college level not enough');
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_no_stable_training() {
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        increase_time(100);
        let err = context.kingdom_lord.start_training(3).unwrap_err();
        assert(err == Error::TrainingPrerequirementNotMatch, 'stable have not built');
    }

    #[test]
    #[available_gas(300000000000)]
    fn test_stable_training_no_college() {
        let context = setup_world();

        context.kingdom_lord.spawn().expect('spawn works');
        construct_stable(context);
        let err = context.kingdom_lord.start_training(4).unwrap_err();
        assert(err == Error::TrainingPrerequirementNotMatch, 'college level not enough');
    }
}