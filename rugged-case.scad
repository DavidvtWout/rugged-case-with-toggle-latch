include <rugged-case-library.scad>;

// Options: case|lid|hinge|lock-hinge|lock-left|lock-right|seal
part = "";
inner_x = 30.2;
inner_y = 20; //57.2;
case_inner_z = 30;  // 87.0;
lid_inner_z = 15.0;
inner_r = 2.0;
wall_thickness = 1.6;
seal_enable = true;
n_hinges = 1;
hinge_screw_length = 20;
hinge_spacing_adjustment = 0.15;
n_locks = 1;
lock_screw_length = 25;
lock_spacing_adjustment = 0.20;
lock_hinge_angle = 15;

lid_text = "v11";
bottom_text = "v11";
font_size = 8;

$fn = 32;

overrides = [
        ["seal", [
            ["enable", false],
        ]],
        ["screw_diamter_tap", 2.90],
    ];

config = merge_configs(default_config, overrides);
echo("config:\n", config);


if (part == "case")
    ruggedCase(inner_x, inner_y, case_inner_z, inner_r = inner_r, n_hinges = n_hinges, n_locks = n_locks,
    bottom_text = bottom_text, font_size = font_size, text_rotate = 180, wall_thickness = wall_thickness);
if (part == "lid")
    ruggedLid(inner_x, inner_y, lid_inner_z, inner_r = inner_r, n_hinges = n_hinges, n_locks = n_locks,
    lid_text = lid_text, font_size = font_size, text_rotate = 0, wall_thickness = wall_thickness);
if (part == "hinge")
    hinge(config2);
if (part == "lock-hinge")
    lockHinge();
if (part == "lock-left")
    lockSide();
if (part == "lock-right")
    mirror([0, 1, 0]) lockSide();
if (part == "seal")
    seal(inner_x, inner_y, inner_r = inner_r);
