include <NopSCADlib/lib.scad>
use <L-profile.scad>

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
  translate([17,-4,5])
    rotate([90,90,0])
      picker_assembly(-position);
  
  translate([-17,-4,5])
    rotate([90,90,0])
      picker_assembly(position);
 
  translate([0,4,109])
    rotate([90,0,0])
      NEMA(stepper);
      
  translate([0,64,82]) horiz_plate();

  translate([-20,4,78]) rotate([0,90,0]) extrusion_corner_bracket(E40_corner_bracket);      
  translate([20,4,78]) rotate([0,90,0]) extrusion_corner_bracket(E40_corner_bracket);      
      
      
  pulley_belt();  
  
  translate([0,0,5]) rotate([90,0,0]) {
    translate([-13,13,4.05])
      screw(M4_cs_cap_screw, 16 );
    translate([13,13,4.05])
      screw(M4_cs_cap_screw, 16 );
    translate([-13,-13,4.05])
      screw(M4_cs_cap_screw, 16 );
    translate([13,-13,4.05])
      screw(M4_cs_cap_screw, 16 );
  }
}

module head_plate_dxf() {
  dxf("head_plate");
  difference() {
    sheet_2D(AL8, 80, 240, [3,3,3,3] );
    translate([0,89]) 
      NEMA_screw_positions(stepper)
        circle(d=3.2);
    translate([0,89,-5])
      circle(NEMA_big_hole(stepper) );
    translate([0,-15]) {
      translate([-13,13,4.05])
        circle(d=4.2);
      translate([13,13,4.05])
        circle(d=4.2);
      translate([-13,-13,4.05])
        circle(d=4.2);
      translate([13,-13,4.05])
        circle(d=4.2);
      translate([17,-50]) rotate(90) rail_hole_positions(MGN7, 100)  
        circle(d=2.1);
      translate([-17,-50]) rotate(90) rail_hole_positions(MGN7, 100)  
        circle(d=2.1);
    }
  }
}

module head_plate() {
  render_2D_sheet(AL8)
    head_plate_dxf();
  pitch=NEMA_hole_pitch(stepper)/2;
  holes=[[-pitch,-pitch,4.05],[pitch,-pitch,4.05],[-pitch,pitch,4.05],[pitch,pitch,4.05]];
  translate([0,89,0])
    for( hole = holes )
      translate(hole)
        screw(M3_cs_cap_screw, 12 );
  translate([17,-65,6.5]) rotate(90) rail_hole_positions(MGN7, 100)
    screw(M2_cap_screw, 10 );
  translate([-17,-65,6.5]) rotate(90) rail_hole_positions(MGN7, 100)
    screw(M2_cap_screw, 10 );
}

module pulley_belt() {
  translate([0,-4,109]) rotate([90,0,0]) pulley(GT2x20ob_pulley);
  start=[-2,-position-35,0];
  end=[2,position-35,0];
  translate([0,-14,0]) rotate([90,0,0]) belt(GT2x6, [start,[-6,112,0],[-3,114,0],[-2,115,0],[0,116,0],[2,115,0],[3,114,0],[6,112,0],end], gap_pos=[0,-35,0], gap=100);
}

module picker_assembly(position) 
  assembly("picker") {
    nema=NEMA8;
    translate([50,0,0]) rail_assembly(MGN7, 100, position );
    translate([position+10,0,22]) {
        translate([55,0,-12]) rotate([90,0,-90]) pick_bracket(nema);
        translate([55,0,3]) rotate([0,90,0]) {
          NEMA(nema);
          color("silver") translate([0,0,-37]) cylinder(h=7,d=5);
        }
        translate([57,0,3]) rotate([0,90,0]) nozzle();
    }
  }

module pick_bracket(nema) {
  difference() {
    L_shape(AL2,30,30,30);
    translate([0,15,-2.5]) linear_extrude(3) nema_holes_dxf(nema);
    translate([0,0.5,15]) rotate([90,0,0]) linear_extrude(3) rail_holes_dxf();
  }
  translate([0,-7.95,15]) rotate([-90,0,0]) carriage_hole_positions(MGN7_carriage) screw(M2_cs_cap_screw, 6);
  translate([0,15,-2.05]) rotate([180,0,0]) NEMA_screw_positions(nema) {
      screw(M2_cs_cap_screw, 6);
  }
}
module rail_holes_dxf() {
  dxf("rail_holes");
  carriage_hole_positions(MGN7_carriage) circle(d=2.1);
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

module horiz_plate_dxf() {
  dxf("horiz_plate");
  difference() {
    translate([0,15]) sheet_2D(AL8, 80, 150, [3,3,3,3] );
    holes = [[-12,-80,5.2],[12,-80,5.2],[-12,-40,5.2],[12,-40,5.2],[12,-40,5.2],[20,-109,5.2], [-20,-109,5.2]];
    translate([0,68,0]) for(h=holes)
      translate(h)
        circle(d=h[2]);
  }
}

module horiz_plate() {
  render_2D_sheet(AL8)
    horiz_plate_dxf();
  translate([20,-41,4.05]) {
      screw(M5_cs_cap_screw,20);
      translate([0,0,-11]) washer(M5_washer);
      translate([0,0,-11]) rotate([180,0,0]) nut(M5_nut, nyloc = true);
  }
  translate([-20,-41,4.05]) {
      screw(M5_cs_cap_screw,20);
      translate([0,0,-11]) washer(M5_washer);
      translate([0,0,-11]) rotate([180,0,0]) nut(M5_nut, nyloc = true);
  }
  translate([12,-12,4.05]) screw(M5_cs_cap_screw,20);
  translate([-12,-12,4.05]) screw(M5_cs_cap_screw,20);
  translate([12,28,4.05]) screw(M5_cs_cap_screw,20);
  translate([-12,28,4.05]) screw(M5_cs_cap_screw,20);
}

module nozzle() {
    color("#b5a642") cylinder(24,d=15);
    translate([0,0,24]) color("gray") cylinder(5,d=10);
    translate([0,0,29]) color("green") cylinder(2,d=20);
    translate([0,0,31]) color("green") cylinder(5,d=14);
    translate([0,0,36]) color("gray") cylinder(5,d=5);   
    translate([0,0,41]) color("green") cylinder(2,r1=3, r2=2);
    translate([0,0,43]) color("black") cylinder(8,r1=2.5, r2=1);   
}

