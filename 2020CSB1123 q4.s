# Shahnawaz Khan
# 2020CSB1123

#Note:
#       *. Give two string as an input in .data section
#       *. It is assumed that the input contains character a-z and A-Z only.
#       *. The length of the string is not used in the program since the end of the string can be detected by Null character only.
#       *. The length of both the strings should be same

.data
string1: .string "fdnsadknnf"       #Input First string
string2: .string "aslgdkfnln"       #Input Second String
size: .word 10                      #Input size of the string [Optional]

.text

add x7 x0 x0            #Initialsing the register x7 with 0
la x11 string1          #Loading the address of the first string
la x12 string2          #Load the address of the second string
lui x28 0x10001         #Load the address 0x10001000 in register x28
lui x29 0x10002         #Load the address 0x10002000 in register x29

StoreString:            #A function used to store string in the desired memory location

    lb x5 0(x11)            #Load the character of first string
    lb x6 0(x12)            #Load the character of second string
    beq x5 x0 ExitStoring   #If it is a Null character, then break from the loop  
    sb x5 0(x28)            #Store the character in the desired memory loaction
    sb x6 0(x29)            #Store the character of the second string in the memory
    addi x11 x11 1          #Move to the next byte of input string 1
    addi x12 x12 1          #Move to the next byte of input string 2
    addi x28 x28 1          #Move to the next byte storing string 1
    addi x29 x29 1          #Move to the next byte to store string 2
    beq x0 x0 StoreString   #Move to the start of the loop

ExitStoring:                #A subroutine which initialises the registers to start function count

    sb x0 0(x28)            #Store Null character at the end of the first string
    sb x0 0(x28)            #Store Null character at the end of the second string
    lui x11 0x10001         #Load the start address of the string 1
    lui x12 0x10002         #Load the start address of the string 2
    addi x28 x0 96          #Load 96(Small letters starts at 97 in ASCII)

FunctionCount:

    lb x5 0(x11)                    #Load character of first string
    lb x6 0(x12)                    #Load character of second string
    beq x5 x0 Exit                  #If its a null character, then exit the program
    ble x5 x28 DontCapitalise1      #If the character is less than 96, then its small letter.(No need to make it capital for comparison )
    addi x5 x5 -32                  #If its a small letter, then add 32 to make it capital temporarly
    DontCapitalise1:                
    ble x6 x28 DontCapitalise2      #If the character of the second string is capital then don't capitalise
    addi x6 x6 -32                  #Making the character of the second string captital temporarly
    DontCapitalise2:
    beq x5 x6 DontAdd               #If both characters are equal, then no need to increment x7
    addi x7 x7 1                    #If not equal, then increment x7 by 1
    DontAdd:
    addi x11 x11 1                  #Move to the next character of string 1
    addi x12 x12 1                  #Move to the next character of string 2
    beq x0 x0 FunctionCount         #Move back again to FunctionCount

Exit: