# Usage:
#   make firmware                 build the firmware
#   make firmware flash           build and flash
#   make firmware flash monitor   build, flash, then open the serial monitor
#   make cad                      build the 3D-print STLs into cad/

help:
	@echo "make firmware                - build the firmware"
	@echo "make firmware flash          - build and flash"
	@echo "make firmware flash monitor  - build, flash and open the monitor"
	@echo "make cad                     - build the 3D-print STLs into cad/"

firmware:
	@cargo build

flash:
	@cargo espflash flash

monitor:
	@cargo espflash monitor

cad:
	@$(MAKE) -C cad

.PHONY: help firmware flash monitor cad
