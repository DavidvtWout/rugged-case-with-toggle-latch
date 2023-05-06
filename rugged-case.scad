include <default-config.scad>;
include <config-library.scad>;
include <rugged-case-library.scad>;

// What part to render. When you click the Create Thing button, all parts will automatically be generated as separate stl files, no matter what value you selected here.
part = "case"; // [case, lid, hinge, lock-lever, lock-left, lock-right, seal]

// Applies to both case and lid.
inner_width = 30;
// Applies to both case and lid.
inner_depth = 20;
case_inner_height = 35;
lid_inner_height = 16;
// Radius of the roundings of the walls. A higher value will result in a rounder case and lid.
inner_radius = 2.0;
enable_seal = 1; // [yes:1, no:0]
number_of_hinges = 1; // [0:1:3]
number_of_locks = 1; // [0:1:3]
// Applies to both case and lid.
wall_thickness = 2.0;
// Applies to both case and lid.
floor_thickness = 1.6;
hinge_screw_length = 20; // [10:1:50]
// This is the length of the two longest screws of the lock. The shorter screw should be 9 mm shorter, so 16 mm by default.
lock_screw_length = 25; // [20:1:50]

/* [Text] */
// Text on the top of the lid.
lid_text = "";
// Text on the bottom of the case.
case_text = "v11";
// The customizer does not support all fonts. If you want a custom font you should download the scad file and build the STLs on your computer.
font = "Liberation Sans:style=Bold";
font_size = 10;
rotation = 0;  // [0, 90, 180, 270]

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
            ["bottom_text", case_text],
        ]],
        ["seal", [
            ["enable", enable_seal == 1 ? true : false],
        ]],
        ["lock", [
            ["number_of_locks", number_of_locks],
            ["screw_length", lock_screw_length],
        ]],
        ["hinge", [
            ["number_of_hinges", number_of_hinges],
            ["screw_length", hinge_screw_length],
        ]],
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
