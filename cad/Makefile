OPENSCAD ?= /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

all:
	for p in case stick_plate stick_carrier knob bottom; do \
	  $(OPENSCAD) -o $$p.stl -D "part=\"$$p\"" body.scad; \
	done
