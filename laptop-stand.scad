$fn= $preview ? 32 : 128;               // render more accurately than preview

// =============================
// ===== ADJUSTABLE VALUES =====
// =============================

length = 100;                           // length of platform in mm
height = 100;                           // height of platform in mm  ==> 100
angle = 45;                             // angle of platform in degrees
width = 12;                             // width in mm
slotHeight = 11;                        // slot height in mm
thickness = 4.5;                        // thickness of slot support

// =============================
// ===== CALCULATED VALUES =====
// =============================

totalLength = length / cos(angle);      // length of bottom
totalHeight = height + totalLength;     // total height

// =============================
// ========= THE MODEL =========
// =============================

union() {
    // FRONT LEG
    translate([0, 0, 0])
        hull(){
            translate([thickness/2, 1, thickness/2])
                rotate([90, 0, 0])
                    cylinder(h=1, d=thickness);
            translate([thickness/2, 1, width - thickness/2])
                rotate([90, 0, 0])
                    cylinder(h=1, d=thickness);
            translate([thickness/2, height-thickness/2, thickness/2])
                sphere(d=thickness);
            translate([thickness/2, height-thickness/2, width - thickness/2])
                sphere(d=thickness);
        }

    // BACK LEG
    translate([totalLength - thickness, 0, 0])
        hull(){
            translate([thickness/2, 1, thickness/2])
                rotate([90, 0, 0])
                    cylinder(h=1, d=thickness);
            translate([thickness/2, 1, width - thickness/2])
                rotate([90, 0, 0])
                    cylinder(h=1, d=thickness);
            translate([thickness/2, height-thickness/2, thickness/2])
                sphere(d=thickness);
            translate([thickness/2, height-thickness/2, width - thickness/2])
                sphere(d=thickness);
        }

    // TOP STRINGER
    translate([0, height, thickness/2])
        hull(){
            translate([thickness/2, -thickness/2, 0])
                sphere(d=thickness);
            translate([thickness/2, -thickness/2, width - thickness])
                sphere(d=thickness);
            translate([totalLength - thickness/2, -thickness/2, 0])
                sphere(d=thickness);
            translate([totalLength - thickness/2, -thickness/2, width - thickness])
                sphere(d=thickness);
        }

    // BOTTOM STRINGER
    translate([0, height/2 + thickness/2, thickness/2])
        hull(){
            translate([thickness/2, -thickness/2, 0])
                rotate([0, 90, 0])
                    cylinder(h=1, d=thickness);
            translate([thickness/2, -thickness/2, width - thickness])
                rotate([0, 90, 0])
                    cylinder(h=1, d=thickness);
            translate([totalLength - .75*thickness, -thickness/2, 0])
                rotate([0, 90, 0])
                    cylinder(h=1, d=thickness);
            translate([totalLength - .75*thickness, -thickness/2, width - thickness])
                rotate([0, 90, 0])
                    cylinder(h=1, d=thickness);
        }

    // FRONT ANGLED SUPPORT
    translate([0, height, 0])
        hull(){
            translate([0, -thickness/4, thickness/2])
                rotate([-45, 90, 0])
                    translate([0, -thickness/2, 1])
                        sphere(d=thickness);
            translate([0, -thickness/4, width - thickness/2])
                rotate([-45, 90, 0])
                    translate([0, -thickness/2, 1])
                        sphere(d=thickness);
            translate([0, 0, thickness/2])
                rotate([-45, 90, 0])
                    translate([0, -thickness/2, totalLength / sin(angle)/2 - thickness/2])
                        sphere(d=thickness);
            translate([0, 0, width - thickness/2])
                rotate([-45, 90, 0])
                    translate([0, -thickness/2, totalLength / sin(angle)/2 - thickness/2])
                        sphere(d=thickness);
        }

    // BACK ANGLED SUPPORT
    translate([0, height, 0])
        hull(){
            translate([totalLength - thickness/2, -thickness/2, thickness/2])
                        sphere(d=thickness);
            translate([totalLength - thickness/2, -thickness/2, width - thickness/2])
                        sphere(d=thickness);
            translate([0, 0, thickness/2])
                rotate([-45, 90, 0])
                    translate([0, -thickness/2, totalLength / sin(angle)/2 - thickness/2])
                        sphere(d=thickness);
            translate([0, 0, width - thickness/2])
                rotate([-45, 90, 0])
                    translate([0, -thickness/2, totalLength / sin(angle)/2 - thickness/2])
                        sphere(d=thickness);
        }

    // FRONT CLIP
    translate([thickness/2, height-thickness/2, thickness/2]) {
        hull() {
            sphere(d=thickness);
            translate([0, 0, width - thickness])
                sphere(d=thickness);
            rotate([0, 0, 45]) {
                translate([0, slotHeight + thickness, 0])
                    sphere(d=thickness);
                translate([0, slotHeight + thickness, width - thickness])
                    sphere(d=thickness);
            }
        }
        rotate([0, 0, 45]) {
            translate([0, slotHeight + thickness, 0])
                hull() {
                    sphere(d=thickness);
                    translate([0, 0, width - thickness])
                        sphere(d=thickness);
                    translate([1.5*thickness, 0, 0]) {
                        sphere(d=thickness);
                        translate([0, 0, width - thickness])
                            sphere(d=thickness);
                    }
                }
        }
    }

}
