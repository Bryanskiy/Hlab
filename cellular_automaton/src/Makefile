.PHONY: all clean dump_ir

all: clean
	gcc main.c -c -o main.o -O2
	g++ draw.cpp -c -o draw.o -O2
	g++ main.o draw.o -o CA -lsfml-graphics -lsfml-window -lsfml-system -O2

dump_ir: 
	clang main.c -S -emit-llvm -o ir.ll

clean:
	rm -rf *.o