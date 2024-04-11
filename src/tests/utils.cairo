#[cfg(test)]
use dojo::test_utils::{spawn_test_world, deploy_contract};
use kingdom_lord::components::barn::barn;
use starknet::ContractAddress;
use kingdom_lord::components::outer_city::outer_city;
use kingdom_lord::components::warehouse::warehouse;
use kingdom_lord::components::city_building::city_building;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use kingdom_lord::actions::{kingdom_lord_controller};
use kingdom_lord::interface::{
    IKingdomLordDispatcher, IKingdomLordAdminDispatcher, IKingdomLordAdmin,IKingdomLordTestDispatcherImpl, 
    IKingdomLordLibraryDispatcherImpl, IKingdomLordAdminDispatcherImpl, IKingdomLordDispatcherTrait, IKingdomLordTestDispatcher
};
use openzeppelin::token::erc20::interface::IERC20DispatcherImpl;
use kingdom_lord::actions::kingdom_lord_controller::world_dispatcherContractMemberStateTrait;
use kingdom_lord::admin::kingdom_lord_admin;
use kingdom_lord::components::outer_city::OuterCityTraitDispatcher;
use kingdom_lord::tests::upgrade_info::{barrack_level1_proof, stable_level1_proof, barrack_level2_proof, stable_level2_proof};
use starknet::contract_address_const;
use openzeppelin::presets::erc20::ERC20;
use openzeppelin::token::erc20::interface::IERC20Dispatcher;
use kingdom_lord::models::time::get_current_time;
use starknet::testing::{set_caller_address, set_contract_address, set_block_number};
trait SerializedAppend<T> {
    fn append_serde(ref self: Array<felt252>, value: T);
}

impl SerializedAppendImpl<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of SerializedAppend<T> {
    fn append_serde(ref self: Array<felt252>, value: T) {
        value.serialize(ref self);
    }
}

#[derive(Drop, Clone, Copy)]
struct TestContext {
    world: IWorldDispatcher,
    contract_address: ContractAddress,
    kingdom_lord: IKingdomLordDispatcher,
    kingdom_lord_test: IKingdomLordTestDispatcher,
    kingdom_lord_admin: IKingdomLordAdminDispatcher,
    erc20_dispatcher: IERC20Dispatcher,
    erc20_address: ContractAddress
}

// fn NAME() -> felt252 {
//     'test'
// }

// fn SYMBOL() -> felt252 {
//     'test'
// }

fn NAME() -> ByteArray {
    "NAME"
}

fn SYMBOL() -> ByteArray {
    "SYMBOL"
}

const SUPPLY: u256 = 2000000;

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn PLAYER() -> ContractAddress {
    contract_address_const::<'PLAYER'>()
}

fn assert_resource(
    context: TestContext, player: ContractAddress, wood: u64, brick: u64, steel: u64, food: u64
) {
    let (actual_wood, actual_brick, actual_steel, actual_food) = context
        .kingdom_lord
        .get_resource(player);
    let actual_wood: u64 = actual_wood.into();
    let actual_brick: u64 = actual_brick.into();
    let actual_steel: u64 = actual_steel.into();
    let actual_food: u64 = actual_food.into();
    assert_eq!(actual_wood, wood, "resource wood should be {} but got {}", wood, actual_wood);
    assert_eq!(actual_brick, brick, "resource brick should be {} but got {}", brick, actual_brick);
    assert_eq!(actual_steel, steel, "resource steel should be {} but got {}", steel, actual_steel);
    assert_eq!(actual_food, food, "resource food should be {} but got {}", food, actual_food);
}

fn assert_troop(
    context: TestContext,
    player: ContractAddress,
    millitia: u64,
    guard: u64,
    heavy_infantry: u64,
    scouts: u64,
    knights: u64,
    heavy_knights: u64
) {
    let troop = context.kingdom_lord.get_troops(player);
    assert_eq!(
        troop.millitia, millitia, "millititia should be {} but got {}", troop.millitia, millitia
    );
    assert_eq!(troop.guard, guard, "guard should be {} but got {}", troop.guard, guard);
    assert_eq!(
        troop.heavy_infantry,
        heavy_infantry,
        "heavy_infantry should be {} but got {}",
        troop.heavy_infantry,
        heavy_infantry
    );
    assert_eq!(troop.scouts, scouts, "scouts should be {} but got {}", troop.scouts, scouts);
    assert_eq!(troop.knights, knights, "knights should be {} but got {}", troop.knights, knights);
    assert_eq!(
        troop.heavy_knights,
        heavy_knights,
        "heavy_knights should be {} but got {}",
        troop.heavy_knights,
        heavy_knights
    );
}

fn increase_time(time: u64) {
    let current_time = get_current_time();
    set_block_number(current_time + time);
}


fn construct_barrack(context: TestContext) {
    increase_time(100);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            21,
            8,
            1,
            210,
            140,
            260,
            120,
            4,
            2000,
            100,
            barrack_level1_proof()
        )
        .expect('start construct barrack');
    increase_time(2000);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('construct barrack');
}

fn level2_barrack(context: TestContext){
    context
        .kingdom_lord_test
        .start_upgrade_test(
            21,8, 2, 270, 180, 335, 155, 2, 2620, 90,
            barrack_level2_proof()
        )
        .expect('start construct barrack');
    increase_time(2620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('construct barrack');
}

fn construct_stable(context: TestContext){
    increase_time(100);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            20,
            9, 1, 260, 140, 220, 100, 5, 2200, 100,
            stable_level1_proof()
        )
        .expect('start construct stable');
    increase_time(2200);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('construct stable');
}

fn level2_stable(context: TestContext){
    context
        .kingdom_lord_test
        .start_upgrade_test(
            20,9, 2, 335, 180, 280, 130, 3, 2850, 90,
            stable_level2_proof()
        )
        .expect('start construct stable');
    increase_time(2850);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('construct stable');
}

fn train_millitia(context: TestContext){
    context.kingdom_lord_test.start_training_test(0).expect('train millitia');
    increase_time(1600);
    context.kingdom_lord_test.finish_training_test(true).expect('finish training millitia');
}

fn train_scouts(context: TestContext){
    context.kingdom_lord_test.start_training_test(3).expect('train scouts');
    increase_time(1600);
    context.kingdom_lord_test.finish_training_test(false).expect('finish training scouts');
}

#[cfg(test)]
fn setup_world() -> TestContext {
    let mut models = array![
        barn::TEST_CLASS_HASH,
        warehouse::TEST_CLASS_HASH,
        city_building::TEST_CLASS_HASH,
        outer_city::TEST_CLASS_HASH
    ];
    // deploy world with models
    let world = spawn_test_world(models);
    // deploy systems contract
    let contract_address = world
        .deploy_contract(
            'salt1',
            kingdom_lord_controller::TEST_CLASS_HASH.try_into().expect('kingdom controller')
        );
    let admin_contract_address = world
        .deploy_contract(
            'salt2', kingdom_lord_admin::TEST_CLASS_HASH.try_into().expect('kindom admin')
        );

    // deploy erc20 contract
    let mut calldata: Array<felt252> = array![];
    let owner = OWNER();
    let name = NAME();
    let symbol = SYMBOL();
    name.serialize(ref calldata);
    symbol.serialize(ref calldata);
    SUPPLY.serialize(ref calldata);
    owner.serialize(ref calldata);
    let (erc20_contract_address, _) = starknet::deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().expect('erc20 test classs'), 0, calldata.span(), false
    )
        .expect('expect deploy erc20');

    let admin_dispatcher = IKingdomLordAdminDispatcher { contract_address: admin_contract_address };
    let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_contract_address };
    set_caller_address(PLAYER());
    set_contract_address(PLAYER());
    admin_dispatcher
        .set_config(
            erc20_contract_address,
            200_u256,
            owner,
            0x608f06197fc3aab41e774567c8e4b7e8fa5dae821240eda6b39f22939315f8c
        );
    TestContext {
        world,
        contract_address,
        kingdom_lord: IKingdomLordDispatcher { contract_address },
        kingdom_lord_test: IKingdomLordTestDispatcher{ contract_address},
        kingdom_lord_admin: admin_dispatcher,
        erc20_dispatcher,
        erc20_address: erc20_contract_address
    }
}
