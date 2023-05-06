include <config-library.scad>;

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
