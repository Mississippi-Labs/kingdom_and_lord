#[derive(Drop, Introspect, Copy, Serde, Default, Debug)]
struct Resource<T>{
    amount: u64
}

impl ResourceAdd<T> of Add<Resource<T>>{
   fn add(lhs: Resource<T>, rhs: Resource<T>) -> Resource<T> {
       Resource { amount: lhs.amount + rhs.amount }
   }
}

impl ResourceAddEq<T> of AddEq<Resource<T>>{
    fn add_eq(ref self: Resource<T>, other: Resource<T>) {
         self.amount += other.amount;
    }
}

impl ResourceSub<T> of Sub<Resource<T>>{
    fn sub(lhs: Resource<T>, rhs: Resource<T>) -> Resource<T> {
         Resource { amount: lhs.amount - rhs.amount }
    }
}

impl ResourceSubEq<T> of SubEq<Resource<T>>{
    fn sub_eq(ref self: Resource<T>, other: Resource<T>) {
         self.amount -= other.amount;
    }
}

impl ResourceFrom<T> of Into<u64,Resource<T>>{
    fn into(self: u64) -> Resource<T> {
        Resource{ amount: self}
    }
}

impl ResourceInto<T> of Into<Resource<T>, u64>{
    fn into(self: Resource<T>) -> u64 {
        self.amount
    }
}

impl ResourcePartialEq<T> of PartialEq<Resource<T>>{
    fn eq(lhs: @Resource<T>, rhs: @Resource<T>) -> bool{
        lhs.amount == rhs.amount
    }
    fn ne(lhs: @Resource<T>, rhs: @Resource<T>) -> bool{
        !(lhs.amount == rhs.amount)
    }
}
impl ResourcePartialOrd<T> of PartialOrd<Resource<T>>{
    fn le(lhs: Resource<T>, rhs: Resource<T>) -> bool{
        lhs.amount <= rhs.amount
    }
    fn ge(lhs: Resource<T>, rhs: Resource<T>) -> bool{
        lhs.amount >= rhs.amount
    }
    fn lt(lhs: Resource<T>, rhs: Resource<T>) -> bool{
        lhs.amount < rhs.amount
    }
    fn gt(lhs:Resource<T>, rhs: Resource<T>) -> bool{
        lhs.amount > rhs.amount
    
    }
}


#[derive(Drop, Introspect, Copy, Serde, Default, Debug)]
struct Steel{}
#[derive(Drop, Introspect, Copy, Serde, Default, Debug)]
struct Wood{}
#[derive(Drop, Introspect, Copy, Serde, Default, Debug)]
struct Food{}
#[derive(Drop, Introspect, Copy, Serde, Default, Debug)]
struct Brick{}

trait Minable<T> {
    fn mine(growth_rate: u64, last_block_number:u64, current_block_number: u64) -> T;
}

impl MinableImpl<T, +Into<u64, T>> of Minable<T>{
    fn mine(growth_rate: u64, last_block_number:u64, current_block_number: u64) -> T{
        let amount = growth_rate * (current_block_number - last_block_number);
        amount.into()
    }
}