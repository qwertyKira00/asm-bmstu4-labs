hd.exe:
	nasm -f elf64 -o str_copy.o str_copy.asm
	gcc -c -masm=intel -o main.o main.c
	gcc -o $@ main.o str_copy.o

run:
	./hd.exe

clean:
	rm -f *.o *.exe
