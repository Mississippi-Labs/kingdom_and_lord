use kingdom_lord::models::level::{LevelTrait, Level, LevelUpTrait};
use starknet::{ContractAddress, get_block_timestamp, get_block_number, get_tx_info};
#[derive(Model, Copy, Drop, Serde)]
struct City {
    #[key]
    player: ContractAddress,
    x: u64,
    y: u64,
}


#[derive(Model, Copy, Drop, Serde)]
struct CityLocation {
    #[key]
    x: u64,
    #[key]
    y: u64,
    player: ContractAddress,
}

#[derive(Model, Copy, Drop, Serde)]
struct CityConfirm {
    #[key]
    player: ContractAddress,
    block: u64
}

fn get_position(block_number: u64) -> (u64, u64){
    let target_block_hash = starknet::syscalls::get_block_hash_syscall(block_number + 1).expect('get_block_hash_syscall failed');
    let target_block_u: u256 = target_block_hash.into();
    // 2**126 = 340282366920938463463374607431768211456
    let pre = target_block_u / 340282366920938463463374607431768211456;
    let suf = target_block_u % 340282366920938463463374607431768211456;
    let x: u64 = (pre % 99 + 1).try_into().expect('mod of 99');
    let y: u64 = (suf % 99 + 1).try_into().expect('mod of 99');
    (x, y)
}

fn get_position_temp(block_number: u64)  -> (u64, u64){
    let tx_hash: u256 = get_tx_info().unbox().transaction_hash.into();
    let timestamp: u256  = get_block_timestamp().try_into().expect('work');
    let n = tx_hash + timestamp;
    // 2**126 = 340282366920938463463374607431768211456
    let pre = n / 340282366920938463463374607431768211456;
    let suf = n % 340282366920938463463374607431768211456;
    let x: u64 = (pre % 99 + 1).try_into().expect('mod of 99');
    let y: u64 = (suf % 99 + 1).try_into().expect('mod of 99');
    (x, y)
}

#[starknet::component]
mod globe_component {
    use starknet::{get_caller_address, ContractAddress};
    use dojo::world::{
        IWorldProvider, IWorldProviderDispatcher, IWorldDispatcher, IWorldDispatcherTrait
    };
    use super::{CityConfirm, CityLocation, City, get_position_temp};
    use kingdom_lord::models::time::get_current_time;
    use kingdom_lord::interface::Error;

    #[storage]
    struct Storage {}

    #[generate_trait]
    impl GlobeInternalImpl<
        TContractState, +HasComponent<TContractState>, +IWorldProvider<TContractState>
    > of GlobeInternalTrait<TContractState> {

        fn get_city_location(self: @ComponentState<TContractState>, player: ContractAddress) -> (u64, u64){
            let world = self.get_contract().world();
            let city = get!(world, (player), City);
            (city.x, city.y)
        }

        fn create_city_confirm(
            self: @ComponentState<TContractState>
        ) -> Result<CityConfirm, Error> {
            let player = get_caller_address();
            let world = self.get_contract().world();

            let confirm = get!(world, (player), CityConfirm);
            if confirm.block == 0 {
                let time = get_current_time();
                let confirm = CityConfirm { player, block: time };
                set!(world, (confirm));
                return Result::Ok(confirm);
            } else {
                return Result::Err(Error::CityConfirmAlreadyExist);
            }
        }

        fn create_city_reveal(self: @ComponentState<TContractState>) -> Result<(), Error>{
            let player = get_caller_address();
            let world = self.get_contract().world();

            let confirm = get!(world, (player), CityConfirm);
            let current_time = get_current_time();
            if confirm.block == 0  || current_time - confirm.block  == 0{
                return Result::Err(Error::CityConfirmNotStarted);
            }
            let city = get!(world, (player), City);
            if city.x != 0 || city.y != 0 {
                return Result::Err(Error::CityAlreadyCreated);
            }

            let (x, y)  = get_position_temp(confirm.block);

            let city_location = get!(world, (x, y), CityLocation);
            if !city_location.player.is_zero(){
                return Result::Err(Error::CityPositionAlreadyTaken);
            }
            let city = City { player, x, y };
            let city_location = CityLocation { x, y, player };
            set!(world, (city_location));
            set!(world, (city));
            Result::Ok(())
        }
    }
}
