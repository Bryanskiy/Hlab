.PHONY: all clean dump_ir

DRAW_PATH="../../src/draw.cpp"
INIT_WORLD_CODEGEN="main.ll"

all: clean
	clang++ $(DRAW_PATH) -c -o draw.o -O2
	clang++ $(INIT_WORLD_CODEGEN) -c -o main.o -O2
	clang++ draw.o main.o -o CA -lsfml-graphics -lsfml-window -lsfml-system -O2

clean:
	rm -rf *.o
	rm -rf CA