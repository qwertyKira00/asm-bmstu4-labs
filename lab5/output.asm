PUBLIC NewLine
PUBLIC print

DataS  SEGMENT PARA PUBLIC 'DATA'
m      DB    "Entered number is ", "$", 10, 13
base   DW     8

DataS ENDS

CodeS SEGMENT PARA PUBLIC 'CODE'
      ASSUME CS:CodeS, DS:DataS

print PROC NEAR
      MOV CX, 0               ;количество выводимых цифр
division:
      XOR DX, DX
      DIV base                ;делим AX на 8 (основание системы счисления)
      ADD DL, '0'             ;преобразуем остаток деления в символ цифры
      PUSH DX                 ;и сохраняем его в стеке
      INC CX                  ;увеличиваем счётчик цифр
      TEST AX, AX             ;в числе ещё есть цифры?
      JNZ division            ;да - повторить цикл выделения цифры

      MOV AX, DataS
      MOV DS, AX
      MOV DX, OFFSET m
      MOV AH, 09h
      INT 21h
show:
      MOV AH, 02h         ;функция ah=02h int 21h - вывести символ из dl на экран
      POP DX              ;извлекаем из стека очередную цифру
      INT 21h             ;и выводим её на экран
      LOOP show           ;и так поступаем столько раз, сколько нашли цифр в числе (cx)        pop     bx
      RET
print ENDP


NewLine PROC NEAR
        MOV AH, 02h                 ;Функция вывода символа на экран 02h
        MOV DL, 13                  ;Возврат каретки
        INT 21h                     ;Вызов DOS
        MOV DL, 10                  ;Перевод строки
        INT 21h                     ;Вызов DOS
        RET
NewLine ENDP

CodeS   ENDS
END
