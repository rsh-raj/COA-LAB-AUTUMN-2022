add r0  r1
comp r2 r10
and r3 r4
xor r4 r3
xor r1 r2
diff r3 r4
addi r1 4
compi r2 3
shllv r1 r2
shrl r2 r10
shrav r3 r9
shll r1 10
shrl r5 2
shra r5 6
nop
lw r1 10(r3)
sw r2 11(r2)
for:
add r1 r2
add r3 r4
bltz r2,for
bz r1,for
L:
bnz r2,L 
br r1 
b L 
bcy L 
bncy for
bl L
