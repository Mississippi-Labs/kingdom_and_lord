#[derive(Drop, Serde, Introspect, Copy, Default, Debug, starknet::Store, PartialEq)]
struct Level{
    level: u64,
}

trait LevelTrait<T>{
    fn get_level(self: @T) -> Level;
}

trait LevelUpTrait<T, V>{
    fn level_up(ref self: T, value: V);
}

trait LevelExtentionTraits<T>{
    fn get_next_level(self: @T) -> Level;
    fn is_next_level_valid(self: @T, target_next_level: Level) -> bool;
}



impl LevelImpl of LevelTrait<Level>{
    fn get_level(self: @Level) -> Level{
        *self
    }
}
impl  LevelUpTraitImpl<T, +Drop<T>> of  LevelUpTrait<Level, T>{
    fn level_up(ref self: Level, value: T){
        self.level +=1;
    }

}

impl LevelExtentionTraitsImpl<T, +LevelTrait<T>> of LevelExtentionTraits<T>{
    fn is_next_level_valid(self: @T, target_next_level: Level) -> bool{
        self.get_next_level() == target_next_level
    }

    fn get_next_level(self: @T) -> Level{
        Level { level: self.get_level().level + 1 }
    }
}

impl LevelInto of Into<u64, Level>{
    fn into(self: u64) -> Level{
        Level{ level: self }
    }
}

