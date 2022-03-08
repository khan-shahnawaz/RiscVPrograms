# Shahnawaz Khan
# 2020CSB1123

# Merging two lists in RiscV

# Note:
#
#    * Edit the contents in the .data to provide input
#    * All the elements should be fit under 32 bits
#    * The elements are inserted in sorted order seperated by space
#    * Number of elements in atleast one of the array should be greater than 0.
#    * ListLen should be correct and consistent with the List.


.data

List1: .word 12 13 14           #Enter the list elements seperated by space
ListLen1: .word 3               #Enter number of elements in the first list
List2: .word -4 -1 0 7 10       #Enter the list elements seperated by space
ListLen2: .word 5               #Enter number of elements in the second list


.text

la x11 List1        #Load address of first List
la x12 List2        #Load address of the Second List
la x5 ListLen1      #Load address of the Location storing length of List1
la x6 ListLen2      #Load address of the Location storing length of List2
lw x6 0(x6)         #Load the length of List2
lw x5 0(x5)         #Load the length of List1
slli x5 x5 2        #Multiply the length of list1 by 4
slli x6 x6 2        #Multiply the length of list2 by 4
add x5 x5 x11       #Add the start address of List1 to get the end address of List2
add x6 x6 x12       #Add the start address of List1 to get the end address of List1
lui x9 0x10001      #Load 0x10001000 in x9 register to store the sorted list

#Beginning of While Loop
LoopBegin:

    bne x5 x11 Else1        #Checking if all elements of List1 are already stored or not
    lw x28 0(x12)           #If List1 has reached its end, then load element of List2
    sw x28 0(x9)            #Store the contents in the memory
    addi x9 x9 4            #Move to the next memory location
    addi x12 x12 4          #Move to the next memory location for List2
    beq x6 x12 Exit         #When the second list is empty also, then break
    beq x0 x0 LoopBegin     #Jump to the begin of the loop

Else1:

    bne x6 x12 Else2        #Checking if all elements of List2 are already stored or not
    lw x28 0(x11)           #If List2 has reached its end, then load element of List1
    sw x28 0(x9)            #Store the contents in the memory
    addi x9 x9 4            #Move to the next memory location
    addi x11 x11 4          #Move to the next memory location for List1
    beq x5 x11 Exit         #When the first list becomes empty also, then break
    beq x0 x0 LoopBegin     #Jump to the begin of the loop

Else2:

    lw x28 0(x11)           #Load an element of first List
    lw x29 0(x12)           #Load an element of second List
    blt x28 x29 JoinFirst   #If first element is smaller, then join first element
    sw x29 0(x9)            #Store the element in the memory
    addi x9 x9 4            #Go to the next memory location
    addi x12 x12 4          #Go to the next memory location of List 2
    beq x0 x0 LoopBegin     #Go to the Beginning again
    
    JoinFirst:
        sw x28 0(x9)        #Store the contents of list1 to memory
        addi x9 x9 4        #Go to the next memory location
        addi x11 x11 4      #Go to next memory location 
        beq x0 x0 LoopBegin #Start from beginning again

Exit: