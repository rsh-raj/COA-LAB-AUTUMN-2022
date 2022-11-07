# file_name = ALU_control_tb.v
file_name = CPU_tb.v
# file=assembler/test.s

a.vvp: ${file_name} 
	iverilog -o a.vvp ${file_name}
	vvp a.vvp
	
# assembler/outputFile: a.out
# 	./a.out $(file)

# assembler/a.out: assembler/assembler.cpp
# 	g++ assembler/assembler.cpp
	
clean:
	rm -f a.vvp