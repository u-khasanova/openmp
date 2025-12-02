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
	@echo "Сборка завершена"
	@echo "Используйте 'make parallel' для запуска параллельной версии"
	@echo "Используйте 'make sequential' для запуска последовательной версии"

$(BUILD_DIR)/$(TARGET_PARALLEL): $(SOURCE)
	@echo "Сборка параллельной версии..."
	$(CXX) $(CXXFLAGS) $(OMP_FLAG) -D_OPENMP $(SOURCE) -o $(BUILD_DIR)/$(TARGET_PARALLEL)

$(BUILD_DIR)/$(TARGET_SEQUENTIAL): $(SOURCE)
	@echo "Сборка последовательной версии..."
	$(CXX) $(CXXFLAGS) $(SOURCE) -o $(BUILD_DIR)/$(TARGET_SEQUENTIAL)

parallel: $(BUILD_DIR)/$(TARGET_PARALLEL)
	@echo "Запуск параллельной версии..."
	@if [ -z "$(N)" ] && [ -z "$(array)" ]; then \
		echo "Используется тестовый массив по умолчанию с 4 потоками"; \
		./$(BUILD_DIR)/$(TARGET_PARALLEL); \
	elif [ -n "$(N)" ] && [ -n "$(array)" ]; then \
		echo "Используется пользовательский массив с $(N) потоками"; \
		./$(BUILD_DIR)/$(TARGET_PARALLEL) N=$(N) array="$(array)"; \
	elif [ -n "$(N)" ]; then \
		echo "Используется тестовый массив по умолчанию с $(N) потоками"; \
		./$(BUILD_DIR)/$(TARGET_PARALLEL) N=$(N); \
	elif [ -n "$(array)" ]; then \
		echo "Используется пользовательский массив с 4 потоками"; \
		./$(BUILD_DIR)/$(TARGET_PARALLEL) array="$(array)"; \
	fi

sequential: $(BUILD_DIR)/$(TARGET_SEQUENTIAL)
	@echo "Запуск последовательной версии..."
	@if [ -z "$(array)" ]; then \
		echo "Используется тестовый массив по умолчанию"; \
		./$(BUILD_DIR)/$(TARGET_SEQUENTIAL); \
	else \
		echo "Используется пользовательский массив"; \
		./$(BUILD_DIR)/$(TARGET_SEQUENTIAL) array="$(array)"; \
	fi

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Доступные цели:"
	@echo "  make all               			- Собрать обе версии (параллельную и последовательную)"
	@echo "  make parallel          			- Запустить параллельную версию с массивом по умолчанию (4 потока)"
	@echo "  make sequential        			- Запустить последовательную версию с массивом по умолчанию"
	@echo "  make clean             			- Очистить директорию сборки"
	@echo "  make help              			- Показать это справочное сообщение"
	@echo ""
	@echo "Аргументы для параллельной версии:"
	@echo "  make parallel N=4                  - Запустить с 4 потоками (массив по умолчанию)"
	@echo "  make parallel array='1 2 -3 6'     - Запустить с пользовательским массивом (4 потока)"
	@echo "  make parallel N=2 array='1 2 -3 6' - Запустить с пользовательским массивом и 2 потоками"
	@echo ""
	@echo "Аргументы для последовательной версии:"
	@echo "  make sequential                    - Запустить с массивом по умолчанию"
	@echo "  make sequential array='1 2 -3 6'   - Запустить с пользовательским массивом"
	@echo ""
	@echo "Потоков по умолчанию: 4 (для параллельной версии)"

.PHONY: all parallel sequential clean help