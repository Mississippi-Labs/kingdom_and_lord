use super::resource::{Wood, Brick, Steel, Food};
use core::traits::{Add, Into};

trait Growth<T, R> {
    fn get_growth_rate(self: @T) -> GrowthRate<R>;
}

#[derive(Copy, Drop, Serde, PartialEq, Debug)]
struct GrowthRate<T> {
    amount: u64
}

impl LevelInto<T> of Into<u64, GrowthRate<T>> {
    fn into(self: u64) -> GrowthRate<T> {
        GrowthRate { amount: self }
    }
}

impl GrowthRateIntou64<T> of Into<GrowthRate<T>, u64> {
    fn into(self: GrowthRate<T>) -> u64 {
        self.amount
    }
}

impl GrowthRateAdd<T> of Add<GrowthRate<T>> {
    fn add(lhs: GrowthRate<T>, rhs: GrowthRate<T>) -> GrowthRate<T> {
        GrowthRate { amount: lhs.amount + rhs.amount }
    }
}

impl GrowthRateAddEq<T> of AddEq<GrowthRate<T>> {
    fn add_eq(ref self: GrowthRate<T>, other: GrowthRate<T>) {
        self.amount += other.amount;
    }
}

type WoodGrowthRate = GrowthRate<Wood>;
type BrickGrowthRate = GrowthRate<Brick>;
type SteelGrowthRate = GrowthRate<Steel>;
type FoodGrowthRate = GrowthRate<Food>;
