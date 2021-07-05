STK  SEGMENT PARA STACK 'STACK'
     DB    100h DUP (?)
STK  ENDS

DataS1  SEGMENT WORD 'DATA'
N       DB    1                     ;Количество строк
M       DB    1                     ;Количество столбцов
index   DW    1
matrix  DB    81 DUP (0)            ;Зануленная матрица 9х9
DataS1  ENDS

DataS2  SEGMENT WORD 'DATA'
message    DB    "Enter n and m separated by space: ", "$", 13, 10
DataS2  ENDS

CodeS    SEGMENT WORD 'CODE'
         ASSUME CS:CodeS, DS:DataS1

NewLine:

        MOV AH, 02h                 ;Функция вывода символа на экран 02h
        MOV DL, 13                  ;Возврат каретки
        INT 21h                     ;Вызов DOS
        MOV DL, 10                  ;Перевод строки
        INT 21h                     ;Вызов DOS
	      RET

PRINT_MESSAGE:

        MOV AH, 09h
        LEA DX, DataS2:message
        INT 21h
        RET

INPUT_DIMENSION:

        MOV AH, 01h                 ;Функция считывания символа (находится в AL)
        INT 21h
        AND AL, 0Fh                 ;Получили младшую тетраду кода ASCII, чтобы перевести символ в цифру
        MOV N, AL                   ;Считали количество строк
        INT 21h

        INT 21h
        AND AL, 0Fh                 ;Получили младшую тетраду кода ASCII, чтобы перевести символ в цифру
        MOV M, AL                   ;Считали количество столбцов

        CMP M, 1                    ;Проверка на корректность M (должно быть > 1)
        JE EXIT                     ;Если M = 1, выдаем сообщение об ошибке, завершаем программу

        CALL NewLine
        RET

EXIT:

        MOV AH, 4Ch
        INT 21h

 GET_ADRESS:

        MOV AX, SI                   ;Вычисляем адрес элемента (i * m + j), где m - количество столбцов
        MOV BL, M                    ;i - индекс текущей строки (хранится в SI), j - индекс текущего
        MUL BL                       ;столбца (хранится в DI)
        ADD AX, DI
        MOV BX, AX                   ;Адрес хранится в BX

        RET

INPUT_MATRIX PROC NEAR

        MOV AH, 01h
        MOV SI, 0                    ;Установили счетчик по строкам в 0
        MOV CH, 0
        MOV CL, N
lp1:
        MOV index, CX                ;Сохранили значение счетчика CX
        MOV CH, 0
        MOV CL, M
        MOV DI, 0                    ;Установили счетчик по столбцам в 0
lp2:
        CALL GET_ADRESS              ;Получили адрес элемента матрицы

        MOV AH, 01h                  ;Считываем символ, переводим в цифру
        INT 21h
        AND AL, 0Fh

        MOV matrix[BX], AL

        INT 21h                      ;(обработка ввода пробела между цифрами)
        INC DI
        LOOP lp2

        CALL NewLine                  ;Новая строка
        MOV CX, index
        INC SI
        LOOP lp1

        RET
INPUT_MATRIX    ENDP

EXCHANGE PROC NEAR
        MOV SI, 0
        MOV CH, 0
        MOV CL, N
lp:

        CALL GET_ADRESS
        SUB BX, 1
        MOV AL, matrix[BX]
        ADD BX, 1
        MOV matrix[BX], AL
        INC SI
        LOOP lp

        RET
EXCHANGE ENDP

COLUMN_EXCHANGE PROC NEAR

        MOV DI, 1                    ;Установили счетчик по столбцам в 1
        MOV CH, 0
        MOV CL, M
        SUB CL, 1                    ;Итерация с 1 до M-1
lp1:
        MOV index, CX                ;Сохранили значение счетчика CX
        MOV CH, 0
        MOV CL, N
        MOV SI, 0                    ;Установили счетчик по строкам в 0
lp2:
        CALL GET_ADRESS              ;Получили адрес элемента матрицы

        CMP matrix[BX], 0            ;Сравнение элемента матрицы с 0
        JNE EndOfIf                  ;Переход, если не равно
        CALL EXCHANGE
        MOV CX, index
        INC DI
        LOOP lp1

        CMP CX, 0
        JE END_CYCLE

EndOfIf:
        INC SI
        LOOP lp2

        MOV CX, index
        INC DI
        LOOP lp1

END_CYCLE:
        RET
COLUMN_EXCHANGE    ENDP

PRINT_MATRIX PROC NEAR

        CALL NewLine

        MOV SI, 0                    ;Установили счетчик по строкам в 0
        MOV CH, 0
        MOV CL, N
lp1:
        MOV index, CX                ;Сохранили значение счетчика CX
        MOV CH, 0
        MOV CL, M
        MOV DI, 0                    ;Установили счетчик по столбцам в 0
lp2:
        CALL GET_ADRESS              ;Получили адрес элемента матрицы
        MOV DL, matrix[BX]           ;Загрузили элемент матрицы в DL
        ADD DL, 30h

        MOV AH, 02h                  ;Выводим символ
        INT 21h

        MOV DL, 20h                  ;код ASCII пробела
        INT 21h                      ;(обработка вывода пробела между цифрами)
        INC DI
        LOOP lp2

        CALL NewLine                  ;Новая строка
        MOV CX, index
        INC SI
        LOOP lp1

        RET
PRINT_MATRIX    ENDP

main:
	     MOV    AX, DataS1
	     MOV    DS, AX
	     CALL   PRINT_MESSAGE
       CALL   INPUT_DIMENSION
       CALL   INPUT_MATRIX
       CALL   COLUMN_EXCHANGE
       CALL   PRINT_MATRIX

       MOV AH,4Ch
       INT 21h

CodeS   ENDS
	END   main
