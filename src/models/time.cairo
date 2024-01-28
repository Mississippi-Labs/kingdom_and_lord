use core::starknet::info::get_block_number;
fn get_current_time() -> u64{
    get_block_number()
}