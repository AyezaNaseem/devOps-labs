SRC_DIR := src
OUT_DIR := out

SOURCES := $(wildcard $(SRC_DIR)/*.txt)
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

.PHONY: all check build test clean ci

all: test

check:
	@if [ -z "$(SOURCES)" ]; then \
		echo "ERROR: No source files found in $(SRC_DIR)"; \
		exit 1; \
	fi
	@echo "Check passed: Found source files."

$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt
	@mkdir -p $(OUT_DIR)
	@echo "Building $@ from $<"
	@tr '[:lower:]' '[:upper:]' < $< > $@

build: $(OUTPUTS)

test: build
	@echo "Running tests..."
	@for f in $(OUTPUTS); do \
		if grep -q '[a-z]' "$$f"; then \
			echo "Test failed: lowercase found in $$f"; \
			exit 1; \
		fi; \
	done
	@echo "All tests passed successfully!"

clean:
	@echo "Cleaning output directory..."
	@rm -rf $(OUT_DIR)

ci: clean check test

count: build ## report source files and built words
	@ls -1 $(SRC_DIR)/*.txt | wc -l
	@wc -w $(OUTPUTS) | tail -1
# count: see section 5 of the README
# OUTPUTS is set by the wildcard above
# run 'make help' for all targets
