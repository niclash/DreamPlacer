include <NopSCADlib/lib.scad>

position = 0;

if( $preview ) { 
  head_assembly();
}

module head_assembly() 
  assembly("head") {
   
  stepper = NEMA17;
  translate([0,61,87])
    rotate([0,0,0])
      sheet(AL8, 100, 114, [3,3,3,3] );
  rotate([90,0,0]){
    difference() {
      translate([0,20,0])
        sheet(AL8, 100, 240, [3,3,3,3] );
      union() {
        translate([-13,13,4.05])
          screw(M3_cs_cap_screw, 10 );
        translate([13,13,4.05])
          screw(M3_cs_cap_screw, 10 );
        translate([-13,-13,4.05])
          screw(M3_cs_cap_screw, 10 );
        translate([13,-13,4.05])
          screw(M3_cs_cap_screw, 10 );

    
        // Stepper holes  
        translate([0,115,-5])
          cylinder(h=10,r=NEMA_big_hole(stepper) );

        pitch=NEMA_hole_pitch(stepper)/2;
        holes=[[-pitch,-pitch,4.05],[pitch,-pitch,4.05],[-pitch,pitch,4.05],[pitch,pitch,4.05]];
        translate([0,115,0])
          for( hole = holes )
            translate(hole)
              screw(M3_cs_cap_screw, 10 );
    }
  }
  translate([30,0,4])
    rotate([0,0,-90])
      picker_assembly(position);
  
  translate([-30,0,4])
    rotate([0,0,-90])
      picker_assembly(position);
  }
  
  translate([0,4,115])
    rotate([90,0,0])
      NEMA(stepper);
  
}

module picker_assembly(position) 
  assembly("picker") {
    stepper=NEMA8_H;
    rail_assembly(MGN7, 200, position );
    translate([position+10,0,10]) {
      rotate([0,0,90]) {
        difference() {
          L_shape(AL2, w1=30, w2=30, length=30);
          holes1=[[-6,-4,4.05],[-6,4,4.05],[6,-4,4.05],[6,4,4.05]];
          translate([0,10,-4.05])
            for( hole = holes1 )
              translate(hole)
                screw(M2_cs_cap_screw, 6 );
          // Stepper holes  
          rotate([90,0,0]) {
            translate([0,12,-3.1])
              cylinder(h=10,r=NEMA_big_hole(stepper) );
            pitch=NEMA_hole_pitch(stepper)/2;
            holes2=[[-pitch,-pitch,2.05],[pitch,-pitch,2.05],[-pitch,pitch,2.05],[pitch,pitch,2.05]];
            translate([0,12,0])
              for( hole = holes2 )
                translate(hole)
                  screw(M2_cs_cap_screw, 6 );      
          }
        }
      }
      translate([0,0,12]) {
        rotate([0,90,0]) {
          NEMA(stepper);
          color("silver")
            translate([0,0,-37])
          cylinder(h=7,d=5);
        }
      }
    }
  }

module L_shape(material, w1, w2, length){
  translate([0,-sheet_thickness(material),-sheet_thickness(material)])
    union() {
      translate([0,w1/2,sheet_thickness(material)/2])
        sheet(material, length, w1 );
      translate([0,sheet_thickness(material)/2, w2/2])
        rotate([90,0,0])
          sheet(material, length, w2 );
    }
}
