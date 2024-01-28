use core::fmt::{Debug, Formatter, Error};
use starknet::ContractAddress;
impl FmtContractAddr of Debug<ContractAddress>{
     fn fmt(self: @ContractAddress, ref f: Formatter) -> Result<(), Error>{
        let felt: felt252 = self.clone().into();
        write!(f, "ContractAddress({:})", felt);
        Result::Ok(())
     }
}
