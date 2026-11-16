OPENSCAD ?= /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

all:
	for p in case stick_plate stick_carrier knob bottom; do \
	  $(OPENSCAD) -o $$p.stl -D "part=\"$$p\"" body.scad; \
	done

# Turntable GIF for the README (needs ImageMagick "magick")
demo:
	rm -rf frames && mkdir frames
	$(OPENSCAD) --animate 36 --imgsize=640,480 --viewall --autocenter --projection=p --camera=0,0,0,55,0,25,400 --colorscheme=Tomorrow -o frames/f.png demo.scad
	magick -delay 8 -loop 0 frames/f*.png -layers Optimize ../docs/keyboard_demo.gif
	rm -rf frames
