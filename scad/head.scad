include <NopSCADlib/lib.scad>

position = 0;
stepper = NEMA17;

if( $preview ) { 
  head_assembly();
}

module head_assembly() 
  assembly("head") {
  translate([0,0,20])
    rotate([90,0,0])
      head_plate(); 
  translate([30,-4,0])
    rotate([90,90,0])
      picker_assembly(position);
  
  translate([-30,-4,0])
    rotate([90,90,0])
      picker_assembly(position);
 
  translate([0,4,115])
    rotate([90,0,0])
      NEMA(stepper);
  
}

module head_plate_dxf() {
  dxf("head_plate");
  difference() {
  sheet_2D(AL8, 100, 240, [3,3,3,3] );
  NEMA_screw_positions(stepper)
    circle(d=3.2);
  translate([0,95,-5])
    circle(NEMA_big_hole(stepper) );
  }
}

module head_plate() {
  render_2D_sheet(AL8)
    head_plate_dxf();
    
  pitch=NEMA_hole_pitch(stepper)/2;
  holes=[[-pitch,-pitch,4.05],[pitch,-pitch,4.05],[-pitch,pitch,4.05],[pitch,pitch,4.05]];
  translate([0,95,0])
    for( hole = holes )
      translate(hole)
        screw(M3_cs_cap_screw, 12 );
    
  
}

module picker_assembly(position) 
  assembly("picker") {
    nema=NEMA8;
    rail_assembly(MGN7, 200, position );
    translate([position+10,0,22]) {
        translate([0,0,-12]) rotate([90,0,-90]) pick_bracket(nema);
        translate([0,0,3]) rotate([0,90,0]) {
          NEMA(nema);
          color("silver") translate([0,0,-37]) cylinder(h=7,d=5);
        }
    }
  }

module pick_bracket(nema) {
  difference() {
    L_shape(AL2,30,30,30);
    translate([0,15,-2.5]) linear_extrude(3) nema_holes_dxf(nema);
    translate([0,0.5,15]) rotate([90,0,0]) linear_extrude(3) rail_holes_dxf();
  }
}
module rail_holes_dxf() {
  dxf("rail_holes");
      translate([-6,-4,4.05]) circle(d=2.1);
      translate([-6,4,4.05]) circle(d=2.1);
      translate([6,-4,4.05]) circle(d=2.1);
      translate([6,4,4.05]) circle(d=2.1);
}

module nema_holes_dxf(nema) {
  dxf("nema_holes");
  big_hole = NEMA_big_hole(nema);
  union() {
    NEMA_screw_positions(nema)
      circle(d=2.0);
    circle(big_hole );
  }
}

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
