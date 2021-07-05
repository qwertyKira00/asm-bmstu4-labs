PUBLIC convert_h
PUBLIC convert_b
EXTRN NewLine: NEAR

DataS  SEGMENT PARA PUBLIC 'DATA'
base_h DW  16
base_b DW  2
unsigned DB "Unsigned number: ", "$", 10, 13

DataS  ENDS

CodeS SEGMENT PARA PUBLIC 'CODE'
      ASSUME CS:CodeS, DS:DataS

convert_h PROC NEAR
      MOV CX, 0               ;количество выводимых цифр
division16:
      XOR DX, DX
      DIV base_h              ;делим AX на 16(основание системы счисления)
      ;AND DL, 0Fh
      ; Далее, смотрим, выводить её цифрой или буквой. Если цифрой, то число надо
      ; увеличить на 30h, чтобы из 0..9 сделать 30h..39h - коды '0'..'9'.
      ; Если же буквой, то из 10..15 надо сделать 41h..46h - коды 'A'..'F',
      ; то есть число увеличить на 37h.
      CMP DL, 9
      JBE digital
      ADD DL, 7
digital:
      ADD DL, 30h

      PUSH DX                 ;и сохраняем его в стеке
      INC CX                  ;увеличиваем счётчик цифр
      TEST AX, AX             ;(выполняет логическое И между всеми битами двух операндов)
      JNZ division16          ;ZF = 0 - повторить цикл выделения цифры (если не ноль)
show16:
      MOV AH, 02h         ;функция ah=02h int 21h - вывести символ из dl на экран
      POP DX              ;извлекаем из стека очередную цифру
      INT 21h             ;и выводим её на экран
      LOOP show16         ;и так поступаем столько раз, сколько нашли цифр в числе (cx)
      RET
convert_h ENDP

convert_b PROC NEAR
      MOV DI, 0
      MOV CX, 0               ;количество выводимых цифр

      MOV AX, DataS
      MOV DS, AX
      MOV DX, OFFSET unsigned
      MOV AH, 09h
      INT 21h
      MOV AX, BX

division2:
      XOR DX, DX
      DIV base_b              ;делим AX на 2 (основание системы счисления)
      ADD DL, '0'             ;преобразуем остаток деления в символ цифры
      PUSH DX                 ;и сохраняем его в стеке
      INC CX                  ;увеличиваем счётчик цифр
      TEST AX, AX
      JNZ division2           ;ZF = 0 - повторить цикл выделения цифры

      CMP DI, 1
      JNE show2
minus:
      MOV AH, 02h
      MOV DX, '-'
      INT 21h
show2_neg:
      POP DX
      INT 21h
      LOOP show2_neg
      CMP DI, 1
      JE end_of           ;если равно
show2:
      MOV AH, 02h         ;функция ah=02h int 21h - вывести символ из dl на экран
      POP DX              ;извлекаем из стека очередную цифру
      INT 21h             ;и выводим её на экран
      LOOP show2          ;и так поступаем столько раз, сколько нашли цифр в числе (cx)

      CALL NewLine
      MOV AX, BX
      SHL AX, 1
      JNC end_of          ;флаг переноса CF = 0 => старший бит AX равен 0

      RCR AX, 1
      NEG AX
      MOV DI, 1
      XOR CX, CX
      CALL division2

end_of:
      RET
convert_b ENDP

CodeS   ENDS
END
