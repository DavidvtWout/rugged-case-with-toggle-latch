include <rugged-case-library.scad>;
include <config-library.scad>;

// Options: case|lid|hinge|lock-hinge|lock-left|lock-right|seal
part = "lock-left";

inner_x = 30.2;
inner_y = 20;
case_inner_z = 35;
lid_inner_z = 15.0;
inner_radius = 2.0;
wall_thickness = 1.6;
seal_enable = true;
n_hinges = 1;
hinge_screw_length = 20;
hinge_spacing_adjustment = 0.15;
n_locks = 1;
lock_screw_length = 25;
lock_spacing_adjustment = 0.20;
layer_height = 0.2;

lid_text = "v11";
bottom_text = "v11";
font_size = 8;

$fn = 32;

overrides = [
        ["lid", [
            ["lid_text", lid_text],
        ]],
        ["case", [
            ["inner_x_length", inner_x],
            ["inner_y_length", inner_y],
            ["inner_height", case_inner_z],
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
