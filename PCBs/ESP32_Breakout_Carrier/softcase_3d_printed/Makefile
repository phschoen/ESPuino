#CPUS ?= $(getconf _NPROCESSORS_ONLN)
CPUS ?= $(shell nproc)
MAKEFLAGS += --jobs=$(CPUS)
#Q=@


UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	OPENSCAD=openscad
	stl2pov=$(BUILD_DIR)/stl2pov-2.5.0/stl2pov
endif
ifeq ($(UNAME_S),MINGW64_NT-10.0)
	OPENSCAD=/C/Program Files/OpenSCAD/openscad.exe
	stl2pov=TODO
endif


OPENSCAD_FLAGS=
OPENSCADPATH=$(shell pwd)

SCAD_FILES = $(wildcard src/*.scad)

BUILD_DIR = build
OUTPUT_DIR = output

default: all

define def_parts
# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard $(BUILD_DIR)/*.deps)

.SECONDARY: $(BUILD_DIR)/$2.scad
# define a new target for a temporary "build file" that only calls the part module
$(BUILD_DIR)/$2.scad: $1 | dir_build dir_output
	$(Q)echo Generating $2
	$(Q)/bin/echo -n -e 'use <../$(1)>\n'  >  $(BUILD_DIR)/$2.scad
	$(Q)/bin/echo -n -e 'rotate(gif_offset_rot($t))\n' >> $(BUILD_DIR)/$2.scad
	$(Q)/bin/echo -n -e 'translate(gif_offset_pos($t))\n' >> $(BUILD_DIR)/$2.scad
	$(Q)/bin/echo -n -e 'part_$(2)();\n' >> $(BUILD_DIR)/$2.scad

$(OUTPUT_DIR)/$2.stl: $(BUILD_DIR)/$2.scad
	$(Q)echo Building $2
	$(Q)OPENSCADPATH=$(OPENSCADPATH) $(OPENSCAD) $(OPENSCAD_FLAGS) \
		$(BUILD_DIR)/$2.scad \
		-m make \
		-D is_build=true \
		-o $(OUTPUT_DIR)/$2.stl \
		-d $(BUILD_DIR)/$2.deps $<

$(BUILD_DIR)/$2.inc: $(stl2pov) $(OUTPUT_DIR)/$2.stl
	$(stl2pov) -s $(OUTPUT_DIR)/$2.stl > $(BUILD_DIR)/$2.inc


all:: $(OUTPUT_DIR)/$2.gif

$(OUTPUT_DIR)/$2.gif: $(OUTPUT_DIR)/$2.stl
	for i in $$\( seq 1 $(FPS) ) \
	do  \
		$(OPENSCAD) -o $(BUILD_DIR)/$2_$$i.png --imgsize=2048,2048 $(BUILD_DIR)/$2.scad; \
	done
	convert -limit memory 1GiB -loop 0 -layers optimize -resize 400 $(BUILD_DIR)/$2_*.png $(OUTPUT_DIR)/$2.gif




.PHONY: all
all:: $(BUILD_DIR)/$2.inc


.PHONY: all
all:: $(OUTPUT_DIR)/$2.stl
endef

define find_parts
# use sed to find all openscad modules that begin with part_
$(eval PARTS := $(shell  sed -n -e 's/^module part_\(.*\)().*/\1/p' $1))
# define a new build target for each found part
$(foreach part,$(PARTS),$(eval $(call def_parts,$1,$(part))))
endef

# Find all parts in all scad files
$(foreach file,$(SCAD_FILES),$(eval $(call find_parts,$(file))))

.PHONY: list
list:
	$(Q)@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | uniq | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.SECONDARY: dir_build
dir_build:
	$(Q)mkdir -p $(BUILD_DIR)

.SECONDARY: dir_output
dir_output:
	$(Q)mkdir -p $(OUTPUT_DIR)

clean:
	$(Q)rm -rf $(BUILD_DIR)
	$(Q)rm -rf $(OUTPUT_DIR)

gui:
	$(Q)OPENSCADPATH=$(OPENSCADPATH) $(OPENSCAD) $(OPENSCAD_FLAGS)


ifeq ($(UNAME_S),Linux)
$(stl2pov): dir_build
	cd $(BUILD_DIR) && wget https://rsmith.home.xs4all.nl/files/stl2pov-2.5.0.tar.gz
	cd $(BUILD_DIR) && tar -xzvf stl2pov-2.5.0.tar.gz
	cd $(BUILD_DIR) && rm -rf stl2pov-2.5.0.tar.gz
	cd $(BUILD_DIR) && cd stl2pov-2.5.0 && make all

install: dir_build
	sudo apt-get install povray openscad



endif

