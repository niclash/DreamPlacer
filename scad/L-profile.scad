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
 
L_shape(2, 30, 30, 1140);
 
module L_shape(thickness, w1, w2, length) {
  vitamin(str("L-profile(",w1,"x",w2,") : L-profile(",w1,"x",w2,") ", length, "mm" ));
  color("silver")
    translate([-length/2,0,0])
      union() {
        translate([0,-w1,0])
          cube([length, w1, thickness] );
        rotate([90,0,0])
          cube([length, w2, thickness] );
      }
}
