mod actions;
mod interface;
mod constants;
mod events;
mod admin;

mod models {
    mod army;
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
    mod battle;
    mod city_hall;
    mod city_building;
    mod embassy;
    mod universal;
    mod config;
    mod barrack;
    mod college;
    mod stable;
    mod city_wall;
    mod globe;
}

mod helpers {
    mod array;
    mod bitmap;
}

mod tests {
    mod test_spawn;
    mod test_storage;
    mod test_upgrade;
    mod test_city_hall;
    mod test_city_wall;
    mod test_train;
    mod test_embassy;
    mod test_total_population;
    // mod test_pay_upgrade;
    mod test_growth_rate;
    mod test_create_city;
    mod test_ambush;
    mod utils;
    mod upgrade_proof;
    mod upgrade_func;
}

mod merkle{
    mod merkle_tree;
    mod merkle_tree_tests;
}