// Inner dimensions
inner_x = 30.2;
inner_y = 57.2;
case_inner_z = 87;
lid_inner_z = 15;
inner_r = 1;

// Outer dimensions
wall_thickness = 2.4;
bottom_rounding = 2.0;  // Not really rounding, but how thick the bottom 45° angle part is. Also applies to lid.
// Calculated values. No need to modify these generally.
outer_r = inner_r + wall_thickness;
outer_x = inner_x + 2 * wall_thickness;
outer_y = inner_y + 2 * wall_thickness;
case_outer_z = case_inner_z + wall_thickness;

// Seal variables
seal_enable = true;
seal_width = 1.6;
seal_height = 1.0;  // Thickness of the seal
seal_depth = 0.6;   // How deep the seal is sunken into the case seal ridge.
seal_wall = 1.2;    // Wall around the seal for the case ridge.
seal_overhang = seal_width + 2 * seal_wall - wall_thickness;  // How far the case ridge goes outside the case wall.

// Hinge variables
n_hinges = 1;
hinge_screw_length = 20;
hinge_wall_thickness = 3;
hinge_screw_h_offset = 4;           // Offset of hinge screw from the case wall
hinge_screw_lid_v_offset = 6.0;       // Offset of hinge screw from the top of the lid
hinge_screw_case_v_offset = hinge_screw_lid_v_offset + seal_height + seal_depth - 1;
// Offset of hinge screw from the top of the case
hinge_screw_distance = hinge_screw_lid_v_offset + hinge_screw_case_v_offset;

// Lock variables
// TODO: n_locks
lock_screw_length = 25;
// Screw length for the sides. Length of the case lock screw is lock_screw_length - 2 * wall_thickness - length of the head of this third screw. So generally it is 25 - 2*3 - 3 = 16 mm.
lock_tightness = 0.015;  // 0 is a perfect fit for the lock sides. If too loose, increase this value.
lock_hinge_angle1 = 15;
// Angle between the lock hinge screw and the case screw. Increasing this value makes the lock more "clicky".
lock_hinge_angle2 = 10;
// Angle between the case wall and the lock hinge. If too small, the lock won't be easily accessible.
lock_hinge_length = 16;  // Length of the lock hinge part to grab onto.
lock_wall_thickness = 3;
lock_screw_lid_v_offset = 5;    // Offset of lock screw from the top of the lid
lock_screw_lid_h_offset = 4;    // Offset of lock screw from the lid wall
lock_screw_case_v_offset = 7;   // Offset of lock screw from the top of the case
lock_screw_case_h_offset = lock_screw_lid_h_offset + lock_screw_case_v_offset * sin(lock_hinge_angle1);
lock_screw_total_v_offset = lock_screw_lid_v_offset + lock_screw_case_v_offset;
lock_width = lock_screw_length - 2 * lock_wall_thickness;
lock_hinge_offset = lock_screw_total_v_offset;
// Vertical distance between the case screw and the hinging screw of the lock. NOT total euclidean distance!
lock_hinge_radius = min(lock_screw_case_h_offset, lock_screw_case_v_offset);
screw_head_height = 3.2;  // 3.2 for socket head, 1.8 for button head.

// Screws (M3)
screw_diameter_free = 3.30; // Diameter where the screw needs to be able to rotate freely.
screw_diameter_tap = 2.80;  // Diameter where the screw needs to tap into the plastic.

// Text
case_text = "V0.8";
text_size = 11;
text_font = "Liberation Sans:style=Bold";

$fn = 32;

use <rugged-case-library.scad>;

//cylinder(h=10, d=10);
//seal(seal_width, seal_height, seal_wall, inner_x, inner_y, inner_r);

hinge(hinge_screw_length, hinge_wall_thickness, hinge_screw_h_offset, hinge_screw_case_v_offset, hinge_screw_lid_v_offset,
seal_enable = seal_enable, seal_overhang = seal_overhang, seal_depth = seal_depth, seal_height = seal_height);
