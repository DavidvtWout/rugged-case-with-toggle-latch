// [Type:enum] [Options:case|lid|hinge|lock-hinge|lock-left|lock-right|seal]
part = "";

// [Minimum:1 Maximum:300 Step:0.1] [Desciption: The inner length of the box in the x direction]
inner_x = 30.2;

// [Minimum:1 Maximum:300 Step:0.1] [Desciption: The inner length of the box in the y direction]
inner_y = 20; //57.2;

// [Minimum:1 Maximum:200 Step:0.1] [Desciption: The inner height of the box]
case_inner_z = 30;  // 87.0;

// [Minimum:1 Maximum:50 Step:0.1] [Desciption: The inner height of the lid]
lid_inner_z = 15.0;

// [Minimum:1 Maximum:20 Step:0.1] [Desciption: The radius of the rounding of the inside of the box]
inner_r = 2.0;

// [Minimum:0.4 Maximum:10 Step:0.1] [Desciption: Thickness of the walls of the box]
wall_thickness = 1.6;

// [Type:bool] [Desciption: Whether or not to enable seal (should be printed with a flexible material such as TPU)]
seal_enable = true;

// [Minimum:0 Maximum:5 Step:1] [Desciption: Number of hinges]
n_hinges = 1;

// [Minimum:10 Maximum:30 Step:1] [Desciption: Length of the M3 screws used by the hinges]
hinge_screw_length = 20;

// [Minimum:0 Maximum:1 Step:0.01] [Desciption: Increasing this value makes the hinges more tight. It is the amount the hinges are made to short in mm]
hinge_spacing_adjustment = 0.15;

// [Minimum:0 Maximum:5 Step:1] [Desciption: Number of locks]
n_locks = 1;

// [Minimum:15 Maximum:35 Step:1] [Desciption: Length of the M3 screws used by the locks]
lock_screw_length = 25;

// [Minimum:0 Maximum:1 Step:0.01] [Desciption: Increasing this value makes the locks more tight. It is the amount the lock sides are made to short in mm]
lock_spacing_adjustment = 0.20;

// [Minimum:5 Maximum:25 Step:0.5] [Desciption: Increasing the angle of the hinge lock makes the lock more "clicky"]
lock_hinge_angle = 15;

// [Type:text]
lid_text = "v11";

// [Type:text]
bottom_text = "v11";

font_size = 8;


$fn = 32;

include <rugged-case-library.scad>;

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
