// Defaults
default_r_inner = 2.0;

//module ruggedCase() {
//    difference() {
//        union() {
//            // Outer cube
//            translate([0, 0, outer_height / 2])
//                roundedCube([outer_width, outer_depth, outer_height], outer_radius, center = true);
//
//            // Seal ridge
//            if (seal_enable) hull() {
//                h = seal_depth + seal_height + 0.4;
//                o = seal_width + 2 * seal_wall;
//                translate([0, 0, outer_height - h / 2])
//                    roundedCube([inner_width + 2 * o, inner_depth + 2 * o, h], radius = inner_radius + o, center = true)
//                    ;
//                translate([0, 0, outer_height - h - (o - wall_thickness) + 0.5])
//                    roundedCube([outer_width, outer_depth, 1], radius = outer_radius, center = true);
//            }
//
//            // Hinges
//            translate([- (hinge_screw_length - hinge_wall_thickness) / 2, outer_depth / 2, outer_height -
//                hinge_screw_case_v_offset])
//                caseHinge(hinge_screw_case_v_offset);
//            translate([(hinge_screw_length - hinge_wall_thickness) / 2, outer_depth / 2, outer_height -
//                hinge_screw_case_v_offset])
//                caseHinge(hinge_screw_case_v_offset);
//
//            // Lock holder
//            x_lock = lock_width / 2 - 1.5;
//            translate([- x_lock, - outer_depth / 2, outer_height - lock_screw_case_v_offset])
//                caseLock();
//            translate([x_lock - screw_head_height, - outer_depth / 2, outer_height - lock_screw_case_v_offset])
//                caseLock();
//        };
//
//        // Inner cube
//        translate([0, 0, inner_height / 2 + wall_thickness])
//            roundedCube([inner_width, inner_depth, inner_height], inner_radius, center = true);
//
//        // Seal
//        if (seal_enable) translate([0, 0, outer_height]) {
//            // The actual seal slot
//            translate([0, 0, - seal_depth - seal_height + 0.2]) seal();
//            // Seal 45° slot
//            difference() {
//                hull() {
//                    translate([0, 0, - seal_depth]) seal();
//                    o = 2 * (seal_wall + seal_width + seal_depth);
//                    translate([0, 0, 1])
//                        roundedCube([inner_width + o, inner_depth + o, 2], radius = inner_radius + o / 2, center = true)
//                        ;
//                };
//                hull() {
//                    translate([0, 0, - 1 - seal_depth])
//                        roundedCube([inner_width + 2 * seal_wall, inner_depth + 2 * seal_wall, 2],
//                        radius = inner_radius + seal_wall, center = true);
//                    o = seal_wall - seal_depth;
//                    translate([0, 0, - 1])
//                        roundedCube([inner_width + 2 * o, inner_depth + 2 * o, 2], radius = inner_radius + o, center =
//                        true);
//                }
//            };
//        };
//
//        // Round bottom edges
//        difference() {
//            difference() {
//                translate([0, 0, bottom_rounding / 2])
//                    roundedCube([outer_width, outer_depth, bottom_rounding], center = true);
//                hull() {
//                    translate([0, 0, bottom_rounding / 2])
//                        roundedCube([outer_width - 2 * bottom_rounding, outer_depth - 2 * bottom_rounding,
//                            bottom_rounding], radius = outer_radius - bottom_rounding, center = true);
//                    translate([0, 0, bottom_rounding + 0.5])
//                        roundedCube([outer_width, outer_depth, 1], radius = outer_radius, center = true);
//                }
//            };
//        };
//
//        mirror([1, 0, 0]) rotate([0, 0, - 90]) linear_extrude(0.6) text(case_text, size = text_size, halign = "center",
//        valign = "center", font = text_font);
//    };
//}
//
//
//module ruggedLid() {
//    outer_height = lid_inner_height + wall_thickness;
//
//    module coinSlot() {
//        translate([0, 0, inner_width / 4 + wall_thickness])
//            rotate([90, 0, 0])
//                hull() {
//                    cylinder(h = inner_depth, d = inner_width / 2 + 0.4, center = true);
//                    translate([0, inner_width, 0])
//                        cylinder(h = inner_depth, d = inner_width / 2 + 0.4, center = true);
//                };
//    };
//
//    difference() {
//        union() {
//            // Outer cube
//            translate([0, 0, outer_height / 2])
//                roundedCube([outer_width, outer_depth, outer_height], outer_radius, center = true);
//
//            // Seal ridge
//            if (seal_enable) hull() {
//                h = 1;
//                o = seal_width + 2 * seal_wall;
//                translate([0, 0, outer_height - h / 2])
//                    roundedCube([inner_width + 2 * o, inner_depth + 2 * o, h], radius = inner_radius + o, center = true)
//                    ;
//                translate([0, 0, outer_height - h - (o - wall_thickness) + 0.5])
//                    roundedCube([outer_width, outer_depth, 1], radius = outer_radius, center = true);
//            }
//
//            // Seal pusher
//            margin = 0.3;
//            if (seal_enable) translate([0, 0, outer_height])
//                difference() {
//                    hull() {
//                        translate([0, 0, - seal_height + seal_depth]) seal();
//                        o = 2 * (seal_wall + seal_width + seal_depth) - margin;
//                        translate([0, 0, - 0.1])
//                            roundedCube([inner_width + o, inner_depth + o, 0.2], radius = inner_radius + o / 2, center =
//                            true);
//                    };
//                    hull() {
//                        translate([0, 0, 1 + seal_depth])
//                            roundedCube([inner_width + 2 * seal_wall, inner_depth + 2 * seal_wall, 2],
//                            radius = inner_radius + seal_wall, center = true);
//                        o = seal_wall - seal_depth + margin;
//                        translate([0, 0, 1])
//                            roundedCube([inner_width + 2 * o, inner_depth + 2 * o, 2], radius = inner_radius + o, center
//                            = true);
//                    };
//                };
//
//            // Hinges
//            translate([- (hinge_screw_length - hinge_wall_thickness) / 2, outer_depth / 2, outer_height -
//                hinge_screw_lid_v_offset])
//                caseHinge(hinge_screw_lid_v_offset);
//            translate([(hinge_screw_length - hinge_wall_thickness) / 2, outer_depth / 2, outer_height -
//                hinge_screw_lid_v_offset])
//                caseHinge(hinge_screw_lid_v_offset);
//
//            // Lock holder
//            translate([0, - outer_depth / 2, outer_height - lock_screw_lid_v_offset])
//                lidLock();
//        };
//
//        // Round bottom edges
//        difference() {
//            difference() {
//                translate([0, 0, bottom_rounding / 2])
//                    roundedCube([outer_width, outer_depth, bottom_rounding], center = true);
//                hull() {
//                    translate([0, 0, bottom_rounding / 2])
//                        roundedCube([outer_width - 2 * bottom_rounding, outer_depth - 2 * bottom_rounding,
//                            bottom_rounding], radius = outer_radius - bottom_rounding, center = true);
//                    translate([0, 0, bottom_rounding + 0.5])
//                        roundedCube([outer_width, outer_depth, 1], radius = outer_radius, center = true);
//                }
//            };
//        };
//
//        // Inner cube
//        *translate([0, 0, inner_height / 2 + wall_thickness])
//            roundedCube([inner_width, inner_depth, inner_height], inner_radius, center = true);
//
//        // For machiavelli
//        intersection() {
//            union() {
//                translate([- inner_width / 4 + 0.2, 0, 0]) coinSlot();
//                translate([inner_width / 4 - 0.2, 0, 0]) coinSlot();
//                translate([0, 0, 10.4]) cube([inner_width / 2, inner_depth, 10], center = true);
//            };
//            roundedCube([inner_width, inner_depth, 1000], radius = inner_radius, center = true);
//        };
//        rotate([0, 0, 90]) mirror([1, 0, 0]) linear_extrude(0.6) text("Machiavelli", size = 7.5, halign = "center",
//        valign = "center", font = "Liberation Sans:style=Bold Italic");
//    };
//};


module seal(seal_width, seal_height, seal_wall, x_inner, y_inner, r_inner = 0) {
    r_inner = r_inner == 0 ? default_r_inner : r_inner;

    // Inner dimensions of the seal
    r1 = r_inner + seal_wall;
    x1 = x_inner + 2 * seal_wall;
    y1 = y_inner + 2 * seal_wall;

    // Outer dimensions of the seal
    r2 = r1 + seal_width;
    x2 = x1 + 2 * seal_width;
    y2 = y1 + 2 * seal_width;

    difference() {
        roundedCube([x2, y2, seal_height], radius = r2);
        translate([seal_width, seal_width, 0]) roundedCube([x1, y1, seal_height], radius = r1);
    };
};


//module hinge() {
//    radius = hinge_screw_h_offset - 0.1;
//    screw_offset = 0.2;  // Put the two screws about one layer height closer together.
//
//    linear_extrude(hinge_width - 0.2)
//        difference() {
//            hull() {
//                translate([hinge_screw_lid_v_offset - screw_offset / 2, 0]) circle(r = radius);
//                translate([- hinge_screw_case_v_offset + screw_offset / 2, 0]) circle(r = radius);
//            }
//
//            // Screw holes
//            translate([hinge_screw_lid_v_offset - screw_offset / 2, 0]) circle(d = screw_diameter_free);
//            translate([- hinge_screw_case_v_offset + screw_offset / 2, 0]) circle(d = screw_diameter_free);
//
//            // Seal ridge space
//            margin = 0.3;
//            case_ridge = seal_depth + seal_height + 0.4;
//            translate([0, radius]) offset(margin) polygon([
//                    [- case_ridge, - seal_overhang],
//                    [- case_ridge - seal_overhang, margin],
//                    [1 + seal_overhang, margin],
//                    [1, - seal_overhang]
//                ]);
//        }
//};
//
//
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
//            case_ridge = seal_depth + seal_height + 0.4;
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
//module caseLock(screw_offset = 0, radius = 0) {
//    screw_offset = screw_offset == 0 ? lock_screw_case_h_offset : screw_offset;
//    radius = radius == 0 ? lock_hinge_radius : radius;
//
//    intersection() {
//        translate([lock_wall_thickness / 2, 0, 0])
//            rotate([0, - 90, 0])
//                linear_extrude(lock_wall_thickness)
//                    difference() {
//                        hull() {
//                            translate([0, 1]) square([2 * radius, 2], center = true);
//                            translate([0, - screw_offset]) circle(r = radius);
//                        }
//                        translate([0, - screw_offset]) circle(d = screw_diameter_tap);
//                    };
//
//        translate([0, - 500, 0]) cube(1000, center = true);
//    };
//};
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
