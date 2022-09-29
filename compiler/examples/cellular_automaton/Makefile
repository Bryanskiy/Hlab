.PHONY: all clean

all: clean
	gcc main.c -c -o main.o
	g++ draw.cpp -c -o draw.o
	g++ main.o draw.o -o CA -lsfml-graphics -lsfml-window -lsfml-system

clean:
	rm -rf *.o