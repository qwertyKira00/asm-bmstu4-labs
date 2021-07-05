PUBLIC input
EXTRN exit: NEAR
EXTRN NewLine: NEAR

DataS   SEGMENT PARA PUBLIC 'DATA'
error   DB    "Incorrect number$"
buffer  DB    7,7 Dup(?)

DataS   ENDS

CodeS  SEGMENT PARA PUBLIC 'CODE'
       ASSUME CS:CodeS, DS:DataS

input PROC NEAR

       MOV DX, OFFSET buffer
       MOV AH, 0Ah
       INT 21h                      ;Ввод строки
       CALL NewLine

       MOV SI, OFFSET buffer + 2    ;Адрес начала строки

notation:
       XOR AX, AX
       MOV BX, 8                    ;Основание системы счисления
input_number:
       MOV CH, 0
       MOV CL,[si]                  ;Символ из буфера
       CMP CL, 0Dh                  ;Проверка на конец строки
       JE ending

       CMP CL, '0'                   ;Проверка на корректный ввод
       JB error_exit
       CMP CL, '7'
       JA error_exit

       AND CL, 0Fh
       MUL BX                        ;Умножили на 8
       ADD AX, CX
       INC SI
       JMP input_number              ;Продолжение цикла

error_exit:
       MOV DX, OFFSET error
       MOV AH, 09h
       INT 21h
       CALL exit

ending:
        XOR BX, BX
        RET
input ENDP

CodeS   ENDS
END
