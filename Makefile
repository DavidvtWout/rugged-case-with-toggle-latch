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
	echo "// Contents of default-config.scad\n" > $(THINGIVERSE_FILE)
	sed -e '/^[[:space:]]*\/\/.*/d' -e 's/\/\/.*//' default-config.scad >> $(THINGIVERSE_FILE)  # Remove comments because customizer can't handle them
	echo "\n\n// Contents of rugged-case.scad\n" >> $(THINGIVERSE_FILE)
	sed '/^include/d' rugged-case.scad >> $(THINGIVERSE_FILE)
	echo "\n\n// Contents of config-library.scad\n" >> $(THINGIVERSE_FILE)
	cat config-library.scad >> $(THINGIVERSE_FILE)
	echo "\n\n// Contents of rugged-case-library.scad\n" >> $(THINGIVERSE_FILE)
	sed -e '/^include/d' -e '/^[[:space:]]*\/\/.*/d' -e 's/\/\/.*//' rugged-case-library.scad >> $(THINGIVERSE_FILE)


clean:
	rm -f $(addprefix $(OUT_DIR)/,$(addsuffix .stl,$(PARTS)))

.PHONY: all clean force $(PARTS)
