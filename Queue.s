# Shahnawaz Khan
# 2020CSB1123

# Implementation of Queue Data structure in RiscV

# Note:
#       * The input is case sensitive.
#       * Enter E <space> <num> to enque a number
#       * Enter D for Deque and S to get the size at address 0x10005000
#       * Seperate each instruction by space
#       * Do not enter any unknown character
#       * Do not enter any space between - and number in case of negative number
#		* When S is called, the size is stored in the memory location  0x10005000
#		* When deque is called, the start pointer just shifts to the next word. The removed word may remian in the memory but it will not be a part of queue


# Assembly Directives

.data
Input: .string "D D D D D E 34 E 12 E 11 E -24354657 E 1 S D S" #Edit the characters inside double quotes to make an input


# Main program

.text
# Main Fuction that is to be executed First
main:

    lui x18 65537       #Start of the queue struct. x18 contains 0x10001000 and this location will store first element of the queue.
    addi x5 x18 4       #Next location in memory which stores the address the last element of the queue.
    addi x6 x5 4        #Queue will start from this location initially
    sw x6 0(x18)        #First element of the queue at 0x10001000 + 0x8
    sw x6 0(x5)         #Last element also points at same location
    addi x31 x0 32      # Stores Ascii Value of Space " "
    addi x28 x0 69      # Stores Ascii Value of E
    addi x29 x0 68      # Store Ascii Value of D
    addi x30 x0 83      # Store Ascii Value of S
    addi x27 x0 45      # Store Ascii Value of character '-'
    la x9 Input         #Loads the address of the Input String


# A loop for iterating characters of the input string
LoopThroughInstruction:

    lb x5 0(x9)             #Load the character in x5
    beq x5 x31 Continue     #If the character is space then continue
    beq x5 x28 CallEnqueue  #If the character is E, then call Enque Function
    beq x5 x29 CallDeque    #If the character is D, then call Deque Function
    beq x5 x30 CallSize     #If the character is S, then call Size function
    beq x5 x0 Exit          #If its a null character, then Exit


Continue:
    addi x9 x9 1                        #Move to the byte to read in next iteration
    beq x0 x0 LoopThroughInstruction    #Jump to start of the Loop

#A block used to call function Size
CallSize:

    addi x9 x9 1                        #Move to the next byte for next iteration
    jal x1 Size                         #Call the function Size
    beq x0 x0 LoopThroughInstruction    #Jump to the start of the loop after Size function returns

#A block used to call function Dequeue
CallDeque:

    addi x9 x9 1                        #Move to the next byte
    jal x1 Deque                        #Call the function Deque
    beq x0 x0 LoopThroughInstruction    #Move to the start of the loop

#A function used to call Enque Fuction
CallEnqueue:

    addi x9 x9 2                #Move two bytes ahead(Next byte is guaranteed to be a whitespace)
    lb x5 0(x9)                 #Load the character into register x9
    addi x14 x0 0               #Store 0 in x14
    bne x5 x27 Call             #If the current character is not '-' sign, then directly call
    addi x9 x9 1                #If the current character is '-', then move to the next byte
    addi x14 x0 1               #If the current character is '-', then make x14 as 1
    Call:
        jal x1 AsciiToInt                   #Call function to convert Ascii to int value and store it in register x11
        jal x1 Enqueue                      #Call Enque
        beq x0 x0 LoopThroughInstruction    #Move to the start of the loop after returning

#A subroutine to convert Ascii value to integer
AsciiToInt:

    add x11 x0 x0               #Initialise value of x11 to 0
    
    #Start itering through digits
    LoopBegin:
        lb x5 0(x9)                 #Load the digit
        beq x5 x0 ReturnToMain      #If the character is null then return to Main
        beq x5 x31 ReturnToMain     #If the character is space, then also retun
        addi x5 x5 -48              #Get the numerical value of the digit from its 
        slli x7 x11 1               #Multiply contents of x11 by 2 and store it in x7
        slli x11 x11 3              #Multiply contents of x11 by 8 and store it in x11
        add x11 x11 x7              #Add contents of x7 and x11 to get the value of x11 multiplied by 10
        beq x14 x0 AddDigit         #If x14 is 0, then the number is positive. So add the current digit tp x11
        sub x11 x11 x5              #If the number is negtive, then subtract the digit
        beq x0 x0 ExitIf            #Exit the if statement
        #Add the digit if the number is positive
        AddDigit:
        	add x11 x11 x5          #Add the digit
        ExitIf:
        addi x9 x9 1                #Move to the next byte
        beq x0 x0 LoopBegin         #Iterate the next digit

    ReturnToMain:
        jalr x0 x1 0 #Return to main

#A function for enque operation
Enqueue:

    lw x5 4(x18)    #Load the address of last pointer of the queue
    sw x11 0(x5)    #Store the number in x11 to the last pointer of the queue
    addi x5 x5 4    #Move the end of queue to next integer
    sw x5 4(x18)    #Store new address of the last pointer in the main memory
    jalr x0 x1 0    #Return to the Main function

#A function for performing the deque operatin
Deque:
    lw x5 0(x18)                    #Load the address of first element of the queue
    lw x6 4(x18)                    #Load the address of the last element of the queue
    beq x5 x6 ReturnFromDequeue     #If both the addresses are same, then queue is already empty
    addi x5 x5 4                    #Move the start pointer to next word(In other words, the first element is removed)
    sw x5 0(x18)                    #Store the new address in the memory
    ReturnFromDequeue:
    	jalr x0 x1 0        #Return to the main

#A function for getting the size of the queue
Size:
    lw x5 0(x18)            #Load the start pointer of the queue
    lw x6 4(x18)            #Load the end pointer of the queue
    sub x7 x6 x5            #Subtract the start pointer from the end pointer3
    srli x7 x7 2            #Divide the result by 4 to get the size
    lui x5 0x10005          #Load 0x10005000 in the register
    sw x7 0(x5)             #Store the size in the address given in x5
    jalr x0 x1 0            #Return to the main

#Exit of the program
Exit: