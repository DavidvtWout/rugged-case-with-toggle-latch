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
