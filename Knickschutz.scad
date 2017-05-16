module Stecker(knickschutzlaenge) {
    steckerbreite = 7.2;
    steckerhoehe = 4.6;
    steckerlaenge = 12;
    union() {
        for(i=[-1, 1]) {
            translate([i * (steckerbreite / 2 - steckerhoehe / 2), 0, 0]) {
                cylinder(d=steckerhoehe, h=steckerlaenge, $fn=32);
            }
        }
        translate([-(steckerbreite/2-steckerhoehe/2), -steckerhoehe/2, 0]) {
            cube([steckerbreite-steckerhoehe, steckerhoehe, steckerlaenge]);
        }
        rotate([180, 0, 0]) {
            translate([0, 0, -1]) {
                cylinder(d=4.1, h=knickschutzlaenge+1, $fn=32);
                cylinder(d=3.05, h=71, $fn=32);
            }
        }
    }
}

module Ausschnitt(breite, dicke) {
    translate([-dicke/2, -breite/2, sqrt(2)*dicke/2]) {
        cube([dicke, breite, breite/2]);
    }
    translate([0, 0, sqrt(2)*dicke/2]) {
        rotate([0, 45, 0]) {
            cube([sqrt(2)*dicke/2, breite, sqrt(2)*dicke/2], center=true);
        }
    }
}

module Knickschutz(laenge, durchmesser) {
    difference() {
        union() {
            cylinder(d1=durchmesser-2, d2=durchmesser, h=1, $fn=64);
            translate([0, 0, 1]) {
                cylinder(d=durchmesser, h=5, $fn=64);
            }
            translate([0, 0, 6]) {
                cylinder(d1=durchmesser, d2=4.5, h=laenge-6, $fn=64);
            }
        }
        for(i=[0:(laenge-6)/4]) {
            for(j=[-1, 1]) {
                translate([j*0.2, 0, 6+i*4]) {
                    rotate([0, j*90, 0]) {
                        Ausschnitt(durchmesser+1, 1);
                    }
                }
            }
        }
        for(i=[0:(laenge-6)/4]) {
            for(j=[-1, 1]) {
                translate([0, j*0.2, 8+i*4]) {
                    rotate([0, j*90, 90]) {
                        Ausschnitt(durchmesser+1, 1);
                    }
                }
            }
        }
    }
}

module halbesDruckteil() {
    difference() {
        translate([4.9, 0, 0.4]) {
            rotate([0, -90, 0]) {
                Knickschutz(47.5, 10);
            }
        }
        rotate([0, 90, 0]) {
            translate([-0.4, 0, 0]) {
                Stecker(10.5);
            }
        }
        translate([-45, -6, -6]) {
            cube([52, 12, 6]);
        }
    }
}

for(i=[-1, 1]) {
    translate([i*4.5, i*18.8, 0]) {
        rotate([0, 0, i*90]) {
            halbesDruckteil();
        }
    }
}