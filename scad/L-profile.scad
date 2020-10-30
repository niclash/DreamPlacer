include <NopSCADlib/lib.scad>

module L_shape(material, w1, w2, length) {
  vitamin(str("L-profile(",w1,"x",w2,") : L-profile(",w1,"x",w2,") ", length, "mm" ));
  color("silver")
    translate([0,-sheet_thickness(material),-sheet_thickness(material)])
      union() {
        translate([0,w1/2,sheet_thickness(material)/2])
          sheet(material, length, w1 );
        translate([0,sheet_thickness(material)/2, w2/2])
          rotate([90,0,0])
            sheet(material, length, w2 );
      }
}
