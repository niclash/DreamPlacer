//   Copyright 2020, Niclas Hedhman
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

include <NopSCADlib/lib.scad>
use <L-profile.scad>

position = -28;
stepper = NEMA17;

if( $preview ) { 
  head_assembly();
}

module head_assembly() 
  assembly("head") {
  translate([0,0,20])
    rotate([90,0,0])
      head_plate(); 
  translate([14,-4,5])
    rotate([90,90,0])
      picker_assembly(-position);
  
  translate([-14,-4,5])
    rotate([90,90,0])
      picker_assembly(position);
 
  translate([38,4,109])
    rotate([90,0,0])
      NEMA(stepper);
      
  translate([-38,4,109])
    rotate([90,0,0])
      NEMA(stepper);
      
  translate([0,64,82]) horiz_plate();

  translate([-30,4,78]) rotate([0,90,0]) extrusion_corner_bracket(E40_corner_bracket); 
      
  translate([30,4,78]) rotate([0,90,0]) extrusion_corner_bracket(E40_corner_bracket);      
      
      
  translate([38,-2,0]) pulley_belt();  
  translate([-38,-2,0]) pulley_belt();  
  translate([0,25,-90]) rotate([0,180,-90]) camera(rpi_camera_v2);
  
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
    sheet_2D(AL8, 120, 240, [3,3,3,3] );
    translate([38,89]) 
      NEMA_screw_positions(stepper)
        circle(d=3.2);
    translate([38,89,-5])
      circle(NEMA_big_hole(stepper) );
    translate([-38,89]) 
      NEMA_screw_positions(stepper)
        circle(d=3.2);
    translate([-38,89,-5])
      circle(NEMA_big_hole(stepper) );
    
    translate([30,38])
      circle(d=5.2);
    translate([-30,38])
        circle(d=5.2);

    hull() {
      translate([38,-100])
        circle(d=5);
      translate([38,-110])
        circle(d=5);
    }
    hull() {
      translate([-38,-100])
        circle(d=5);
      translate([-38,-110])
        circle(d=5);
    }
    translate([0,-15]) {
      translate([-13,13])
        circle(d=4.2);
      translate([13,13])
        circle(d=4.2);
      translate([-13,-13])
        circle(d=4.2);
      translate([13,-13])
        circle(d=4.2);
      translate([14,-50]) rotate(90) rail_hole_positions(MGN7, 100)  
        circle(d=2.1);
      translate([-14,-50]) rotate(90) rail_hole_positions(MGN7, 100)  
        circle(d=2.1);
    }
  }
}

module head_plate() {
  render_2D_sheet(AL8)
    head_plate_dxf();
  pitch=NEMA_hole_pitch(stepper)/2;
  holes=[[-pitch,-pitch,4.05],[pitch,-pitch,4.05],[-pitch,pitch,4.05],[pitch,pitch,4.05]];
  translate([38,89,0])
    for( hole = holes )
      translate(hole)
        screw(M3_cs_cap_screw, 12 );
  translate([-38,89,0])
    for( hole = holes )
      translate(hole)
        screw(M3_cs_cap_screw, 12 );
  translate([14,-65,6.5]) rotate(90) rail_hole_positions(MGN7, 100)
    screw(M2_cap_screw, 10 );
  translate([-14,-65,6.5]) rotate(90) rail_hole_positions(MGN7, 100)
    screw(M2_cap_screw, 10 );

  translate([30,38,4.05]) rotate(90) {
    screw(M5_cs_cap_screw, 20 );
    translate([0,0,-11]) washer(M5_washer);
    translate([0,0,-11]) rotate([0,180,0]) nut(M5_nut, nyloc = true);
  }
  translate([-30,38,4.05]) rotate(90) {
    screw(M5_cs_cap_screw, 20 );
    translate([0,0,-11]) washer(M5_washer);
    translate([0,0,-11]) rotate([0,180,0]) nut(M5_nut, nyloc = true);
  }
}

module pulley_belt() {
  translate([0,0,109]) rotate([90,0,0]) pulley(GT2x20ob_pulley);
  translate([0,-6,-90]) rotate([90,0,0]) pulley(GT2x20_plain_idler);
  translate([0,-10,0]) rotate([90,0,0]) belt(GT2x6, [
    [-6,112,0],[-3,114,0],[-2,115,0],[0,116,0],[2,115,0],[3,114,0],[6,112,0],
    [6,-94,0],[3,-96,0],[2,-97,0],[0,-98,0],[-2,-97,0],[-3,-96,0],[-6,-94,0]
  ]);
  translate([0,-14.5,-90]) rotate([90,0,0]) screw_and_washer(M4_cap_screw, 30 );
  translate([0,-6,-90]) rotate([-90,0,0]){
    washer(screw_washer(M4_cap_screw));
    nut(screw_nut(M4_cap_screw));
    translate([0,0,3]) washer(screw_washer(M4_cap_screw));
  }
  translate([0,6,-90]) rotate([-90,0,0]){
    washer(screw_washer(M4_cap_screw));
    nut(screw_nut(M4_cap_screw));
  }
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
    translate([0,-2,-2])
    rotate([0,0,180])
      L_shape(2,30,30,25);
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
    translate([-30,20]) sheet_2D(AL8, 180, 160, [3,3,3,3] );
    holes = [[-12,-80,5.2],[12,-80,5.2],[-12,-40,5.2],[12,-40,5.2],[12,-40,5.2],[30,-109,5.2], [-30,-109,5.2], [50,20,2.5], [50,-72,2.5], [-65,20,2.5], [-65,-72,2.5], [50,-51.3,2.5], [-51.6,20,2.5], [-51.6,-51.3,2.5]];
    translate([0,68,0]) for(h=holes)
      translate(h)
        circle(d=h[2]);
  }
}

module horiz_plate() {
  render_2D_sheet(AL8)
    horiz_plate_dxf();
  translate([30,-41,4.05]) {
      screw(M5_cs_cap_screw,20);
      translate([0,0,-11]) washer(M5_washer);
      translate([0,0,-11]) rotate([180,0,0]) nut(M5_nut, nyloc = true);
  }
  translate([-30,-41,4.05]) {
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

