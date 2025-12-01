```markdown
# OpenMP Parallel Programming Demo

## Project Overview
This project demonstrates parallel array processing using OpenMP tasks. The program counts positive elements in a double array, implementing both sequential and parallel (task-based) versions for comparison.

## Student Information
- **Student:** Uma Khasanova  
- **Student Number:** 61  
- **Task:** Count positive elements in array (Task 2: `(61 % 4) + 1 = 2`)  
- **Parallel Method:** OpenMP tasks (Method 1: `((61/4) % 5) + 1 = 1`)  
- **Data Type:** double (Type 4: `(61/20) + 1 = 4`)

## Implementation Details
- **Parallel Version:** Uses OpenMP tasks with dynamic work distribution
- **Sequential Version:** Simple iterative approach for baseline comparison
- **Thread Management:** Configurable thread count via command line

## Build Instructions
```bash
# Build both versions
make all

# Build and run parallel version (default: 4 threads, test array)
make parallel

# Build and run sequential version (default: test array)
make sequential

# Clean build files
make clean

# Show help with examples
make help
```

## Usage Examples
```bash
# Parallel version with default test array (4 threads)
make parallel

# Parallel version with 2 threads
make parallel N=2

# Parallel version with custom array
make parallel array='1.5 -2.0 3.0 -4.0 5.5'

# Parallel version with custom array and 3 threads
make parallel N=3 array='1.5 -2.0 3.0 -4.0 5.5'

# Sequential version with default array
make sequential

# Sequential version with custom array
make sequential array='1.5 -2.0 3.0 -4.0 5.5'
```

## Example Output
```
Student: Uma Khasanova
Number: 61
Task: Count positive elements in array
Implementation: OpenMP tasks (parallel)
Threads: 4
Data type: double
Array size: 20
Using default test array

Array elements:
3.5 (+), -2.1, 0.0, 7.8 (+), -1.2, 
4.2 (+), -3.0, 0.5 (+), -0.1, 2.3 (+),
-5.6, 1.1 (+), -2.8, 3.3 (+), -4.4,
6.6 (+), -7.7, 8.8 (+), -9.9, 10.0 (+)

Result: 9 positive elements found
Expected for default array: 9 positive elements

Correct number of positive elements
```


## Requirements
- GCC/G++ compiler with OpenMP support
- C++17 compatible standard library
- Linux/Unix environment or MSYS2/MinGW on Windows
