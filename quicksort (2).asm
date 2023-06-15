.data       # here is data segment
    enter_length: .asciiz "please enter the length of your array : "
    next_line: .asciiz "\n"
    .text       # here is text segment
    .globl main
    # we know that mips is not enough clever to run main at first so we declare it as our
    # first function
main: # declaration of function main
    la $a0, enter_length # load address of the text you want in $a0
    li $v0, 4 # define what system call you want
    syscall # call the system call
    li $v0, 5 # at first we need to read the length of our array
    move $s0, $v0 # now we move the value from $v0 to $s0 cause we want to use it later
    sll $s1,$s0,2 # we need to left shift our $s0 2 times to $s1 cause each array element occuipies
    # 4 bits 
    move $a0,$s1 # we move $s1 value to $a0
    li $v0, 9   # now we allocate heap memory which its size is equal to value stored in $a0
    syscall
    
    move $s2,$v0 # $s2 points to the array
    
    li $v0, 9 # heap memory allocation
    syscall
    
    move $t0,$s2 # now $t0 points to the beginning of our array
    add $t1,$s2,$s1 # now $t1 points to the end of our array

input_reading:

    bgeu $t0, $t1, end_of_input_reading # if we reach the last index of our array we will move to the mentioned function
    li $v0, 5 # we read an integer which will be an element of our array
    syscall
    sw $v0, 0($t0) # we move our element of array to $t0 and store it there
    addi $t0,$t0,4 # now we move $t0 4bits so that at the next round of our loop , the new elemnt would be stored 
    # in correct position and to finally reach the end loop condition
    b input_reading # the new element is stored in its right place and we are ready to assign the next array element to
    # input value
end_of_input_reading:
    move $a0,$s5 #$a0 points to the array
    li $a1, 0 #$a1 stores first index of our array
    addi $a2,$s0,-1 # now $a2 stores last inex of our array
    jal quick_sort # now we jump to quick_sort function and link our array to it
    sll $t7,$s0,2 # we left shift $s0 4 bits due to reason mentioned above and store it
    # in $t7,now $t7 stores the length of our array
    add $t7,$t7,$a0 #$a0 was already pointing to our array,by adding that to $t7 and storeing
    # the result in $t7 we made $t7 a pointer to last index of our array
    move $t0,$a0 # we store the $a0 value in $t0 and we make it a pointer to the beginning of
    # our array
print_array:
    bgeu $t0,$t7,end_of_print_array # similar to previous part , we first declare the loop end condition which functions just
    # like the previous part
    lw $a0, 0($t0) #load word:we set contents of $a0 to $t0
    li $v0, 1 # we print the integer which is our first array element
    syscall
    li $v0, 4 # load immediate
    la $a0, next_line # we load next_line address to $a0 so when we issue a system call it will be 
    # executed
    syscall
    addi $t0,$t0, 4 # we move to next array element by moving $t0 4 bits forward
    b print_array # we go back to beginning of our loop
 end_of_print_array:
 # if our loop is finished it means that we have printed all of our sorted array elements and we are done!
    li $v0, 10  # exit the program
    syscall     # make the systemcall
quick_sort:
    
    addi $sp,$sp, -16 # a stack pointer with 4 bytes space
    sw $a0, 0($sp) # we set $sp to point at our array , $a0
    sw $a1,4($sp) #low
    sw $a2,8($sp) #high
    sw $ra,12($sp) # return address
    
    move $t0 , $a2 # we set $a2=high to $t0
    
    slt $t1 ,$a1,$t0 # since $a1=low, if low < high then $t1=1 else its 0 , if low>high means our array is sort
    beq $t1,$zero,end_of_quick_sort # if our array is sorted then we jump to end_Of_quick_sort function
    
    jal random_partition #jump and link array to random_partition function
    move $s0,$v0 # pivot(pi)
    
    lw $a1, 4($sp) #a1=low
    addi $a2 ,$s0,-1 #$a2=pi-1
    jal quick_sort
    
    addi $a1,$s0, 1 #$a1=pi+1
    lw $a2, 8($sp) #$a2=high
    jal quick_sort 
    
end_of_quick_sort:
    lw $a0 ,0($sp) #load word $a0
    lw $a1,4($sp) #load word $a1
    lw $a2,8($sp) #load word $a2
    lw $ra,12($sp) #return address
    addi $sp,$sp,16 #stack
    jr $ra #now the array is sorted
random_partition:
    addi $sp, $sp, -16 # we consider 4 bytes for $sp(pointer)
    sw $a0, 0($sp) # store word $a0
    sw $a1, 4($sp) # store word $a1 = low
    sw $a2, 8($sp)  # store word $a2=high
    sw $ra, 12($sp) # return address
    
    li $a0 , 1 # low  a0=1
    li $a1 , 4 # high a1=4
    move $t0 , $a0 # save a0 in t0
    sub $a1,$a1,$a0 # high - low 
    li $v0, 42 # this order gives us a random number
    syscall # a random number in range ( 0 , high - low )
    add $a0 , $a0 , $t0 #  a random number in range ( low  , high )


    move $s0, $a1 #store s0 = low 
    move $s1 , $ra 	# s1 = return address as random number

    move $a0, $a1 # store $a0 = low 
    addi $a1, $a2, 0 # store $a1 = high 
    sub $a1, $a1, $a0 # store $a1 = high  - low

    div $s1, $a1 # $t0 = random number / (high -low)
    mfhi $a2 # $a2 = random number % (high -low)
    add $a1, $a0 , $a2 # $a1 = right + low

    lw $a0, 0($sp) #load word $a0
    lw $a2, 8($sp)	#load word $a2
# swap 
    jal swap
    lw $a1, 4($sp) #load word $a1
    jal partition

    lw $a0, 0($sp)#load word $a0
    lw $a1, 4($sp)#load word $a1
    lw $a2, 8($sp)#load word $a2
    lw $ra, 12($sp)	# return address
    addi $sp, $sp, 16 # stack    
    jr $ra # return 
swap: #swap method

     addi $sp, $sp, -12	# we consideer 12 bits(3 bytes) for following elemnts
     sw $a0, 0($sp) # Store word $a0
     sw $a1, 4($sp) # Store word $a1
     sw $a2, 8($sp) # store word $a2

     sll $t1, $a1, 2  #$t1 = 4a($a1*4 => because we had 2 left shifts)
     add $t1, $a0, $t1 #$t1 = arr + 4a
     lw $s3, 0($t1) #$t1 = array[a]

     sll $t2, $a2, 2  #$t2 = 4b
     add $t2, $a0, $t2 #$t2 = arr + 4b
     lw $s4, 0($t2) #$s4 = arr[b]

     sw $s4, 0($t1)#arr[a] = arr[b]
     sw $s3, 0($t2) #arr[b] = $t3 


     addi $sp, $sp, 12#Restoring the stack size
     jr $ra #jump back (return) to random partition
	


partition:
# we do the partitioning using pi,i and j , their function is the same as what they do in cpp mergesort code 			

     addi $sp, $sp, -16	# we consider 16 bits(4 bytes) for pointer

     sw $a0, 0($sp) #word store $a0
     sw $a1, 4($sp) #store $a1
     sw $a2, 8($sp) #store $a2 
     sw $ra, 12($sp) #store return address
	
     move $s1, $a1#$s1 = low
     move $s2, $a2#$s2 = high

     sll $t1, $s2, 2 # $t1 = 4*high, because we shifted $s2 to left 2 times
     add $t1, $a0, $t1# $t1 = array + 4*high
     lw $t9, 0($t1)# $t9 = array[high] (pi)
# the i and j,each one,point at one number in algorithm.after reaching the end of array they go back to beginning of our array
     addi $t3, $s1 , -1 #$t3, i=low -1
     move $t4, $s1#$t4, j=low
     addi $t5, $s2, -1	#$t5 = high - 1
for_Partition: 
     slt $t6, $t5, $t4 #$t6=1 if j>high-1, $t6=0 if j<=high-1
     bne $t6, $zero, end_for #if $t6=1 then branch to endfor

     sll $t1, $t4, 2 #$t1 = j*4
     add $t1, $t1, $a0 #$t1 = array + j*4
     lw $t7, 0($t1) #$t7 = array[j]

     slt $t8, $t9, $t7 #pi < array[j] =>$t8=1,else $t8=0
     bne $t8, $zero, If_For #if $t8=1 then branch to If_For
     addi $t3, $t3, 1 #moving i forward(i++)
     move $a1, $t3 #$a1 = i++
     move $a2, $t4 #$a2 = j
     jal swap #swap(array, i, j)
     addi $t4, $t4, 1 #j++
		
     j for_Partition # jump to for_partition function

If_For:
     addi $t4, $t4, 1 #moving j forward(j++)
     j for_Partition #jump back to for_Partition function

end_for:
     addi $a1, $t3, 1 #$a1 = i + 1
     move $a2, $s2 #$a2 = high
     add $v0, $zero, $a1 #$ v0 = i+1 => return (i + 1);
     jal swap #jump to swap(array, i + 1, high);
     lw $ra, 12($sp) #return address
     addi $sp, $sp, 16	#restore the stack
     jr $ra  #junp back to for_partition function
    
    
