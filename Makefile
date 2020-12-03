  
CC := g++
CFLAGS := -Wall -Wextra -std=c++11 # without debug
TARGET := ./main

all: run

main.lex.yy.c: main.l
	 flex --noyywrap -o main.lex.yy.cpp  main.l

main.tab.c: main.y
	bison -o main.tab.cpp --defines=main.tab.h -v main.y

pch.h.gch: pch.h
	g++ -x c++-header -o pch.h.gch -c pch.h

lex: main.lex.yy.c

yacc: main.tab.c

main: pch.h.gch
	$(CC) $(CFLAGS) $(shell ls ./*.cpp) -o ./main

.PHONY: all clean main run lex yacc test debug link testscope asm nasm example-code out

run: lex yacc main

clean:
	rm -f *.output lex.yy.cc main.tab.cpp main.tab.h main.output pch.h.gch main.tab.cc test/*.res


test:
	for file in $(basename $(shell find test/*.c)); \
	do \
		./main <$$file.c >$$file.res; \
	done
