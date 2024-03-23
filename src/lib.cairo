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
}

mod helpers {
    mod array;
    mod contract_address;
}

mod tests {
    // mod test_spawn;
    // mod test_storage;
    // mod test_upgrade;
    // mod test_city_hall;
    mod test_barrack;
    // mod test_pay_upgrade;
    mod utils;
}

mod merkle{
    mod merkle_tree;
    mod merkle_tree_tests;
}