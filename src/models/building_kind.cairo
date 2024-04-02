#[derive(Drop, Copy, Serde, Hash, Debug, PartialEq)]
enum BuildingKind {
    None,
    WoodBuilding,
    BrickBuilding,
    SteelBuilding,
    FoodBuilding,
    CityHall,
    Warehouse,
    Barn,
    Barrack,
    Stable,
    College
}

impl IntoBuildingKind of Into<u64, BuildingKind> {
    fn into(self: u64) -> BuildingKind {
        let self:felt252 = self.into();
        match self{
            0 => BuildingKind::None,
            1 => BuildingKind::WoodBuilding,
            2 => BuildingKind::BrickBuilding,
            3 => BuildingKind::SteelBuilding,
            4 => BuildingKind::FoodBuilding,
            5 => BuildingKind::CityHall,
            6 => BuildingKind::Warehouse,
            7 => BuildingKind::Barn,
            8 => BuildingKind::Barrack,
            9 => BuildingKind::Stable,
            10 => BuildingKind::College,
            _ => panic!("Invalid building id")
        }
    }
}

impl BuildingKindIntou64 of Into<BuildingKind, u64> {
    fn into(self: BuildingKind) -> u64 {
        match self {
            BuildingKind::None => 0,
            BuildingKind::WoodBuilding => 1,
            BuildingKind::BrickBuilding => 2,
            BuildingKind::SteelBuilding => 3,
            BuildingKind::FoodBuilding => 4,
            BuildingKind::CityHall => 5,
            BuildingKind::Warehouse => 6,
            BuildingKind::Barn => 7,
            BuildingKind::Barrack => 8,
            BuildingKind::Stable => 9,
            BuildingKind::College => 10
        }
    }
}
