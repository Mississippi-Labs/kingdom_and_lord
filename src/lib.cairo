mod actions;
mod interface;
mod constants;
mod events;
mod admin;

mod models {
    mod resource;
    mod building;
    mod level;
    mod growth;
    mod time;
    mod building_kind;
}

mod components {
    mod outer_city;
    mod warehouse;
    mod barn;
    mod city_hall;
    mod city_building;
    mod universal;
    mod config;
    mod barrack;
    mod college;
    mod stable;
    mod city_wall;
}

mod helpers {
    mod array;
    mod contract_addr;
    mod bitmap;
}

mod tests {
    mod test_spawn;
    mod test_storage;
    mod test_upgrade;
    mod test_city_hall;
    mod test_city_wall;
    mod test_train;
    mod test_total_population;
    // mod test_pay_upgrade;
    mod utils;
    mod upgrade_info;
}

mod merkle{
    mod merkle_tree;
    mod merkle_tree_tests;
}