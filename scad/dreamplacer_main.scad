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

$fn=25;


include <NopSCADlib/lib.scad>
use <./head.scad>
use <./L-profile.scad>
use <./ParametricCableChain.scad>

WIDTH=1498;
LENGTH=1000;
FEEDER_GAP = 100;
X_AXIS_HEIGHT = 120;
GANTRY_POS = 170;
//GANTRY_POS = sin($t*360)*LENGTH/3;
HEAD_POS = 200;
//HEAD_POS = sin($t*180)*LENGTH/3;
BACK_OFFSET=150;
Y_AXIS_MOTOR=Lichuan_M03530_80ST;
X_AXIS_MOTOR=Lichuan_M03530_80ST;
KP_BLOCK=KP001;

if($preview)
  main_assembly();

module main_assembly()
  assembly("main") {
    frame_assembly();
    build_bed(WIDTH,LENGTH);
    translate([0, GANTRY_POS, X_AXIS_HEIGHT+78]) 
      xaxis_assembly();
    translate([WIDTH/2+40,37,18]) rotate([-90,180,-90]) { 
      L_shape(2, 30, 30, LENGTH+66);
      color("darkgray") 
        for( p = [ 0 : 250 : LENGTH/2 ] ) {
          translate([p,-20,2.05]) screw(M8_cs_cap_screw, 16 );
          if( p != 0 )
            translate([-p,-20,2.05]) screw(M8_cs_cap_screw, 16 );
        }
    }
    if( !is_undef($pose) )
      y_dragchain();

    x = WIDTH/2+20;
    translate([x,0,X_AXIS_HEIGHT/2])
      right_side_frame_assembly();  // Right
      
    translate([-x,0,X_AXIS_HEIGHT/2])
      left_side_frame_assembly(); // Left
  }

    
module xaxis_assembly()
  assembly("xaxis") {
    length=WIDTH;
    motor = X_AXIS_MOTOR;
    shaft_length = shaft_length(servo_shaft(motor));
    translate([0,0,-30]) rotate([0,90,0])
      extrusion(E4080,length+140);

    translate([0,-40,-30]) rotate([90,0,0]) {
      rail_assembly(HGH15CA, length, HEAD_POS );
      rail_hole_positions(HGH15CA, length)  
        translate([0,0,10])
          screw(M4_cap_screw, 20);
    }
    translate([3,0,17]) rotate([90,0,90])
      lead_screw_assembly(length, HEAD_POS+6, 180); 
    x_axis_standoffs(length);
    translate([HEAD_POS,-72,-35])
      head_assembly();
    
    translate([length/2 + shaft_length + 39,0,25])
      rotate([0,-90,0]) {
        at_z(-1) servo(motor);
      }
    translate([-length/2-74,0,-78]) rotate([90,0,-90])
      bracket_left();
        
    translate([length/2+74,0,-78]) rotate([90,0,-90])
      bracket_right();
      
    translate([0,40,-45])
      rotate([-90,0,0])
      L_shape(2, 30, 30, WIDTH+140);

    if( !is_undef($pose) )
      x_dragchain();

}


module x_axis_standoffs(length) {
    translate([length/2-24,0,-6]) x_axis_screw_standoff_right();
    translate([-length/2+29,0,-6]) x_axis_screw_standoff_left();
}

module x_axis_screw_standoff_left_dxf() {
  dxf("x_axis_screw_standoff_left");
  difference() {
    sheet_2D(AL8, 60,80, 3);
    translate([15,20]) circle(d=8.2);
    translate([15,-20]) circle(d=8.2);
    translate([-15,20]) circle(d=8.2);
    translate([-15,-20]) circle(d=8.2);
    translate([0,-23]) circle(d=5.0);
    translate([0,23]) circle(d=5.0);
  }
}

module x_axis_screw_standoff_left(){
  render_2D_sheet(AL8) 
    x_axis_screw_standoff_left_dxf();
  // screws
  translate([0,23,36]) screw(M6_cap_screw, 40);
  translate([0,-23,36]) screw(M6_cap_screw, 40);
  translate([15,20,4.05]) screw(M8_cs_cap_screw, 16);
  translate([15,-20,4.05]) screw(M8_cs_cap_screw, 16);
  translate([-15,20,4.05]) screw(M8_cs_cap_screw, 16);
  translate([-15,-20,4.05]) screw(M8_cs_cap_screw, 16);
}

module x_axis_screw_standoff_right_dxf() {
  dxf("x_axis_screw_standoff_right");
  difference() {
    sheet_2D(AL8, 60,80, 3);
    translate([20,20]) circle(d=8.2);
    translate([20,-20]) circle(d=8.2);
    translate([-20,20]) circle(d=8.2);
    translate([-20,-20]) circle(d=8.2);
    translate([6.5,-23]) circle(d=5.0);
    translate([6.5,23]) circle(d=5.0);
    translate([-6.5,-23]) circle(d=5.0);
    translate([-6.5,23]) circle(d=5.0);
  }
}

module x_axis_screw_standoff_right() {
  render_2D_sheet(AL8) 
    x_axis_screw_standoff_right_dxf();

  translate([6.5,23,36]) screw(M6_cap_screw, 40);
  translate([6.5,-23,36]) screw(M6_cap_screw, 40);
  translate([-6.5,23,36]) screw(M6_cap_screw, 40);
  translate([-6.5,-23,36]) screw(M6_cap_screw, 40);
  translate([20,20,4.05]) screw(M8_cs_cap_screw, 16);
  translate([20,-20,4.05]) screw(M8_cs_cap_screw, 16);
  translate([-20,20,4.05]) screw(M8_cs_cap_screw, 16);
  translate([-20,-20,4.05]) screw(M8_cs_cap_screw, 16);
}


module bracket_right_dxf() {
  dxf("bracket_right");
  holes = [[-12,-80,5.2],[12,-80,5.2],[-12,-40,5.2],[12,-40,5.2], 
           [-20,50,8.2], [20,50,8.2]];
  difference() {
    minkowski() {
      difference() {
        sheet_2D(AL8, 200, 300, 3);
        translate([0,105]) motor_mount_holes(X_AXIS_MOTOR);
        translate([50,23]) square([50,130]);
        translate([-100,23]) square([50,130]);
        translate([-100,-151]) square([50,130]);
        translate([50,-151]) square([50,130]);
        translate([-50,-150]) square([100,60]);
      }
      circle(2);
    }  
    translate([75,0,0])
      carriage_hole_positions(HGH20CA_carriage)
        circle(d=carriage_screw(HGH20CA_carriage)[3]+0.2);
    translate([-75,0,0])
      carriage_hole_positions(HGH20CA_carriage)
        circle(d=carriage_screw(HGH20CA_carriage)[3]+0.2);
    for(h=holes)
      translate(h)
        circle(d=h[2]);
  }
}
module bracket_right() {
  render_2D_sheet(AL8) 
    bracket_right_dxf();
  translate([12,-80,4.05]) screw(M5_cs_cap_screw, 16);
  translate([-12,-80,4.05]) screw(M5_cs_cap_screw, 16);
  translate([12,-40,4.05]) screw(M5_cs_cap_screw, 16);
  translate([-12,-40,4.05]) screw(M5_cs_cap_screw, 16);

  translate([-20,50,-4.05]) rotate([0,180,0]) screw(M8_cs_cap_screw, 24);
  translate([20,50,-4.05]) rotate([0,180,0]) screw(M8_cs_cap_screw, 24);
    
  translate([0,105]) motor_mount_screws(X_AXIS_MOTOR);
}

module bracket_left_dxf() {
  dxf("bracket_left");
  holes = [[-12,-80,5.2],[12,-80,5.2],[-12,-40,5.2],[12,-40,5.2], [-20,50,8.2], [20,50,8.2]];
  difference() {
    minkowski() {
      difference() {
        sheet_2D(AL8, 200, 180, 3);
        translate([50,23]) square([50,70]);
        translate([-100,23]) square([50,70]);
        translate([-100,-91]) square([50,70]);
        translate([50,-91]) square([50,70]);
        translate([-60,66]) square([120,30]);
      }
      circle(2);
    }
    translate([75,0,0])
      carriage_hole_positions(HGH20CA_carriage)
        circle(d=carriage_screw(HGH20CA_carriage)[3]+0.2);
    translate([-75,0,0])
      carriage_hole_positions(HGH20CA_carriage)
        circle(d=carriage_screw(HGH20CA_carriage)[3]+0.2);
    for(h=holes)
      translate(h)
        circle(d=h[2]);
  } 
  
}
module bracket_left() {
  render_2D_sheet(AL8) 
    bracket_left_dxf();
  translate([12,-80,-4.05]) rotate([0,180,0]) screw(M5_cs_cap_screw, 16);
  translate([-12,-80,-4.05]) rotate([0,180,0]) screw(M5_cs_cap_screw, 16);
  translate([12,-40,-4.05]) rotate([0,180,0]) screw(M5_cs_cap_screw, 16);
  translate([-12,-40,-4.05]) rotate([0,180,0]) screw(M5_cs_cap_screw, 16);
    
  translate([-20,50,4.05]) rotate([0,0,0]) screw(M8_cs_cap_screw, 24);
  translate([20,50,4.05]) rotate([0,0,0]) screw(M8_cs_cap_screw, 24);
}

module lead_screw_assembly(length,pos, rotation=0) {
  translate([0,6,-3]) {
    leadscrew(16 , length-65, 10, 1 );
    
    translate([0,0,length/2-15])
      rod(12,50);

    translate([0,0,length/2+15])
      rod(10,15);

    translate([0,0,-(length/2-30)])
      rod(12,15);

    translate([0,0,length/2+8])
      difference() {
        cylinder(h=55,d=40, $fn=100);
        translate([0,0,28])
          cylinder(h=28,d=19.2);
        translate([0,0,-1])
          cylinder(h=28,d=12.2);
      }

  }
  
  translate([0, 6, pos+11]) { 
    leadnut(SFU1610);
    rotate([0,180,rotation])
      difference() {
        linear_extrude(40)
          polygon([[-26,-20], [-26,8], [-13,20], [13,20],[26,8],[26,-20]]);
        translate([0,0,-5])
          cylinder(h=50,d=28);
        translate([20,-6,8]) rotate([90,0,0])
          cylinder(h=15,d=4);
        translate([-20,-6,8]) rotate([90,0,0])
          cylinder(h=15,d=4);
        translate([20,-6,32]) rotate([90,0,0])
          cylinder(h=15,d=4);
        translate([-20,-6,32]) rotate([90,0,0])
          cylinder(h=15,d=4);
      }
  }

  translate([0,6,length/2-23])
      bk12();

  translate([0,6,-(length/2-26)])
      bf12();
}

module bk12() {
   vitamin(str("Bearing(", "BK12", ") : Bearing BK12 " ));
   translate([0,0,-16])
      difference() {
        union() {
          translate([-30,-25,0])
            cube([60,32,25]);
          translate([-17.5,-16,0])
            cube([35,35,25]);
        }
        translate([23,0,13])
          cylinder(h=30,d=5.5,center=true);
        translate([-23,0,13])
          cylinder(h=30,d=5.5,center=true);
        translate([23,-18,13])
          cylinder(h=30,d=5.5,center=true);
        translate([-23,-18,13])
          cylinder(h=30,d=5.5,center=true);

        translate([-23,0,6])
          rotate([90,0,0])
            cylinder(h=50,d=6.6,center=true);
        translate([23,0,6])
          rotate([90,0,0])
            cylinder(h=50,d=6.6,center=true);
        translate([-23,0,18])
          rotate([90,0,0])
            cylinder(h=50,d=6.6,center=true);
        translate([23,0,18])
          rotate([90,0,0])
            cylinder(h=50,d=6.6,center=true);
      }
    translate([0,0,5])
      ball_bearing(BB6201);
    translate([0,0,-12])
      ball_bearing(BB6201);
}

module bf12() {
  vitamin(str("Bearing(", "BF12", ") : Bearing BF12 " ));
  translate([0,0,-10])
    difference() {
      union() {
        translate([-30,-25,0])
          cube([60,32,20]);
        translate([-17.5,-16,0])
          cube([35,35,20]);
      }
      translate([0,0,-5])
      cylinder(h=40,d=25);
      translate([23,0,13])
        cylinder(h=30,d=5.5,center=true);
      translate([-23,0,13])
        cylinder(h=30,d=5.5,center=true);
      translate([23,-18,13])
        cylinder(h=30,d=5.5,center=true);
      translate([-23,-18,13])
        cylinder(h=30,d=5.5,center=true);

      translate([-23,0,10])
        rotate([90,0,0])
          cylinder(h=50,d=6.6,center=true);
      translate([23,0,10])
        rotate([90,0,0])
          cylinder(h=50,d=6.6,center=true);
    }
  ball_bearing(BB6201);
}

module rail_block_assembly(length, pos){
  translate([0, 0, 0] )
    rail(HGH20CA, length );
  translate([pos-75,0,0])
    carriage(HGH20CA_carriage, HGH20CA );
  translate([pos+75,0,0])
    carriage(HGH20CA_carriage, HGH20CA );
  translate([0,0,12])
    rail_hole_positions(HGH20CA, length)
      screw(M5_cap_screw, 24);

  translate([pos-76,0,8.05])
    carriage_hole_positions(rail_carriage(HGH20CA))
      screw(M5_cs_cap_screw, 16);
  translate([pos+76,0,8.05])
    carriage_hole_positions(rail_carriage(HGH20CA))
      screw(M5_cs_cap_screw, 16);

}

module right_side_frame_assembly() 
  assembly("right_side_frame") {
    mirror([1,0,0])
      side_frame();
  }
  
module left_side_frame_assembly() 
  assembly("left_side_frame") {
    side_frame();
  }
  
module bracket_y_motor_dxf() {
  dxf("bracket_y_motor");
  motor = Y_AXIS_MOTOR;
  difference() {
    sheet_2D(AL8, 200, X_AXIS_HEIGHT + 40, 3);
    motor_mount_holes(motor);
    translate([80,X_AXIS_HEIGHT/2]) circle(d=6.3);
    translate([80,-X_AXIS_HEIGHT/2]) circle(d=6.3);
    translate([80,X_AXIS_HEIGHT/4]) circle(d=8.3);
    translate([80,0]) circle(d=8.3);
    translate([80,-X_AXIS_HEIGHT/4]) circle(d=8.3);
    translate([-100,-(X_AXIS_HEIGHT + 40)/2]) square([30,X_AXIS_HEIGHT+60]);
  }  
}
module bracket_y_motor() render_2D_sheet(AL8) bracket_y_motor_dxf();

module side_frame() {
    length = LENGTH;
    height = X_AXIS_HEIGHT;
    block_pos = GANTRY_POS;
    h = height/2;
    rotate([90,0,0]) {
      translate([0,h,-35]) 
        extrusion(E4040,length+70);
      translate([0,-h,-35]) 
        extrusion(E4040,length+70);
    }
    
    translate([-20,0,height/2]) 
      rotate([-90,0,90])
        rail_block_assembly(length, block_pos );
    
    at_y(length/2-50) extrusion(E4040,height-40);
    at_y(length/2+50) extrusion(E4040,height-40);
    at_y(-length/2+20) extrusion(E4040,height-40);
    
    translate([0,-length/2+40,-40]) rotate([90,0,90])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([0,-length/2+40,40]) rotate([-90,0,90])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([20,-length/2+20,-40]) rotate([90,0,0])
      extrusion_corner_bracket_assembly(E40_corner_bracket, screw_type=M8_cap_screw, nut_type = M8_sliding_t_nut);

    translate([0,length/2+40,-40]) rotate([90,0,-90])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([0,length/2+40,40]) rotate([-90,0,-90])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);

    translate([0,length/2-60,-40]) rotate([90,0,-90])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([0,length/2-60,40]) rotate([-90,0,-90])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);

    translate([20,length/2-150,-60]) rotate([0,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([20,length/2-190,-60]) rotate([180,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);

    translate([20,length/2-250,-60]) rotate([0,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([20,length/2-290,-60]) rotate([180,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);

    translate([20,-55,-60]) rotate([0,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([20,-95,-60]) rotate([180,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);

    translate([20,-length/2 + 40,-60]) rotate([0,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([20,-length/2 + 100,-60]) rotate([180,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);
    translate([20,-length/2 + 140,-60]) rotate([0,0,0])
      extrusion_inner_corner_bracket(E40_inner_corner_bracket, true);

    
    translate([-72,-16,0]) 
      rotate([-90,90,0])
        lead_screw_assembly(length,GANTRY_POS+25);
  
    motor=Y_AXIS_MOTOR;
    translate([-78, shaft_length( servo_shaft(motor) ) + length/2+39, 0])
      rotate([90,0,0]) {
        servo(motor);
        bracket_y_motor();
        motor_mount_screws(motor);
        translate([80,0,-4.01]) rotate([180,0,0]) color("darkgray") screw(M8_cs_cap_screw, 16);
        translate([80,-X_AXIS_HEIGHT/4,-4.01]) rotate([180,0,0]) color("darkgray") screw(M8_cs_cap_screw, 16);
        translate([80,X_AXIS_HEIGHT/4,-4.01]) rotate([180,0,0]) color("darkgray") screw(M8_cs_cap_screw, 16);
        translate([80,-X_AXIS_HEIGHT/2,-4.01]) rotate([180,0,0]) color("darkgray") screw(M5_cs_cap_screw, 16);
        translate([80,X_AXIS_HEIGHT/2,-4.01]) rotate([180,0,0]) color("darkgray") screw(M5_cs_cap_screw, 16);
      }
      translate([-50,-length/2,0]) {
        rotate([90,0,0])
          ballscrew_mount1();
      }
      translate([-50,length/2-26,0]) {
        rotate([90,0,0])
          ballscrew_mount2();
      }
}

module ballscrew_mount1_dxf() {
  dxf("ballscrew_mount1");
  difference() {
    sheet_2D(AL8, 140, X_AXIS_HEIGHT+40, 3);
    translate([-10,23]) circle(d=5.2);
    translate([-28,23]) circle(d=5.2);
    translate([-10,-23]) circle(d=5.2);
    translate([-28,-23]) circle(d=5.2);
      
    translate([50,0]) circle(d=8.2);
    translate([50,X_AXIS_HEIGHT/4]) circle(d=8.2);
    translate([50,-X_AXIS_HEIGHT/4]) circle(d=8.2);

    translate([50,X_AXIS_HEIGHT/2]) circle(d=5.2);
    translate([50,-X_AXIS_HEIGHT/2]) circle(d=5.2);
  }
}

module ballscrew_mount1() {
  unit = X_AXIS_HEIGHT/4;
  m8 = M8_cs_cap_screw;
  m5 = M5_cs_cap_screw;
  render_2D_sheet(AL8) 
    ballscrew_mount1_dxf();
  translate([50,0,4.01]) color("darkgray") screw(m8, 16);
  translate([50,-unit,4.01]) color("darkgray") screw(m8, 16);
  translate([50,unit,4.01]) color("darkgray") screw(m8, 16);
  translate([50,-2*unit,4.01]) color("darkgray") screw(m5, 16);
  translate([50,2*unit,4.01]) color("darkgray") screw(m5, 16);
    
  translate([-10,-23, 4.05]) { 
        screw(M5_cs_cap_screw, 40);
        at_z(-25.1) washer(M5_washer);
        at_z(-25.1) rotate([180,0,0]) nut(M5_nut, nyloc = true);
  }
  translate([-10,23, 4.05]) { 
        screw(M5_cs_cap_screw, 40);
        at_z(-25.1) washer(M5_washer);
        at_z(-25.1) rotate([180,0,0]) nut(M5_nut, nyloc = true);
  }
  translate([-28,-23, 4.05]) { 
        screw(M5_cs_cap_screw, 40);
        at_z(-25.1) washer(M5_washer);
        at_z(-25.1) rotate([180,0,0]) nut(M5_nut, nyloc = true);
  }
  translate([-28,23, 4.05]) { 
        screw(M5_cs_cap_screw, 40);
        at_z(-25.1) washer(M5_washer);
        at_z(-25.1) rotate([180,0,0]) nut(M5_nut, nyloc = true);
  }

}

module ballscrew_mount2_dxf() {
  dxf("ballscrew_mount2");
  difference() {
    sheet_2D(AL8, 140, X_AXIS_HEIGHT-42, 3);
    translate([-10,23]) circle(d=5.2);
    translate([-28,23]) circle(d=5.2);
    translate([-10,-23]) circle(d=5.2);
    translate([-28,-23]) circle(d=5.2);
      
    translate([50,0]) circle(d=8.2);
    translate([50,X_AXIS_HEIGHT/4]) circle(d=8.2);
    translate([50,-X_AXIS_HEIGHT/4]) circle(d=8.2);

    translate([50,X_AXIS_HEIGHT/2]) circle(d=5.2);
    translate([50,-X_AXIS_HEIGHT/2]) circle(d=5.2);
  }
}
module ballscrew_mount2() {
  unit = X_AXIS_HEIGHT/4;
  m8 = M8_cs_cap_screw;
  m5 = M5_cs_cap_screw;
  render_2D_sheet(AL8) 
    ballscrew_mount2_dxf();
  rotate([180,0,0]){  
    translate([50,0,4.01]) color("darkgray") screw(m8, 16);
    translate([50,-unit,4.01]) color("darkgray") screw(m8, 16);
    translate([50,unit,4.01]) color("darkgray") screw(m8, 16);

    translate([-10,-23, 4.05]) { 
        screw(m5, 45);
        at_z(-34.1) washer(M5_washer);
        at_z(-34.1) rotate([180,0,0]) nut(M5_nut, nyloc = true);
    }
    translate([-10,23, 4.05]) { 
        screw(m5, 45);
        at_z(-34.1) washer(M5_washer);
        at_z(-34.1) rotate([180,0,0]) nut(M5_nut, nyloc = true);
    }
    translate([-28,-23, 4.05]) { 
        screw(m5, 45);
        at_z(-34.1) washer(M5_washer);
        at_z(-34.1) rotate([180,0,0]) nut(M5_nut, nyloc = true);
    }
    translate([-28,23, 4.05]) { 
        screw(m5, 45);
        at_z(-34.1) washer(M5_washer);
        at_z(-34.1) rotate([180,0,0]) nut(M5_nut, nyloc = true);
    }
}

}

module motor_mount_holes(motor) {  
  motor_mount_screw = mount_hole_dist( servo_mount(motor) )/2;
  mount_flange = mount_flange( servo_mount(motor));
  screw_pos = [[motor_mount_screw,motor_mount_screw],
               [motor_mount_screw,-motor_mount_screw],
               [-motor_mount_screw,motor_mount_screw],
               [-motor_mount_screw,-motor_mount_screw]];
  union() {
    translate([0,0,-4.05])
      circle(d=mount_flange );  
    for( pos = screw_pos )
        translate([pos[0],pos[1], 0])
          circle(d=6.3);
    }
}

module motor_mount_screws(motor){
  motor_mount_screw = mount_hole_dist( servo_mount(motor) )/2;
  screw_pos = [[motor_mount_screw,motor_mount_screw],
               [motor_mount_screw,-motor_mount_screw],
               [-motor_mount_screw,motor_mount_screw],
               [-motor_mount_screw,-motor_mount_screw]];
  rotate([180,0,0])
    for( pos = screw_pos )
      translate([pos[0],pos[1], 9.2])
      { 
        screw(M6_cap_screw, 24);
        at_z(-14) washer(M6_washer);
        at_z(-14) rotate([180,0,0]) nut(M6_nut, nyloc = true);
      }
}

module frame_assembly() 
  assembly("frame") {
    width = WIDTH;
    length = LENGTH;
  
    rotate([0,90,0]) {  
      first = length/2-20;
      second = first-FEEDER_GAP;
      at_y(-first) extrusion(E4040,width);
      at_y(first-BACK_OFFSET) extrusion(E4040,width);
      at_y(-BACK_OFFSET/2) extrusion(E4040,width);   
      at_y(second-BACK_OFFSET) extrusion(E4040,width);
      at_y(-second) extrusion(E4040,width);
    }
  }

module build_bed(width, length) {
  d = length - (BACK_OFFSET/2 + 2*(40+FEEDER_GAP));
  translate([0,-BACK_OFFSET/2,20]) {
    sheet(AL2, width, d, 6);
  }
}

module at_z(z_translate) {
  translate([0,0,z_translate]) children();
}

module at_y(y_translate) {
  translate([0,y_translate,0]) children();
}

module at_x(x_translate) {
  translate([x_translate,0,0]) children();
}

module x_dragchain() {
    m = (WIDTH/2 - 160);
    pos = HEAD_POS + m;

    end_links = floor(pos / 32)+2;
    start_links = 90-end_links;

    echo(pos, start_links, end_links);
    
    bend_segments = [
      for( [1 : 9] ) [ 1,20 ]
    ];
    start_segments = [
      for( [1 : start_links] ) [ 1,0 ]
    ];
    end_segments = [
      for( [1 : end_links] ) [ 1,0 ]
    ];
    chain_segments = concat( start_segments, bend_segments, end_segments );
  translate([WIDTH/2+80,50,-50]) rotate([0,0,90])  
    color("#606060") dragchain([25,15,25.5], chain_segments);
}

module y_dragchain() {
    m = LENGTH/2;
    pos = GANTRY_POS + m;

    end_links = floor(pos / 51)+1;
    start_links = 62-end_links;

    echo(pos, start_links, end_links);
    
    bend_segments = [[1,30],[1,30],[1,30],[1,30],[1,30],[1,30]];
    start_segments = [
      for( [1 : start_links] ) [ 1,0 ]
    ];
    end_segments = [
      for( [1 : end_links] ) [ 1,0 ]
    ];
    chain_segments = concat( start_segments, bend_segments, end_segments );
  translate([WIDTH/2+68,LENGTH/2,20]) rotate([0,0,180])
    color("#606060") dragchain([40,15,25.5], chain_segments);
}
