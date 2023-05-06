
// What part to render. When you clock the Create Thing button, all parts will automatically be generated as separate stl files, no matter what value you selected here.
part = "case"; // [case, lid, hinge, lock-lever, lock-left, lock-right, seal]

// Applies to both case and lid.
inner_width = 30;
// Applies to both case and lid.
inner_depth = 20;
case_inner_height = 35;
lid_inner_height = 16;
// Radius of the roundings of the walls. A higher value will result in a rounder case and lid.
inner_radius = 2.0;
enable_seal = true;
number_of_hinges = 2; // [0:1:3]
number_of_locks = 2; // [0:1:3]

/* [Text] */
// Text on the top of the lid.
lid_text = "";
// Text on the bottom of the case.
case_text = "v11";
// The customizer does not support all fonts. If you want a custom font you should download the scad file and build the STLs on your computer.
font = "Liberation Sans:style=Bold";
font_size = 10;
rotation = 0;  // [0, 90, 180, 270]

/* [Basic] */
// Applies to both case and lid.
wall_thickness = 2.0;
// Applies to both case and lid.
floor_thickness = 1.6;

/* [Advanced] */
hinge_screw_length = 20; // [10:1:50]
// This is the length of the two longest screws of the lock. The shorter screw should be 9 mm shorter, so 16 mm by default.
lock_screw_length = 25; // [20:1:50]

/* [Hidden] */
overrides = [
        ["lid", [
            ["lid_text", lid_text],
        ]],
        ["case", [
            ["inner_x_length", inner_width],
            ["inner_y_length", inner_depth],
            ["inner_height", case_inner_height],
            ["inner_radius", inner_radius],
            ["wall_thickness", wall_thickness],
            ["bottom_text", bottom_text],
        ]],
        ["seal", [
            ["enable", seal_enable],
        ]],
        ["lock", [
            ["number_of_locks", n_locks],
            ["screw_length", lock_screw_length],
            ["side_spacing_adjustment", lock_spacing_adjustment],
        ]],
        ["hinge", [
            ["number_of_hinges", n_hinges],
            ["screw_length", hinge_screw_length],
            ["screw_spacing_adjustment", hinge_spacing_adjustment],
        ]],
        ["layer_height", layer_height],
    ];

config = merge_configs(default_config, overrides);

$fn = 32;

if (part == "case")
    ruggedCase(config);
if (part == "lid")
    ruggedLid(config);
if (part == "hinge")
    hinge(config);
if (part == "lock-hinge")
    lockHinge(config);
if (part == "lock-left")
    lockSide(config);
if (part == "lock-right")
    mirror([0, 1, 0]) lockSide(config);
if (part == "seal")
    seal(config);


// Contents of config-library.scad

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
    : merge_configs(set_value(config1, config2[0][0], config2[0][1]), tail(config2));


function get_value(config, key) =
    len(config) == 0
    ? undef
    : config[0][0] == key
    ? config[0][1]
    : get_value(tail(config), key);


function set_value(config, key, value) =
    len(config) == 0  // Key was not in config. Add the key value pair.
    ? [[key, value]]
    : config[0][0] == key  // Key found
    ? value[0][0] == undef
        ? concat([[key, value]], tail(config))  // Value is a normal value.
        : concat([[key, _merge_values(config[0][1], value)]], tail(config))  // Value is a nested config.
    : concat([config[0]], set_value(tail(config), key, value));


// Values may be simple values.
function _merge_values(value1, value2) =
    !(_is_subconfig(value1) && _is_subconfig(value2))
    ? value2
    : _merge_values2(value1, value2);

// Only true if value is a [["key", value]] pair where the key is
// a string (or array, since strings are basically char arrays)
function _is_subconfig(value) = value[0][0][0] == undef ? false : true;


// Both values are sure to be a subconfig.
function _merge_values2(value1, value2) =
    value2 == []
    ? value1
    : _merge_values2(set_value(value1, value2[0][0], value2[0][1]), tail(value2));


// Does what you think it does. OpenSCAD somehow does not support array slicing natively..
function slice(array, start, end) = [for (i = [start:end]) array[i]];


function tail(array) =
    len(array) == 0
    ? undef
    : len(array) == 1
    ? []
    : slice(array, 1, len(array) - 1);


// Contents of rugged-case-library.scad

include <config-library.scad>;

default_config = [
        ["case", [
            ["inner_x_length", 30],
            ["inner_y_length", 20],
            ["inner_height", 35],
            ["inner_radius", 2.0], // Radius of the rounding of the edges of the inner cavity.
            ["wall_thickness", 2.0],
            ["floor_thickness", 1.6],
            ["chamfer_height", 2.0], // Height of the 45° bottom chamfer.
            ["bottom_text", ""],
        ]],
        ["lid", [
            ["inner_height", 15],
            ["lid_text", ""],
        ]],
        ["seal", [
            ["enable", true],
            ["width", 1.6],
            ["thickness", 0.8],
            ["groove_wall_thickness", 1.0], // Thickness of the walls around the seal on the case ridge.
            ["groove_depth", 0.6], // Extra depth of the 45° sides of the seal groove on top of the seal thickness.
        ]],
        ["hinge", [
            ["number_of_hinges", 2],
            ["screw_length", 20.0], // M3x20 by default
            ["mount_thickness", 3.0], // Thickness of the mounts on the lid and case
            ["corner_spacing", 12.5], // Distance between hinge mount and corner of case/lid
            ["screw_spacing_adjustment", 0.3], // How close the two screws are. Higher value is more tight hinge.
            ["screw_h_offset", 4.0], // How far the screws are from the walls of the case
            ["lid_screw_v_offset", 6.0], // Distance between lid screw and bottom of lid
            ["case_screw_v_offset", 6.0], // Distance between case screw and top of case
        ]],
        ["lock", [
        // There are 3 screws involved in the locking mechanism. From top to bottom;
        //   lid screw, case screw, hinge screw
            ["number_of_locks", 2], // If only one lock is used, it is centered
            ["corner_spacing", 10], // Distance between the locks and the edge of the case
        // By default, use M3x25 screws for the lid and hinge screws.
        // The maximum length of the case screw can be calculated;
        //   length = lock_screw_length - 2 * lock_side_thickness - lock_case_screw_head - 0.2
        // For lock_screw_length=25 and lock_side_thickness=2.8, a M3x16 socket head fits perfectly.
            ["screw_length", 25],
            ["case_screw_head", 3.2], // M3 socket head height. Use 1.8 for button head.
            ["mount_thickness", 3.0], // Thickness of the mounts on the case
            ["side_thickness", 2.8], // Thickness of the lockSide part
            ["side_spacing_adjustment", 0.3], // Increasing the space adjustment makes the lock more tight.
        // Angle between the lock hinge screw and the case screw. Increasing this value makes the lock more "clicky".
            ["locking_angle", 11],
        // Angle between the case wall and the lock hinge. If too small, the lock hinge will be harder to access.
            ["lever_angle", 10],
            ["lever_length", 16], // Length of the lever part to grab onto.
            ["lid_screw_v_offset", 5], // Offset of lid screw from the bottom of the lid
            ["lid_screw_h_offset", 4], // Offset of lid screw from the lid wall
            ["case_screw_v_offset", 7], // Offset of case screw from the top of the case
        // lock_case_screw_h_offset is calculated based on lock_hinge_angle1 and cannot be set.
        ]],
        ["text", [
            ["font", "Liberation Sans:style=Bold"],
            ["size", 10],
            ["depth", 0.4],
            ["rotation", 0],
        ]],
        ["screw_diameter_free", 3.30], // Diameter for the holes where the screw needs to rotate freely.
        ["screw_diameter_tap", 2.80], // Diameter for the holes where the screw needs to tap into the plastic.
        ["layer_height", 0.2],
    ];


module ruggedCase(config) {
    case_config = get_value(config, "case");
    inner_x = get_value(case_config, "inner_x_length");
    inner_y = get_value(case_config, "inner_y_length");
    inner_z = get_value(case_config, "inner_height");
    inner_r = get_value(case_config, "inner_radius");
    wall_thickness = get_value(case_config, "wall_thickness");
    floor_thickness = get_value(case_config, "floor_thickness");
    chamfer_height = get_value(case_config, "chamfer_height");

    seal_config = get_value(config, "seal");
    seal_enable = get_value(seal_config, "enable");
    seal_groove_depth = get_value(seal_config, "groove_depth");
    seal_groove_wall = get_value(seal_config, "groove_wall_thickness");
    seal_width = get_value(seal_config, "width");
    seal_thickness = get_value(seal_config, "thickness");

    hinge_config = get_value(config, "hinge");
    n_hinges = get_value(hinge_config, "number_of_hinges");
    hinge_corner_spacing = get_value(hinge_config, "corner_spacing");
    hinge_screw_length = get_value(hinge_config, "screw_length");
    hinge_screw_v_offset = get_value(hinge_config, "case_screw_v_offset");

    lock_config = get_value(config, "lock");
    n_locks = get_value(lock_config, "number_of_locks");
    lock_corner_spacing = get_value(lock_config, "corner_spacing");
    lock_screw_v_offset = get_value(lock_config, "case_screw_v_offset");
    lock_mount_thickness = get_value(lock_config, "mount_thickness");
    lock_side_thickness = get_value(lock_config, "side_thickness");
    lock_screw_length = get_value(lock_config, "screw_length");
    lock_angle = get_value(lock_config, "locking_angle");
    lock_screw_lid_v_offset = get_value(lock_config, "lid_screw_v_offset");
    lock_screw_lid_h_offset = get_value(lock_config, "lid_screw_h_offset");
    lock_hinge_screw_z_distance = lock_screw_lid_v_offset + lock_screw_v_offset;
    lock_screw_h_offset = lock_case_screw_h_offset(lock_screw_lid_h_offset, lock_hinge_screw_z_distance, lock_angle);
    lock_hinge_radius = min(lock_screw_h_offset, lock_screw_v_offset) - layer_height;

    layer_height = get_value(config, "layer_height");
    screw_diameter_tap = get_value(config, "screw_diameter_tap");

    outer_x = inner_x + 2 * wall_thickness;
    outer_y = inner_y + 2 * wall_thickness;
    outer_z = inner_z + floor_thickness;
    outer_r = inner_r + wall_thickness;

    difference() {
        union() {
            // Outer outline
            translate([0, 0, outer_z / 2]) roundedCube([outer_x, outer_y, outer_z], outer_r, center = true);

            // Seal ridge
            if (seal_enable) hull() {
                ridge_height = seal_groove_depth + seal_thickness;
                ridge_width = seal_width + 2 * seal_groove_wall;
                translate([0, 0, outer_z - ridge_height / 2])
                    roundedCube([inner_x + 2 * ridge_width, inner_y + 2 * ridge_width, ridge_height],
                    radius = inner_r + ridge_width, center = true);
                translate([0, 0, outer_z - ridge_height - (ridge_width - wall_thickness) + 0.05])
                    roundedCube([outer_x, outer_y, 0.1], radius = outer_r, center = true);
            }

            // Hinge mounts
            hinge_corner_spacing = n_hinges == 1 ? (outer_x - hinge_screw_length) / 2 : hinge_corner_spacing;
            hinge_spacing = n_hinges == 1 ? 0 :
                        (outer_x - 2 * hinge_corner_spacing - hinge_screw_length) / (n_hinges - 1);
            hinge_x_start = (- outer_x + hinge_screw_length) / 2 + hinge_corner_spacing;
            for (i = [0:n_hinges - 1]) {
                translate([hinge_x_start + i * hinge_spacing, outer_y / 2, outer_z - hinge_screw_v_offset])
                    hingeMount(config, hinge_screw_v_offset);
            }

            // Lock mount
            lock_corner_spacing = n_locks == 1 ? (outer_x - lock_screw_length) / 2 : lock_corner_spacing;
            lock_spacing = n_locks == 1 ? 0 : (outer_x - 2 * lock_corner_spacing - lock_screw_length) / (n_locks - 1);
            lock_x_start = (- outer_x + lock_screw_length) / 2 + lock_corner_spacing;
            for (i = [0:n_locks - 1]) {
                translate([lock_x_start + i * lock_spacing, - outer_y / 2, outer_z - lock_screw_v_offset])
                    lockMount();
            }
        };

        // Inner cavity
        translate([0, 0, inner_z / 2 + floor_thickness])
            roundedCube([inner_x, inner_y, inner_z], inner_r, center = true);

        // Seal groove
        if (seal_enable) translate([0, 0, outer_z]) {
            updated_seal_config = merge_configs(config, ["seal", [["width", seal_width + 0.1]]]);

            // The actual seal cutout
            translate([0, 0, - seal_groove_depth - seal_thickness + layer_height])
                seal(updated_seal_config);
            // Seal 45° groove
            difference() {
                hull() {
                    translate([0, 0, - seal_groove_depth]) seal(updated_seal_config);
                    o = 2 * (seal_groove_wall + seal_width + seal_groove_depth);
                    translate([0, 0, 0.05])
                        roundedCube([inner_x + o, inner_y + o, 0.1], radius = inner_r + o / 2, center = true);
                };
                hull() {
                    translate([0, 0, - 1 - seal_groove_depth])
                        roundedCube([inner_x + 2 * seal_groove_wall, inner_y + 2 * seal_groove_wall, 2],
                        radius = inner_r + seal_groove_wall, center = true);
                    o = seal_groove_wall - seal_groove_depth;
                    translate([0, 0, - 0.05])
                        roundedCube([inner_x + 2 * o, inner_y + 2 * o, 0.1], radius = inner_r + o, center =
                        true);
                }
            };
        };

        // Bottom chamfer
        difference() {
            difference() {
                translate([0, 0, chamfer_height / 2])
                    roundedCube([outer_x, outer_y, chamfer_height], center = true);
                hull() {
                    translate([0, 0, chamfer_height / 2])
                        roundedCube([outer_x - 2 * chamfer_height, outer_y - 2 * chamfer_height,
                            chamfer_height], radius = outer_r - chamfer_height, center = true);
                    translate([0, 0, chamfer_height + 0.5])
                        roundedCube([outer_x, outer_y, 1], radius = outer_r, center = true);
                }
            };
        };

        // Bottom text
        bottom_text = get_value(case_config, "bottom_text");
        text_config = get_value(config, "text");
        font = get_value(text_config, "font");
        font_size = get_value(text_config, "size");
        text_depth = get_value(text_config, "depth");
        text_rotation = get_value(text_config, "rotation");
        mirror([1, 0, 0]) rotate([0, 0, - text_rotation]) linear_extrude(text_depth)
            text(bottom_text, size = font_size, halign = "center", valign = "center", font = font);
    };

    module lockMount() {
        lock_case_screw_head = get_value(lock_config, "case_screw_head");
        lock_hinge_width = lock_screw_length - 2 * lock_side_thickness - layer_height;

        module singleLockMount() {
            translate([lock_mount_thickness / 2, 0, 0]) rotate([0, - 90, 0])
                linear_extrude(lock_mount_thickness) difference() {
                    hull() {
                        translate([0, - lock_screw_h_offset]) circle(r = lock_hinge_radius);
                        square([2 * lock_hinge_radius, 0.1], center = true);
                    }
                    // Screw hole
                    translate([0, - lock_screw_h_offset]) circle(d = screw_diameter_tap);
                    // Remove one layer height from bottom to compensate for support interface defects.
                    translate([- lock_hinge_radius, - 2 * lock_hinge_radius])
                        square([layer_height, 2 * lock_hinge_radius]);
                };
        };

        translate([- (lock_hinge_width - lock_mount_thickness) / 2 + layer_height, 0, 0]) singleLockMount();
        translate([(lock_hinge_width - lock_mount_thickness) / 2 - lock_case_screw_head, 0, 0]) singleLockMount();
    };
};


module ruggedLid(config) {
    lid_config = get_value(config, "lid");
    inner_z = get_value(lid_config, "inner_height");

    case_config = get_value(config, "case");
    inner_x = get_value(case_config, "inner_x_length");
    inner_y = get_value(case_config, "inner_y_length");
    inner_r = get_value(case_config, "inner_radius");
    wall_thickness = get_value(case_config, "wall_thickness");
    floor_thickness = get_value(case_config, "floor_thickness");
    chamfer_height = get_value(case_config, "chamfer_height");

    hinge_config = get_value(config, "hinge");
    n_hinges = get_value(hinge_config, "number_of_hinges");
    hinge_corner_spacing = get_value(hinge_config, "corner_spacing");
    hinge_screw_length = get_value(hinge_config, "screw_length");
    hinge_screw_v_offset = get_value(hinge_config, "lid_screw_v_offset");

    lock_config = get_value(config, "lock");
    n_locks = get_value(lock_config, "number_of_locks");
    lock_corner_spacing = get_value(lock_config, "corner_spacing");
    lock_screw_length = get_value(lock_config, "screw_length");
    lock_side_thickness = get_value(lock_config, "side_thickness");
    lock_screw_h_offset = get_value(lock_config, "lid_screw_h_offset");
    lock_screw_v_offset = get_value(lock_config, "lid_screw_v_offset");
    screw_diameter_free = get_value(config, "screw_diameter_free");

    outer_x = inner_x + 2 * wall_thickness;
    outer_y = inner_y + 2 * wall_thickness;
    outer_z = inner_z + floor_thickness;
    outer_r = inner_r + wall_thickness;

    difference() {
        union() {
            // Outer outline
            translate([0, 0, outer_z / 2]) roundedCube([outer_x, outer_y, outer_z], outer_r, center = true);

            // Seal stuff
            seal_config = get_value(config, "seal");
            seal_enable = get_value(seal_config, "enable");
            if (seal_enable) {
                seal_groove_depth = get_value(seal_config, "groove_depth");
                seal_groove_wall = get_value(seal_config, "groove_wall_thickness");
                seal_width = get_value(seal_config, "width");
                seal_thickness = get_value(seal_config, "thickness");
                seal_ridge_width = seal_width + 2 * seal_groove_wall;
                seal_ridge_height = 0.8;  // Height of the straight part of the seal ridge before the 45° part begins.

                // Seal ridge
                hull() {
                    translate([0, 0, outer_z - seal_ridge_height / 2])
                        roundedCube([inner_x + 2 * seal_ridge_width, inner_y + 2 * seal_ridge_width, seal_ridge_height],
                        radius = inner_r + seal_ridge_width, center = true);
                    translate([0, 0, outer_z - seal_ridge_height - (seal_ridge_width - wall_thickness) + 0.05])
                        roundedCube([outer_x, outer_y, 0.1], radius = outer_r, center = true);
                }

                // Seal pusher
                translate([0, 0, outer_z]) difference() {
                    seal_pusher_margin = 0.3;

                    hull() {
                        translate([0, 0, seal_groove_depth - seal_thickness]) seal(config);
                        o = 2 * (seal_groove_wall + seal_width + seal_groove_depth) - seal_pusher_margin;
                        translate([0, 0, - 0.1])
                            roundedCube([inner_x + o, inner_y + o, 0.2],
                            radius = inner_r + o / 2, center = true);
                    };
                    hull() {
                        translate([0, 0, seal_groove_depth + 0.05])
                            roundedCube([inner_x + 2 * seal_groove_wall, inner_y + 2 * seal_groove_wall, 0.1],
                            radius = inner_r + seal_groove_wall, center = true);
                        o = 2 * (seal_groove_wall - seal_groove_depth) + seal_pusher_margin;
                        translate([0, 0, 1])
                            roundedCube([inner_x + o, inner_y + o, 2],
                            radius = inner_r + o / 2, center = true);
                    };
                };
            };

            // Hinge mounts
            hinge_corner_spacing = n_hinges == 1 ? (outer_x - hinge_screw_length) / 2 : hinge_corner_spacing;
            hinge_spacing = n_hinges == 1 ? 0 :
                        (outer_x - 2 * hinge_corner_spacing - hinge_screw_length) / (n_hinges - 1);
            hinge_x_start = (- outer_x + hinge_screw_length) / 2 + hinge_corner_spacing;
            for (i = [0:n_hinges - 1]) {
                translate([hinge_x_start + i * hinge_spacing, outer_y / 2, outer_z - hinge_screw_v_offset])
                    hingeMount(config, hinge_screw_v_offset);
            }
            // Lock holders
            lock_corner_spacing = n_locks == 1 ? (outer_x - lock_screw_length) / 2 : lock_corner_spacing;
            lock_spacing = n_locks == 1 ? 0 : (outer_x - 2 * lock_corner_spacing - lock_screw_length) / (n_locks - 1);
            lock_x_start = (- outer_x + lock_screw_length) / 2 + lock_corner_spacing;
            for (i = [0:n_locks - 1]) {
                translate([lock_x_start + i * lock_spacing, - outer_y / 2, outer_z - lock_screw_v_offset])
                    lockHolder();
            }
        };

        // Chamfer
        difference() {
            difference() {
                translate([0, 0, chamfer_height / 2])
                    roundedCube([outer_x, outer_y, chamfer_height], center = true);
                hull() {
                    translate([0, 0, chamfer_height / 2])
                        roundedCube([outer_x - 2 * chamfer_height, outer_y - 2 * chamfer_height,
                            chamfer_height], radius = outer_r - chamfer_height, center = true);
                    translate([0, 0, chamfer_height + 0.5])
                        roundedCube([outer_x, outer_y, 1], radius = outer_r, center = true);
                }
            };
        };

        // Inner cavity
        translate([0, 0, inner_z / 2 + floor_thickness + 0.001])
            roundedCube([inner_x, inner_y, inner_z], inner_r, center = true);

        // Lid text
        lid_text = get_value(lid_config, "lid_text");
        text_config = get_value(config, "text");
        font = get_value(text_config, "font");
        font_size = get_value(text_config, "size");
        text_depth = get_value(text_config, "depth");
        text_rotation = get_value(text_config, "rotation");
        mirror([1, 0, 0]) rotate([0, 0, text_rotation]) linear_extrude(text_depth)
            text(lid_text, size = font_size, halign = "center", valign = "center", font = font);
    };

    module lockHolder() {
        radius = min(lock_screw_v_offset, lock_screw_h_offset);
        width = lock_screw_length - 2 * lock_side_thickness - 0.5;

        translate([width / 2, 0, 0]) rotate([0, - 90, 0]) linear_extrude(width) difference() {
            hull() {
                translate([0, 0.05]) square([2 * lock_screw_v_offset, 0.1], center = true);
                translate([lock_screw_v_offset - radius, - lock_screw_h_offset]) circle(r = radius);
                translate([0, - lock_screw_h_offset]) circle(r = radius);
            }
            translate([0, - lock_screw_h_offset]) hull() {
                circle(d = screw_diameter_free);  // Screw hole
                translate([- lock_screw_v_offset, 0]) circle(d = screw_diameter_free);
                translate([- lock_screw_v_offset - 1, lock_screw_h_offset - 1]) square(1);  // Closest to wall
            };
            translate([- radius, - radius - lock_screw_h_offset]) square(radius);
        };
    };
};


module seal(config) {
    seal_config = get_value(config, "seal");
    width = get_value(seal_config, "width");
    thickness = get_value(seal_config, "thickness");
    groove_wall_thickness = get_value(seal_config, "groove_wall_thickness");

    case_config = get_value(config, "case");
    inner_x = get_value(case_config, "inner_x_length");
    inner_y = get_value(case_config, "inner_y_length");
    inner_r = get_value(case_config, "inner_radius");

    // Inner dimensions of the seal
    r1 = inner_r + groove_wall_thickness;
    x1 = inner_x + 2 * groove_wall_thickness;
    y1 = inner_y + 2 * groove_wall_thickness;

    // Outer dimensions of the seal
    r2 = r1 + width;
    x2 = x1 + 2 * width;
    y2 = y1 + 2 * width;

    translate([0, 0, thickness / 2]) difference() {
        roundedCube([x2, y2, thickness], radius = r2, center = true);
        roundedCube([x1, y1, thickness], radius = r1, center = true);
    };
};


module hinge(config) {
    hinge_config = get_value(config, "hinge");

    screw_length = get_value(hinge_config, "screw_length");
    screw_h_offset = get_value(hinge_config, "screw_h_offset");
    screw_diameter = get_value(config, "screw_diameter_free");

    case_v_offset = get_value(hinge_config, "case_screw_v_offset");
    lid_v_offset = get_value(hinge_config, "lid_screw_v_offset");
    mount_thickness = get_value(hinge_config, "mount_thickness");
    screw_spacing_adjustment = get_value(hinge_config, "screw_spacing_adjustment");

    wall_thickness = get_value(config, "case:wall_thickness");
    layer_height = get_value(config, "layer_height");

    radius = screw_h_offset - 0.1;  // Keep some distance from the case wall.

    // Make the hinge slightly narrower (one layer height) for a better fit.
    width = screw_length - 2 * mount_thickness - layer_height;

    spring_length = lid_v_offset + case_v_offset - screw_spacing_adjustment;
    spring_width = 2;
    spring_amplitude = radius;

    linear_extrude(width) difference() {
        union() {
            translate([lid_v_offset - screw_spacing_adjustment / 2, 0]) circle(r = radius);
            translate([- case_v_offset + screw_spacing_adjustment / 2, 0]) circle(r = radius);
            scale([0.97, 0.97]) translate([- case_v_offset, 0])
                spring_wave(spring_width, spring_length, spring_amplitude);
        }

        // Screw holes
        translate([lid_v_offset - screw_spacing_adjustment / 2, 0]) circle(d = screw_diameter);
        translate([- case_v_offset + screw_spacing_adjustment / 2, 0]) circle(d = screw_diameter);
    };

    module spring_wave(width, length, amplitude, samples = 20) {
        module point(x) {
            translate([x * length, cos(x * 360) * (amplitude - width / 2)]) circle(d = width);
        }
        // Wave section
        union() {
            for (i = [1:samples]) {
                hull() {
                    point((i - 1) / samples);
                    point(i / samples);
                }
            }
        };
    };
};

function lock_case_screw_h_offset(h_offset, v_offset, angle) = h_offset + v_offset * tan(angle);

// There are 3 screws involved in the locking mechanism. From top to bottom;
//   lid screw, case screw, hinge screw
module lockHinge(config) {
    lock_config = get_value(config, "lock");

    screw_length = get_value(lock_config, "screw_length");
    side_thickness = get_value(lock_config, "side_thickness");
    mount_thickness = get_value(lock_config, "mount_thickness");
    screw_head_height = get_value(lock_config, "case_screw_head");

    hinge_angle = get_value(lock_config, "locking_angle");;  // Angle between case and hinge screw
    lever_angle = get_value(lock_config, "lever_angle");;  // Angle for lever
    lever_length = get_value(lock_config, "lever_length");

    hinge_screw_h_offset = get_value(lock_config, "lid_screw_h_offset");  // Hinge and lid screw have same offset
    case_screw_v_offset = get_value(lock_config, "case_screw_v_offset");
    lid_screw_v_offset = get_value(lock_config, "lid_screw_v_offset");
    case_hinge_screw_v_distance = case_screw_v_offset + lid_screw_v_offset;
    case_screw_h_offset = lock_case_screw_h_offset(hinge_screw_h_offset, case_hinge_screw_v_distance, hinge_angle);

    screw_diameter_free = get_value(config, "screw_diameter_free");
    layer_height = get_value(config, "layer_height");

    width = screw_length - 2 * side_thickness - layer_height;

    difference() {
        linear_extrude(width)
            difference() {
                union() {
                    // Screw part
                    hull() {
                        // Circle around case screw
                        translate([- case_screw_h_offset, case_hinge_screw_v_distance])
                            circle(r = case_screw_h_offset);
                        // Circle around hinge screw
                        translate([- hinge_screw_h_offset, 0]) circle(r = hinge_screw_h_offset);
                    }
                    // Lever part
                    hull() {
                        // Circle around hinge screw
                        translate([- hinge_screw_h_offset, 0]) circle(r = hinge_screw_h_offset);
                        // End of lever
                        rotate(- lever_angle) translate([- hinge_screw_h_offset, - lever_length])
                            circle(r = hinge_screw_h_offset * 0.5);
                    }
                }
                // Case screw hole
                translate([- case_screw_h_offset, case_hinge_screw_v_distance]) circle(d = screw_diameter_free);
                // Hinge screw hole
                translate([- hinge_screw_h_offset, 0]) circle(d = screw_diameter_free);

                // Cut away a part of the side that touches the wall for a better fit.
                translate([- 0.25, - 50]) square([0.25, 100]);
            }

        translate([- case_screw_h_offset, case_hinge_screw_v_distance, 0]) {
            // Bottom hinge mount cutout
            h1 = mount_thickness + layer_height;
            hingeMountCutout(h1);
            // Top hinge mount cutout
            h2 = h1 + screw_head_height + layer_height;
            translate([0, 0, width - h2]) hingeMountCutout(h2 + 0.001);
        };
    };

    module hingeMountCutout(height) {
        hull() {
            cylinder(r = case_screw_h_offset, h = height);
            translate([case_screw_h_offset, 0, 0])
                cylinder(r = case_screw_h_offset, h = height);
        };
        // Add a rounding for a better fit.
        r = 1.5;
        translate([case_screw_h_offset - r, - case_screw_h_offset - r, 0]) difference() {
            cube([2 * r, 2 * r, height]);
            cylinder(r = r, h = height);
        }
    };
};


module lockSide(config) {
    lock_config = get_value(config, "lock");
    thickness = get_value(lock_config, "side_thickness");
    spacing_adjustment = get_value(lock_config, "side_spacing_adjustment");

    lid_screw_v_offset = get_value(lock_config, "lid_screw_v_offset");
    lid_screw_h_offset = get_value(lock_config, "lid_screw_h_offset");
    case_screw_v_offset = get_value(lock_config, "case_screw_v_offset");
    hinge_screw_v_distance = 2 * case_screw_v_offset + lid_screw_v_offset;

    screw_diameter = get_value(config, "screw_diameter_tap");
    radius = lid_screw_h_offset + 0.1;

    difference() {
        linear_extrude(thickness) difference() {
            hull() {
                translate([lid_screw_v_offset - spacing_adjustment / 2, 0]) circle(r = radius);
                translate([- hinge_screw_v_distance + spacing_adjustment / 2, 0]) circle(r = radius);
            }

            translate([lid_screw_v_offset - spacing_adjustment / 2, 0]) circle(d = screw_diameter);
            translate([- hinge_screw_v_distance + spacing_adjustment / 2, 0]) circle(d = screw_diameter);

            // Seal ridge space
            seal_config = get_value(config, "seal");
            seal_enable = get_value(seal_config, "enable");
            if (seal_enable) {
                seal_groove_depth = get_value(seal_config, "groove_depth");
                seal_width = get_value(seal_config, "width");
                seal_thickness = get_value(seal_config, "thickness");
                seal_groove_wall = get_value(seal_config, "groove_wall_thickness");
                case_ridge = seal_groove_depth + seal_thickness;
                case_wall_thickness = get_value(get_value(config, "case"), "wall_thickness");
                seal_overhang = seal_width + 2 * seal_groove_wall - case_wall_thickness;

                margin = 0.3;
                difference() {
                    translate([0, lid_screw_h_offset]) offset(margin) polygon([
                            [lid_screw_v_offset, 0],
                            [lid_screw_v_offset, - seal_overhang],
                            [- case_ridge - 0.5, - seal_overhang],
                            [- case_ridge - 0.5 - seal_overhang, margin],
                        ]);
                    translate([lid_screw_v_offset - spacing_adjustment / 2, 0]) circle(r = radius);
                };
            };
        };

        // Cut off a small edge because the edges of the lock mounts are not printed exactly at 90 °.
        translate([- 50, radius, thickness - 0.8]) rotate([45, 0, 0]) cube([100, 10, 10]);
    };
};

// This module is used both by the lid and case.
module hingeMount(config, screw_v_offset) {
    hinge_config = get_value(config, "hinge");
    screw_length = get_value(hinge_config, "screw_length");
    screw_h_offset = get_value(hinge_config, "screw_h_offset");
    screw_diameter = get_value(config, "screw_diameter_tap");
    thickness = get_value(hinge_config, "mount_thickness");

    module singleHingeMount() {
        translate([thickness / 2, 0, 0]) rotate([0, - 90, 0]) linear_extrude(thickness) difference() {
            hull() {
                // Circle around screw hole
                translate([0, screw_h_offset]) circle(r = screw_h_offset);
                h = screw_h_offset * (1 + sqrt(2));  // Make the support exactly 45°
                translate([- h, - 0.1]) square([h + screw_v_offset, 0.1]);
            }
            translate([0, screw_h_offset]) circle(d = screw_diameter);
        };
    }

    translate([- (screw_length - thickness) / 2, 0, 0]) singleHingeMount();
    translate([(screw_length - thickness) / 2, 0, 0]) singleHingeMount();
};


function get_dimensions(dimensions) =
    dimensions[0] != undef
    ? dimensions
    : [dimensions, dimensions, dimensions];

// RoundedCube works the same as the normal cube module, except that the vertical
// edges are rounded. Dimensions can be a list [x, y, z] or an number. If just a number
// is provided, this number is used for all dimensions.
module roundedCube(dimensions, radius = 1, center = false) {
    dims = get_dimensions(dimensions);
    x = dims[0]; y = dims[1]; z = dims[2];

    module _roundedCube() {
        linear_extrude(z) offset(radius) offset(- radius) square([x, y], center = true);
    };

    if (center) {
        translate([0, 0, - z / 2]) _roundedCube();
    } else {
        translate([x / 2, y / 2, 0]) _roundedCube();
    };
}