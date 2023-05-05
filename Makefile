PARTS := case lid hinge lock-hinge lock-left lock-right seal
OUT_DIR := stl/v11
THINGIVERSE_FILE := thingiverse/rugged-case-with-toggle-latches.scad

all: $(PARTS)

# TODO: add thingiverse option

$(PARTS): force
	mkdir -p $(OUT_DIR)
	openscad -o "$(OUT_DIR)/rugged case $@.stl" -D 'part="$@";' rugged-case.scad

thingiverse: force
	mkdir -p thingiverse
	sed '/^include/d' rugged-case.scad > $(THINGIVERSE_FILE)
	echo "\n\n// Contents of config-library.scad\n" >> $(THINGIVERSE_FILE)
	cat config-library.scad >> $(THINGIVERSE_FILE)
	echo "\n\n// Contents of rugged-case-library.scad\n" >> $(THINGIVERSE_FILE)
	cat rugged-case-library.scad >> $(THINGIVERSE_FILE)


clean:
	rm -f $(addprefix $(OUT_DIR)/,$(addsuffix .stl,$(PARTS)))

.PHONY: all clean force $(PARTS)
