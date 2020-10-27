
$fn=25;

include <NopSCADlib/lib.scad>
use <./head.scad>

WIDTH=1500;
LENGTH=1000;
FEEDER_GAP = 100;
X_AXIS_HEIGHT = 120;
GANTRY_POS = 80;
//GANTRY_POS = sin($t*360)*LENGTH/3;
HEAD_POS = -200;
//HEAD_POS = sin($t*180)*LENGTH/3;
BACK_OFFSET=150;
Y_AXIS_MOTOR=Lichuan_M03530_80ST;
X_AXIS_MOTOR=Lichuan_M03530_80ST;
KP_BLOCK=KP001;

module main_assembly()
  assembly("main") {
      
    frame_assembly();
    build_bed(WIDTH,LENGTH);
    translate([0, GANTRY_POS, X_AXIS_HEIGHT+78]) 
      xaxis_assembly();

    x = WIDTH/2+20;
    translate([x,0,X_AXIS_HEIGHT/2])
      right_side_frame_assembly();  // Right
      
    translate([-x,0,X_AXIS_HEIGHT/2])
      left_side_frame_assembly(); // Left
  }

if($preview)
    main_assembly();
    
module xaxis_assembly() 
  assembly("xaxis") {
    length=WIDTH;
    motor = X_AXIS_MOTOR;
    shaft_length = shaft_length(servo_shaft(motor));
    translate([0,0,-30]) rotate([0,90,0])
      extrusion(E4080,length+140);
    translate([0,-40,-30]) rotate([90,0,0])
      rail_assembly(HGH15CA, length, HEAD_POS );
    translate([3,0,17]) rotate([90,0,90])
      lead_screw_assembly(length, HEAD_POS-15, 180); 
    translate([length/2-24,0,-6]) sheet(AL8,60,80,[3,3,3,3]);
    translate([-length/2+28,0,-6]) sheet(AL8,60,80,[3,3,3,3]);
    translate([HEAD_POS,-72,-40])
      head_assembly();
    
    translate([length/2 + shaft_length + 39,0,25])
      rotate([0,-90,0]) {
        at_z(-1) servo(motor);
      }
    translate([-length/2-74,0,-62]) rotate([0,-90,0])
      bracket_x1_axis_dxf();
    translate([length/2+74,0,-62]) rotate([0,-90,0])
      bracket_x2_axis_dxf();
}


module bracket_x1_axis_dxf() {
    dxf("bracket_x1_axis");
    difference() {
      union()  {
        sheet(AL8, 80,100,[0,3,3,0]);
        translate([-15,75,0]) sheet(AL8, 50,50,[3,3,0,0]);
        translate([-15,-75,0]) sheet(AL8, 50,50,[0,0,3,3]);
      }
      
      translate([-30,87,-5])
        cylinder(h=10,d=5.5);
      translate([0,87,-5])
        cylinder(h=10,d=5.5);
      translate([-30,52,-5])
        cylinder(h=10,d=5.5);
      translate([0,52,-5])
        cylinder(h=10,d=5.5);
  
      translate([-30,-88,-5])
        cylinder(h=10,d=5.5);
      translate([0,-88,-5])
        cylinder(h=10,d=5.5);
      translate([-30,-52,-5])
        cylinder(h=10,d=5.5);
      translate([0,-52,-5])
        cylinder(h=10,d=5.5);
    }
  }

module bracket_x2_axis_dxf() {
    dxf("bracket_x2_axis");
    difference() {
      union()  {
        translate([86,0,0]) rotate([0,0,-90]) 
          motor_mount_plate_dxf(Y_AXIS_MOTOR, 100, 250);
        translate([-15,75,0]) sheet(AL8, 50,50,[3,3,0,0]);
        translate([-15,-75,0]) sheet(AL8, 50,50,[0,0,3,3]);
      }
      
      translate([-30,87,-5])
        cylinder(h=10,d=5.5);
      translate([0,87,-5])
        cylinder(h=10,d=5.5);
      translate([-30,52,-5])
        cylinder(h=10,d=5.5);
      translate([0,52,-5])
        cylinder(h=10,d=5.5);
  
      translate([-30,-88,-5])
        cylinder(h=10,d=5.5);
      translate([0,-88,-5])
        cylinder(h=10,d=5.5);
      translate([-30,-52,-5])
        cylinder(h=10,d=5.5);
      translate([0,-52,-5])
        cylinder(h=10,d=5.5);
    }
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
  
  translate([0, 6, pos-10]) { 
    leadnut(SFU1610);
    translate([0,0,10.1]) rotate([0,0,rotation])
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
   translate([0,0,-16])

      difference() {
        union() {
          translate([-30,-25,0])
            cube([60,32,25]);
          translate([-17.5,-16,0])
            cube([35,35,25]);
        }
        translate([23,0,13])
          cylinder(h=30,d=4,center=true);
        translate([-23,0,13])
          cylinder(h=30,d=4,center=true);
        translate([23,-18,13])
          cylinder(h=30,d=4,center=true);
        translate([-23,-18,13])
          cylinder(h=30,d=4,center=true);

        translate([-23,0,6])
          rotate([90,0,0])
            cylinder(h=50,d=6,center=true);
        translate([23,0,6])
          rotate([90,0,0])
            cylinder(h=50,d=6,center=true);
        translate([-23,0,18])
          rotate([90,0,0])
            cylinder(h=50,d=6,center=true);
        translate([23,0,18])
          rotate([90,0,0])
            cylinder(h=50,d=6,center=true);
      }
    translate([0,0,5])
      ball_bearing(BB6201);
    translate([0,0,-12])
      ball_bearing(BB6201);
}

module bf12() {
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
        cylinder(h=30,d=4,center=true);
      translate([-23,0,13])
        cylinder(h=30,d=4,center=true);
      translate([23,-18,13])
        cylinder(h=30,d=4,center=true);
      translate([-23,-18,13])
        cylinder(h=30,d=4,center=true);

      translate([-23,0,10])
        rotate([90,0,0])
          cylinder(h=50,d=6,center=true);
      translate([23,0,10])
        rotate([90,0,0])
          cylinder(h=50,d=6,center=true);
    }
  ball_bearing(BB6201);
}

module rail_block_assembly(length, pos){
  translate([0, 0, 0] )
    rail(HGH20CA, length );
  translate([pos-70,0,0])
    carriage(HGH20CA_carriage, HGH20CA );
  translate([pos+70,0,0])
    carriage(HGH20CA_carriage, HGH20CA );
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
    
    at_y(length/2-34) extrusion(E4040,height-40);
    at_y(length/2+50) extrusion(E4040,height-40);
    at_y(-length/2+20) extrusion(E4040,height-40);
  
    translate([-72,9,0]) 
      rotate([-90,90,0])
        lead_screw_assembly(length,GANTRY_POS);
  
    motor=Y_AXIS_MOTOR;
    translate([-78, shaft_length( servo_shaft(motor) ) + length/2+39, 0])
      rotate([90,0,0]) {
        servo(motor);
        difference(){
          rotate([0,0,90]) motor_mount_plate_dxf(motor, X_AXIS_HEIGHT+40, 160);
          translate([78,X_AXIS_HEIGHT/2,-5]) cylinder(10,d=5.5);
          translate([78,-X_AXIS_HEIGHT/2,-5]) cylinder(10,d=5.5);
          translate([78,X_AXIS_HEIGHT/4,-5]) cylinder(10,d=5.5);
          translate([78,-X_AXIS_HEIGHT/4,-5]) cylinder(10,d=5.5);
          translate([78,0,-5]) cylinder(10,d=5.5);
        }
      }
    translate([-36.5,length/2-24,-2])
      block_stand_off(true);
    translate([-36.5,-length/2+30,0])
      block_stand_off(false);
  }

module block_stand_off(double_holes) {
  difference() {
    cube([33,40,75],center=true);
    translate([-16.6,-10,-25]) rotate([0,-90,0])
      screw(M5_cs_cap_screw, 40);
    translate([-16.6,-10,0]) rotate([0,-90,0])
      screw(M5_cs_cap_screw, 40);
    translate([-16.6,-10,25]) rotate([0,-90,0])
      screw(M5_cs_cap_screw, 40);
    if( double_holes ) {
      translate([-17,0,25])
        rotate([0,90,0])
         cylinder(h=20,d=5);
      translate([-17,0,-21])
        rotate([0,90,0])
         cylinder(h=20,d=5);
      translate([-17,12,25])
        rotate([0,90,0])
         cylinder(h=20,d=5);
      translate([-17,12,-21])
        rotate([0,90,0])
         cylinder(h=20,d=5);
    } else {
      translate([-17,5,23])
        rotate([0,90,0])
          cylinder(h=20,d=5);
      translate([-17,5,-23])
        rotate([0,90,0])
          cylinder(h=20,d=5);
    }
  }
}

module motor_mount_plate_dxf(motor, height, width) 
//  dxf("motor_mount_plate") {
{  
    motor_mount_screw = mount_hole_dist( servo_mount(motor) )/2;
    mount_flange = mount_flange( servo_mount(motor));
    
    // Motor Mount Plate
    screw_pos = [[motor_mount_screw,motor_mount_screw],
                 [motor_mount_screw,-motor_mount_screw],
                 [-motor_mount_screw,motor_mount_screw],
                 [-motor_mount_screw,-motor_mount_screw]];
    difference() {
      translate([0,-width/2 + motor_mount_screw+30,0])
        sheet(AL8,height,width, [3,3,3,3] );
      translate([0,0,-4.05])
        cylinder(h=8.1, d=mount_flange );  
      for( pos = screw_pos )
        translate([pos[0],pos[1], 0])
          cylinder( h=10, d=5.4, center=true);
    }
    rotate([180,0,0])
      for( pos = screw_pos )
        translate([pos[0],pos[1], 9.2])
        { 
          screw(M5_cap_screw, 24);
          at_z(-14) washer(M5_washer);
          at_z(-14) rotate([180,0,0]) nut(M5_nut, nyloc = true);
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
  translate([0,-BACK_OFFSET/2,20]) 
    sheet(AL2, width, d, 6);
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
