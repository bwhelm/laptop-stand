$fn= $preview ? 32 : 128;               // render more accurately than preview

// =============================
// ===== ADJUSTABLE VALUES =====
// =============================

width = 12;                             // width in mm
thickness = 4.5;                        // thickness of slot support
laptopDistance = 210;                   // distance between supports for laptop
tabletDistance = 110;                   // distance between supports for tablet
slotFromEnd = 5;                        // distance from end of crossbar to slot

// Calculated values
crossbarWidth = laptopDistance + width + 10;    // width of crossbar in mm

// NOTCH IN CROSSBAR
module notch(distance) {
    translate([crossbarWidth/2 - width/2 + thickness/2 + .25 + distance/2, 0, width/2 - thickness/2])
        hull() {
            translate([0, 5, -thickness/2])
                sphere(d=thickness + .5);
            translate([0, -5, -thickness/2])
                sphere(d=thickness + .5);
            translate([width - thickness, 5, -thickness/2])
                sphere(d=thickness + .5);
            translate([width - thickness, -5, -thickness/2])
                sphere(d=thickness + .5);
            translate([-thickness/2 - .25, -thickness/2 - .5, -thickness - 2])
                cube([width + .5, thickness + 1, thickness]);
        }
}

module crossbar() {
    difference() {
        hull() {  // MAIN CROSSBAR
            translate([0, 0, 0])
                sphere(d=thickness);
            translate([0, 0, thickness * 2])
                sphere(d=thickness);
            translate([crossbarWidth, 0, 0])
                sphere(d=thickness);
            translate([crossbarWidth, 0, thickness * 2])
                sphere(d=thickness);
        }

        // NOTCHES
        notch(-laptopDistance);
        notch(laptopDistance);
        notch(-tabletDistance);
        notch(tabletDistance);

    }
}

rotate([90, 0, 0])  // Put flat on bed
{
    crossbar();
    translate([0, 0, width + 3])
        crossbar();
    translate([0, 0, 2*(width + 3)])
        crossbar();
}
