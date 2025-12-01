CXX = g++
CXXFLAGS = -O3 -Wall -Wextra -std=c++17
OMP_FLAG = -fopenmp
STUDENT_NUMBER = 61

SRC_DIR = src
BUILD_DIR = build
TARGET_PARALLEL = openmp_demo_$(STUDENT_NUMBER)_parallel
TARGET_SEQUENTIAL = openmp_demo_$(STUDENT_NUMBER)_sequential
SOURCE = $(SRC_DIR)/positive_counter.cpp

$(shell mkdir -p $(BUILD_DIR))

all: parallel sequential
	@echo ""
	@echo "Build complete"
	@echo "Use 'make parallel' to run parallel version"
	@echo "Use 'make sequential' to run sequential version"

$(BUILD_DIR)/$(TARGET_PARALLEL): $(SOURCE)
	@echo "Building parallel version..."
	$(CXX) $(CXXFLAGS) $(OMP_FLAG) -D_OPENMP $(SOURCE) -o $(BUILD_DIR)/$(TARGET_PARALLEL)

$(BUILD_DIR)/$(TARGET_SEQUENTIAL): $(SOURCE)
	@echo "Building sequential version..."
	$(CXX) $(CXXFLAGS) $(SOURCE) -o $(BUILD_DIR)/$(TARGET_SEQUENTIAL)

parallel: $(BUILD_DIR)/$(TARGET_PARALLEL)
	@echo "Running parallel version..."
	@if [ -z "$(N)" ] && [ -z "$(array)" ]; then \
		echo "Using default test array with 4 threads"; \
		./$(BUILD_DIR)/$(TARGET_PARALLEL); \
	elif [ -n "$(N)" ] && [ -n "$(array)" ]; then \
		echo "Using custom array with $(N) threads"; \
		./$(BUILD_DIR)/$(TARGET_PARALLEL) N=$(N) array="$(array)"; \
	elif [ -n "$(N)" ]; then \
		echo "Using default test array with $(N) threads"; \
		./$(BUILD_DIR)/$(TARGET_PARALLEL) N=$(N); \
	elif [ -n "$(array)" ]; then \
		echo "Using custom array with 4 threads"; \
		./$(BUILD_DIR)/$(TARGET_PARALLEL) array="$(array)"; \
	fi

sequential: $(BUILD_DIR)/$(TARGET_SEQUENTIAL)
	@echo "Running sequential version..."
	@if [ -z "$(array)" ]; then \
		echo "Using default test array"; \
		./$(BUILD_DIR)/$(TARGET_SEQUENTIAL); \
	else \
		echo "Using custom array"; \
		./$(BUILD_DIR)/$(TARGET_SEQUENTIAL) array="$(array)"; \
	fi

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Available targets:"
	@echo "  make all               			- Build both parallel and sequential versions"
	@echo "  make parallel          			- Run parallel version with default array (4 threads)"
	@echo "  make sequential        			- Run sequential version with default array"
	@echo "  make clean             			- Clean build directory"
	@echo "  make help              			- Show this help message"
	@echo ""
	@echo "Arguments for parallel version:"
	@echo "  make parallel N=4                  - Run with 4 threads (default array)"
	@echo "  make parallel array='1 2 -3 6'     - Run with custom array (4 threads)"
	@echo "  make parallel N=2 array='1 2 -3 6' - Run with custom array and 2 threads"
	@echo ""
	@echo "Arguments for sequential version:"
	@echo "  make sequential                    - Run with default array"
	@echo "  make sequential array='1 2 -3 6'   - Run with custom array"
	@echo ""
	@echo "Default threads: 4 (for parallel version)"

.PHONY: all parallel sequential clean help