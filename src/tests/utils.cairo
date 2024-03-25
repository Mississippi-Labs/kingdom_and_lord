#[cfg(test)]
use dojo::test_utils::{spawn_test_world,
 deploy_contract};
use kingdom_lord::components::barn::barn;
use starknet::ContractAddress;
use kingdom_lord::components::outer_city::outer_city;
use kingdom_lord::components::warehouse::warehouse;
use kingdom_lord::components::city_building::city_building;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use kingdom_lord::actions::{kingdom_lord_controller};
use kingdom_lord::interface::{
    IKingdomLordDispatcher, IKingdomLordAdminDispatcher, IKingdomLordAdmin,
    IKingdomLordLibraryDispatcherImpl, IKingdomLordAdminDispatcherImpl,
    IKingdomLordDispatcherTrait
};
 use openzeppelin::token::erc20::interface::IERC20DispatcherImpl;
 use kingdom_lord::helpers::contract_address::FmtContractAddr;
use kingdom_lord::actions::kingdom_lord_controller::world_dispatcherContractMemberStateTrait;
use kingdom_lord::admin::kingdom_lord_admin;
use kingdom_lord::components::outer_city::OuterCityTraitDispatcher;
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
    kingdom_lord_admin: IKingdomLordAdminDispatcher,
    erc20_dispatcher: IERC20Dispatcher,
    erc20_address: ContractAddress
}


const NAME: felt252 = 'test';
const SYNBOL: felt252 = 'test';
const SUPPLY: u256 = 2000000;

fn OWNER() -> ContractAddress {
    contract_address_const::<'OWNER'>()
}

fn PLAYER() -> ContractAddress {
    contract_address_const::<'PLAYER'>()
}

fn wood_level_1_proof() -> Array<felt252> {
    array![
        0x5bd703a76bfe8b2261ff982e1896c88a6d6e2452bc696278f2a5c19f653e0c4,
        0xbbafcb4a5708030baa205ce47a23e2590c83d319fe625bdf662b99e510ab8c,
        0x7311928e7a8f9bcc86d715a6a7d4028f125daf5b5bf841de4ebdd288f6e4368,
        0x4bd1dbe10d1ef0faa8a2a9d79e269fccb754465edae46c66e440254d6a1e8ab,
        0x2ca45d555302aaf1dd30099b789063b0b293e9282c7cf0d50072a69e748e2e,
        0x58ea808ed1dd6d4eb8c2412089e406fd565973ae11f097a8ef1cd395484fff3,
        0x30a686f921ae094fb5747465a4390f70c1d521603c8a1da5799450feeb567fb,
        0x6f083eb9dc40b555e9f8c6ed4529c2c5bfd33087c0f80701992b254230a0c32
    ]
}

fn city_hall_level2_proof() -> Array<felt252> {
    array![
        0x56221680bf3d6661ba394e3c97541cd07fe77d832a713572201b3bee1604735,
        0x575978c19ae8821f17dcb09f2865515b661bb72486a758da18853b0208c5081,
        0x751fea1cdd1b21696ae357f83c2b96fbd0a7891b053cdc652807c88320c942c,
        0x352510f1269cea2ac10dab006a027dee2dcc6fc82676fbb5b862269d99528ee,
        0x660a74333a6082be847d98d1779c25ab498eaf93ea998125db323a1bc0c8cc7,
        0x53292aa62ac71f440a6c19786b359d3242844aed9effad78c0e7972ef409a1b,
        0x59dc966df9f4d4b5a02fa4d584ce7280cc0c8633e411a3f92f558abe1ecc464,
        0x6f083eb9dc40b555e9f8c6ed4529c2c5bfd33087c0f80701992b254230a0c32
    ]
}

fn city_hall_level1_proof() -> Array<felt252> {
    array![
        0x56e9e5ce79486d11d4079f6521d5de93bc3e474dc2cd647063fe45c22054ac8,
        0x575978c19ae8821f17dcb09f2865515b661bb72486a758da18853b0208c5081,
        0x751fea1cdd1b21696ae357f83c2b96fbd0a7891b053cdc652807c88320c942c,
        0x352510f1269cea2ac10dab006a027dee2dcc6fc82676fbb5b862269d99528ee,
        0x660a74333a6082be847d98d1779c25ab498eaf93ea998125db323a1bc0c8cc7,
        0x53292aa62ac71f440a6c19786b359d3242844aed9effad78c0e7972ef409a1b,
        0x59dc966df9f4d4b5a02fa4d584ce7280cc0c8633e411a3f92f558abe1ecc464,
        0x6f083eb9dc40b555e9f8c6ed4529c2c5bfd33087c0f80701992b254230a0c32
    ]
}

fn warehouse_level1_proof() -> Array<felt252> {
    array![
        0x15e13da9e4006b0743b75b13080030f13ed8f485efa02b4a66c8b59e5150ce3,
        0x3e18c7be39fc9a8cbb8aae595fd4e898abfc9945356debf6b201344d5fa3b82,
        0x63537e18ece5a69d40ccb8ee30eee5439965b8e3bbaaafd50cd98cb48a3b7a0,
        0x5db1c0cec9f79605143f8686956a6114b50d34724944c02047b7350ac243a8e,
        0x53671a3938b8eb7a9e796f00ec21a86a8ceabeb3d1cc45dceec3bd8883c5ed6,
        0x32c207f7db5b02df3916cb11144023134ad16417964abb3f7fa66d2fa1bdcc6,
        0x59dc966df9f4d4b5a02fa4d584ce7280cc0c8633e411a3f92f558abe1ecc464,
        0x6f083eb9dc40b555e9f8c6ed4529c2c5bfd33087c0f80701992b254230a0c32
    ]
}

fn assert_resource(
    context: TestContext, player: ContractAddress, wood: u64, brick: u64, steel: u64, food: u64
) {
    let (actual_wood, actual_brick, actual_steel, actual_food) = context.kingdom_lord.get_resource(player);
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
    context: TestContext, player: ContractAddress, millitia: u64, guard: u64, heavy_infantry: u64, scouts: u64, knights: u64, heavy_knights: u64
) {
    let troop = context.kingdom_lord.get_troops(player);
    assert_eq!(troop.millitia, millitia, "millititia should be {} but got {}", troop.millitia, millitia);
    assert_eq!(troop.guard, guard, "guard should be {} but got {}", troop.guard, guard);
    assert_eq!(troop.heavy_infantry, heavy_infantry, "heavy_infantry should be {} but got {}", troop.heavy_infantry, heavy_infantry);
    assert_eq!(troop.scouts, scouts, "scouts should be {} but got {}", troop.scouts, scouts);
    assert_eq!(troop.knights, knights, "knights should be {} but got {}", troop.knights, knights);
    assert_eq!(troop.heavy_knights, heavy_knights, "heavy_knights should be {} but got {}", troop.heavy_knights, heavy_knights);
}

fn increase_time(time: u64) {
    let current_time = get_current_time();
    set_block_number(current_time + time);
}


fn construct_barrack(context: TestContext){
    increase_time(100);
    let res = context.kingdom_lord.start_upgrade(19, 8, 1, 210, 140, 260, 120, 4, 2000, 100,     array![
        0x3e6b3f2c7624525e03ed0c96ff43d0fe1dafa24a61eaca42b1e9dd00a9bf2b9,
        0x2e42f1daa91953d844c066e52c9355208979c982e0cea128e7ea54db6dd1d75,
        0x5eeef9158bbb0ed60b496e2dd18f1b50f2efd44a619a1e4f4b312562fd86202,
        0x76a918559603e1db782e6b05119251069e444c6f0aa1fa6e9f2c21a607fe648,
        0x5a39d476538786b9849535508804dfe168518b1f6c2d65541109b2534791136,
        0x0,
        0x0,
        0x5f0dde256e23129e6713acf8c87088898a0632c9d3cddcd77fc58c2c1a8922b
    ]);
    increase_time(2000);
    let res = context.kingdom_lord.finish_upgrade(0);
    res.unwrap();
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
        .deploy_contract('salt1', kingdom_lord_controller::TEST_CLASS_HASH.try_into().unwrap());
    let admin_contract_address = world
        .deploy_contract('salt2', kingdom_lord_admin::TEST_CLASS_HASH.try_into().unwrap());

    // deploy erc20 contract
    let mut calldata: Array<felt252> = array![];
    let owner = OWNER();
    NAME.serialize(ref calldata);
    SYNBOL.serialize(ref calldata);
    SUPPLY.serialize(ref calldata);
    owner.serialize(ref calldata);
    let (erc20_contract_address, _) = starknet::deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();

    let admin_dispatcher = IKingdomLordAdminDispatcher { contract_address: admin_contract_address };
    let erc20_dispatcher = IERC20Dispatcher { contract_address: erc20_contract_address };
    set_caller_address(PLAYER());
    set_contract_address(PLAYER());
    admin_dispatcher
        .set_config(
            erc20_contract_address,
            200_u256,
            owner,
            0x2e3aa949c5d014218a1194b9d5c84c7457a027fc34826547b8dfe5b52d72220
        );
    TestContext {
        world,
        contract_address,
        kingdom_lord: IKingdomLordDispatcher { contract_address },
        kingdom_lord_admin: admin_dispatcher,
        erc20_dispatcher,
        erc20_address: erc20_contract_address
    }
}
