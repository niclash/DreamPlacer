//   Copyright 2021, Niclas Hedhman
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
$fn=50;

vacuum_mount();

module vacuum_mount() {
  linear_extrude(8){
    wall_2D();
  }
  translate([0,0,7.9])
    cupol();
}

module vacuum_mount_stl() {
  stl("vacuum mount");
  vacuum_mount();
}
  
  
module base_2D() {
  minkowski(){
    union() {
      square([9,19], center=true);
      translate([7,0])
        square([5,10], center=true);
      translate([-5.75,0])
        square([2.5,10], center=true);
    }
    circle(0.5);
  }
}
  
module wall_2D() {
  difference() {
    base_2D();
    circle(3);
  }
}

module cupol() {
  nipple();
  difference() {
    sphere(d=10);
    sphere(d=6);
    translate([0,0,5])
      cylinder(h=5,r=1.5, center=true);
    translate([-5,-5,-10.01])
      cube([10,10,10]);
  }
}

module nipple() {
  difference() {
    union(){
      translate([0,0,10])
        sphere(d=5);
      translate([0,0,4.5])
        sphere(d=5);
      translate([0,0,5])
        cylinder(h=6,d=4.5);
    }
    translate([0,0,8])
      cylinder(h=15,r=1.5, center=true);

  }
}