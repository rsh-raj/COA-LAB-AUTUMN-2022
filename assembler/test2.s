nop
ld r2 12
ld r3 13
beq r2 r3 next
addi r5 30
next:
addi r5 69
halt

# exit:
# ld r2 7
# ld r3 -1
# addi r10 1000
# # printing array
# loop:
# lw r1 0(r0)
# addi r0 1
# add r2 r3
# addi r1 0
# bz r2 exit
# b loop

# exit:
# addi r1 0
# halt