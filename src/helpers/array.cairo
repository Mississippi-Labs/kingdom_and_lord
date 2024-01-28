use core::serde::Serde;
use super::super::models::building::{Minable};
use super::super::models::growth::{Growth, GrowthRate};
use super::super::models::level::{Level};
use super::super::models::resource::Resource;

impl MinableArrayImpl<T, R, +Minable<T, Resource<R>>, +Drop<R>> of Minable<Array<T>, Resource<R>> {
    fn get_minable(
        self: @Array<T>, last_time: u64, current_time: u64
    ) -> Resource<R> {
        let mut amount: Resource<R> = 0_u64.into();
        let mut index = self.len() - 1;
        loop {
            amount += self.at(index).get_minable(last_time, current_time);
            if index == 0 {
                break;
            }
            index -= 1
        };
        amount
    }
    fn mine(self: @Array<T>, last_time: u64, current_time: u64) -> Resource<R> {
        let mut amount: Resource<R> = 0_u64.into();
        let mut index = self.len() - 1;
        loop {
            amount += self.at(index).mine(last_time, current_time);
            if index == 0 {
                break;
            }
            index -= 1
        };
        amount
    }
}

impl GrowthArrayImpl<T, R, +Growth<T, R>, +Drop<T>, +Drop<R>> of Growth<Array<T>, R> {
    fn get_growth_rate(self: @Array<T>) -> GrowthRate<R> {
        let mut amount: GrowthRate<R> = 0_u64.into();
        let mut index = self.len() - 1;
        loop {
            amount += self.at(index).get_growth_rate();
            if index == 0 {
                break;
            }
            index -= 1
        };
        amount
    }
}

// impl GetLevelArrayImpl<T, +GetLevel<T, Level>> of GetLevel<Array<T>, Array<Level>> {
//     fn get_level(self: @Array<T>) -> Array<Level> {
//         let mut res = array![];
//         let mut index = self.len() - 1;
//         loop {
//             res.append(self.at(index).get_level());
//             if index == 0 {
//                 break;
//             }
//             index -= 1
//         };
//         res
//     }
// }
