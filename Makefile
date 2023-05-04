PARTS := case lid hinge lock-hinge lock-left lock-right seal
OUT_DIR := stl/v11

all: $(PARTS)

$(PARTS): force
	mkdir -p $(OUT_DIR)
	openscad -o "$(OUT_DIR)/rugged case $@.stl" -D 'part="$@";' rugged-case.scad

clean:
	rm -f $(addprefix $(OUT_DIR)/,$(addsuffix .stl,$(PARTS)))

.PHONY: all clean force $(PARTS)
