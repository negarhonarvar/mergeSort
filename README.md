# MIPS Merge Sort Implementation

### Overview
This project implements the **Merge Sort** algorithm in **MIPS assembly language**. The objective is to sort an array provided by the user using the divide-and-conquer merge sort method, leveraging the architecture and functionalities of the MIPS processor. This project also showcases how to manage arrays, memory allocation, stack operations, and recursive function calls in assembly.

---

### Key Sections

1. **Array Input and Setup**:
   - The main function initializes by taking input for the number of elements in the array.
   - The array is stored in memory, and a pointer to the array is managed using MIPS registers.
   - A memory allocation process is initiated to handle the array dynamically, preparing for the sorting procedure.

2. **Recursive Merge Sort Implementation**:
   - The array is split into smaller sub-arrays using recursion, where each sub-array is processed individually.
   - A pointer-based mechanism is used to track and merge the sub-arrays after sorting.

3. **Partitioning and Sorting**:
   - During each merge step, the array is divided into two halves.
   - The sorting is done recursively by comparing elements from each half, merging them in order.

4. **Stack Management**:
   - The project effectively uses stack operations (`push`, `pop`) to handle recursive function calls and manage local variables in MIPS.
   - Temporary results and pointers are saved to and restored from the stack as necessary.

5. **Random Partitioning**:
   - A random partition is introduced to shuffle the array before sorting, which helps in avoiding worst-case scenarios.
   - The partitioning step ensures a more uniform performance of the merge sort.

6. **Performance Considerations**:
   - The merge sort algorithm is implemented in an optimized way, ensuring efficient sorting by recursively dividing and merging the sub-arrays.
   - The code uses various MIPS instructions to manipulate memory addresses and handle large datasets efficiently.

---

### How to Use
1. **Input**: 
   - The program begins by accepting the number of elements in the array and the array elements themselves.
   
2. **Sorting**:
   - The merge sort algorithm will recursively sort the input array and return the sorted array.

3. **Output**:
   - The sorted array is printed to the console at the end of the process, demonstrating the successful implementation of the sorting algorithm in MIPS assembly.

---

### How To Run The Code
Use Mars environment for editting and running the code, Run run.sh to test the code.
