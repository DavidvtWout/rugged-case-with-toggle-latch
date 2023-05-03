// [Minimum:1 Maximum:300 Step:0.1] [Desciption: The inner length of the box in the x direction]
inner_x = 30.2;

// [Minimum:1 Maximum:300 Step:0.1] [Desciption: The inner length of the box in the y direction]
inner_y = 57.2;

// [Minimum:1 Maximum:200 Step:0.1] [Desciption: The inner height of the box]
case_inner_z = 87.0;

// [Minimum:1 Maximum:50 Step:0.1] [Desciption: The inner height of the lid]
lid_inner_z = 15.0;

// [Minimum:1 Maximum:20 Step:0.1] [Desciption: The radius of the rounding of the inside of the box]
inner_r = 2.0;

// [Minimum:0.4 Maximum:10 Step:0.1] [Desciption: Thickness of the walls of the box]
wall_thickness = 2.4;

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
lid_text = "";

// [Type:text]
case_bottom_text = "";

case_text = "V0.9";
font_size = 11;


$fn = 32;

use <rugged-case-library.scad>;


ruggedCase(inner_x, inner_y, case_inner_z, n_locks = n_locks, bottom_text = case_bottom_text, font_size = font_size, text_rotate=90);
//cylinder(h=10, d=10);
//seal(seal_width, seal_height, seal_wall, inner_x, inner_y, inner_r);

*hinge();
