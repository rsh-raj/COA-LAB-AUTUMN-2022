file_name = CPU_tb.v

a.vvp: ${file_name}
	iverilog -o a.vvp ${file_name}
	vvp a.vvp

clean:
	rm -f a.vvp