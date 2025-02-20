{
name: "GEO",
index: "world",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "", // world volume has no mother
type: "tube",
r_max: 8125.0, // changed to accommodate 0.5m-thick layer of concrete on walls (L. Kneale)
size_z: 7650.0,
position: [0.0, 0.0, 0.0],
material: "air", //rock?
invisible: 1
}

///////////////////// Define the rock volumes. Thin slab of rock is assumed ////////////////////////

//Create a 1-m rock layer around a cylindrical cavern
{
name: "GEO",
index: "rock_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "world", // world volume has no mother
type: "tube",
r_max: 5187.5, // changed to accommodate 0.5m-thick layer of concrete on walls (L. Kneale)
size_z: 4950.0,
position: [0.0, 0.0, 0.0], //this will allow for the concrete layer on the floor and not on the ceiling
material: "rock",
invisible: 1
//color: [1.0,0.6,0.0,1.0],
//drawstyle: "solid"
}


//Create a 0.5m concrete layer on the walls and base
{
name: "GEO",
index: "rock_2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "rock_1",
type: "tube",
r_max: 3287.5, // changed to accommodate 0.5m-thick layer of concrete on walls (L. Kneale)
size_z: 3050.0,
position: [0.0, 0.0, 0.0], // this will give a concrete layer on the floor and not on the ceiling
material: "rock", // changed from "gunite" (L. Kneale)
invisible: 1
//color: [0.8,0.8,0.8,0.8],
//drawstyle: "solid"
}
//Create the cavern space between the tank and concrete
{
name: "GEO",
index: "cavern_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "rock_2",
type: "tube",
r_max: 3187.5, // changed to accommodate 0.5m-thick layer of concrete on walls (L. Kneale)
size_z: 2950.0,
position: [0.0, 0.0, 0.0],
material: "air",
invisible: 1
}
{name:"GEO",
index: "ibeam",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "cavern_1",
type: "tube",
r_max: 2714.5,
size_z: 2477.0,
position: [0.0, 0.0,0.0],
material: "stainless_steel",
color: [0.96,0.95,0.27,1.0],
drawstyle: "solid",
invisible: 1
}
{
name: "GEO",
index: "cavern_2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "ibeam",
type: "tube",
r_max: 2687.5,
size_z: 2450.0, 
position: [0.0, 0.0, 0.0],
material: "air",
color: [0.85, 0.72, 1.0, 0.5],
invisible: 1
}
////////////////////////////////// Define the rock volumes done.///////////////////////////////////
{
name: "GEO",
index: "tank",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "cavern_2",
type: "tube",
r_max: 1797.5, // changed to accommodate 0.5m-thick layer of concrete on walls (L. Kneale)
size_z: 1560.0,
position: [0.0, 0.0, 0.0],
material: "stainless_steel",
color: [0.43,0.70,0.90,1.0],
drawstyle: "solid"
invisible: 0 // omitted for visualization
}
{
name: "GEO",
index: "detector_veto1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "tube",
r_max: 1787.5, // changed to accommodate 0.5m-thick layer of concrete on walls (L. Kneale)
size_z: 1550.0,
position: [0.0, 0.0, 0.0],
material: "doped_water",
color: [0.2,0.2,0.9,0.2],
drawstyle: "solid"
invisible: 0 // omitted for visualization
}
{
name: "GEO",
index: "black_sheet",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "detector_veto1",
type: "tube",
r_max: 1690.0, // changed to accommodate 0.5m-thick layer of concrete on walls (L. Kneale)
size_z: 1452.5, // changed to put tarp behind washer plates
position: [0.0, 0.0, 0.0],
material: "polypropylene",
//color: [1.,1.,0.,1.0],
color: [0.01,0.01,0.01,0.8],
drawstyle: "solid",
invisible: 0 // omitted for visualization
}
{
name: "GEO",
index: "detector_target_gb",// gb: gamma buffer
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "black_sheet",
type: "tube",
r_max: 1687.5, // changed to put tarp behind washer plates
size_z: 1450.0,
position: [0.0, 0.0, 0.0],
material: "doped_water",
color: [0.2,0.2,0.9,0.2],
drawstyle: "solid"
invisible: 0 // omitted for visualization
}
{
name: "GEO",
index: "detector_target_fv", // fv : fiducial volume
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "detector_target_gb", // gb : gamma buffer
type: "tube",
r_max: 1187.5, // changed to accommodate 0.5m-thick layer of concrete on walls (L. Kneale)
size_z: 950.0,
position: [0.0, 0.0, 0.0],
material: "doped_water",
color: [1.0,0.2,0.9,0.2],
drawstyle: "solid"
invisible: 1 // omitted for visualization
}
{
//Bergevin: Set the interface were reflection can occur. Must make sure volume1 and volume2
//are in the correct order
name: "GEO",
index: "midsurface_black_sheet",
valid_begin: [0, 0],
valid_end: [0, 0],
invisible: 1, // omitted for visualization
mother: "black_sheet", //not used but needs to be a valid name, parent of 'a' and 'b' would be best choice
type: "border",
volume1: "detector_target_gb",
volume2: "black_sheet",
reverse: 1, //0 only considers photons from a->b, 1 does both directions
surface: "nonreflective_tarp",
}
{
//Bergevin: Set the interface were reflection can occur. Must make sure volume1 and volume2
//are in the correct order
name: "GEO",
index: "midsurface_tank",
valid_begin: [0, 0],
valid_end: [0, 0],
invisible: 1, // omitted for visualization
mother: "tank", //not used but needs to be a valid name, parent of 'a' and 'b' would be best choice
type: "border",
volume1: "detector_veto1",
volume2: "tank",
reverse: 1, //0 only considers photons from a->b, 1 does both directions
//surface: "tank_edge", /// changed here 
surface: "nonreflective_tarp",
}
{
name: "GEO",
index: "inner_pmts",
enable: 1,
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "detector_target_gb",
type: "pmtarray",
end_idx: 95, //idx of the last pmt
//end_idx: 0, //idx of the last pmt
start_idx: 0, //idx of the first pmt
pmt_model: "r7081pe",
mu_metal: 0,
mu_metal_material: "aluminum",
mu_metal_surface: "aluminum",
light_cone: 0,
light_cone_material: "aluminum",
light_cone_surface: "aluminum",
light_cone_length: 17.5,
light_cone_innerradius: 12.65,
light_cone_outerradius: 21.0,
light_cone_thickness: 0.2,
black_sheet_offset: 300.0, //30 cm default black tarp offset
black_sheet_thickness: 10.0, //1 cm default black tarp thickness
pmt_detector_type: "idpmt",
sensitive_detector: "/mydet/pmt/inner",
efficiency_correction: 0.90000,
pos_table: "PMTINFO", //generated by positions.nb
orientation: "manual",
orient_point: [0.,0.,0.],
color: [0.3,0.5, 0.0, 0.2],
encapsulation: 0,
invisible: 1 // omitted for visualization
}
{
name: "GEO",
index: "uprightAssemblies",
enable: 1,
valid_begin: [0, 0],
valid_end: [0, 0],
//mother: "detector_veto1",
mother: "detector_target_gb",
//mother: "tank",
type: "tubearray",
end_idx: 8, //idx of the last pmt
start_idx: 0, //idx of the first pmt
r_max:  50.00,
r_min:  40.40,
size_z: 1250.0,
pos_table: "FRAMEUPRIGHTSINFO", //generated by button-construction (past 19/Aug/22)
orientation: "manual",
orient_point: [0.,0.,0.],
material: "stainless_steel",
drawstyle: "solid",
//color: [1.0,0.0,0.0,0.0],
//invisible: 1 // omitted for visualization
}

{
name: "GEO",
index: "frameBar0_0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [0.0, 1437.1, 1250.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [0.0, 1554.0, 540.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 1554.0, 1050.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [0.0, 1554.0, 30.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar1_0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [1016.1831552431873, 1016.1831552431875, 1250.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [1098.8439379638949, 1098.8439379638949, 540.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [1098.8439379638949, 1098.8439379638949, 1050.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [1098.8439379638949, 1098.8439379638949, 30.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar2_0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [1437.1, 8.799699575273305e-14, 1250.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [1554.0, 9.515505629374935e-14, 540.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [1554.0, 9.515505629374935e-14, 1050.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [1554.0, 9.515505629374935e-14, 30.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar3_0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [1016.1831552431875, -1016.1831552431873, 1250.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [1098.8439379638949, -1098.8439379638949, 540.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [1098.8439379638949, -1098.8439379638949, 1050.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [1098.8439379638949, -1098.8439379638949, 30.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar4_0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [1.759939915054661e-13, -1437.1, 1250.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright4",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [1.903101125874987e-13, -1554.0, 540.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal4",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [1.903101125874987e-13, -1554.0, 1050.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal4",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [1.903101125874987e-13, -1554.0, 30.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar5_0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [-1016.1831552431873, -1016.1831552431876, 1250.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright5",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [-1098.8439379638949, -1098.843937963895, 540.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal5",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [-1098.8439379638949, -1098.843937963895, 1050.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal5",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [-1098.8439379638949, -1098.843937963895, 30.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar6_0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [-1437.1, -2.6399098725819915e-13, 1250.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright6",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [-1554.0, -2.85465168881248e-13, 540.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal6",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [-1554.0, -2.85465168881248e-13, 1050.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal6",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [-1554.0, -2.85465168881248e-13, 30.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar7_0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [-1016.1831552431876, 1016.1831552431871, 1250.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright7",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [-1098.843937963895, 1098.8439379638946, 540.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal7",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [-1098.843937963895, 1098.8439379638946, 1050.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal7",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [-1098.843937963895, 1098.8439379638946, 30.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar8_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [0.0, 1437.1, -1250.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright8",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [0.0, 1554.0, -540.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal8",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 1554.0, -30.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal8",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [0.0, 1554.0, -1050.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar9_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [1016.1831552431873, 1016.1831552431875, -1250.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright9",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [1098.8439379638949, 1098.8439379638949, -540.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal9",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [1098.8439379638949, 1098.8439379638949, -30.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal9",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [1098.8439379638949, 1098.8439379638949, -1050.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar10_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [1437.1, 8.799699575273305e-14, -1250.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright10",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [1554.0, 9.515505629374935e-14, -540.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal10",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [1554.0, 9.515505629374935e-14, -30.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal10",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [1554.0, 9.515505629374935e-14, -1050.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar11_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [1016.1831552431875, -1016.1831552431873, -1250.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright11",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [1098.8439379638949, -1098.8439379638949, -540.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal11",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [1098.8439379638949, -1098.8439379638949, -30.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal11",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [1098.8439379638949, -1098.8439379638949, -1050.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar12_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [1.759939915054661e-13, -1437.1, -1250.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright12",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [1.903101125874987e-13, -1554.0, -540.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal12",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [1.903101125874987e-13, -1554.0, -30.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal12",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [1.903101125874987e-13, -1554.0, -1050.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar13_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [-1016.1831552431873, -1016.1831552431876, -1250.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright13",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [-1098.8439379638949, -1098.843937963895, -540.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal13",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [-1098.8439379638949, -1098.843937963895, -30.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal13",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [-1098.8439379638949, -1098.843937963895, -1050.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar14_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [-1437.1, -2.6399098725819915e-13, -1250.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright14",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [-1554.0, -2.85465168881248e-13, -540.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal14",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [-1554.0, -2.85465168881248e-13, -30.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal14",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [-1554.0, -2.85465168881248e-13, -1050.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "frameBar15_1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [583.5, 20.0,  20.0], // mm, half-length
position: [-1016.1831552431876, 1016.1831552431871, -1250.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerUpright15",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [20.0,20.0 , 490.0], // mm, half-length
position: [-1098.843937963895, 1098.8439379638946, -540.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "topHorizontal15",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [-1098.843937963895, 1098.8439379638946, -30.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "bottomHorizontal15",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [570.0, 20.0,20.0], // mm, half-length
position: [0.0, 0.0, -510.0],
position: [-1098.843937963895, 1098.8439379638946, -1050.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "innerSquSide0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [589.5, 20.0, 20.0], // mm, half-length
position: [480.83261120685233, 480.8326112068523, 1250.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "outerSquSide0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [780.5, 20.0, 20.0], // mm, half-length
position: [843.5783899555513, 843.5783899555511, 1250.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "connectSqu0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [235.0, 230.0, 20.0], // mm, half-length
position: [662.2055005812018, 662.2055005812017, 1250.0],
rotation: [0.0, 0.0, -45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "innerSquSide1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [589.5, 20.0, 20.0], // mm, half-length
position: [-480.8326112068523, 480.83261120685233, 1250.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "outerSquSide1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [780.5, 20.0, 20.0], // mm, half-length
position: [-843.5783899555511, 843.5783899555513, 1250.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "connectSqu1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [235.0, 230.0, 20.0], // mm, half-length
position: [-662.2055005812017, 662.2055005812018, 1250.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "innerSquSide2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [589.5, 20.0, 20.0], // mm, half-length
position: [-480.83261120685245, -480.8326112068523, 1250.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "outerSquSide2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [780.5, 20.0, 20.0], // mm, half-length
position: [-843.5783899555514, -843.5783899555511, 1250.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "connectSqu2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [235.0, 230.0, 20.0], // mm, half-length
position: [-662.2055005812019, -662.2055005812017, 1250.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "innerSquSide3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [589.5, 20.0, 20.0], // mm, half-length
position: [480.8326112068522, -480.83261120685245, 1250.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "outerSquSide3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [780.5, 20.0, 20.0], // mm, half-length
position: [843.578389955551, -843.5783899555514, 1250.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "connectSqu3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [235.0, 230.0, 20.0], // mm, half-length
position: [662.2055005812016, -662.2055005812019, 1250.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerSquSide0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [85.0, 20.0, 20.0], // mm, half-length
position: [0.0, 105.0, 1250.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "topCross0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [642.0, 20.0, 20.0], // mm, half-length
position: [0.0, 767.0, 1250.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "bottomCross0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [680.0, 50.0, 20.0], // mm, half-length
position: [0.0, 730.0, -1250.0],
rotation: [0.0, 0.0, 90.0],
material: "doped_water"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerSquSide1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [85.0, 20.0, 20.0], // mm, half-length
position: [105.0, 6.429395695523604e-15, 1250.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "topCross1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [642.0, 20.0, 20.0], // mm, half-length
position: [767.0, 4.696520474730099e-14, 1250.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "bottomCross1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [680.0, 50.0, 20.0], // mm, half-length
position: [730.0, 4.469960816887839e-14, -1250.0],
rotation: [0.0, 0.0, 180.0],
material: "doped_water"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerSquSide2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [85.0, 20.0, 20.0], // mm, half-length
position: [1.2858791391047208e-14, -105.0, 1250.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "topCross2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [642.0, 20.0, 20.0], // mm, half-length
position: [9.393040949460198e-14, -767.0, 1250.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "bottomCross2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [680.0, 50.0, 20.0], // mm, half-length
position: [8.939921633775678e-14, -730.0, -1250.0],
rotation: [0.0, 0.0, 270.0],
material: "doped_water"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerSquSide3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [85.0, 20.0, 20.0], // mm, half-length
position: [-105.0, -1.928818708657081e-14, 1250.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "topCross3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [642.0, 20.0, 20.0], // mm, half-length
position: [-767.0, -1.4089561424190298e-13, 1250.0],
rotation: [0.0, 0.0, 360.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "bottomCross3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [680.0, 50.0, 20.0], // mm, half-length
position: [-730.0, -1.3409882450663516e-13, -1250.0],
rotation: [0.0, 0.0, 360.0],
material: "doped_water"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "innerSquSide4",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [589.5, 20.0, 20.0], // mm, half-length
position: [480.83261120685233, 480.8326112068523, -1250.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "outerSquSide4",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [780.5, 20.0, 20.0], // mm, half-length
position: [843.5783899555513, 843.5783899555511, -1250.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "connectSqu4",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [235.0, 230.0, 20.0], // mm, half-length
position: [662.2055005812018, 662.2055005812017, -1250.0],
rotation: [0.0, 0.0, -45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "innerSquSide5",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [589.5, 20.0, 20.0], // mm, half-length
position: [-480.8326112068523, 480.83261120685233, -1250.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "outerSquSide5",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [780.5, 20.0, 20.0], // mm, half-length
position: [-843.5783899555511, 843.5783899555513, -1250.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "connectSqu5",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [235.0, 230.0, 20.0], // mm, half-length
position: [-662.2055005812017, 662.2055005812018, -1250.0],
rotation: [0.0, 0.0, 45.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "innerSquSide6",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [589.5, 20.0, 20.0], // mm, half-length
position: [-480.83261120685245, -480.8326112068523, -1250.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "outerSquSide6",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [780.5, 20.0, 20.0], // mm, half-length
position: [-843.5783899555514, -843.5783899555511, -1250.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "connectSqu6",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [235.0, 230.0, 20.0], // mm, half-length
position: [-662.2055005812019, -662.2055005812017, -1250.0],
rotation: [0.0, 0.0, 135.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "innerSquSide7",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [589.5, 20.0, 20.0], // mm, half-length
position: [480.8326112068522, -480.83261120685245, -1250.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "outerSquSide7",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [780.5, 20.0, 20.0], // mm, half-length
position: [843.578389955551, -843.5783899555514, -1250.0],
rotation: [0.0, 0.0, 315.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "connectSqu7",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [235.0, 230.0, 20.0], // mm, half-length
position: [662.2055005812016, -662.2055005812019, -1250.0],
rotation: [0.0, 0.0, 225.0],
material: "stainless_steel"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerSquSide0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [85.0, 20.0, 20.0], // mm, half-length
position: [0.0, 105.0, 1250.0],
rotation: [0.0, 0.0, 0.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "topCross0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [642.0, 20.0, 20.0], // mm, half-length
position: [0.0, 767.0, 1250.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "bottomCross0",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [680.0, 50.0, 20.0], // mm, half-length
position: [0.0, 730.0, -1250.0],
rotation: [0.0, 0.0, 90.0],
material: "doped_water"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerSquSide1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [85.0, 20.0, 20.0], // mm, half-length
position: [105.0, 6.429395695523604e-15, 1250.0],
rotation: [0.0, 0.0, 90.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "topCross1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [642.0, 20.0, 20.0], // mm, half-length
position: [767.0, 4.696520474730099e-14, 1250.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "bottomCross1",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [680.0, 50.0, 20.0], // mm, half-length
position: [730.0, 4.469960816887839e-14, -1250.0],
rotation: [0.0, 0.0, 180.0],
material: "doped_water"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerSquSide2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [85.0, 20.0, 20.0], // mm, half-length
position: [1.2858791391047208e-14, -105.0, 1250.0],
rotation: [0.0, 0.0, 180.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "topCross2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [642.0, 20.0, 20.0], // mm, half-length
position: [9.393040949460198e-14, -767.0, 1250.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "bottomCross2",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [680.0, 50.0, 20.0], // mm, half-length
position: [8.939921633775678e-14, -730.0, -1250.0],
rotation: [0.0, 0.0, 270.0],
material: "doped_water"
drawstyle: "wireframe",
}
{
name: "GEO",
index: "centerSquSide3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [85.0, 20.0, 20.0], // mm, half-length
position: [-105.0, -1.928818708657081e-14, 1250.0],
rotation: [0.0, 0.0, 270.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "topCross3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [642.0, 20.0, 20.0], // mm, half-length
position: [-767.0, -1.4089561424190298e-13, 1250.0],
rotation: [0.0, 0.0, 360.0],
material: "stainless_steel"
drawstyle: "solid",
}
{
name: "GEO",
index: "bottomCross3",
valid_begin: [0, 0],
valid_end: [0, 0],
mother: "tank",
type: "box",
size: [680.0, 50.0, 20.0], // mm, half-length
position: [-730.0, -1.3409882450663516e-13, -1250.0],
rotation: [0.0, 0.0, 360.0],
material: "doped_water"
drawstyle: "wireframe",
}
