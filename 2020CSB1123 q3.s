# Shahnawaz Khan
# 2020CSB1123

# Note:
#        *. Write the instruction in hex or decimal format in the InstructionCode label
#        *. It stores the information in this way -> rs1, rs2, rd, immediate and opcode in the memory. In some instruction type, rd or rs2 or immediate may not exist. In this case the next memory location contains the next available element keeping the sequence of rs1, rs2, rd, immediate and opcode same.(More details at corresponding labels)
#        *. The absolute value of the immediate is stored which is extracted from the machine instruction. The sign of the immediate is ignored.
#        *. In Sb type instruction, the stored value doesn't append 0 at the end to make complete value. the stored value is directly taken from the instruction and stored.
#        *. As per the instruction in the assignment, only 7 digit op code is stored

.data
InstructionCode: .word	0x80C28063      #Edit the number present here to make an input

.text

la x5 InstructionCode 	#Loading address of Input data
lui x9 0x10001			#Load the address of Output location
lw x5 0(x5)				#Load the input in the register x5
andi x6 x5 0x7f			#Take and with 0b1111111 to extract opCode and save it into x6
addi x7 x0 0x33			#Load opcode of add instruction in register x7
beq x6 x7 CaseRtype		#If opcode matches, then jump to the CaseRtype label
addi x7 x0 0x13			#Load opcode of slti instruction in register x7
beq x6 x7 CaseItype		#If opcode matches, then jump to the CaseItype label
addi x7 x0 0x3			#Load opcode of lw instruction in register x7
beq x6 x7 CaseItype		#If opcode matches, then jump to the CaseItype label
addi x7 x0 0x23			#Load opcode of sw instruction in register x7
beq x6 x7 CaseStype		#If opcode matches, then jump to the CaseStype label
addi x7 x0 0x63 		#Load opcode of beq instruction in register x7
beq x6 x7 CaseSbtype	#If opcode matches, then jump to the CaseSbtype label

CaseRtype:

#Storage Format -> rs1 rs2 rd opcode [All the values are stored as a 32 bit integer starting from 0x10001000]

    srli x28 x5 15          #Right shift to extract rs1
    andi x28 x28 0x1F       #And with 0b11111 to get value of rs1
    sw x28 0(x9)            #Store the value of rs1
    srli x28 x5 20          #Right shift to extract rs2
    andi x28 x28 0x1F       #And with 0b11111 to get value of rs2
    sw x28 4(x9)            #Store the value of rs2
    srli x28 x5 7           #Right shift to extract rd
    andi x28 x28 0x1F       #And with 0b11111 to get the value of rd
    sw x28 8(x9)            #Store the value of rd in memory
    beq x0 x0 Exit          #Go to exit


CaseItype:

#Storage Format -> rs1 rd immediate opcode [All the values are stored as a 32 bit integer starting from 0x10001000 and the sign of immediate is ignored]

    srli x28 x5 15          #Right shift to extract rs1
    andi x28 x28 0x1F       #And with 0b11111 to get value of rs1
    sw x28 0(x9)            #Store the value in the memory
    srli x28 x5 7           #Right shift to extract rd
    andi x28 x28 0x1F       #And with 0b11111 to get value of rd
    sw x28 4(x9)            #Store the value in the memory
    srli x28 x5 20          #Right shift to extract immediate
    sw x28 8(x9)            #Store immediate in the memory
    beq x0 x0 Exit          #Go to exit

CaseStype:

#Storage Format -> rs1 r2 immediate opcode [All the values are stored as a 32 bit integer starting from 0x10001000 and the sign of immediate is ignored]

    srli x28 x5 15          #Right shift to extract rs1
    andi x28 x28 0x1F       #And with 0b11111 to get value of rs1
    sw x28 0(x9)            #Store the value in memory
    srli x28 x5 20          #Right shift to extract rs2
    andi x28 x28 0x1F       #And with 0b11111 to get value of rs2
    sw x28 4(x9)            #Store the value in memory
    srli x28 x5 25          #Shifting the instruction by 25 to get last 7 bits
    slli x28 x28 5          #Shifting left to relocate them at appropriate place
    srli x29 x5 7           #Shifting the value by 7 to get 5 bits of immediate
    andi x29 x29 0x1F       #Add to get absolute value of 5 bits of instruction
    add x28 x28 x29         #Add these two values to get complete address
    sw x28 8(x9)            #Store the immediate value
    beq x0 x0 Exit          #Exit after storing everything

CaseSbtype:

#Storage Format -> rs1 r2 immediate opcode [All the values are stored as a 32 bit integer starting from 0x10001000 and the sign of immediate is ignored. Only imm[12:1] is stored as an integer]

    srli x28 x5 15          #Right shift to extract rs1
    andi x28 x28 0x1F       #And with 0b11111 to get value of rs1
    sw x28 0(x9)            #Store into memory
    srli x28 x5 20          #Right shift to extract rs2
    andi x28 x28 0x1F       #And with 0b11111 to get value of rs2
    sw x28 4(x9)            #Store into memory
    srli x28 x5 7           #Shift right by 7 units to get imme[4:1|11] at the last 5 bits
    andi x28 x28 0x1F       #And with 0b11111 to get last 5 bits
    srli x29 x5 25          #Shift right by 25 units to get last 7 bits of immediate[12|10:5]
    slli x29 x29 5          #Left shift to get the values at appropriate postitions
    add x28 x28 x29         #Add the values. Now, last bit of x28 contains imm[11] and x28[11] contains imm[12]
    srli x29 x29 11         #x29[11] conatains imm[12], so shift it by 11 to erase all other bits
    slli x29 x29 12         #Shift left by 12 to get it at appropriate position
    slli x28 x28 21         #Left shift by 21 to erase all bits after x28[10]
    srli x28 x28 21         #Bring all bits at thier appropraite position
    andi x30 x28 1          #And with 1 to get last bit of x28(Containing imm[11])
    slli x30 x30 11         #Shift x30 by 11 to get imm[11] at appropriate position
    add x28 x28 x30         #Place imm[11] bit in x28
    add x28 x28 x29         #Place imm[12] in x28
    srli x28 x28 1          #Shift immediate by 1 to remove imm[11] from the end.
    sw x28 8(x9)            #Store in the memory
    beq x0 x0 Exit          #Exit

Exit:

    sw x6 12(x9)            #Store the opcode at the end