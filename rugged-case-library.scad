// Defaults
default_inner_r = 2.0;        // Radius of the rounding of the edges of the inner cavity.
default_screw_d_free = 3.30;  // Diameter for the holes where the screw needs to rotate freely.
default_screw_d_tap = 2.80;   // Diameter for the holes where the screw needs to tap into the plastic.
default_layer_height = 0.20;
default_wall_thickness = 2.0;
default_floor_thickness = 1.6;
default_chamfer_height = 2.0;  // Height of the 45° bottom chamfer.

// Hinge
default_hinge_screw_length = 20;  // Use M3x20 screws by default.
default_hinge_mount_thickness = 3.0;
default_hinge_screw_h_offset = 4.0;
default_hinge_screw_lid_v_offset = 6.0;
default_hinge_screw_case_v_offset = 6.0;

// Lock
// There are 3 screws involved in the locking mechanism. From top to bottom;
//   lock_screw_lid, lock_case_hinge, lock_hinge_case
default_number_of_locks = 1;
default_lock_corner_spacing = 10;  // Distance between the locks and the edge of the case. Only used when n_locks > 1.
// By default, use M3x25 screws for the lid and hinge screws.
// The maximum length of case screw can be calculated;
//   length = lock_screw_length - 2 * lock_side_thickness - lock_case_screw_head - 0.2
// For lock_screw_length=25 and lock_side_thickness=2.8, a M3x16 socket head fits perfectly.
default_lock_screw_length = 25;  // For lid and hinge screw.
default_lock_case_screw_head = 3.4;  // Slightly more than a M3 socket head to ensure it fits.
default_lock_mount_thickness = 3.0;
default_lock_side_thickness = 2.8;
// Increasing the space adjustment makes the lock more tight.
default_lock_side_spacing_adjustment = 0.2;
// Angle between the lock hinge screw and the case screw. Increasing this value makes the lock more "clicky".
default_lock_hinge_angle1 = 15;
// Angle between the case wall and the lock hinge. If too small, the lock hinge will be harder to access.
default_lock_hinge_angle2 = 10;
default_lock_hinge_length = 16;  // Length of the lock hinge part to grab onto.
default_lock_lid_screw_v_offset = 5;    // Offset of lid screw from the bottom of the lid
default_lock_lid_screw_h_offset = 4;    // Offset of lid screw from the lid wall
default_lock_case_screw_v_offset = 7;   // Offset of case screw from the top of the case
// lock_case_screw_h_offset is calculated based on lock_hinge_angle1 and cannot be set.

// Seal
default_seal_width = 1.6;
default_seal_thickness = 0.6;
default_seal_groove_depth = 0.6;
default_seal_groove_wall_thickness = 1.0;


// TODO: make all default variables overridable.
module ruggedCase(inner_x, inner_y, inner_z, inner_r = 0, wall_thickness = 0, floor_thickness = 0, seal_enable = true,
n_locks = - 1,
lock_side_screws_wall_distance = 0, // Distance between the lock side screws (lid and hinge) and the wall.
lock_hinge_screw_z_distance = 0, // Vertical distance between lock case screw and lock hinge screw
bottom_text = "", font = "Liberation Sans:style=Bold", font_size = 10, text_rotate = 0, text_depth = 0.6) {
    inner_r = inner_r == 0 ? default_inner_r : inner_r;
    wall_thickness = wall_thickness == 0 ? default_wall_thickness : wall_thickness;
    floor_thickness = floor_thickness == 0 ? default_floor_thickness : floor_thickness;

    chamfer_height = default_chamfer_height;

    seal_groove_depth = default_seal_groove_depth;
    seal_groove_wall = default_seal_groove_wall_thickness;
    seal_width = default_seal_width;
    seal_thickness = default_seal_thickness;

    n_locks = n_locks == - 1 ? default_number_of_locks : n_locks;
    lock_corner_spacing = default_lock_corner_spacing;  // Only used when n_locks > 1
    lock_screw_v_offset = default_lock_case_screw_v_offset;
    lock_hinge_screw_z_distance = lock_hinge_screw_z_distance == 0 ?
            default_lock_lid_screw_v_offset + default_lock_case_screw_v_offset : lock_hinge_screw_z_distance;
    lock_side_screws_wall_distance = lock_side_screws_wall_distance == 0 ? default_lock_lid_screw_h_offset :
            lock_side_screws_wall_distance;
    lock_angle = default_lock_hinge_angle1;
    lock_screw_h_offset = lock_case_screw_h_offset(lock_side_screws_wall_distance, lock_hinge_screw_z_distance,
    lock_angle);
    lock_hinge_radius = min(lock_screw_h_offset, lock_screw_v_offset);
    lock_mount_thickness = default_lock_mount_thickness;
    lock_case_screw_head = default_lock_case_screw_head;
    lock_side_thickness = default_lock_side_thickness;
    lock_screw_length = default_lock_screw_length;

    screw_diameter_tap = default_screw_d_tap;

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

            //            // Hinge mounts
            //            translate([- (hinge_screw_length - hinge_wall_thickness) / 2, outer_y / 2, outer_z -
            //                hinge_screw_case_v_offset])
            //                caseHinge(hinge_screw_case_v_offset);
            //            translate([(hinge_screw_length - hinge_wall_thickness) / 2, outer_y / 2, outer_z -
            //                hinge_screw_case_v_offset])
            //                caseHinge(hinge_screw_case_v_offset);

            // Lock mount
            translate([0, - outer_y / 2, outer_z - lock_screw_v_offset]) lockMount();
        };

        // Inner cavity
        translate([0, 0, inner_z / 2 + wall_thickness])
            roundedCube([inner_x, inner_y, inner_z], inner_r, center = true);

        // Seal groove
        if (seal_enable) translate([0, 0, outer_z]) {
            // The actual seal cutout
            translate([0, 0, - seal_groove_depth - seal_thickness + 0.2])
                seal(inner_x, inner_y, seal_width = seal_width + 0.1);
            // Seal 45° groove
            difference() {
                hull() {
                    translate([0, 0, - seal_groove_depth]) seal(inner_x, inner_y, seal_width = seal_width + 0.1);
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
        mirror([1, 0, 0]) rotate([0, 0, text_rotate]) linear_extrude(text_depth)
            text(bottom_text, size = font_size, halign = "center", valign = "center", font = font);
    };

    module lockMount() {
        module singleLockMount() {
            translate([lock_mount_thickness / 2, 0, 0])
                rotate([0, - 90, 0])
                    linear_extrude(lock_mount_thickness)
                        difference() {
                            hull() {
                                translate([0, - lock_screw_h_offset]) circle(r = lock_hinge_radius);
                                square([2 * lock_hinge_radius, 0.1], center = true);
                            }
                            // Screw hole
                            translate([0, - lock_screw_h_offset]) circle(d = screw_diameter_tap);
                            // Remove one layer height from bottom to compensate for support interface defects.
                            translate([- lock_hinge_radius, - 2 * lock_hinge_radius])
                                square([default_layer_height, 2 * lock_hinge_radius]);
                        };
        };

        lock_mount_distance = lock_screw_length - 2 * lock_side_thickness - lock_case_screw_head + lock_mount_thickness;

        translate([- lock_mount_distance / 2 + 0.2, 0, 0]) singleLockMount();
        translate([lock_mount_distance / 2 - lock_case_screw_head, 0, 0]) singleLockMount();
    };
};


//module ruggedLid() {
//    outer_z = lid_inner_z + wall_thickness;
//
//    module coinSlot() {
//        translate([0, 0, inner_x / 4 + wall_thickness])
//            rotate([90, 0, 0])
//                hull() {
//                    cylinder(h = inner_y, d = inner_x / 2 + 0.4, center = true);
//                    translate([0, inner_x, 0])
//                        cylinder(h = inner_y, d = inner_x / 2 + 0.4, center = true);
//                };
//    };
//
//    difference() {
//        union() {
//            // Outer cube
//            translate([0, 0, outer_z / 2])
//                roundedCube([outer_x, outer_y, outer_z], outer_r, center = true);
//
//            // Seal ridge
//            if (seal_enable) hull() {
//                h = 1;
//                o = seal_width + 2 * seal_groove_wall;
//                translate([0, 0, outer_z - h / 2])
//                    roundedCube([inner_x + 2 * o, inner_y + 2 * o, h], radius = inner_r + o, center = true)
//                    ;
//                translate([0, 0, outer_z - h - (o - wall_thickness) + 0.5])
//                    roundedCube([outer_x, outer_y, 1], radius = outer_r, center = true);
//            }
//
//            // Seal pusher
//            margin = 0.3;
//            if (seal_enable) translate([0, 0, outer_z])
//                difference() {
//                    hull() {
//                        translate([0, 0, - seal_thickness + seal_groove_depth]) seal();
//                        o = 2 * (seal_groove_wall + seal_width + seal_groove_depth) - margin;
//                        translate([0, 0, - 0.1])
//                            roundedCube([inner_x + o, inner_y + o, 0.2], radius = inner_r + o / 2, center =
//                            true);
//                    };
//                    hull() {
//                        translate([0, 0, 1 + seal_groove_depth])
//                            roundedCube([inner_x + 2 * seal_groove_wall, inner_y + 2 * seal_groove_wall, 2],
//                            radius = inner_r + seal_groove_wall, center = true);
//                        o = seal_groove_wall - seal_groove_depth + margin;
//                        translate([0, 0, 1])
//                            roundedCube([inner_x + 2 * o, inner_y + 2 * o, 2], radius = inner_r + o, center
//                            = true);
//                    };
//                };
//
//            // Hinges
//            translate([- (hinge_screw_length - hinge_wall_thickness) / 2, outer_y / 2, outer_z -
//                hinge_screw_lid_v_offset])
//                caseHinge(hinge_screw_lid_v_offset);
//            translate([(hinge_screw_length - hinge_wall_thickness) / 2, outer_y / 2, outer_z -
//                hinge_screw_lid_v_offset])
//                caseHinge(hinge_screw_lid_v_offset);
//
//            // Lock holder
//            translate([0, - outer_y / 2, outer_z - lock_screw_lid_v_offset])
//                lidLock();
//        };
//
//        // Round bottom edges
//        difference() {
//            difference() {
//                translate([0, 0, chamfer_height / 2])
//                    roundedCube([outer_x, outer_y, chamfer_height], center = true);
//                hull() {
//                    translate([0, 0, chamfer_height / 2])
//                        roundedCube([outer_x - 2 * chamfer_height, outer_y - 2 * chamfer_height,
//                            chamfer_height], radius = outer_r - chamfer_height, center = true);
//                    translate([0, 0, chamfer_height + 0.5])
//                        roundedCube([outer_x, outer_y, 1], radius = outer_r, center = true);
//                }
//            };
//        };
//
//        // Inner cube
//        *translate([0, 0, inner_z / 2 + wall_thickness])
//            roundedCube([inner_x, inner_y, inner_z], inner_r, center = true);
//
//        // For machiavelli
//        intersection() {
//            union() {
//                translate([- inner_x / 4 + 0.2, 0, 0]) coinSlot();
//                translate([inner_x / 4 - 0.2, 0, 0]) coinSlot();
//                translate([0, 0, 10.4]) cube([inner_x / 2, inner_y, 10], center = true);
//            };
//            roundedCube([inner_x, inner_y, 1000], radius = inner_r, center = true);
//        };
//        rotate([0, 0, 90]) mirror([1, 0, 0]) linear_extrude(0.6) text("Machiavelli", size = 7.5, halign = "center",
//        valign = "center", font = "Liberation Sans:style=Bold Italic");
//    };
//};


module seal(inner_x, inner_y, inner_r = 0, seal_width = 0, seal_thickness = 0, seal_groove_wall = 0) {
    inner_r = inner_r == 0 ? default_inner_r : inner_r;
    seal_width = seal_width == 0 ? default_seal_width : seal_width;
    seal_thickness = seal_thickness == 0 ? default_seal_thickness : seal_thickness;
    seal_groove_wall = seal_groove_wall == 0 ? default_seal_groove_wall_thickness : seal_groove_wall;

    // Inner dimensions of the seal
    r1 = inner_r + seal_groove_wall;
    x1 = inner_x + 2 * seal_groove_wall;
    y1 = inner_y + 2 * seal_groove_wall;

    // Outer dimensions of the seal
    r2 = r1 + seal_width;
    x2 = x1 + 2 * seal_width;
    y2 = y1 + 2 * seal_width;

    translate([0, 0, seal_thickness / 2]) difference() {
        roundedCube([x2, y2, seal_thickness], radius = r2, center = true);
        roundedCube([x1, y1, seal_thickness], radius = r1, center = true);
    };
};

// TODO: make all default values overridable.
module hinge(screw_length = 0, screw_diameter = 0, screw_h_offset = 0, screw_case_v_offset = 0, screw_lid_v_offset = 0,
screw_spacing_adjustment = 0.15, mount_thickness = 0, wall_thickness = 0, seal_enable = true) {
    screw_length = screw_length == 0 ? default_hinge_screw_length : screw_length;
    screw_diameter = screw_diameter == 0 ? default_screw_d_free : screw_diameter;
    screw_h_offset = screw_h_offset == 0 ? default_hinge_screw_h_offset : screw_h_offset;
    case_v_offset = screw_case_v_offset == 0 ? default_hinge_screw_case_v_offset : screw_case_v_offset;
    lid_v_offset = screw_lid_v_offset == 0 ? default_hinge_screw_lid_v_offset : screw_lid_v_offset;
    mount_thickness = mount_thickness == 0 ? default_hinge_mount_thickness : mount_thickness;
    wall_thickness = wall_thickness == 0 ? default_wall_thickness : wall_thickness;

    radius = screw_h_offset - 0.1;  // Keep some distance from the case wall.
    seal_margin = 0.3;              // Keep some extra distance from the seal ridge.
    // How far the case ridge goes outside the case wall.
    seal_overhang = default_seal_width + 2 * default_seal_groove_wall_thickness - wall_thickness;

    // Make the hinge slightly narrower (one layer height) for a better fit.
    width = screw_length - 2 * mount_thickness - default_layer_height;

    linear_extrude(width)
        difference() {
            hull() {
                translate([lid_v_offset - screw_spacing_adjustment / 2, 0]) circle(r = radius);
                translate([- case_v_offset + screw_spacing_adjustment / 2, 0]) circle(r = radius);
            }

            // Screw holes
            translate([lid_v_offset - screw_spacing_adjustment / 2, 0]) circle(d = screw_diameter);
            translate([- case_v_offset + screw_spacing_adjustment / 2, 0]) circle(d = screw_diameter);

            // Seal ridge space
            if (seal_enable) {
                case_ridge = default_seal_thickness + default_seal_groove_depth;
                lid_ridge = 1;
                translate([0, radius]) offset(seal_margin)
                    polygon([
                            [- case_ridge, - seal_overhang],
                            [- case_ridge - seal_overhang, seal_margin],
                            [lid_ridge + seal_overhang, seal_margin],
                            [lid_ridge, - seal_overhang]
                        ]);
            };
        }
};

function lock_case_screw_h_offset(h_offset, v_offset, angle) = h_offset + v_offset * sin(angle);

//module lockHinge() {
//    radius = lock_screw_lid_h_offset;
//
//    module hingeCutout(height) {
//        hull() {
//            cylinder(r = lock_hinge_radius, h = height);
//            translate([lock_hinge_radius, 0, 0])
//                cylinder(r = lock_hinge_radius, h = height);
//        };
//        r = 1;
//        translate([lock_hinge_radius - r, - lock_hinge_radius - r, 0]) difference() {
//            cube([2 * r, 2 * r, height]);
//            cylinder(r = r, h = height);
//        }
//    };
//
//    difference() {
//        linear_extrude(lock_width - 0.2)
//            difference() {
//                union() {
//                    // Screw part
//                    hull() {
//                        translate([- lock_hinge_radius, lock_hinge_offset])
//                            circle(r = lock_hinge_radius);
//                        translate([- lock_screw_lid_h_offset, 0]) circle(r = radius);
//                    }
//                    // Lever part
//                    hull() {
//                        translate([- lock_screw_lid_h_offset, 0]) circle(r = radius);
//                        rotate(- lock_hinge_angle2)
//                            translate([- lock_screw_lid_h_offset, - lock_hinge_length])
//                                circle(r = radius * 0.5);
//                    }
//                }
//                // Screw holes
//                translate([- lock_hinge_radius, lock_hinge_offset]) circle(d = screw_diameter_free);
//                translate([- lock_screw_lid_h_offset, 0]) circle(d = screw_diameter_free);
//            }
//
//        h1 = lock_wall_thickness + 0.2;
//        translate([- lock_hinge_radius, lock_hinge_offset, 0])
//            hingeCutout(h1);
//        h2 = h1 + screw_head_height;
//        translate([- lock_hinge_radius, lock_hinge_offset, lock_width - 0.2 - h2])
//            hingeCutout(h2);
//    };
//};
//
//
//module lockSides() {
//    radius = lock_screw_lid_h_offset;
//
//    case_screw_offset = lock_screw_case_h_offset - lock_screw_lid_h_offset;
//    distance = (1 - lock_tightness) * (
//        sqrt(pow(lock_screw_total_v_offset, 2) - pow(case_screw_offset, 2)) +
//        sqrt(pow(lock_hinge_offset, 2) - pow(case_screw_offset, 2))
//    );
//
//    linear_extrude(lock_wall_thickness)
//        difference() {
//            hull() {
//                translate([lock_screw_lid_v_offset, 0]) circle(r = radius);
//                translate([lock_screw_lid_v_offset - distance, 0]) circle(r = radius);
//            }
//
//            translate([lock_screw_lid_v_offset, 0]) circle(d = screw_diameter_tap);
//            translate([lock_screw_lid_v_offset - distance, 0]) circle(d = screw_diameter_tap);
//
//            // Seal ridge space
//            margin = 0.3;
//            case_ridge = seal_groove_depth + seal_thickness + 0.4;
//            translate([0, radius]) offset(margin) polygon([
//                    [- case_ridge, - seal_overhang],
//                    [- case_ridge - seal_overhang, margin],
//                    [1.8 + seal_overhang, margin],
//                    [1.8, - seal_overhang]
//                ]);
//        }
//};
//
//
//module caseHinge(screw_v_offset) {
//    screw_offset = hinge_screw_h_offset;
//    intersection() {
//        translate([hinge_wall_thickness / 2, 0, 0])
//            rotate([0, - 90, 0])
//                linear_extrude(hinge_wall_thickness)
//                    difference() {
//                        hull() {
//                            translate([0, screw_offset]) circle(r = screw_offset); // Circle around screw hole
//                            h = screw_offset * (1 + sqrt(2));  // Make the support exactly 45°
//                            translate([- h, - 1]) square([h + screw_v_offset, 1]);
//                        }
//                        translate([0, screw_offset]) circle(d = screw_diameter_tap);
//                    };
//        // Cut off excess material.
//        translate([0, 500, 0]) cube(1000, center = true);
//    };
//};
//
//
//module lidLock() {
//    v_offset = lock_screw_lid_v_offset;
//    h_offset = lock_screw_lid_h_offset;
//    radius = min(v_offset, h_offset);
//    width = lock_width - 0.6;
//
//    intersection() {
//        translate([width / 2, 0, 0])
//            rotate([0, - 90, 0])
//                linear_extrude(width)
//                    difference() {
//                        hull() {
//                            translate([0, 1]) square([2 * v_offset, 2], center = true);
//                            translate([v_offset - radius, - h_offset]) circle(r = radius);
//                            translate([0, - h_offset]) circle(r = radius);
//                        }
//                        translate([0, - h_offset])
//                            hull() {
//                                circle(d = screw_diameter_free);  // Screw hole
//                                translate([- v_offset, 0]) circle(d = screw_diameter_free);
//                                translate([- v_offset - 1, h_offset - 1]) square(1);  // Closest to wall
//                            };
//                        translate([- radius, - radius - h_offset]) square(radius);
//                    };
//
//        // Cut off excess parts.
//        translate([0, - 500, 0]) cube(1000, center = true);
//    };
//};
//
//
function get_dimensions(dimensions) =
    dimensions[0] != undef ? dimensions : [dimensions, dimensions, dimensions];

// RoundedCube works the same as the normal cube function, except that the vertical edges are rounded. Dimensions can be a list [x, y, z] or an int. If just a number is provided, this number is used for all dimensions.
module roundedCube(dimensions, radius = 1, center = false) {
    dims = get_dimensions(dimensions);
    x = dims[0]; y = dims[1]; z = dims[2];

    module _roundedCube() {
        linear_extrude(z)
            offset(radius)
                offset(- radius)
                    square([x, y], center = true);
    };

    if (center) {
        translate([0, 0, - z / 2]) _roundedCube();
    } else {
        translate([x / 2, y / 2, 0]) _roundedCube();
    }
}
