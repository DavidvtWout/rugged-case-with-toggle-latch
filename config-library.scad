// This is a set of functions that are used to emulate a config dictionary (as in key-value pairs).
// example;
//    seal_config = get_value(config, "seal");
//    seal_enable = get_value(seal_config, "enable");
//
// To update the default config;
//    config_overrides = [["seal", [["enable", false]]]];
//    config = update_config(default_config, config_overrides);


function merge_configs(config1, config2) =
    len(config2) == 0
    ? config1
    : merge_configs(_set_value(config1, config2[0][0], config2[0][1]), tail(config2));


function get_value(config, key) =
let(keys = split_key(key))
    len(keys) == 1
    ? _get_value(config, keys[0])
    : get_value(_get_value(config, keys[0]), keys[1]);


function _get_value(config, key) =
    len(config) == 0
    ? undef
    : config[0][0] == key
    ? config[0][1]
    : _get_value(tail(config), key);


// Sets value recursively.
function set_value(config, key, value) =
let(keys = split_key(key, n = 1))
    len(keys) == 1
    ? _set_value(config, keys[0], value)
    : _set_value(config, keys[0], set_value(_get_value(config, keys[0]), keys[1], value));


// Helper function that sets a value without needing to split the key.
function _set_value(config, key, value) =
    len(config) == 0  // Key was not in config. Add the key value pair.
    ? [[key, value]]
    : config[0][0] == key  // Key found
    ? value[0][0] == undef
        ? concat([[key, value]], tail(config))  // Value is a normal value.
        : concat([[key, _merge_values(config[0][1], value)]], tail(config))  // Value is a nested config.
    : concat([config[0]], _set_value(tail(config), key, value));


// Values may be simple values.
function _merge_values(value1, value2) =
    !(is_subconfig(value1) && is_subconfig(value2))
    ? value2
    : _merge_values2(value1, value2);


// Both values are sure to be a subconfig.
function _merge_values2(value1, value2) =
    value2 == []
    ? value1
    : _merge_values2(_set_value(value1, value2[0][0], value2[0][1]), tail(value2));


// Same as key.split(":") in python. This function takes a string, splits on ":" and returns a list of strings.
function split_key(key, n = 0) =
let(index = search(":", key))
    index == - 1
    ? [key]
    : n == 1
    ? [slice(key, 0, index), slice(key, index, len(key))]
    : [slice(key, 0, index)] + split_key(slice(key, index, len(key)), n - 1);


// Does what you think it does. OpenSCAD somehow does not support array slicing natively..
function slice(array, start, end) = [for (i = [start:end]) array[i]];


function tail(array) =
    len(array) == 0
    ? undef
    : len(array) == 1
    ? []
    : slice(array, 1, len(array) - 1);


// Only true if value is a [["key", value]] pair where the key is
// a string (or array, since strings are basically char arrays)
function is_subconfig(value) = value[0][0][0] == undef ? false : true;


// Override the search function because the builtin one prints warnings when item is not found..
function search(list, item) =
    len(list) == 0
    ? - 1
    : list[0] == item
    ? 0
    : let (next_index = search(item, tail(list)))
            next_index == - 1 ? - 1 : next_index + 1;
