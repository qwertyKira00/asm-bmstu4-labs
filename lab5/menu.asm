EXTRN input: NEAR
EXTRN convert_h: NEAR
EXTRN convert_b: NEAR
EXTRN NewLine: NEAR
EXTRN print: NEAR
PUBLIC exit

STK  SEGMENT PARA STACK 'STACK'
     DB    200h DUP (?)
STK  ENDS

DataS  SEGMENT PARA PUBLIC 'DATA'
message DB    "MENU: ", 10, 13
        DB    "1 - Input number (octal notation)", 10, 13
        DB    "2 - Print number in binary notation(signed)", 10, 13
        DB    "3 - Print number in hexadecimal notation(unsigned)", 10, 13
        DB    "4 - EXIT", 10, 13
        DB    "Choose option: ", "$", 10, 13
ar_ptr  DW    input, convert_b, convert_h, exit
error   DB    "Incorrect number$"
buffer  DB     10 Dup(?)

DataS  ENDS

CodeS  SEGMENT PARA PUBLIC 'CODE'
       ASSUME CS:CodeS, DS:DataS, SS:STK

exit PROC NEAR

       MOV AH,4Ch
       INT 21h
exit ENDP

main:
	     MOV AX, DataS
	     MOV DS, AX

       MOV AH, 09h                 ;Вывод меню
       MOV DX, OFFSET message
       INT 21h

       MOV AH, 01h                 ;Ввод пользователем номера опции
       INT 21h

       CMP AL, 31h                 ;Проверка на корректность ввода
       JB exit
       CMP AL, 34h
       JA exit

       MOV AH, 0
       SUB AL, 31h
       MOV DL, 2
       MUL DL
       MOV SI, AX

       CALL NewLine
       XOR AX, AX
       MOV AX, BX
       CALL ar_ptr[SI]
       CMP BX, 0
       JE store
       CALL NewLine

       JMP main
store:
       MOV BX, AX
       CALL print
       CALL NewLine
       JMP main

CodeS   ENDS
	END   main
