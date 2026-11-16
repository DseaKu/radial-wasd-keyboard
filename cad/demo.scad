// Turntable demo of the full assembly, used by `make demo` in this folder.
// OpenSCAD --animate sets $t from 0 to 1 for each frame.
// body.scad reads $demo_spin as the turn angle.
$demo_spin = $t * 360;
include <body.scad>
