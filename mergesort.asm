    .data
sep:    .asciiz "\n"
    .text
    .globl main
main:

    li $v0, 5
    syscall                 # get n
    move $s7, $v0           # store it in s7
    sll $s6, $v0, 2         # store array length 
    move $a0, $s6           # to allocate the memory
    li $v0, 9               # sbrk syscall code
    syscall
    move $s5,$v0            # store the pointer of the array
    li $v0, 9
    syscall
    move $s4, $v0           # another array for merging

    move $t0, $s5           # pointer of the array
    addu $t1, $s5, $s6      # latest element + 1
    
for:
    bgeu $t0, $t1, endfor   # if reached end stop the loop
    li $v0, 5               # for reading integer
    syscall
    sw $v0, 0($t0)          # store the word
    addi $t0, $t0, 4        # add to the pointer
    b for
endfor:

    move $a0, $s5           # pass the pointer of the first of them
                            # array to the first argument of the mergesrot
                            # function
    addu $a1, $s5, $s6      # pass the pointer of the element after the last
                            # part of the array as the second arguement to
                            # the mergesrot function
    jal mergesort           # call the mergesrot function

    ## print the output
    move $t0, $s5           # pointer
    addu $t1, $s5, $s6      # latest home + 1
printfor:
    bgeu $t0, $t1, endprintfor # if reached end stop the loop
    lw $a0, 0($t0)
    li $v0, 1               # for printing integer
    syscall
    #for printing sep
    li $v0, 4
    la $a0, sep
    syscall
    addi $t0, $t0, 4 # add to the pointer
    b printfor
endprintfor:
    li $v0, 10
    syscall # exit


mergesort:
    subu $t0, $a1, $a0
    bleu $t0, 4, endmergesort   # if the length of the array is less
                                # than or equal to one, just simply
                                # return
    # find the middle point of the array
    subu $t0, $a0, $a1          # the length of the array memory in
                                # bytes
    srl $t0, $t0, 2             # divide it by 4 to get the actual
                                # size of the array
    li $t1, 2                   # load 2
    divu $t0,  $t1              # divide the size by 2
    mfhi $t2                    # get the remainder to use it later
    # find the mean of the begin and end pointers: (begin + end)/2
    addu $t0, $a0, $a1          # add them up
    divu $t0, $t1               # divide them by 2
    mflo $t0                    # load the result
    beq $t2, 0, jumpeven        # if the remainder was even then go to jumpeven
    addu $t0, $t0, 2            # else add 2 to the median of the pointers 
                                # to get the elem at index [n/2]+1
jumpeven:                       # if it was even there's no shit to do
    # stored bastards we want so we can make recursion call
    addu $sp, $sp, -16
    sw $t0, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $ra, 12($sp)
    move $a1, $t0
    jal mergesort               # get the first half sorted
    lw $a0, 0($sp)              # restore $a0
    lw $a1, 8($sp)              # restore $a1
    jal mergesort               # get the second half sorted
    # restore the saved bastards
    lw $a0, 4($sp)
    lw $a1, 0($sp)
    lw $a2, 8($sp)
    jal merge                   # merge the sorted halves
    lw $ra, 12($sp)
    addu $sp, $sp, 16           # decrement the stack
endmergesort:
    jr $ra                      # return the hell out of this place


merge:                          # a0, #a1, #a2 are first last and middle
    # move the shits we want in temps
    move $t0, $a0               # pointer to first part
    move $t1, $a1               # pointer to second part
    move $t2, $s4               # $s4 holds the array we allocated for u
mergewhile:
    # if each of $t0 and $t1 and get out of their boundaries go to endmergewhile
    bgeu $t0, $a1, endmergewhile
    bgeu $t1, $a2, endmergewhile
    lw $t3, 0($t0)
    lw $t4, 0($t1)
    bgtu $t3, $t4, else         # if $t3 is greater than $t4 go to else
    sw $t3, 0($t2)              # and if not store $t3 in $t2
    addiu $t0, $t0, 4           # move $t0 by one
    addiu $t2, $t2, 4           # move $t2 by one
    b endif
else:
    sw $t4, 0($t2)              # store $t4 in $t2
    addiu $t1, $t1, 4           # move $t1 by one
    addiu $t2, $t2, 4           # move $t2 by one
endif:
    b  mergewhile               # get the hell back to the beggning of the loop
endmergewhile:
whileleft:                      # store what the hello if left on the left array
                                # to the temp array
    bgeu $t0, $a1, endwhileleft # check if shit is left
    lw $t3, 0($t0)              # load it from left
    sw $t3, 0($t2)              # store it to temp array
    addiu $t0, $t0, 4           # move $t0 by one
    addiu $t2, $t2, 4           # move $t2 by one
    b whileleft                 # get the hell back to beggining of the loop
endwhileleft:
whileright:                     # the same shit for the right side
    bgeu $t1, $a2, endwhileright # check if shit is left
    lw $t4, 0($t1)              # load it from right
    sw $t4, 0($t2)              # store it to temp array
    addiu $t1, $t1, 4           # move $t1 by one
    addiu $t2, $t2, 4           # move $t2 by one
    b whileleft                 # get the hell back to beggining of the loop
endwhileright:
    move $t0, $a0               # set the pointer back to the beggining
    move $t1, $s4
whilecopy:                      # copy from temp to the original array
    bgeu $t0, $a2, endwhilecopy # check if we have reacked end of the array
    lw $t2, 0($t1)              # load from temp array
    sw $t2, 0($t0)              # store it to original
    addiu $t0, $t0, 4           # move $t0 by one
    addiu $t1, $t1, 4           # move $t1 by one
    b whilecopy                 # get back to loop
endwhilecopy:
    jr $ra                      # finally return :))))
