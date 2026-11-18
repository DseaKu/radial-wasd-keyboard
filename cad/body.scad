// =====================================================================
//  Ferris LEFT half, Charybdis-style
//  3x5 Kailh Choc v1 in a curved key well (column + row curvature,
//  column stagger, tenting), full-size Hall effect thumbstick (PS4/PS5/Xbox
//  replacement module, ALPS RKJXV footprint) in the thumb position.
//  The stick sits on a printed carrier board (instead of a PCB); wires are
//  soldered straight to its pins under the carrier.
//
//  Parts (set `part`, F6, export):
//    "case"        key well + walls; switches clip straight into it.
//                  Prints upright (open bottom on the bed), needs tree
//                  supports under the key well.
//    "stick_plate" top plate with the stick opening + 4 posts, drops into a
//                  pocket in the case; prints top face down, posts up
//    "stick_carrier" printed "PCB" the stick's pins go through; screws to
//                  the posts from below; prints flat
//    "bottom"      bottom plate, screws into the case; prints flat
//    "bat_lid"     twist lid of the 18650 bay (back wall); prints plug end down
//    "assembly"    everything with dummy switches, caps, stick, MCU
//    "top_view"    2D layout check
//
//  Screws: carrier to the stick plate posts 4x M2 x 6 (pan head, from below)
//          stick plate to case 3x M2 x 6 countersunk
//          bottom plate to case 5x M2 x 6 countersunk
//
//  Coordinates: x = to the right (pinky -> index -> thumb), y = away from
//  you, z = up, z = 0 = table / underside of the case walls.
// =====================================================================

/* [Part] */
part = "assembly"; // [assembly, case, stick_plate, stick_carrier, knob, bottom, bat_lid, top_view]
show_dummies = true;
spin_z = is_undef($demo_spin) ? 0 : $demo_spin; // turn angle, set by cad/demo.scad only
spin_c = is_undef($demo_center) ? [0, 0, 0] : $demo_center; // turn center, set by cad/demo.scad only

/* [Key well] */
alpha = 15; // column curvature: tilt between rows (deg)
beta = 5; // row curvature: tilt between columns (deg)
tent = 15; // index side higher than the pinky side (deg)
centerrow = 1; // flattest row (0 = front, 2 = back)
centercol = 2; // flattest column (0 = pinky .. 4 = inner index)
// column stagger [x, y, z] per column, pinky .. inner index (dactyl/Charybdis defaults)
col_offset = [[0, -12, 5.64], [0, 0, 0], [0, 2.82, -4.5], [0, 0, 0], [0, 0, 0]];
key_clear = 2; // free space under the switch pins + wiring, above the floor

/* [Keys — Kailh Choc v1] */
switch_hole = 13.8;
relief = 15.0; // pocket from below so the clips grab clip_t
clip_t = 1.2;
plate_t = 3; // key well thickness
mount_w = 17.4; // keyhole tile
mount_h = 16.4;
key_pitch = [18, 17]; // spacing at keycap height (Choc spacing)
cap_h = 6.5; // keycap top above the plate top

/* [Stick (thumb)] */
// stick centre relative to the front-right corner of the inner index key
thumb_off = [4, -19.5, -8];
// stick plate rotation [x, y, z] (deg): z turns the plate toward the
// front-right, x tilts it toward you, y tents it like the key well
thumb_rot = [15, -10, 25];
pad_margin = 3.5; // pad border around the stick unit
pad_t = 2; // stick plate thickness
pad_frame_t = 5; // case around the stick plate: pocket (pad_t) + ledge below
rim = 1.2; // case rim beside the stick plate
ledge = 1.5; // ledge the stick plate rests on
fit = 0.2;
pad_screw_inset = 4.5; // stick plate screws, from the plate corners
pad_screws = ["bl", "tl", "tr", "br"]; // which corners get a screw

/* [Walls] */
wall_t = 2.5;
wall_xy = 4; // walls step out this far from the key well edge ...
wall_z = -8; // ... and this far down, then go straight to the floor
web_t = plate_t;
post_s = 0.1;

/* [Bottom plate + screw posts] */
bottom_t = 2;
boss_d = 6;
boss_h = 5;
boss_hole = 1.8; // 1.8 = M2 self-tapping, 3.2 = M2 heat-set insert
screw_d = 2.3;
head_d = 4.0; // M2 countersunk
// screw posts at these boundary entries (index into `boundary`)
boss_at = [1, 9, 20, 25]; // (indices with the battery bay)
boss_at_nobay = [1, 9, 16, 23, 28];

/* [Controller — ESP32-C3 Super Mini] */
mcu_w = 18;
mcu_l = 22.52;
mcu_board_t = 1.2;
mcu_standoff = 2;
mcu_clear = 0.3;
mcu_col = 3; // sits behind this column, USB-C out the back wall
mcu_dx = 10; // shift to the right (mm)
usb_w = 12.5;
usb_h = 7.5;
usb_dx = 2; // USB-C opening shifted to the right (stick side) relative to the controller

/* [Battery bay — 18650, hot-swap through the back wall] */
// The case is extended on the stick side: the back wall runs on straight,
// a new side wall runs forward beside the stick, then angles in to the stick
// plate's front corner. The cell lies in a tube in that bay, beside (not
// behind) the stick unit, and slides out through a flush twist lid in the
// back wall, next to the USB-C port.
// Contacts: + at the front (flat plate), - on the lid (spring).
battery = true;
bat_d = 18.6; // cell diameter (max incl. wrap)
bat_space = 70; // cell + compressed spring (18650: 65-67 + ~4)
bat_fit = 0.6; // diametral play in the tube
bat_x = 76; // tube axis x (world): beside the stick unit
bat_tube_wall = 1.6;
bat_plate = 1; // + contact plate at the front
bat_end_t = 2; // closed front end
bay_wall_t = 2.5; // new side wall
bay_top = 24.5; // height of the new walls (roof slopes up to the keys / stick plate)
lid_plug = 7; // lid plug length inside the tube
lid_fit = 0.4; // diametral play lid <-> tube
lid_pin_d = 2.5; // bayonet pins on the lid
lid_pin_h = 1.2;
lid_pin_at = 3.5; // pin centre below the lid face
lid_pins = [55, 125]; // pin angles when locked (deg, 90 = up)
lid_turn = 35; // twist to lock
lid_ramp = 1.0; // the slot pulls the lid in this much over the twist ...
lid_detent = 0.5; // ... then it drops back this much into a notch
lid_grip = [13, 3, 2.5]; // grip bar on the lid face (l, w, h)
spring_pocket = [12, 3]; // spring seat in the lid (d, depth)
strip_w = 5.5; // groove for the - strip along the tube floor
strip_t = 0.6;

/* [Stick module — Hall effect, ALPS RKJXV / PS4-PS5 size] */
// Module frame: origin = stick axis, y+ = push-switch side, the 3-pin
// sensor rows sit at y- and x+. Footprint from the RKJXV / THB001P layout
// (same pins as the Hall replacement sticks). CHECK with calipers when the
// sticks arrive and adjust here.
mod_x = [-8.9, 8.9]; // body outline (RKJXV: 17.8 wide)
mod_y = [-9.5, 11.8]; // body outline incl. push switch (RKJXV: 21.3 deep)
mod_h = 11.2; // body height above the PCB
leg_pos = [[-6.325, -5], [-6.325, 5], [6.325, -5], [6.325, 5]]; // 4 metal legs
leg_hole = 2.0; // legs: 1.55 drill on a PCB, a bit more in print
pin_pos = concat(
  [for (x = [-2.5, 0, 2.5]) [x, -8.73]], // sensor 1
  [for (y = [-2.5, 0, 2.5]) [8.73, y]], // sensor 2
  [for (x = [-3.25, 3.25]) for (y = [5.75, 10.25]) [x, y]] // push switch
);
pin_hole = 1.4;
// open windows through the carrier around each pin group, so the (short)
// pins are free to solder from below: [indices into pin_pos]
pin_groups = [[0, 1, 2], [3, 4, 5], [6, 7], [8, 9]];
pin_window = 3.6; // window width
mod_clear = 0.5; // body top -> underside of the stick plate
stick_hole = 22; // opening in the stick plate for the stick + cap skirt
stick_chamfer = 1.5;
stick_tilt = 23; // max tilt (RKJXV)

/* [Knob (thumb cap)] */
// Shaft of the stick: MEASURE yours and set these (defaults = typical
// PS4/PS5-size stick: round shaft with one flat side)
shaft_d = 4.0; // shaft diameter
shaft_flat = 3.3; // across the flat (= shaft_d for a round shaft)
shaft_len = 5; // how deep the shaft goes into the knob
shaft_top = 6.5; // shaft tip above the stick plate's top face
knob_fit = 0.15; // extra room in the socket (press fit; raise if too tight)
knob_d = 18; // top diameter
knob_gap = 6; // underside of the top disc above the stick plate (tilt room)
knob_top = 3.5; // disc thickness at the rim
knob_dish = 1.2; // depth of the thumb dish
knob_grip = 24; // grip ribs around the rim (0 = none)
stem_d = 7.5;

/* [Stick carrier (printed PCB)] */
carrier_t = 2;
carrier_post_d = 5;
carrier_pilot = 1.8; // M2 self-tapping
carrier_screw = 2.4;
// posts beside the body (module frame), carrier screws into them from below
carrier_posts = [[-11.9, -4], [-11.9, 7], [11.9, -4], [11.9, 7]];
carrier_border = 1.2; // carrier around body / posts
// cage: a frame around the stick body; the stick rests on 4 small corner
// pads, everything else under it is open (pins / legs free for soldering)
cage_fit = 0.3; // gap around the stick body
cage_pad = 3; // corner pads reach this far under the body
cage_wall = 1.2; // corner walls that hold the body sideways ...
cage_wall_h = 2.5; // ... and their height above the pads
cage_arm = 2.5; // length of each corner wall arm
wire_clear = 3; // pins + solder + wires below the carrier
blind = 1.5;

/* [Hidden] */
$fa = 4;
$fs = 0.4;
eps = 0.01;
L = 400;

// ============================================================ matrices
function T(v) = [[1, 0, 0, v[0]], [0, 1, 0, v[1]], [0, 0, 1, v[2]], [0, 0, 0, 1]];
function Rx(a) = [[1, 0, 0, 0], [0, cos(a), -sin(a), 0], [0, sin(a), cos(a), 0], [0, 0, 0, 1]];
function Ry(a) = [[cos(a), 0, sin(a), 0], [0, 1, 0, 0], [-sin(a), 0, cos(a), 0], [0, 0, 0, 1]];
function Rz(a) = [[cos(a), -sin(a), 0, 0], [sin(a), cos(a), 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]];
function ap(M, p) = let (q = M * [p[0], p[1], len(p) > 2 ? p[2] : 0, 1]) [q[0], q[1], q[2]];

// ============================================================ key placement
R_row = (key_pitch[1] / 2) / sin(alpha / 2) + cap_h;
R_col = (key_pitch[0] / 2) / sin(beta / 2) + cap_h;
// key frame: origin = keyhole centre, plate top at z = 0
function key_M0(c, r) =
  Ry(-tent) * T(col_offset[c])
  * T([0, 0, R_col]) * Ry(beta * (centercol - c)) * T([0, 0, -R_col])
  * T([0, 0, R_row]) * Rx(alpha * (r - centerrow)) * T([0, 0, -R_row]);

// stick pad frame: origin = stick axis, pad top at z = 0
pad_anchor0 = ap(key_M0(4, 0), [mount_w / 2, -mount_h / 2, 0]) + thumb_off;
PAD_M0 = T(pad_anchor0) * Rz(thumb_rot[2]) * Ry(thumb_rot[1]) * Rx(thumb_rot[0]);
// stick module turned in the pad (deg); 0 = push-switch side toward the pad's +y
stick_rot = 0;
SLP = Rz(stick_rot);

// lowest points -> lift everything so switches and the stick wiring clear the floor
key_low = [for (sx = [-1, 1]) for (sy = [-1, 1]) [sx * 7, sy * 7, -(clip_t + 2.2 + 2.65 + 1.5)]];
z_mtop = -(pad_t + mod_clear); // module body top
z_ctop = z_mtop - mod_h; // carrier top (= the module's PCB plane)
z_cbot = z_ctop - carrier_t;
z_low = z_cbot - wire_clear;
carrier_x = [min(mod_x[0], min([for (p = carrier_posts) p.x]) - carrier_post_d / 2) - carrier_border,
  max(mod_x[1], max([for (p = carrier_posts) p.x]) + carrier_post_d / 2) + carrier_border];
carrier_y = [min(mod_y[0], min([for (p = carrier_posts) p.y]) - carrier_post_d / 2) - carrier_border,
  max(mod_y[1], max([for (p = carrier_posts) p.y]) + carrier_post_d / 2) + carrier_border];
unit_low = [for (x = carrier_x) for (y = carrier_y) [x, y, z_low]];
z_min0 = min(concat(
    [for (c = [0:4]) for (r = [0:2]) for (p = key_low) ap(key_M0(c, r), p).z],
    [for (p = unit_low) ap(PAD_M0 * SLP, p).z]
  ));
z_lift = key_clear - z_min0;
function key_M(c, r) = T([0, 0, z_lift]) * key_M0(c, r);
PAD_M = T([0, 0, z_lift]) * PAD_M0;
S = PAD_M * SLP;
echo(str("lift: ", z_lift, " mm"));

// ============================================================ stick unit (unit coords, top = 0)
function rot2(p, a) = [p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a)];
unit_pts = concat(
  [for (x = carrier_x) for (y = carrier_y) [x, y]],
  [for (a = [0:45:315]) [cos(a), sin(a)] * (stick_hole / 2 + stick_chamfer)]
);
pad_pts = [for (p = unit_pts) rot2(p, stick_rot)];
pad_x = [min([for (p = pad_pts) p.x]) - pad_margin, max([for (p = pad_pts) p.x]) + pad_margin];
pad_y = [min([for (p = pad_pts) p.y]) - pad_margin, max([for (p = pad_pts) p.y]) + pad_margin];
echo(str("stick plate: ", pad_x[1] - pad_x[0], " x ", pad_y[1] - pad_y[0], " mm"));

// ============================================================ keyholes + posts
module keyhole() {
  difference() {
    translate([-mount_w / 2, -mount_h / 2, -plate_t]) cube([mount_w, mount_h, plate_t]);
    translate([0, 0, -plate_t / 2]) cube([switch_hole, switch_hole, plate_t + 2], center=true);
    translate([-relief / 2, -relief / 2, -plate_t - 1]) cube([relief, relief, plate_t - clip_t + 1]);
  }
}
// corner posts of a key tile (key frame)
function kc(corner) =
  let (hx = mount_w / 2 - post_s / 2, hy = mount_h / 2 - post_s / 2)
  corner == "tl" ? [-hx, hy] : corner == "tr" ? [hx, hy] : corner == "bl" ? [-hx, -hy] : [hx, -hy];
module post() { translate([-post_s / 2, -post_s / 2, -web_t]) cube([post_s, post_s, web_t]); }
module kpost(c, r, corner) { multmatrix(key_M(c, r)) translate(kc(corner)) post(); }
// corner posts of the stick pad (pad frame)
function pc(corner) =
  corner == "tl" ? [pad_x[0], pad_y[1]] : corner == "tr" ? [pad_x[1], pad_y[1]]
  : corner == "bl" ? [pad_x[0], pad_y[0]] : [pad_x[1], pad_y[0]];
module ppost(corner) { multmatrix(PAD_M) translate(pc(corner)) post(); }

module key_well() {
  for (c = [0:4]) for (r = [0:2]) multmatrix(key_M(c, r)) keyhole();
  // webs between neighbouring keys
  for (c = [0:4]) for (r = [0:1]) hull() { kpost(c, r, "tl"); kpost(c, r, "tr"); kpost(c, r + 1, "bl"); kpost(c, r + 1, "br"); }
  for (c = [0:3]) for (r = [0:2]) hull() { kpost(c, r, "tr"); kpost(c, r, "br"); kpost(c + 1, r, "tl"); kpost(c + 1, r, "bl"); }
  for (c = [0:3]) for (r = [0:1]) hull() { kpost(c, r, "tr"); kpost(c + 1, r, "tl"); kpost(c, r + 1, "br"); kpost(c + 1, r + 1, "bl"); }
}

// ============================================================ stick pad (in the case)
module pad_rect(inset = 0) { translate([pad_x[0] + inset, pad_y[0] + inset]) square([pad_x[1] - pad_x[0] - 2 * inset, pad_y[1] - pad_y[0] - 2 * inset]); }
function pad_screw_pos(corner) =
  let (p = pc(corner)) [p.x + (p.x < 0 ? 1 : -1) * pad_screw_inset, p.y + (p.y < 0 ? 1 : -1) * pad_screw_inset];
module pad_frame() {
  multmatrix(PAD_M) {
    translate([0, 0, -pad_frame_t]) linear_extrude(pad_frame_t) pad_rect();
    for (c = pad_screws) let (p = pad_screw_pos(c)) translate([p.x, p.y, -pad_frame_t - 4]) cylinder(d=5.5, h=4 + eps);
  }
}
module pad_cuts() {
  multmatrix(PAD_M) {
    translate([0, 0, -pad_t]) linear_extrude(pad_t + 10) pad_rect(rim); // pocket, stick plate drops in flush
    translate([0, 0, -50]) linear_extrude(50 + eps) difference() { // through, leaves a ledge + screw tabs
        pad_rect(rim + ledge);
        for (c = pad_screws) translate(pad_screw_pos(c)) circle(d=5.5);
      }
    for (c = pad_screws) let (p = pad_screw_pos(c)) translate([p.x, p.y, -pad_frame_t - 5]) cylinder(d=1.8, h=pad_frame_t + 5);
  }
}

// ============================================================ walls (dactyl style)
// ---- battery bay geometry (world)
back_out = ap(key_M(4, 2), [kc("tr").x, kc("tr").y + wall_xy + wall_t, wall_z]).y; // outer face of the back wall
bore_d = bat_d + bat_fit;
bat_R = bore_d / 2 + bat_tube_wall;
bat_z = bat_R; // tube sits on the floor
bay_x = bat_x + bat_R; // outer face of the new side wall
lid_face = back_out; // lid flush with the back wall
bat_in1 = lid_face - lid_plug; // lid plug end (spring seat)
bat_in0 = bat_in1 - bat_space - bat_plate; // inner front end
bat_front = bat_in0 - bat_end_t;
pbr_out = ap(PAD_M, concat(pc("br"), [0]) + [0, -(wall_xy + wall_t), wall_z]); // stick plate front corner, outside
bay_A = [bay_x - bay_wall_t, back_out - bay_wall_t, bay_top]; // back corner (inner top edge)
bay_B = [bay_x - bay_wall_t, bat_front - 2, bay_top]; // front end of the side wall
bay_n = let (d = [pbr_out.x - bay_x, pbr_out.y - bay_B.y], l = norm(d)) [-d.y / l, d.x / l]; // outward normal of the angled wall
echo(str("battery bay: case ", bay_x - 52, " mm wider on the stick side, cell space ", bat_space, " mm"));

// boundary entries: ["K", col, row, corner, dx, dy] or ["P", corner, dx, dy] (directions in the key/pad frame)
// ["W", [x, y, z], [dx, dy]]: a straight vertical wall at a world point (inner top edge)
function eM(e) = e[0] == "K" ? key_M(e[1], e[2]) : e[0] == "W" ? T([0, 0, 0]) : PAD_M;
function eP(e) = e[0] == "K" ? kc(e[3]) : e[0] == "W" ? e[1] : pc(e[1]);
function eP3(e) = e[0] == "W" ? e[1] : concat(eP(e), [0]);
function eD(e) = e[0] == "K" ? [e[4], e[5]] : e[0] == "W" ? e[2] : [e[2], e[3]];
function wl(e, i) = let (d = eD(e), wt = e[0] == "W" ? bay_wall_t : wall_t)
  e[0] == "W" ? (i == 1 ? [d.x * wt, d.y * wt, 0] : i == 2 ? [0, 0, -0.02] : [d.x * wt, d.y * wt, -0.02])
  : i == 1 ? [d.x * wall_t, d.y * wall_t, -1]
  : i == 2 ? [d.x * wall_xy, d.y * wall_xy, wall_z]
  : [d.x * (wall_xy + wall_t), d.y * (wall_xy + wall_t), wall_z];
module wall_seg(a, b) {
  hull() for (e = [a, b]) multmatrix(eM(e)) translate(eP(e)) {
        post();
        for (i = [1:3]) translate(wl(e, i)) post();
      }
  hull() for (e = [a, b]) for (i = [2, 3]) {
        multmatrix(eM(e)) translate(eP(e)) translate(wl(e, i)) post();
        let (q = ap(eM(e), eP3(e) + wl(e, i))) translate([q.x, q.y, 0]) cube([post_s, post_s, eps]);
      }
}
boundary = [
  // pinky side
  ["K", 0, 0, "bl", -1, 0], ["K", 0, 0, "tl", -1, 0], ["K", 0, 1, "bl", -1, 0], ["K", 0, 1, "tl", -1, 0],
  ["K", 0, 2, "bl", -1, 0], ["K", 0, 2, "tl", -1, 0],
  // back
  ["K", 0, 2, "tl", 0, 1], ["K", 0, 2, "tr", 0, 1], ["K", 1, 2, "tl", 0, 1], ["K", 1, 2, "tr", 0, 1],
  ["K", 2, 2, "tl", 0, 1], ["K", 2, 2, "tr", 0, 1], ["K", 3, 2, "tl", 0, 1], ["K", 3, 2, "tr", 0, 1],
  ["K", 4, 2, "tl", 0, 1], ["K", 4, 2, "tr", 0, 1],
  // battery bay: back wall straight on, side wall beside the stick, angled to the stick plate corner
  each (battery ? [
    ["W", bay_A, [0, 1]], ["W", bay_A, [1, 0]],
    ["W", bay_B, [1, 0]], ["W", bay_B, bay_n],
  ] : [
    ["K", 4, 2, "tr", 1, 0], ["K", 4, 2, "br", 1, 0], ["K", 4, 1, "tr", 1, 0], ["K", 4, 1, "br", 1, 0],
    ["K", 4, 0, "tr", 1, 0], ["P", "tr", 1, 0], ["P", "br", 1, 0],
  ]),
  // stick plate
  ["P", "br", 0, -1], ["P", "bl", 0, -1], ["P", "bl", -1, 0],
  // front (straight from the stick plate to the middle finger: no notch beside the stick)
  ["K", 3, 0, "bl", 0, -1], ["K", 2, 0, "br", 0, -1], ["K", 2, 0, "bl", 0, -1],
  ["K", 1, 0, "br", 0, -1], ["K", 1, 0, "bl", 0, -1], ["K", 0, 0, "br", 0, -1], ["K", 0, 0, "bl", 0, -1],
  ["K", 0, 0, "bl", -1, 0],
];
module walls() { for (i = [0:len(boundary) - 1]) wall_seg(boundary[i], boundary[(i + 1) % len(boundary)]); }

// top surface between the key well and the stick plate
module thumb_connectors() {
  // thin triangles, so nothing reaches under the keys
  hull() { kpost(4, 0, "bl"); kpost(4, 0, "br"); ppost("tl"); }
  hull() { kpost(4, 0, "br"); ppost("tl"); ppost("tr"); }
  hull() { kpost(4, 0, "br"); kpost(4, 0, "tr"); ppost("tr"); }
  hull() { kpost(3, 0, "br"); kpost(4, 0, "bl"); ppost("tl"); }
  hull() { kpost(3, 0, "bl"); kpost(3, 0, "br"); ppost("tl"); }
  hull() { kpost(3, 0, "bl"); ppost("tl"); ppost("bl"); } // closes the corner in front of the middle finger
}

module key_cuts() {
  for (c = [0:4]) for (r = [0:2]) multmatrix(key_M(c, r)) {
        translate([0, 0, -plate_t / 2]) cube([switch_hole, switch_hole, plate_t + 2], center=true);
        translate([-relief / 2, -relief / 2, -plate_t - 1]) cube([relief, relief, plate_t - clip_t + 1]);
      }
}

// ---- floor outline: outer / inner wall points at the floor
function wall_floor(e, i) = let (q = ap(eM(e), eP3(e) + wl(e, i))) [q.x, q.y];
module floor_outer2d() { polygon([for (e = boundary) wall_floor(e, 3)]); }
module floor_inner2d() { polygon([for (e = boundary) wall_floor(e, 2)]); }

// ---- screw posts in the wall corners
function boss_pos(i) =
  let (e = boundary[i], d = eD(e), q = ap(eM(e), concat(eP(e), [0]) + [d.x * (wall_xy - boss_d / 2 + 1), d.y * (wall_xy - boss_d / 2 + 1), wall_z]))
  [q.x, q.y];
// extra posts in the battery bay: behind the tube end block, and in the front corner
bay_bosses = [[bat_x - bat_R - 4.5, back_out - wall_t - 3], [bay_x - bay_wall_t - 4.5, bat_front - 4]];
all_boss = concat([for (i = battery ? boss_at : boss_at_nobay) boss_pos(i)], battery ? bay_bosses : []);
module bosses() {
  for (p = all_boss) translate(p) cylinder(d=boss_d, h=boss_h);
}
module boss_holes() {
  for (p = all_boss) translate(concat(p, [-1])) cylinder(d=boss_hole, h=boss_h);
}

// ---- controller: on the bottom plate against the back wall, USB-C out the back
mcu_back = min(ap(key_M(mcu_col, 2), [0, mount_h / 2 + wall_xy, wall_z]).y, ap(key_M(mcu_col + 1, 2), [0, mount_h / 2 + wall_xy, wall_z]).y) - 0.4; // inner wall face
mcu_x = ap(key_M(mcu_col, 2), [0, 0, 0]).x + mcu_dx;
mcu_y0 = mcu_back - mcu_l;
usb_z = mcu_standoff + mcu_board_t + 1.6;
module mcu_cradle() {
  x0 = mcu_x - mcu_w / 2 - mcu_clear; x1 = mcu_x + mcu_w / 2 + mcu_clear;
  y0 = mcu_y0 - mcu_clear;
  hh = mcu_standoff + mcu_board_t + 0.6;
  difference() {
    translate([x0 - 1.2, y0 - 1.2, 0]) cube([x1 - x0 + 2.4, mcu_back - y0 + 1.2, hh]);
    translate([x0, y0, -1]) cube([x1 - x0, mcu_l + 5, hh + 2]);
  }
  translate([x0, y0, 0]) cube([2, mcu_back - y0, mcu_standoff]);
  translate([x1 - 2, y0, 0]) cube([2, mcu_back - y0, mcu_standoff]);
  translate([x0, y0, 0]) cube([x1 - x0, 2, mcu_standoff]);
}
module usb_cut() {
  translate([mcu_x + usb_dx, mcu_back - 1, usb_z]) rotate([-90, 0, 0])
      linear_extrude(wall_t + wall_xy + 10) offset(r=1.5) offset(delta=-1.5) square([usb_w, usb_h], center=true);
}

// ---- battery bay: roof, tube, lid
// roof from the key well / stick plate edge out to the top of the new walls
module bay_roof() {
  module wp(p) translate(p) post();
  hull() { kpost(4, 2, "tr"); kpost(4, 2, "br"); wp(bay_A); }
  hull() { kpost(4, 2, "br"); kpost(4, 1, "tr"); wp(bay_A); }
  hull() { kpost(4, 1, "tr"); kpost(4, 1, "br"); wp(bay_A); }
  hull() { kpost(4, 1, "br"); wp(bay_A); wp(bay_B); }
  hull() { kpost(4, 1, "br"); kpost(4, 0, "tr"); wp(bay_B); }
  hull() { kpost(4, 0, "tr"); ppost("tr"); wp(bay_B); }
  hull() { ppost("tr"); ppost("br"); wp(bay_B); }
}
// 2D sections in (x, up), extruded along +y at the tube axis
module along_y(y0, y1) translate([bat_x, y1, bat_z]) rotate([90, 0, 0]) linear_extrude(y1 - y0) children();
// radial cutter / pin at angle a (0 = +x, 90 = up), zz along the axis from the lid face (+ = out)
module radial(a, zz, d, r0, len) translate([bat_x, lid_face + zz, bat_z]) rotate([0, -a, 0]) translate([r0, 0, 0]) rotate([0, 90, 0]) cylinder(d=d, h=len, $fn=20);
module bat_tube() {
  along_y(bat_front, lid_face) hull() { // flat sides down to the floor
      circle(r=bat_R);
      translate([-bat_R, -bat_z]) square([2 * bat_R, 0.01]);
    }
  // solid block around the lid end for the bayonet slots
  intersection() {
    translate([bat_x - bat_R - 6, bat_in1 - 3, 0]) cube([bay_x - (bat_x - bat_R - 6), lid_face - bat_in1 + 3, bay_top]);
    linear_extrude(L) offset(delta=-0.2) floor_outer2d();
  }
}
lid_w = lid_pin_d + 0.4; // slot width
lid_z_lock = -lid_pin_at - (lid_w - lid_pin_d) / 2; // slot centre when locked (pin on the outer edge)
module bat_cuts() {
  r = bore_d / 2;
  along_y(bat_in0, lid_face + 1) {
    intersection() { // teardrop roof, cut flat 0.5 mm above the circle (short bridge)
      hull() {
        circle(d=bore_d);
        polygon([[-r * sin(45), r * cos(45)], [r * sin(45), r * cos(45)], [0, r * sqrt(2)]]);
      }
      translate([-r - 1, -r - 1]) square([2 * r + 2, 2 * r + 1.5]);
    }
    translate([-strip_w / 2, -r - strip_t]) square([strip_w, strip_t + 1]); // - strip groove
  }
  // + contact plate pocket in the front end, slot for its solder tab, hole for the - strip wire
  translate([bat_x - 6.25, bat_in0 - 0.8, bat_z - 6.25]) cube([12.5, 0.8 + eps, 12.5]);
  translate([bat_x - 3, bat_front - 1, bat_z - 5]) cube([6, bat_end_t + 2, 1.2]);
  translate([bat_x, bat_front - 1, bat_z - r - strip_t + 1.1]) rotate([-90, 0, 0]) cylinder(d=2.2, h=bat_end_t + 2);
  // bayonet slots: in axially, twist (ramp pulls the lid in), drop into the notch
  for (al = lid_pins) let (ae = al + lid_turn, z0 = lid_z_lock - lid_detent + lid_ramp,
      path = concat([[ae, 2]], [for (i = [0:6]) [ae - (lid_turn - 5) * i / 6, z0 - lid_ramp * i / 6]], [[al, lid_z_lock - lid_detent], [al, lid_z_lock]]))
    for (i = [0:len(path) - 2]) hull() {
        radial(path[i][0], path[i][1], lid_w, r - 0.5, lid_pin_h + 0.9);
        radial(path[i + 1][0], path[i + 1][1], lid_w, r - 0.5, lid_pin_h + 0.9);
      }
}
// lid, in place (locked)
module bat_lid() {
  pr = (bore_d - lid_fit) / 2;
  difference() {
    union() {
      along_y(bat_in1, lid_face) circle(r=pr, $fn=64);
      for (a = lid_pins) radial(a, -lid_pin_at, lid_pin_d, pr - 0.5, lid_pin_h + 0.5);
      // grip bar on the face
      translate([bat_x, lid_face, bat_z]) rotate([-90, 0, 0]) linear_extrude(lid_grip[2]) offset(r=1) offset(delta=-1) square([lid_grip[0], lid_grip[1]], center=true);
    }
    translate([bat_x, bat_in1 - eps, bat_z]) rotate([-90, 0, 0]) cylinder(d=spring_pocket[0], h=spring_pocket[1]); // spring seat
    translate([bat_x - 0.6, bat_in1 - eps, bat_z - pr - 1]) cube([1.2, spring_pocket[1] + 2, 1.8]); // spring tail out to the - strip
  }
}

// ---- bottom plate (under the walls)
module bottom_plate() {
  difference() {
    union() {
      translate([0, 0, -bottom_t]) linear_extrude(bottom_t) floor_outer2d();
      intersection() { // MCU cradle on the plate, inside the walls
        linear_extrude(L) offset(delta=-0.3) floor_inner2d();
        mcu_cradle();
      }
    }
    for (p = all_boss) translate(concat(p, [-bottom_t - 1])) {
        cylinder(d=screw_d, h=bottom_t + 2);
        cylinder(d1=head_d + 2, d2=screw_d - 0.2, h=(head_d + 2 - screw_d) / 2 + 0.1); // countersink from below
      }
  }
}

// ---- stick plate (drops into the pocket) + carrier (screws to its posts)
module stick_plate() {
  multmatrix(PAD_M) difference() {
      union() {
        translate([0, 0, -pad_t]) linear_extrude(pad_t) pad_rect(rim + fit);
        multmatrix(SLP) for (p = carrier_posts) translate([p.x, p.y, z_ctop]) cylinder(d=carrier_post_d, h=z_mtop - z_ctop + mod_clear + eps);
      }
      multmatrix(SLP) {
        translate([0, 0, -pad_t - eps]) cylinder(d=stick_hole, h=pad_t + 1);
        translate([0, 0, -stick_chamfer]) cylinder(d1=stick_hole, d2=stick_hole + 2 * stick_chamfer, h=stick_chamfer + eps);
        for (p = carrier_posts) translate([p.x, p.y, z_ctop - 1]) cylinder(d=carrier_pilot, h=z_mtop - z_ctop + 1); // stops 0.5 under the plate
      }
      for (c = pad_screws) let (p = pad_screw_pos(c)) translate([p.x, p.y, 0]) {
          translate([0, 0, -pad_t - 1]) cylinder(d=screw_d, h=pad_t + 2);
          translate([0, 0, -(head_d - screw_d) / 2]) cylinder(d1=screw_d, d2=head_d, h=(head_d - screw_d) / 2 + eps);
        }
    }
}
// (part name kept as "stick_carrier"; it is now a cage)
module stick_carrier() {
  ix = [mod_x[0] - cage_fit, mod_x[1] + cage_fit];
  iy = [mod_y[0] - cage_fit, mod_y[1] + cage_fit];
  multmatrix(S) difference() {
      union() {
        // frame around the body, reaching out to the screw bosses
        translate([0, 0, z_cbot]) linear_extrude(carrier_t) difference() {
            translate([carrier_x[0], carrier_y[0]]) square([carrier_x[1] - carrier_x[0], carrier_y[1] - carrier_y[0]]);
            translate([ix[0], iy[0]]) square([ix[1] - ix[0], iy[1] - iy[0]]);
          }
        // corner pads the stick sits on
        for (sx = [0, 1]) for (sy = [0, 1]) let (cx = sx == 0 ? ix[0] : ix[1] - cage_pad - cage_fit, cy = sy == 0 ? iy[0] : iy[1] - cage_pad - cage_fit)
          translate([cx, cy, z_cbot]) cube([cage_pad + cage_fit, cage_pad + cage_fit, carrier_t]);
        // corner walls (L shapes) that keep it from sliding
        for (sx = [0, 1]) for (sy = [0, 1]) let (
            wx = sx == 0 ? ix[0] - cage_wall : ix[1], wy = sy == 0 ? iy[0] - cage_wall : iy[1],
            ax = sx == 0 ? ix[0] - cage_wall : ix[1] - cage_arm, ay = sy == 0 ? iy[0] - cage_wall : iy[1] - cage_arm) {
            translate([ax, wy, z_ctop - eps]) cube([cage_arm + cage_wall, cage_wall, cage_wall_h]);
            translate([wx, ay, z_ctop - eps]) cube([cage_wall, cage_arm + cage_wall, cage_wall_h]);
          }
      }
      for (p = carrier_posts) translate([p.x, p.y, z_cbot - 1]) cylinder(d=carrier_screw, h=carrier_t + 2);
    }
}
// thumb cap, in the stick frame with z = 0 at the shaft tip
module knob() {
  zb = knob_gap - shaft_top; // underside of the disc
  cone_h = (knob_d - stem_d) / 2 * 0.75; // ~53 deg underside -> prints without supports
  zt = zb + knob_top; // rim height
  zs = min(-shaft_len, zb - cone_h); // bottom of the knob
  difference() {
    union() {
      translate([0, 0, zs]) cylinder(d=stem_d, h=zb - cone_h - zs + 0.01, $fn=48);
      translate([0, 0, zb - cone_h]) cylinder(d1=stem_d, d2=knob_d, h=cone_h, $fn=96);
      translate([0, 0, zb]) cylinder(d=knob_d, h=knob_top, $fn=96);
      if (knob_grip > 0) for (a = [0:360 / knob_grip:359]) rotate(a) translate([knob_d / 2 - 0.2, 0, zb + 0.6])
            cylinder(d=1.2, h=knob_top - 1.0, $fn=12);
    }
    // thumb dish (spherical)
    let (r = (pow(knob_d / 2 - 1, 2) + knob_dish * knob_dish) / (2 * knob_dish))
      translate([0, 0, zt + r - knob_dish]) sphere(r=r, $fn=128);
    // shaft socket (D shape)
    translate([0, 0, zs - 0.01]) linear_extrude(-zs + 0.3) intersection() { // shaft enters from below
        circle(d=shaft_d + knob_fit * 2, $fn=48);
        translate([-(shaft_d / 2 + knob_fit), -(shaft_d / 2 + knob_fit)]) square([shaft_flat + 2 * knob_fit, shaft_d + 2 * knob_fit]);
      }
    translate([0, 0, zs - 0.01]) cylinder(d1=shaft_d + 1, d2=shaft_d, h=0.5, $fn=48); // lead-in
  }
}
PADinv = Rx(-thumb_rot[0]) * Ry(-thumb_rot[1]) * Rz(-thumb_rot[2]) * T(-ap(PAD_M, [0, 0, 0]));

module case_body() {
  difference() {
    union() {
      key_well();
      pad_frame();
      thumb_connectors();
      walls();
      intersection() { linear_extrude(L) offset(delta=-0.5) floor_outer2d(); bosses(); } // grow into the wall, never through it
      if (battery) { bay_roof(); bat_tube(); }
    }
    boss_holes();
    usb_cut();
    if (battery) bat_cuts();
    key_cuts();
    pad_cuts();
    translate([-L, -L, -L]) cube([2 * L, 2 * L, L]); // nothing below the table
  }
}

// ============================================================ dummies
module dummies() {
  for (c = [0:4]) for (r = [0:2]) multmatrix(key_M(c, r)) {
    color("#555") translate([0, 0, -2.2 - clip_t]) linear_extrude(2.2 + clip_t + 3) square(15, center=true);
    color("#444") translate([0, 0, -2.2 - clip_t - 2.65]) cylinder(d=1, h=2.65);
    color("#e8e6e1") translate([0, 0, 3.5]) linear_extrude(2.5) offset(r=1.5) offset(delta=-1.5) square([17.5, 16.5], center=true);
  }
  multmatrix(S) {
    color("#222") translate([mod_x[0], mod_y[0], z_ctop]) cube([mod_x[1] - mod_x[0], mod_y[1] - mod_y[0], mod_h]);
    color("#333") {
      translate([0, 0, z_mtop]) cylinder(d=14, h=3);
      translate([0, 0, z_mtop]) cylinder(d=shaft_d, h=pad_t + mod_clear + shaft_top);
      translate([0, 0, shaft_top]) knob();
    }
    color("#ccc") for (p = pin_pos) translate([p.x, p.y, z_cbot - 2.5]) cylinder(d=0.8, h=2.5 + carrier_t);
  }
}

// ============================================================ output
translate(spin_c) rotate([0, 0, spin_z]) translate(-spin_c) if (part == "assembly") {
  color("#7f8fa6") case_body();
  color("#e1b12c") stick_plate();
  color("#2d6a4f") stick_carrier();
  color("#636e72") bottom_plate();
  if (battery) color("#e1b12c") bat_lid();
  if (show_dummies) {
    dummies();
    color("seagreen") translate([mcu_x - mcu_w / 2, mcu_y0, mcu_standoff]) cube([mcu_w, mcu_l, mcu_board_t]);
    color("silver") translate([mcu_x - 4.5, mcu_back - 7, mcu_standoff + mcu_board_t]) cube([9, 7.5, 3.2]);
    if (battery) color("royalblue") translate([bat_x, bat_in0 + bat_plate, bat_z]) rotate([-90, 0, 0]) cylinder(d=bat_d, h=bat_space - 4);
  }
}
else if (part == "case") case_body();
else if (part == "stick_plate") rotate([180, 0, 0]) multmatrix(PADinv) stick_plate();
else if (part == "knob") translate([0, 0, -min(-shaft_len, knob_gap - shaft_top - (knob_d - stem_d) / 2 * 0.75)]) knob();
else if (part == "stick_carrier") translate([0, 0, -z_cbot]) multmatrix(PADinv) stick_carrier();
else if (part == "bottom") translate([0, 0, bottom_t]) bottom_plate();
else if (part == "bat_lid") translate([0, 0, lid_plug]) rotate([90, 0, 0]) translate([-bat_x, -lid_face, -bat_z]) bat_lid(); // plug end on the bed
else if (part == "top_view") {
  color("#ccc") floor_outer2d();
  color("#999") floor_inner2d();
  color("#0a0") for (p = all_boss) translate(p) circle(d=boss_d);
  color("#2a2") translate([mcu_x - mcu_w / 2, mcu_y0]) square([mcu_w, mcu_l]);
  color("#f55") projection() for (c = [0:4]) for (r = [0:2]) multmatrix(key_M(c, r)) translate([0, 0, -1]) linear_extrude(1) square(15, center=true);
  color("#55f") projection() multmatrix(PAD_M) translate([0, 0, -1]) linear_extrude(1) pad_rect();
}
