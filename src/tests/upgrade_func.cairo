use kingdom_lord::tests::utils::{increase_time, TestContext};
use starknet::ContractAddress;
use starknet::testing::set_caller_address;
use kingdom_lord::interface::{
    IKingdomLordDispatcher, IKingdomLordAdminDispatcher, IKingdomLordAdmin,IKingdomLordTestDispatcherImpl, 
    IKingdomLordLibraryDispatcherImpl, IKingdomLordAdminDispatcherImpl, IKingdomLordDispatcherTrait, IKingdomLordTestDispatcher
};
use kingdom_lord::tests::upgrade_proof::wood_level1_proof;
use kingdom_lord::tests::upgrade_proof::wood_level2_proof;
use kingdom_lord::tests::upgrade_proof::wood_level3_proof;
use kingdom_lord::tests::upgrade_proof::wood_level4_proof;
use kingdom_lord::tests::upgrade_proof::wood_level5_proof;
use kingdom_lord::tests::upgrade_proof::wood_level6_proof;
use kingdom_lord::tests::upgrade_proof::wood_level7_proof;
use kingdom_lord::tests::upgrade_proof::wood_level8_proof;
use kingdom_lord::tests::upgrade_proof::wood_level9_proof;
use kingdom_lord::tests::upgrade_proof::wood_level10_proof;
use kingdom_lord::tests::upgrade_proof::wood_level11_proof;
use kingdom_lord::tests::upgrade_proof::wood_level12_proof;
use kingdom_lord::tests::upgrade_proof::wood_level13_proof;
use kingdom_lord::tests::upgrade_proof::wood_level14_proof;
use kingdom_lord::tests::upgrade_proof::wood_level15_proof;
use kingdom_lord::tests::upgrade_proof::wood_level16_proof;
use kingdom_lord::tests::upgrade_proof::wood_level17_proof;
use kingdom_lord::tests::upgrade_proof::wood_level18_proof;
use kingdom_lord::tests::upgrade_proof::wood_level19_proof;
use kingdom_lord::tests::upgrade_proof::wood_level20_proof;
use kingdom_lord::tests::upgrade_proof::brick_level1_proof;
use kingdom_lord::tests::upgrade_proof::brick_level2_proof;
use kingdom_lord::tests::upgrade_proof::brick_level3_proof;
use kingdom_lord::tests::upgrade_proof::brick_level4_proof;
use kingdom_lord::tests::upgrade_proof::brick_level5_proof;
use kingdom_lord::tests::upgrade_proof::brick_level6_proof;
use kingdom_lord::tests::upgrade_proof::brick_level7_proof;
use kingdom_lord::tests::upgrade_proof::brick_level8_proof;
use kingdom_lord::tests::upgrade_proof::brick_level9_proof;
use kingdom_lord::tests::upgrade_proof::brick_level10_proof;
use kingdom_lord::tests::upgrade_proof::brick_level11_proof;
use kingdom_lord::tests::upgrade_proof::brick_level12_proof;
use kingdom_lord::tests::upgrade_proof::brick_level13_proof;
use kingdom_lord::tests::upgrade_proof::brick_level14_proof;
use kingdom_lord::tests::upgrade_proof::brick_level15_proof;
use kingdom_lord::tests::upgrade_proof::brick_level16_proof;
use kingdom_lord::tests::upgrade_proof::brick_level17_proof;
use kingdom_lord::tests::upgrade_proof::brick_level18_proof;
use kingdom_lord::tests::upgrade_proof::brick_level19_proof;
use kingdom_lord::tests::upgrade_proof::brick_level20_proof;
use kingdom_lord::tests::upgrade_proof::steel_level1_proof;
use kingdom_lord::tests::upgrade_proof::steel_level2_proof;
use kingdom_lord::tests::upgrade_proof::steel_level3_proof;
use kingdom_lord::tests::upgrade_proof::steel_level4_proof;
use kingdom_lord::tests::upgrade_proof::steel_level5_proof;
use kingdom_lord::tests::upgrade_proof::steel_level6_proof;
use kingdom_lord::tests::upgrade_proof::steel_level7_proof;
use kingdom_lord::tests::upgrade_proof::steel_level8_proof;
use kingdom_lord::tests::upgrade_proof::steel_level9_proof;
use kingdom_lord::tests::upgrade_proof::steel_level10_proof;
use kingdom_lord::tests::upgrade_proof::steel_level11_proof;
use kingdom_lord::tests::upgrade_proof::steel_level12_proof;
use kingdom_lord::tests::upgrade_proof::steel_level13_proof;
use kingdom_lord::tests::upgrade_proof::steel_level14_proof;
use kingdom_lord::tests::upgrade_proof::steel_level15_proof;
use kingdom_lord::tests::upgrade_proof::steel_level16_proof;
use kingdom_lord::tests::upgrade_proof::steel_level17_proof;
use kingdom_lord::tests::upgrade_proof::steel_level18_proof;
use kingdom_lord::tests::upgrade_proof::steel_level19_proof;
use kingdom_lord::tests::upgrade_proof::steel_level20_proof;
use kingdom_lord::tests::upgrade_proof::food_level1_proof;
use kingdom_lord::tests::upgrade_proof::food_level2_proof;
use kingdom_lord::tests::upgrade_proof::food_level3_proof;
use kingdom_lord::tests::upgrade_proof::food_level4_proof;
use kingdom_lord::tests::upgrade_proof::food_level5_proof;
use kingdom_lord::tests::upgrade_proof::food_level6_proof;
use kingdom_lord::tests::upgrade_proof::food_level7_proof;
use kingdom_lord::tests::upgrade_proof::food_level8_proof;
use kingdom_lord::tests::upgrade_proof::food_level9_proof;
use kingdom_lord::tests::upgrade_proof::food_level10_proof;
use kingdom_lord::tests::upgrade_proof::food_level11_proof;
use kingdom_lord::tests::upgrade_proof::food_level12_proof;
use kingdom_lord::tests::upgrade_proof::food_level13_proof;
use kingdom_lord::tests::upgrade_proof::food_level14_proof;
use kingdom_lord::tests::upgrade_proof::food_level15_proof;
use kingdom_lord::tests::upgrade_proof::food_level16_proof;
use kingdom_lord::tests::upgrade_proof::food_level17_proof;
use kingdom_lord::tests::upgrade_proof::food_level18_proof;
use kingdom_lord::tests::upgrade_proof::food_level19_proof;
use kingdom_lord::tests::upgrade_proof::food_level20_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level1_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level2_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level3_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level4_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level5_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level6_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level7_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level8_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level9_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level10_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level11_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level12_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level13_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level14_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level15_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level16_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level17_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level18_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level19_proof;
use kingdom_lord::tests::upgrade_proof::cityhall_level20_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level1_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level2_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level3_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level4_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level5_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level6_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level7_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level8_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level9_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level10_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level11_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level12_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level13_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level14_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level15_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level16_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level17_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level18_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level19_proof;
use kingdom_lord::tests::upgrade_proof::warehouse_level20_proof;
use kingdom_lord::tests::upgrade_proof::barn_level1_proof;
use kingdom_lord::tests::upgrade_proof::barn_level2_proof;
use kingdom_lord::tests::upgrade_proof::barn_level3_proof;
use kingdom_lord::tests::upgrade_proof::barn_level4_proof;
use kingdom_lord::tests::upgrade_proof::barn_level5_proof;
use kingdom_lord::tests::upgrade_proof::barn_level6_proof;
use kingdom_lord::tests::upgrade_proof::barn_level7_proof;
use kingdom_lord::tests::upgrade_proof::barn_level8_proof;
use kingdom_lord::tests::upgrade_proof::barn_level9_proof;
use kingdom_lord::tests::upgrade_proof::barn_level10_proof;
use kingdom_lord::tests::upgrade_proof::barn_level11_proof;
use kingdom_lord::tests::upgrade_proof::barn_level12_proof;
use kingdom_lord::tests::upgrade_proof::barn_level13_proof;
use kingdom_lord::tests::upgrade_proof::barn_level14_proof;
use kingdom_lord::tests::upgrade_proof::barn_level15_proof;
use kingdom_lord::tests::upgrade_proof::barn_level16_proof;
use kingdom_lord::tests::upgrade_proof::barn_level17_proof;
use kingdom_lord::tests::upgrade_proof::barn_level18_proof;
use kingdom_lord::tests::upgrade_proof::barn_level19_proof;
use kingdom_lord::tests::upgrade_proof::barn_level20_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level1_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level2_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level3_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level4_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level5_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level6_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level7_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level8_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level9_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level10_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level11_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level12_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level13_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level14_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level15_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level16_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level17_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level18_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level19_proof;
use kingdom_lord::tests::upgrade_proof::barrack_level20_proof;
use kingdom_lord::tests::upgrade_proof::stable_level1_proof;
use kingdom_lord::tests::upgrade_proof::stable_level2_proof;
use kingdom_lord::tests::upgrade_proof::stable_level3_proof;
use kingdom_lord::tests::upgrade_proof::stable_level4_proof;
use kingdom_lord::tests::upgrade_proof::stable_level5_proof;
use kingdom_lord::tests::upgrade_proof::stable_level6_proof;
use kingdom_lord::tests::upgrade_proof::stable_level7_proof;
use kingdom_lord::tests::upgrade_proof::stable_level8_proof;
use kingdom_lord::tests::upgrade_proof::stable_level9_proof;
use kingdom_lord::tests::upgrade_proof::stable_level10_proof;
use kingdom_lord::tests::upgrade_proof::stable_level11_proof;
use kingdom_lord::tests::upgrade_proof::stable_level12_proof;
use kingdom_lord::tests::upgrade_proof::stable_level13_proof;
use kingdom_lord::tests::upgrade_proof::stable_level14_proof;
use kingdom_lord::tests::upgrade_proof::stable_level15_proof;
use kingdom_lord::tests::upgrade_proof::stable_level16_proof;
use kingdom_lord::tests::upgrade_proof::stable_level17_proof;
use kingdom_lord::tests::upgrade_proof::stable_level18_proof;
use kingdom_lord::tests::upgrade_proof::stable_level19_proof;
use kingdom_lord::tests::upgrade_proof::stable_level20_proof;
use kingdom_lord::tests::upgrade_proof::college_level1_proof;
use kingdom_lord::tests::upgrade_proof::college_level2_proof;
use kingdom_lord::tests::upgrade_proof::college_level3_proof;
use kingdom_lord::tests::upgrade_proof::college_level4_proof;
use kingdom_lord::tests::upgrade_proof::college_level5_proof;
use kingdom_lord::tests::upgrade_proof::college_level6_proof;
use kingdom_lord::tests::upgrade_proof::college_level7_proof;
use kingdom_lord::tests::upgrade_proof::college_level8_proof;
use kingdom_lord::tests::upgrade_proof::college_level9_proof;
use kingdom_lord::tests::upgrade_proof::college_level10_proof;
use kingdom_lord::tests::upgrade_proof::college_level11_proof;
use kingdom_lord::tests::upgrade_proof::college_level12_proof;
use kingdom_lord::tests::upgrade_proof::college_level13_proof;
use kingdom_lord::tests::upgrade_proof::college_level14_proof;
use kingdom_lord::tests::upgrade_proof::college_level15_proof;
use kingdom_lord::tests::upgrade_proof::college_level16_proof;
use kingdom_lord::tests::upgrade_proof::college_level17_proof;
use kingdom_lord::tests::upgrade_proof::college_level18_proof;
use kingdom_lord::tests::upgrade_proof::college_level19_proof;
use kingdom_lord::tests::upgrade_proof::college_level20_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level1_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level2_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level3_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level4_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level5_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level6_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level7_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level8_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level9_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level10_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level11_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level12_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level13_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level14_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level15_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level16_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level17_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level18_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level19_proof;
use kingdom_lord::tests::upgrade_proof::embassy_level20_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level1_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level2_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level3_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level4_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level5_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level6_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level7_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level8_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level9_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level10_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level11_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level12_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level13_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level14_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level15_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level16_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level17_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level18_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level19_proof;
use kingdom_lord::tests::upgrade_proof::city_wall_level20_proof;
fn level1_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 1, 40, 100, 50, 60, 2, 260, 7,
            wood_level1_proof()
        )
        .expect('construct wood level 1');
    increase_time(260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 1 done');
}
fn level2_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 2, 65, 165, 85, 100, 1, 620, 13,
            wood_level2_proof()
        )
        .expect('construct wood level 2');
    increase_time(620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 2 done');
}
fn level3_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 3, 110, 280, 140, 165, 1, 1190, 21,
            wood_level3_proof()
        )
        .expect('construct wood level 3');
    increase_time(1190);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 3 done');
}
fn level4_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 4, 185, 465, 235, 280, 1, 2100, 31,
            wood_level4_proof()
        )
        .expect('construct wood level 4');
    increase_time(2100);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 4 done');
}
fn level5_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 5, 310, 780, 390, 465, 1, 3560, 46,
            wood_level5_proof()
        )
        .expect('construct wood level 5');
    increase_time(3560);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 5 done');
}
fn level6_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 6, 520, 1300, 650, 780, 2, 5890, 70,
            wood_level6_proof()
        )
        .expect('construct wood level 6');
    increase_time(5890);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 6 done');
}
fn level7_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 7, 870, 2170, 1085, 1300, 2, 9620, 98,
            wood_level7_proof()
        )
        .expect('construct wood level 7');
    increase_time(9620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 7 done');
}
fn level8_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 8, 1450, 3625, 1810, 2175, 2, 15590, 140,
            wood_level8_proof()
        )
        .expect('construct wood level 8');
    increase_time(15590);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 8 done');
}
fn level9_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 9, 2420, 6050, 3025, 3630, 2, 25150, 203,
            wood_level9_proof()
        )
        .expect('construct wood level 9');
    increase_time(25150);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 9 done');
}
fn level10_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 10, 4040, 10105, 5050, 6060, 2, 40440, 280,
            wood_level10_proof()
        )
        .expect('construct wood level 10');
    increase_time(40440);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 10 done');
}
fn level11_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 11, 6750, 16870, 8435, 10125, 2, 64900, 392,
            wood_level11_proof()
        )
        .expect('construct wood level 11');
    increase_time(64900);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 11 done');
}
fn level12_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 12, 11270, 28175, 14090, 16905, 2, 17650, 525,
            wood_level12_proof()
        )
        .expect('construct wood level 12');
    increase_time(17650);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 12 done');
}
fn level13_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 13, 18820, 47055, 23525, 28230, 2, 80280, 693,
            wood_level13_proof()
        )
        .expect('construct wood level 13');
    increase_time(80280);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 13 done');
}
fn level14_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 14, 31430, 78580, 39290, 47150, 2, 7680, 889,
            wood_level14_proof()
        )
        .expect('construct wood level 14');
    increase_time(7680);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 14 done');
}
fn level15_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 15, 52490, 131230, 65615, 78740, 2, 81610, 1120,
            wood_level15_proof()
        )
        .expect('construct wood level 15');
    increase_time(81610);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 15 done');
}
fn level16_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 16, 87660, 219155, 109575, 131490, 3, 78930, 1400,
            wood_level16_proof()
        )
        .expect('construct wood level 16');
    increase_time(78930);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 16 done');
}
fn level17_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 17, 146395, 365985, 182995, 219590, 3, 57370, 1820,
            wood_level17_proof()
        )
        .expect('construct wood level 17');
    increase_time(57370);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 17 done');
}
fn level18_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 18, 244480, 611195, 305600, 366715, 3, 22880, 2240,
            wood_level18_proof()
        )
        .expect('construct wood level 18');
    increase_time(22880);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 18 done');
}
fn level19_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 19, 408280, 1020695, 510350, 612420, 3, 36800, 2800,
            wood_level19_proof()
        )
        .expect('construct wood level 19');
    increase_time(36800);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 19 done');
}
fn level20_wood(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 1, 20, 681825, 1704565, 852280, 1022740, 3, 76370, 3430,
            wood_level20_proof()
        )
        .expect('construct wood level 20');
    increase_time(76370);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('wood level 20 done');
}
fn level1_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 1, 80, 40, 80, 50, 2, 220, 7,
            brick_level1_proof()
        )
        .expect('construct brick level 1');
    increase_time(220);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 1 done');
}
fn level2_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 2, 135, 65, 135, 85, 1, 550, 13,
            brick_level2_proof()
        )
        .expect('construct brick level 2');
    increase_time(550);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 2 done');
}
fn level3_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 3, 225, 110, 225, 140, 1, 1080, 21,
            brick_level3_proof()
        )
        .expect('construct brick level 3');
    increase_time(1080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 3 done');
}
fn level4_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 4, 375, 185, 375, 235, 1, 1930, 31,
            brick_level4_proof()
        )
        .expect('construct brick level 4');
    increase_time(1930);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 4 done');
}
fn level5_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 5, 620, 310, 620, 390, 1, 3290, 46,
            brick_level5_proof()
        )
        .expect('construct brick level 5');
    increase_time(3290);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 5 done');
}
fn level6_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 6, 1040, 520, 1040, 650, 2, 5470, 70,
            brick_level6_proof()
        )
        .expect('construct brick level 6');
    increase_time(5470);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 6 done');
}
fn level7_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 7, 1735, 870, 1735, 1085, 2, 8950, 98,
            brick_level7_proof()
        )
        .expect('construct brick level 7');
    increase_time(8950);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 7 done');
}
fn level8_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 8, 2900, 1450, 2900, 1810, 2, 14520, 140,
            brick_level8_proof()
        )
        .expect('construct brick level 8');
    increase_time(14520);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 8 done');
}
fn level9_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 9, 4840, 2420, 4840, 3025, 2, 23430, 203,
            brick_level9_proof()
        )
        .expect('construct brick level 9');
    increase_time(23430);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 9 done');
}
fn level10_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 10, 8080, 4040, 8080, 5050, 2, 37690, 280,
            brick_level10_proof()
        )
        .expect('construct brick level 10');
    increase_time(37690);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 10 done');
}
fn level11_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 11, 13500, 6750, 13500, 8435, 2, 60510, 392,
            brick_level11_proof()
        )
        .expect('construct brick level 11');
    increase_time(60510);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 11 done');
}
fn level12_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 12, 22540, 11270, 22540, 14090, 2, 10610, 525,
            brick_level12_proof()
        )
        .expect('construct brick level 12');
    increase_time(10610);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 12 done');
}
fn level13_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 13, 37645, 18820, 37645, 23525, 2, 69020, 693,
            brick_level13_proof()
        )
        .expect('construct brick level 13');
    increase_time(69020);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 13 done');
}
fn level14_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 14, 62865, 31430, 62865, 39290, 2, 76070, 889,
            brick_level14_proof()
        )
        .expect('construct brick level 14');
    increase_time(76070);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 14 done');
}
fn level15_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 15, 104985, 52490, 104985, 65615, 2, 52790, 1120,
            brick_level15_proof()
        )
        .expect('construct brick level 15');
    increase_time(52790);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 15 done');
}
fn level16_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 16, 175320, 87660, 175320, 109575, 3, 32820, 1400,
            brick_level16_proof()
        )
        .expect('construct brick level 16');
    increase_time(32820);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 16 done');
}
fn level17_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 17, 292790, 146395, 292790, 182995, 3, 69990, 1820,
            brick_level17_proof()
        )
        .expect('construct brick level 17');
    increase_time(69990);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 17 done');
}
fn level18_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 18, 488955, 244480, 488955, 305600, 3, 77620, 2240,
            brick_level18_proof()
        )
        .expect('construct brick level 18');
    increase_time(77620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 18 done');
}
fn level19_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 19, 816555, 408280, 816555, 510350, 3, 20710, 2800,
            brick_level19_proof()
        )
        .expect('construct brick level 19');
    increase_time(20710);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 19 done');
}
fn level20_brick(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 2, 20, 1363650, 681825, 1363650, 852280, 3, 33340, 3430,
            brick_level20_proof()
        )
        .expect('construct brick level 20');
    increase_time(33340);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('brick level 20 done');
}
fn level1_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 1, 100, 80, 30, 60, 3, 450, 7,
            steel_level1_proof()
        )
        .expect('construct steel level 1');
    increase_time(450);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 1 done');
}
fn level2_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 2, 165, 135, 50, 100, 2, 920, 13,
            steel_level2_proof()
        )
        .expect('construct steel level 2');
    increase_time(920);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 2 done');
}
fn level3_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 3, 280, 225, 85, 165, 2, 1670, 21,
            steel_level3_proof()
        )
        .expect('construct steel level 3');
    increase_time(1670);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 3 done');
}
fn level4_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 4, 465, 375, 140, 280, 2, 2880, 31,
            steel_level4_proof()
        )
        .expect('construct steel level 4');
    increase_time(2880);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 4 done');
}
fn level5_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 5, 780, 620, 235, 465, 2, 4800, 46,
            steel_level5_proof()
        )
        .expect('construct steel level 5');
    increase_time(4800);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 5 done');
}
fn level6_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 6, 1300, 1040, 390, 780, 2, 7880, 70,
            steel_level6_proof()
        )
        .expect('construct steel level 6');
    increase_time(7880);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 6 done');
}
fn level7_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 7, 2170, 1735, 650, 1300, 2, 12810, 98,
            steel_level7_proof()
        )
        .expect('construct steel level 7');
    increase_time(12810);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 7 done');
}
fn level8_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 8, 3625, 2900, 1085, 2175, 2, 20690, 140,
            steel_level8_proof()
        )
        .expect('construct steel level 8');
    increase_time(20690);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 8 done');
}
fn level9_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 9, 6050, 4840, 1815, 3630, 2, 33310, 203,
            steel_level9_proof()
        )
        .expect('construct steel level 9');
    increase_time(33310);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 9 done');
}
fn level10_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 10, 10105, 8080, 3030, 6060, 2, 53500, 280,
            steel_level10_proof()
        )
        .expect('construct steel level 10');
    increase_time(53500);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 10 done');
}
fn level11_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 11, 16870, 13500, 5060, 10125, 3, 85800, 392,
            steel_level11_proof()
        )
        .expect('construct steel level 11');
    increase_time(85800);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 11 done');
}
fn level12_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 12, 28175, 22540, 8455, 16905, 3, 51070, 525,
            steel_level12_proof()
        )
        .expect('construct steel level 12');
    increase_time(51070);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 12 done');
}
fn level13_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 13, 47055, 37645, 14115, 28230, 3, 47360, 693,
            steel_level13_proof()
        )
        .expect('construct steel level 13');
    increase_time(47360);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 13 done');
}
fn level14_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 14, 78580, 62865, 23575, 47150, 3, 6850, 889,
            steel_level14_proof()
        )
        .expect('construct steel level 14');
    increase_time(6850);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 14 done');
}
fn level15_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 15, 131230, 104985, 39370, 78740, 3, 45720, 1120,
            steel_level15_proof()
        )
        .expect('construct steel level 15');
    increase_time(45720);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 15 done');
}
fn level16_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 16, 219155, 175320, 65745, 131490, 3, 38790, 1400,
            steel_level16_proof()
        )
        .expect('construct steel level 16');
    increase_time(38790);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 16 done');
}
fn level17_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 17, 365985, 292790, 109795, 219590, 3, 62260, 1820,
            steel_level17_proof()
        )
        .expect('construct steel level 17');
    increase_time(62260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 17 done');
}
fn level18_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 18, 611195, 488955, 183360, 366715, 3, 65260, 2240,
            steel_level18_proof()
        )
        .expect('construct steel level 18');
    increase_time(65260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 18 done');
}
fn level19_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 19, 1020695, 816555, 306210, 612420, 3, 70050, 2800,
            steel_level19_proof()
        )
        .expect('construct steel level 19');
    increase_time(70050);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 19 done');
}
fn level20_steel(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 3, 20, 1704565, 1363650, 511370, 1022740, 3, 43170, 3430,
            steel_level20_proof()
        )
        .expect('construct steel level 20');
    increase_time(43170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('steel level 20 done');
}
fn level1_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 1, 70, 90, 70, 20, 0, 150, 7,
            food_level1_proof()
        )
        .expect('construct food level 1');
    increase_time(150);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 1 done');
}
fn level2_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 2, 115, 150, 115, 35, 0, 440, 13,
            food_level2_proof()
        )
        .expect('construct food level 2');
    increase_time(440);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 2 done');
}
fn level3_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 3, 195, 250, 195, 55, 0, 900, 21,
            food_level3_proof()
        )
        .expect('construct food level 3');
    increase_time(900);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 3 done');
}
fn level4_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 4, 325, 420, 325, 95, 0, 1650, 31,
            food_level4_proof()
        )
        .expect('construct food level 4');
    increase_time(1650);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 4 done');
}
fn level5_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 5, 545, 700, 545, 155, 0, 2830, 46,
            food_level5_proof()
        )
        .expect('construct food level 5');
    increase_time(2830);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 5 done');
}
fn level6_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 6, 910, 1170, 910, 260, 1, 4730, 70,
            food_level6_proof()
        )
        .expect('construct food level 6');
    increase_time(4730);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 6 done');
}
fn level7_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 7, 1520, 1950, 1520, 435, 1, 7780, 98,
            food_level7_proof()
        )
        .expect('construct food level 7');
    increase_time(7780);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 7 done');
}
fn level8_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 8, 2535, 3260, 2535, 725, 1, 12640, 140,
            food_level8_proof()
        )
        .expect('construct food level 8');
    increase_time(12640);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 8 done');
}
fn level9_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 9, 4235, 5445, 4235, 1210, 1, 20430, 203,
            food_level9_proof()
        )
        .expect('construct food level 9');
    increase_time(20430);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 9 done');
}
fn level10_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 10, 7070, 9095, 7070, 2020, 1, 32880, 280,
            food_level10_proof()
        )
        .expect('construct food level 10');
    increase_time(32880);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 10 done');
}
fn level11_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 11, 11810, 15185, 11810, 3375, 1, 52810, 392,
            food_level11_proof()
        )
        .expect('construct food level 11');
    increase_time(52810);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 11 done');
}
fn level12_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 12, 19725, 25360, 19725, 5635, 1, 84700, 525,
            food_level12_proof()
        )
        .expect('construct food level 12');
    increase_time(84700);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 12 done');
}
fn level13_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 13, 32940, 42350, 32940, 9410, 1, 49310, 693,
            food_level13_proof()
        )
        .expect('construct food level 13');
    increase_time(49310);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 13 done');
}
fn level14_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 14, 55005, 70720, 55005, 15715, 1, 44540, 889,
            food_level14_proof()
        )
        .expect('construct food level 14');
    increase_time(44540);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 14 done');
}
fn level15_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 15, 91860, 118105, 91860, 26245, 1, 2350, 1120,
            food_level15_proof()
        )
        .expect('construct food level 15');
    increase_time(2350);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 15 done');
}
fn level16_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 16, 153405, 197240, 153405, 43830, 2, 38510, 1400,
            food_level16_proof()
        )
        .expect('construct food level 16');
    increase_time(38510);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 16 done');
}
fn level17_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 17, 256190, 329385, 256190, 73195, 2, 27260, 1820,
            food_level17_proof()
        )
        .expect('construct food level 17');
    increase_time(27260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 17 done');
}
fn level18_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 18, 427835, 550075, 427835, 122240, 2, 43810, 2240,
            food_level18_proof()
        )
        .expect('construct food level 18');
    increase_time(43810);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 18 done');
}
fn level19_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 19, 714485, 918625, 714485, 204140, 2, 35740, 2800,
            food_level19_proof()
        )
        .expect('construct food level 19');
    increase_time(35740);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 19 done');
}
fn level20_food(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 4, 20, 1193195, 1534105, 1193195, 340915, 2, 22830, 3430,
            food_level20_proof()
        )
        .expect('construct food level 20');
    increase_time(22830);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('food level 20 done');
}
fn level1_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 1, 70, 40, 60, 20, 2, 2500, 100,
            cityhall_level1_proof()
        )
        .expect('construct cityhall level 1');
    increase_time(2500);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 1 done');
}
fn level2_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 2, 90, 50, 75, 25, 1, 2620, 104,
            cityhall_level2_proof()
        )
        .expect('construct cityhall level 2');
    increase_time(2620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 2 done');
}
fn level3_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 3, 115, 65, 100, 35, 1, 3220, 108,
            cityhall_level3_proof()
        )
        .expect('construct cityhall level 3');
    increase_time(3220);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 3 done');
}
fn level4_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 4, 145, 85, 125, 40, 1, 3880, 112,
            cityhall_level4_proof()
        )
        .expect('construct cityhall level 4');
    increase_time(3880);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 4 done');
}
fn level5_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 5, 190, 105, 160, 55, 1, 4610, 116,
            cityhall_level5_proof()
        )
        .expect('construct cityhall level 5');
    increase_time(4610);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 5 done');
}
fn level6_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 6, 240, 135, 205, 70, 2, 5410, 120,
            cityhall_level6_proof()
        )
        .expect('construct cityhall level 6');
    increase_time(5410);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 6 done');
}
fn level7_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 7, 310, 175, 265, 90, 2, 6300, 125,
            cityhall_level7_proof()
        )
        .expect('construct cityhall level 7');
    increase_time(6300);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 7 done');
}
fn level8_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 8, 395, 225, 340, 115, 2, 7280, 129,
            cityhall_level8_proof()
        )
        .expect('construct cityhall level 8');
    increase_time(7280);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 8 done');
}
fn level9_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 9, 505, 290, 430, 145, 2, 8380, 134,
            cityhall_level9_proof()
        )
        .expect('construct cityhall level 9');
    increase_time(8380);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 9 done');
}
fn level10_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 10, 645, 370, 555, 185, 2, 9590, 139,
            cityhall_level10_proof()
        )
        .expect('construct cityhall level 10');
    increase_time(9590);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 10 done');
}
fn level11_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 11, 825, 470, 710, 235, 2, 10940, 144,
            cityhall_level11_proof()
        )
        .expect('construct cityhall level 11');
    increase_time(10940);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 11 done');
}
fn level12_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 12, 1060, 605, 905, 300, 2, 12440, 150,
            cityhall_level12_proof()
        )
        .expect('construct cityhall level 12');
    increase_time(12440);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 12 done');
}
fn level13_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 13, 1355, 775, 1160, 385, 2, 14120, 155,
            cityhall_level13_proof()
        )
        .expect('construct cityhall level 13');
    increase_time(14120);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 13 done');
}
fn level14_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 14, 1735, 990, 1485, 495, 2, 15980, 161,
            cityhall_level14_proof()
        )
        .expect('construct cityhall level 14');
    increase_time(15980);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 14 done');
}
fn level15_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 15, 2220, 1270, 1900, 635, 2, 18050, 167,
            cityhall_level15_proof()
        )
        .expect('construct cityhall level 15');
    increase_time(18050);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 15 done');
}
fn level16_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 16, 2840, 1625, 2435, 810, 3, 20370, 173,
            cityhall_level16_proof()
        )
        .expect('construct cityhall level 16');
    increase_time(20370);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 16 done');
}
fn level17_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 17, 3635, 2075, 3115, 1040, 3, 22950, 180,
            cityhall_level17_proof()
        )
        .expect('construct cityhall level 17');
    increase_time(22950);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 17 done');
}
fn level18_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 18, 4650, 2660, 3990, 1330, 3, 25830, 187,
            cityhall_level18_proof()
        )
        .expect('construct cityhall level 18');
    increase_time(25830);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 18 done');
}
fn level19_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 19, 5955, 3405, 5105, 1700, 3, 29040, 193,
            cityhall_level19_proof()
        )
        .expect('construct cityhall level 19');
    increase_time(29040);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 19 done');
}
fn level20_cityhall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 5, 20, 7620, 4355, 6535, 2180, 3, 32630, 201,
            cityhall_level20_proof()
        )
        .expect('construct cityhall level 20');
    increase_time(32630);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('cityhall level 20 done');
}
fn level1_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 1, 130, 160, 90, 40, 1, 2000, 1200,
            warehouse_level1_proof()
        )
        .expect('construct warehouse level 1');
    increase_time(2000);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 1 done');
}
fn level2_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 2, 165, 205, 115, 50, 1, 2620, 1700,
            warehouse_level2_proof()
        )
        .expect('construct warehouse level 2');
    increase_time(2620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 2 done');
}
fn level3_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 3, 215, 260, 145, 65, 1, 3340, 2300,
            warehouse_level3_proof()
        )
        .expect('construct warehouse level 3');
    increase_time(3340);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 3 done');
}
fn level4_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 4, 275, 335, 190, 85, 1, 4170, 3100,
            warehouse_level4_proof()
        )
        .expect('construct warehouse level 4');
    increase_time(4170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 4 done');
}
fn level5_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 5, 350, 430, 240, 105, 1, 5140, 4000,
            warehouse_level5_proof()
        )
        .expect('construct warehouse level 5');
    increase_time(5140);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 5 done');
}
fn level6_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 6, 445, 550, 310, 135, 1, 6260, 5000,
            warehouse_level6_proof()
        )
        .expect('construct warehouse level 6');
    increase_time(6260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 6 done');
}
fn level7_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 7, 570, 705, 395, 175, 1, 7570, 6300,
            warehouse_level7_proof()
        )
        .expect('construct warehouse level 7');
    increase_time(7570);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 7 done');
}
fn level8_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 8, 730, 900, 505, 225, 1, 9080, 7800,
            warehouse_level8_proof()
        )
        .expect('construct warehouse level 8');
    increase_time(9080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 8 done');
}
fn level9_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 9, 935, 1155, 650, 290, 1, 10830, 9600,
            warehouse_level9_proof()
        )
        .expect('construct warehouse level 9');
    increase_time(10830);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 9 done');
}
fn level10_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 10, 1200, 1475, 830, 370, 1, 12860, 11800,
            warehouse_level10_proof()
        )
        .expect('construct warehouse level 10');
    increase_time(12860);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 10 done');
}
fn level11_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 11, 1535, 1890, 1065, 470, 2, 15220, 14400,
            warehouse_level11_proof()
        )
        .expect('construct warehouse level 11');
    increase_time(15220);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 11 done');
}
fn level12_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 12, 1965, 2420, 1360, 605, 2, 17950, 17600,
            warehouse_level12_proof()
        )
        .expect('construct warehouse level 12');
    increase_time(17950);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 12 done');
}
fn level13_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 13, 2515, 3095, 1740, 775, 2, 21130, 21400,
            warehouse_level13_proof()
        )
        .expect('construct warehouse level 13');
    increase_time(21130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 13 done');
}
fn level14_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 14, 3220, 3960, 2230, 990, 2, 24810, 25900,
            warehouse_level14_proof()
        )
        .expect('construct warehouse level 14');
    increase_time(24810);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 14 done');
}
fn level15_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 15, 4120, 5070, 2850, 1270, 2, 29080, 31300,
            warehouse_level15_proof()
        )
        .expect('construct warehouse level 15');
    increase_time(29080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 15 done');
}
fn level16_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 16, 5275, 6490, 3650, 1625, 2, 34030, 37900,
            warehouse_level16_proof()
        )
        .expect('construct warehouse level 16');
    increase_time(34030);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 16 done');
}
fn level17_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 17, 6750, 8310, 4675, 2075, 2, 39770, 45700,
            warehouse_level17_proof()
        )
        .expect('construct warehouse level 17');
    increase_time(39770);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 17 done');
}
fn level18_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 18, 8640, 10635, 5980, 2660, 2, 46440, 55100,
            warehouse_level18_proof()
        )
        .expect('construct warehouse level 18');
    increase_time(46440);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 18 done');
}
fn level19_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 19, 11060, 13610, 7655, 3405, 2, 54170, 66400,
            warehouse_level19_proof()
        )
        .expect('construct warehouse level 19');
    increase_time(54170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 19 done');
}
fn level20_warehouse(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 6, 20, 14155, 17420, 9800, 4355, 2, 63130, 80000,
            warehouse_level20_proof()
        )
        .expect('construct warehouse level 20');
    increase_time(63130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('warehouse level 20 done');
}
fn level1_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 1, 80, 100, 70, 20, 1, 1600, 1200,
            barn_level1_proof()
        )
        .expect('construct barn level 1');
    increase_time(1600);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 1 done');
}
fn level2_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 2, 100, 130, 90, 25, 1, 2160, 1700,
            barn_level2_proof()
        )
        .expect('construct barn level 2');
    increase_time(2160);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 2 done');
}
fn level3_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 3, 130, 165, 115, 35, 1, 2800, 2300,
            barn_level3_proof()
        )
        .expect('construct barn level 3');
    increase_time(2800);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 3 done');
}
fn level4_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 4, 170, 210, 145, 40, 1, 3550, 3100,
            barn_level4_proof()
        )
        .expect('construct barn level 4');
    increase_time(3550);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 4 done');
}
fn level5_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 5, 215, 270, 190, 55, 1, 4420, 4000,
            barn_level5_proof()
        )
        .expect('construct barn level 5');
    increase_time(4420);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 5 done');
}
fn level6_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 6, 275, 345, 240, 70, 1, 5420, 5000,
            barn_level6_proof()
        )
        .expect('construct barn level 6');
    increase_time(5420);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 6 done');
}
fn level7_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 7, 350, 440, 310, 90, 1, 6590, 6300,
            barn_level7_proof()
        )
        .expect('construct barn level 7');
    increase_time(6590);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 7 done');
}
fn level8_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 8, 450, 565, 395, 115, 1, 7950, 7800,
            barn_level8_proof()
        )
        .expect('construct barn level 8');
    increase_time(7950);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 8 done');
}
fn level9_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 9, 575, 720, 505, 145, 1, 9520, 9600,
            barn_level9_proof()
        )
        .expect('construct barn level 9');
    increase_time(9520);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 9 done');
}
fn level10_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 10, 740, 920, 645, 185, 1, 11340, 11800,
            barn_level10_proof()
        )
        .expect('construct barn level 10');
    increase_time(11340);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 10 done');
}
fn level11_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 11, 945, 1180, 825, 235, 2, 13450, 14400,
            barn_level11_proof()
        )
        .expect('construct barn level 11');
    increase_time(13450);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 11 done');
}
fn level12_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 12, 1210, 1510, 1060, 300, 2, 15910, 17600,
            barn_level12_proof()
        )
        .expect('construct barn level 12');
    increase_time(15910);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 12 done');
}
fn level13_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 13, 1545, 1935, 1355, 385, 2, 18750, 21400,
            barn_level13_proof()
        )
        .expect('construct barn level 13');
    increase_time(18750);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 13 done');
}
fn level14_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 14, 1980, 2475, 1735, 495, 2, 22050, 25900,
            barn_level14_proof()
        )
        .expect('construct barn level 14');
    increase_time(22050);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 14 done');
}
fn level15_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 15, 2535, 3170, 2220, 635, 2, 25880, 31300,
            barn_level15_proof()
        )
        .expect('construct barn level 15');
    increase_time(25880);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 15 done');
}
fn level16_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 16, 3245, 4055, 2840, 810, 2, 30320, 37900,
            barn_level16_proof()
        )
        .expect('construct barn level 16');
    increase_time(30320);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 16 done');
}
fn level17_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 17, 4155, 5190, 3635, 1040, 2, 35470, 45700,
            barn_level17_proof()
        )
        .expect('construct barn level 17');
    increase_time(35470);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 17 done');
}
fn level18_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 18, 5315, 6645, 4650, 1330, 2, 41450, 55100,
            barn_level18_proof()
        )
        .expect('construct barn level 18');
    increase_time(41450);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 18 done');
}
fn level19_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 19, 6805, 8505, 5955, 1700, 2, 48380, 66400,
            barn_level19_proof()
        )
        .expect('construct barn level 19');
    increase_time(48380);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 19 done');
}
fn level20_barn(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 7, 20, 8710, 10890, 7620, 2180, 2, 56420, 80000,
            barn_level20_proof()
        )
        .expect('construct barn level 20');
    increase_time(56420);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barn level 20 done');
}
fn level1_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 1, 210, 140, 260, 120, 4, 2000, 100,
            barrack_level1_proof()
        )
        .expect('construct barrack level 1');
    increase_time(2000);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 1 done');
}
fn level2_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 2, 270, 180, 335, 155, 2, 2620, 90,
            barrack_level2_proof()
        )
        .expect('construct barrack level 2');
    increase_time(2620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 2 done');
}
fn level3_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 3, 345, 230, 425, 195, 2, 3340, 83,
            barrack_level3_proof()
        )
        .expect('construct barrack level 3');
    increase_time(3340);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 3 done');
}
fn level4_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 4, 440, 295, 545, 250, 2, 4170, 71,
            barrack_level4_proof()
        )
        .expect('construct barrack level 4');
    increase_time(4170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 4 done');
}
fn level5_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 5, 565, 375, 700, 320, 2, 5140, 66,
            barrack_level5_proof()
        )
        .expect('construct barrack level 5');
    increase_time(5140);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 5 done');
}
fn level6_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 6, 720, 480, 895, 410, 3, 6260, 58,
            barrack_level6_proof()
        )
        .expect('construct barrack level 6');
    increase_time(6260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 6 done');
}
fn level7_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 7, 925, 615, 1145, 530, 3, 7570, 52,
            barrack_level7_proof()
        )
        .expect('construct barrack level 7');
    increase_time(7570);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 7 done');
}
fn level8_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 8, 1180, 790, 1465, 675, 3, 9080, 47,
            barrack_level8_proof()
        )
        .expect('construct barrack level 8');
    increase_time(9080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 8 done');
}
fn level9_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 9, 1515, 1010, 1875, 865, 3, 10830, 43,
            barrack_level9_proof()
        )
        .expect('construct barrack level 9');
    increase_time(10830);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 9 done');
}
fn level10_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 10, 1935, 1290, 2400, 1105, 3, 12860, 38,
            barrack_level10_proof()
        )
        .expect('construct barrack level 10');
    increase_time(12860);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 10 done');
}
fn level11_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 11, 2480, 1655, 3070, 1415, 3, 15220, 34,
            barrack_level11_proof()
        )
        .expect('construct barrack level 11');
    increase_time(15220);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 11 done');
}
fn level12_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 12, 3175, 2115, 3930, 1815, 3, 17950, 31,
            barrack_level12_proof()
        )
        .expect('construct barrack level 12');
    increase_time(17950);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 12 done');
}
fn level13_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 13, 4060, 2710, 5030, 2320, 3, 21130, 28,
            barrack_level13_proof()
        )
        .expect('construct barrack level 13');
    increase_time(21130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 13 done');
}
fn level14_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 14, 5200, 3465, 6435, 2970, 3, 24810, 25,
            barrack_level14_proof()
        )
        .expect('construct barrack level 14');
    increase_time(24810);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 14 done');
}
fn level15_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 15, 6655, 4435, 8240, 3805, 3, 29080, 22,
            barrack_level15_proof()
        )
        .expect('construct barrack level 15');
    increase_time(29080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 15 done');
}
fn level16_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 16, 8520, 5680, 10545, 4870, 4, 34030, 20,
            barrack_level16_proof()
        )
        .expect('construct barrack level 16');
    increase_time(34030);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 16 done');
}
fn level17_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 17, 10905, 7270, 13500, 6230, 4, 39770, 18,
            barrack_level17_proof()
        )
        .expect('construct barrack level 17');
    increase_time(39770);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 17 done');
}
fn level18_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 18, 13955, 9305, 17280, 7975, 4, 46440, 16,
            barrack_level18_proof()
        )
        .expect('construct barrack level 18');
    increase_time(46440);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 18 done');
}
fn level19_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 19, 17865, 11910, 22120, 10210, 4, 54170, 14,
            barrack_level19_proof()
        )
        .expect('construct barrack level 19');
    increase_time(54170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 19 done');
}
fn level20_barrack(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 8, 20, 22865, 15245, 28310, 13065, 4, 63130, 13,
            barrack_level20_proof()
        )
        .expect('construct barrack level 20');
    increase_time(63130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('barrack level 20 done');
}
fn level1_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 1, 260, 140, 220, 100, 5, 2200, 100,
            stable_level1_proof()
        )
        .expect('construct stable level 1');
    increase_time(2200);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 1 done');
}
fn level2_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 2, 335, 180, 280, 130, 3, 2850, 90,
            stable_level2_proof()
        )
        .expect('construct stable level 2');
    increase_time(2850);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 2 done');
}
fn level3_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 3, 425, 230, 360, 165, 3, 3610, 83,
            stable_level3_proof()
        )
        .expect('construct stable level 3');
    increase_time(3610);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 3 done');
}
fn level4_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 4, 545, 295, 460, 210, 3, 4490, 71,
            stable_level4_proof()
        )
        .expect('construct stable level 4');
    increase_time(4490);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 4 done');
}
fn level5_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 5, 700, 375, 590, 270, 3, 5500, 66,
            stable_level5_proof()
        )
        .expect('construct stable level 5');
    increase_time(5500);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 5 done');
}
fn level6_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 6, 895, 480, 755, 345, 3, 6680, 58,
            stable_level6_proof()
        )
        .expect('construct stable level 6');
    increase_time(6680);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 6 done');
}
fn level7_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 7, 1145, 615, 970, 440, 3, 8050, 52,
            stable_level7_proof()
        )
        .expect('construct stable level 7');
    increase_time(8050);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 7 done');
}
fn level8_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 8, 1465, 790, 1240, 565, 3, 9640, 47,
            stable_level8_proof()
        )
        .expect('construct stable level 8');
    increase_time(9640);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 8 done');
}
fn level9_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 9, 1875, 1010, 1585, 720, 3, 11480, 43,
            stable_level9_proof()
        )
        .expect('construct stable level 9');
    increase_time(11480);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 9 done');
}
fn level10_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 10, 2400, 1290, 2030, 920, 3, 13620, 38,
            stable_level10_proof()
        )
        .expect('construct stable level 10');
    increase_time(13620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 10 done');
}
fn level11_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 11, 3070, 1655, 2595, 1180, 4, 16100, 34,
            stable_level11_proof()
        )
        .expect('construct stable level 11');
    increase_time(16100);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 11 done');
}
fn level12_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 12, 3930, 2115, 3325, 1510, 4, 18980, 31,
            stable_level12_proof()
        )
        .expect('construct stable level 12');
    increase_time(18980);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 12 done');
}
fn level13_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 13, 5030, 2710, 4255, 1935, 4, 22310, 28,
            stable_level13_proof()
        )
        .expect('construct stable level 13');
    increase_time(22310);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 13 done');
}
fn level14_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 14, 6435, 3465, 5445, 2475, 4, 26180, 25,
            stable_level14_proof()
        )
        .expect('construct stable level 14');
    increase_time(26180);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 14 done');
}
fn level15_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 15, 8240, 4435, 6970, 3170, 4, 30670, 22,
            stable_level15_proof()
        )
        .expect('construct stable level 15');
    increase_time(30670);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 15 done');
}
fn level16_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 16, 10545, 5680, 8925, 4055, 4, 35880, 20,
            stable_level16_proof()
        )
        .expect('construct stable level 16');
    increase_time(35880);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 16 done');
}
fn level17_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 17, 13500, 7270, 11425, 5190, 4, 41920, 18,
            stable_level17_proof()
        )
        .expect('construct stable level 17');
    increase_time(41920);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 17 done');
}
fn level18_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 18, 17280, 9305, 14620, 6645, 4, 48930, 16,
            stable_level18_proof()
        )
        .expect('construct stable level 18');
    increase_time(48930);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 18 done');
}
fn level19_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 19, 22120, 11910, 18715, 8505, 4, 57060, 14,
            stable_level19_proof()
        )
        .expect('construct stable level 19');
    increase_time(57060);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 19 done');
}
fn level20_stable(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 9, 20, 28310, 15245, 23955, 10890, 4, 66490, 13,
            stable_level20_proof()
        )
        .expect('construct stable level 20');
    increase_time(66490);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('stable level 20 done');
}
fn level1_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 1, 220, 160, 90, 40, 4, 2000, 0,
            college_level1_proof()
        )
        .expect('construct college level 1');
    increase_time(2000);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 1 done');
}
fn level2_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 2, 280, 205, 115, 50, 2, 2620, 0,
            college_level2_proof()
        )
        .expect('construct college level 2');
    increase_time(2620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 2 done');
}
fn level3_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 3, 360, 260, 145, 65, 2, 3340, 0,
            college_level3_proof()
        )
        .expect('construct college level 3');
    increase_time(3340);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 3 done');
}
fn level4_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 4, 460, 335, 190, 85, 2, 4170, 0,
            college_level4_proof()
        )
        .expect('construct college level 4');
    increase_time(4170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 4 done');
}
fn level5_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 5, 590, 430, 240, 105, 2, 5140, 0,
            college_level5_proof()
        )
        .expect('construct college level 5');
    increase_time(5140);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 5 done');
}
fn level6_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 6, 755, 550, 310, 135, 3, 6260, 0,
            college_level6_proof()
        )
        .expect('construct college level 6');
    increase_time(6260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 6 done');
}
fn level7_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 7, 970, 705, 395, 175, 3, 7570, 0,
            college_level7_proof()
        )
        .expect('construct college level 7');
    increase_time(7570);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 7 done');
}
fn level8_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 8, 1240, 900, 505, 225, 3, 9080, 0,
            college_level8_proof()
        )
        .expect('construct college level 8');
    increase_time(9080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 8 done');
}
fn level9_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 9, 1585, 1155, 650, 290, 3, 10830, 0,
            college_level9_proof()
        )
        .expect('construct college level 9');
    increase_time(10830);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 9 done');
}
fn level10_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 10, 2030, 1475, 830, 370, 3, 12860, 0,
            college_level10_proof()
        )
        .expect('construct college level 10');
    increase_time(12860);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 10 done');
}
fn level11_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 11, 2595, 1890, 1065, 470, 3, 15220, 0,
            college_level11_proof()
        )
        .expect('construct college level 11');
    increase_time(15220);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 11 done');
}
fn level12_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 12, 3325, 2420, 1360, 605, 3, 17950, 0,
            college_level12_proof()
        )
        .expect('construct college level 12');
    increase_time(17950);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 12 done');
}
fn level13_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 13, 4255, 3095, 1740, 775, 3, 21130, 0,
            college_level13_proof()
        )
        .expect('construct college level 13');
    increase_time(21130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 13 done');
}
fn level14_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 14, 5445, 3960, 2230, 990, 3, 24810, 0,
            college_level14_proof()
        )
        .expect('construct college level 14');
    increase_time(24810);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 14 done');
}
fn level15_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 15, 6970, 5070, 2850, 1270, 3, 29080, 0,
            college_level15_proof()
        )
        .expect('construct college level 15');
    increase_time(29080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 15 done');
}
fn level16_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 16, 8925, 6490, 3650, 1625, 4, 34030, 0,
            college_level16_proof()
        )
        .expect('construct college level 16');
    increase_time(34030);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 16 done');
}
fn level17_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 17, 11425, 8310, 4675, 2075, 4, 39770, 0,
            college_level17_proof()
        )
        .expect('construct college level 17');
    increase_time(39770);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 17 done');
}
fn level18_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 18, 14620, 10635, 5980, 2660, 4, 46440, 0,
            college_level18_proof()
        )
        .expect('construct college level 18');
    increase_time(46440);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 18 done');
}
fn level19_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 19, 18715, 13610, 7655, 3405, 4, 54170, 0,
            college_level19_proof()
        )
        .expect('construct college level 19');
    increase_time(54170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 19 done');
}
fn level20_college(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 10, 20, 23955, 17420, 9800, 4355, 4, 63130, 0,
            college_level20_proof()
        )
        .expect('construct college level 20');
    increase_time(63130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('college level 20 done');
}
fn level1_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 1, 180, 130, 150, 80, 3, 2000, 0,
            embassy_level1_proof()
        )
        .expect('construct embassy level 1');
    increase_time(2000);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 1 done');
}
fn level2_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 2, 230, 165, 190, 100, 2, 2620, 0,
            embassy_level2_proof()
        )
        .expect('construct embassy level 2');
    increase_time(2620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 2 done');
}
fn level3_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 3, 295, 215, 245, 130, 2, 3340, 9,
            embassy_level3_proof()
        )
        .expect('construct embassy level 3');
    increase_time(3340);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 3 done');
}
fn level4_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 4, 375, 275, 315, 170, 2, 4170, 12,
            embassy_level4_proof()
        )
        .expect('construct embassy level 4');
    increase_time(4170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 4 done');
}
fn level5_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 5, 485, 350, 405, 215, 2, 5140, 15,
            embassy_level5_proof()
        )
        .expect('construct embassy level 5');
    increase_time(5140);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 5 done');
}
fn level6_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 6, 620, 445, 515, 275, 2, 6260, 18,
            embassy_level6_proof()
        )
        .expect('construct embassy level 6');
    increase_time(6260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 6 done');
}
fn level7_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 7, 790, 570, 660, 350, 2, 7570, 21,
            embassy_level7_proof()
        )
        .expect('construct embassy level 7');
    increase_time(7570);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 7 done');
}
fn level8_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 8, 1015, 730, 845, 450, 2, 9080, 24,
            embassy_level8_proof()
        )
        .expect('construct embassy level 8');
    increase_time(9080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 8 done');
}
fn level9_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 9, 1295, 935, 1080, 575, 2, 10830, 27,
            embassy_level9_proof()
        )
        .expect('construct embassy level 9');
    increase_time(10830);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 9 done');
}
fn level10_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 10, 1660, 1200, 1385, 740, 2, 12860, 30,
            embassy_level10_proof()
        )
        .expect('construct embassy level 10');
    increase_time(12860);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 10 done');
}
fn level11_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 11, 2125, 1535, 1770, 945, 3, 15220, 33,
            embassy_level11_proof()
        )
        .expect('construct embassy level 11');
    increase_time(15220);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 11 done');
}
fn level12_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 12, 2720, 1965, 2265, 1210, 3, 17950, 36,
            embassy_level12_proof()
        )
        .expect('construct embassy level 12');
    increase_time(17950);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 12 done');
}
fn level13_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 13, 3480, 2515, 2900, 1545, 3, 21130, 39,
            embassy_level13_proof()
        )
        .expect('construct embassy level 13');
    increase_time(21130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 13 done');
}
fn level14_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 14, 4455, 3220, 3715, 1980, 3, 24810, 42,
            embassy_level14_proof()
        )
        .expect('construct embassy level 14');
    increase_time(24810);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 14 done');
}
fn level15_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 15, 5705, 4120, 4755, 2535, 3, 29080, 45,
            embassy_level15_proof()
        )
        .expect('construct embassy level 15');
    increase_time(29080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 15 done');
}
fn level16_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 16, 7300, 5275, 6085, 3245, 3, 34030, 48,
            embassy_level16_proof()
        )
        .expect('construct embassy level 16');
    increase_time(34030);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 16 done');
}
fn level17_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 17, 9345, 6750, 7790, 4155, 3, 39770, 51,
            embassy_level17_proof()
        )
        .expect('construct embassy level 17');
    increase_time(39770);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 17 done');
}
fn level18_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 18, 11965, 8640, 9970, 5315, 3, 46440, 54,
            embassy_level18_proof()
        )
        .expect('construct embassy level 18');
    increase_time(46440);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 18 done');
}
fn level19_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 19, 15315, 11060, 12760, 6805, 3, 54170, 57,
            embassy_level19_proof()
        )
        .expect('construct embassy level 19');
    increase_time(54170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 19 done');
}
fn level20_embassy(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 11, 20, 19600, 14155, 16335, 8710, 3, 63130, 60,
            embassy_level20_proof()
        )
        .expect('construct embassy level 20');
    increase_time(63130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('embassy level 20 done');
}
fn level1_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 1, 110, 160, 70, 60, 0, 2000, 8002,
            city_wall_level1_proof()
        )
        .expect('construct city_wall level 1');
    increase_time(2000);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 1 done');
}
fn level2_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 2, 140, 205, 90, 75, 0, 2620, 16005,
            city_wall_level2_proof()
        )
        .expect('construct city_wall level 2');
    increase_time(2620);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 2 done');
}
fn level3_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 3, 180, 260, 115, 100, 0, 3340, 24007,
            city_wall_level3_proof()
        )
        .expect('construct city_wall level 3');
    increase_time(3340);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 3 done');
}
fn level4_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 4, 230, 335, 145, 125, 0, 4170, 32010,
            city_wall_level4_proof()
        )
        .expect('construct city_wall level 4');
    increase_time(4170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 4 done');
}
fn level5_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 5, 295, 430, 190, 160, 0, 5140, 40013,
            city_wall_level5_proof()
        )
        .expect('construct city_wall level 5');
    increase_time(5140);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 5 done');
}
fn level6_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 6, 380, 550, 240, 205, 1, 6260, 48016,
            city_wall_level6_proof()
        )
        .expect('construct city_wall level 6');
    increase_time(6260);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 6 done');
}
fn level7_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 7, 485, 705, 310, 265, 1, 7570, 56018,
            city_wall_level7_proof()
        )
        .expect('construct city_wall level 7');
    increase_time(7570);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 7 done');
}
fn level8_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 8, 620, 900, 395, 340, 1, 9080, 64021,
            city_wall_level8_proof()
        )
        .expect('construct city_wall level 8');
    increase_time(9080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 8 done');
}
fn level9_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 9, 795, 1155, 505, 430, 1, 10830, 72024,
            city_wall_level9_proof()
        )
        .expect('construct city_wall level 9');
    increase_time(10830);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 9 done');
}
fn level10_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 10, 1015, 1475, 645, 555, 1, 12860, 80028,
            city_wall_level10_proof()
        )
        .expect('construct city_wall level 10');
    increase_time(12860);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 10 done');
}
fn level11_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 11, 1300, 1890, 825, 710, 1, 15220, 88031,
            city_wall_level11_proof()
        )
        .expect('construct city_wall level 11');
    increase_time(15220);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 11 done');
}
fn level12_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 12, 1660, 2420, 1060, 905, 1, 17950, 96034,
            city_wall_level12_proof()
        )
        .expect('construct city_wall level 12');
    increase_time(17950);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 12 done');
}
fn level13_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 13, 2130, 3095, 1355, 1160, 1, 21130, 104037,
            city_wall_level13_proof()
        )
        .expect('construct city_wall level 13');
    increase_time(21130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 13 done');
}
fn level14_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 14, 2725, 3960, 1735, 1485, 1, 24810, 112041,
            city_wall_level14_proof()
        )
        .expect('construct city_wall level 14');
    increase_time(24810);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 14 done');
}
fn level15_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 15, 3485, 5070, 2220, 1900, 1, 29080, 120044,
            city_wall_level15_proof()
        )
        .expect('construct city_wall level 15');
    increase_time(29080);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 15 done');
}
fn level16_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 16, 4460, 6490, 2840, 2435, 2, 34030, 128048,
            city_wall_level16_proof()
        )
        .expect('construct city_wall level 16');
    increase_time(34030);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 16 done');
}
fn level17_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 17, 5710, 8310, 3635, 3115, 2, 39770, 136052,
            city_wall_level17_proof()
        )
        .expect('construct city_wall level 17');
    increase_time(39770);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 17 done');
}
fn level18_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 18, 7310, 10635, 4650, 3990, 2, 46440, 144056,
            city_wall_level18_proof()
        )
        .expect('construct city_wall level 18');
    increase_time(46440);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 18 done');
}
fn level19_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 19, 9360, 13610, 5955, 5105, 2, 54170, 152059,
            city_wall_level19_proof()
        )
        .expect('construct city_wall level 19');
    increase_time(54170);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 19 done');
}
fn level20_city_wall(context: TestContext, position: u64, player: ContractAddress){
    set_caller_address(player);
    context
        .kingdom_lord_test
        .start_upgrade_test(
            position, 12, 20, 11980, 17420, 7620, 6535, 2, 63130, 160063,
            city_wall_level20_proof()
        )
        .expect('construct city_wall level 20');
    increase_time(63130);
    let res = context.kingdom_lord_test.finish_upgrade_test();
    res.expect('city_wall level 20 done');
}