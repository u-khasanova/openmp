#include <iostream>
#include <vector>
#include <sstream>
#include <cstring>

#ifdef _OPENMP
#include <omp.h>
#endif

const int STUDENT_NUMBER = 61;

const std::vector<double> DEFAULT_ARRAY = {
    3.5, -2.1, 0.0, 7.8, -1.2, 
    4.2, -3.0, 0.5, -0.1, 2.3,
    -5.6, 1.1, -2.8, 3.3, -4.4,
    6.6, -7.7, 8.8, -9.9, 10.0
};

size_t count_positives(const std::vector<double>& arr) {
    size_t positive_count = 0;
    
    #ifdef _OPENMP
    #pragma omp parallel
    {
        #pragma omp single
        {
            size_t chunk_size = 4; 
            size_t num_chunks = (arr.size() + chunk_size - 1) / chunk_size;
            
            for (size_t i = 0; i < num_chunks; ++i) {
                size_t start = i * chunk_size;
                size_t end = std::min(start + chunk_size, arr.size());
                
                #pragma omp task shared(positive_count)
                {
                    size_t local_count = 0;
                    for (size_t j = start; j < end; ++j) {
                        if (arr[j] > 0.0) {
                            local_count++;
                        }
                    }
                    
                    #pragma omp atomic
                    positive_count += local_count;
                }
            }
        }
    }
    #else
    for (size_t i = 0; i < arr.size(); ++i) {
        if (arr[i] > 0.0) {
            positive_count++;
        }
    }
    #endif
    
    return positive_count;
}

std::vector<double> parse_array(const std::string& str) {
    std::vector<double> arr;
    std::istringstream iss(str);
    double value;
    
    while (iss >> value) {
        arr.push_back(value);
    }
    
    return arr;
}

int main(int argc, char* argv[]) {
    std::vector<double> array = DEFAULT_ARRAY;
    int num_threads = 4;
    bool use_default_array = true;
    
    for (int i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "array=") == 0 && i + 1 < argc) {
            array = parse_array(argv[i + 1]);
            use_default_array = false;
            i++;
        } else if (strncmp(argv[i], "array=", 6) == 0) {
            array = parse_array(argv[i] + 6);
            use_default_array = false;
        } else if (strcmp(argv[i], "N=") == 0 && i + 1 < argc) {
            num_threads = std::atoi(argv[i + 1]);
            i++;
        } else if (strncmp(argv[i], "N=", 2) == 0) {
            num_threads = std::atoi(argv[i] + 2);
        }
    }
    
    #ifdef _OPENMP
    omp_set_num_threads(num_threads);
    #endif
    
    std::cout << "Студент: Ума Хасанова" << "\n";
    std::cout << "Номер: " << STUDENT_NUMBER << "\n";
    std::cout << "Задача: Подсчет положительных элементов в массиве\n";
    
    #ifdef _OPENMP
    std::cout << "Реализация: OpenMP tasks (параллельная)\n";
    std::cout << "Потоки: " << num_threads << "\n";
    #else
    std::cout << "Реализация: Последовательная\n";
    #endif
    
    std::cout << "Тип данных: double\n";
    std::cout << "Размер массива: " << array.size() << "\n";
    
    if (use_default_array) {
        std::cout << "Используется тестовый массив по умолчанию\n";
    } else {
        std::cout << "Используется пользовательский массив\n";
    }
    
    
    std::cout << "Элементы массива:\n";
    for (size_t i = 0; i < array.size(); ++i) {
        std::cout << array[i];
        if (array[i] > 0.0) {
            std::cout << " (+)";
        }
        if (i < array.size() - 1) {
            std::cout << ", ";
        }
        if ((i + 1) % 5 == 0 && i + 1 < array.size()) {
            std::cout << "\n";
        }
    }
    std::cout << "\n\n";
    
    size_t result = count_positives(array);
    
    std::cout << "Результат: найдено " << result << " положительных элементов\n";
    
    if (use_default_array && array.size() == DEFAULT_ARRAY.size()) {
        size_t expected_positives = 0;
        for (double val : DEFAULT_ARRAY) {
            if (val > 0.0) expected_positives++;
        }
        std::cout << "Ожидается для массива по умолчанию: " << expected_positives << " положительных элементов\n";
        
        if (result == expected_positives) {
            std::cout << "\nПравильное количество положительных элементов\n";
        } else {
            std::cout << "\nНеверное количество положительных элементов\n";
        }
    }
    
    return 0;
}