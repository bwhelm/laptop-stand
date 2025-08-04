$fn= $preview ? 32 : 64;               // render more accurately than preview

// =============================
// ===== ADJUSTABLE VALUES =====
// =============================

length = 100;                           // length of angled platform in mm
height = 105;                           // height of platform in mm  ==> 100
angle = 37;                             // angle of platform in degrees
width = 10;                             // width in mm
slotHeight = 11;                        // slot height in mm
thickness = 6.0;                        // thickness of slot support
laptopDistance = 150;                   // distance between supports for laptop
// laptopDistance = 190;                   // distance between supports for laptop
// tabletDistance = 110;                   // distance between supports for tablet
pinFromEnd = 5;                         // distance from end of crossbar to slot

// =============================
// ===== CALCULATED VALUES =====
// =============================

totalLength = length / cos(angle);      // length of bottom
crossbarWidth = laptopDistance + 2*pinFromEnd + thickness;    // width of crossbar in mm

// =============================
// ========= THE MODEL =========
// =============================

module legPlank(x, y, z) {  // Flat bottom for legs, otherwise rounded edges
    hull(){
        translate([0, 1, 0])
            rotate([90, 0, 0])
            cylinder(h=1, d=x);
        translate([0, 1, z])
            rotate([90, 0, 0])
            cylinder(h=1, d=x);
        translate([0, y, 0])
            sphere(d=x);
        translate([0, y, z])
            sphere(d=x);
    }
}

module plank(x, y, z) {  // Rounded edges on all sides
    hull(){
        translate([0, 0, 0])
            sphere(d=x);
        translate([0, 0, z])
            sphere(d=x);
        translate([0, y, 0])
            sphere(d=x);
        translate([0, y, z])
            sphere(d=x);
    }
}

module side() {

        // FRONT LEG
        translate([0, 0, 0])
            legPlank(thickness, height, width);

        // BACK LEG
        translate([totalLength, 0, 0])
            legPlank(thickness, height, width);

        // TOP STRINGER
        translate([0, height, 0])
            difference() {
                rotate([0, 0, -90])
                    plank(thickness, totalLength, width);
                // cut out hole for pin from crossbar: one in the middle
                translate([totalLength / 2, thickness, width/2])
                    rotate([90, 0, 0])
                        cylinder(h=thickness*2, d=width/3 + .1);
            }

        // BOTTOM STRINGER
        translate([0, height/2, 0])
            difference() {
                rotate([0, 0, -90])
                    plank(thickness, totalLength, width);
                // cut out hole for pin from crossbar: two near ends
                translate([width/3 + thickness/2 + .5, thickness, width/2])
                    rotate([90, 0, 0])
                        cylinder(h=thickness*2, d=width/3 + .1);
                translate([totalLength - width/3 - thickness/2 - .5, thickness, width/2])
                    rotate([90, 0, 0])
                        cylinder(h=thickness*2, d=width/3 + .1);
            }

        // FRONT ANGLED SUPPORT
        translate([0, height, 0])
            rotate([0, 0, -(90-angle)]) {
                difference() {
                    plank(thickness, length, width);
                    translate([-thickness/2 - .1, 0, width/2])  // partial hole to adjust tablet angle
                        rotate([0, 90, 0])
                            translate([0, 22, 0]) // distance up from bottom of angled support
                                cylinder(h=thickness/2, d=width/3 + .1);
                }
            }

        // BACK ANGLED SUPPORT
        translate([totalLength, height, 0])
            rotate([0, 0, angle])
            plank(thickness, (length) * tan(angle), width);

        // FRONT CLIP
        translate([0, height, 0]) {
            rotate([0, 0, angle]) {
                plank(thickness, slotHeight + thickness, width);
                translate([0, slotHeight + thickness, 0])
                    rotate([0, 0, -90])
                    plank(thickness, 1.5*thickness, width);
            }
        }

}


module crossbar() {
    union() {
        translate([-thickness/2, 0, 0])
            plank(thickness, crossbarWidth, width/4);

        // PINS
        translate([-thickness*2 + .2, thickness/2 + pinFromEnd, width/8]) {
            rotate([0, 90, 0])
                cylinder(h=thickness, d=width/3);
            translate([0, laptopDistance, 0])
                rotate([0, 90, 0])
                    cylinder(h=thickness, d=width/3);
        }

    }
}

side();

translate([totalLength/2 + 26, 3*height - 28, 0])
    rotate([0, 0, 180])
        side();

rotate([0, 90, 0])  // Put flat on bed
    translate([thickness/2, thickness/2, totalLength + thickness + 2])
    {
        crossbar();
        translate([0, 0, width/2 + thickness/2 + 1])
            crossbar();
        translate([0, 0, 2*(width/2 + thickness/2 + 1)])
            crossbar();
    }
