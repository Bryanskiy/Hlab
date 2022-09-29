.PHONY: all clean dump_ir

all: clean
	gcc main.c -c -o main.o
	g++ draw.cpp -c -o draw.o
	g++ main.o draw.o -o CA -lsfml-graphics -lsfml-window -lsfml-system

dump_ir: 
	clang main.c -S -emit-llvm -o ir.ll

clean:
	rm -rf *.o