compile:
	verilator --cc --exe --build --trace -j 4 main.cc state.sv

run:
	./obj_dir/Vstate


clean:
	-rm -rf obj_dir/