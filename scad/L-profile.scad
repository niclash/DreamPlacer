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
