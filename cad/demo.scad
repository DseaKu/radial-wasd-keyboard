// Turntable demo of the full assembly, used by `make demo` in this folder.
// OpenSCAD --animate sets $t from 0 to 1 for each frame.
// body.scad reads $demo_spin as the turn angle.
$demo_spin = $t * 360;
$demo_center = [11.26, -16.20, 0]; // xy center of the model, so it turns in place
include <body.scad>
