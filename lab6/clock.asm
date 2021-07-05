CODE  SEGMENT
      ASSUME  CS:CODE, DS:CODE
      ORG 100h                           ; размер PSP для COM программы
main:
        JMP start                        ; нерезидентная часть
        prev    DD  0                    ; адрес старого обработчика
        buffer  DB  ' 00:00:00 ',0        ; шаблон для вывода текущего времени

fill_template  PROC                      ; процедура заполнения шаблона
        MOV AH, AL                       ; преобразование числа в регистре AL в пару ASCII символов
        AND AL, 0Fh
        SHR AH, 1
        SHR AH, 1
        SHR AH, 1
        SHR AH, 1
        ADD AL, 30h
        ADD AH, 30h
        MOV buffer[bx + 1], AH          ; запись ASCII символов в шаблон
        MOV buffer[bx + 2], AL
        ADD BX, 3
        RET
fill_template  ENDP

clock   PROC                              ; процедура обработчика прерываний от таймера
        PUSHF                             ; создание в стеке структуры для IRET
        CALL  CS:prev                     ; вызов старого обработчика прерываний
        PUSH  DS                          ; сохранение модифицируемых регистров
        PUSH  ES
	      PUSH  AX
	      PUSH  BX
        PUSH  CX
        PUSH  DX
	      PUSH  DI
        PUSH  CS
        POP   DS                         ;Настроим DS на сегмент обработчика (т.е. на сегмент команд)

        MOV AH, 02h                        ;функция BIOS для получения текущего времени
                                           ;02H -  читать время из "постоянных" (CMOS) часов реального времени
                                           ;выход: CH = часы в коде BCD   (пример: CX = 1243H = 12:43)
                                           ;CL = минуты в коде BCD
                                           ;DH = секунды в коде BCD
                                           ;выход: CF = 1, если часы не работают
        INT  1Ah                           ; прерывание BIOS

        XOR BX, BX                       ; настройка BX на начало шаблона
        MOV AL, CH                       ; в AL - часы
        CALL fill_template               ; вызов процедуры заполнения шаблона - часы
        MOV AL, CL                       ; в AL - минуты
        CALL fill_template               ; вызов процедуры заполнения шаблона - минуты
        MOV AL, DH                       ; в AL - секунды
        CALL fill_template               ; вызов процедуры заполнения шаблона - секунды

        MOV AX, 0B880h                   ; настройка AX на сегмент видеопамяти
        MOV ES, AX
        XOR DI, DI                       ; настройка DI на начало сегмента видеопамяти
        XOR BX, BX                       ; обнуление шаблона
        MOV AH, 1Bh                      ; атрибут выводимых символов
loop1:
        MOV AL, buffer[BX]
        STOSW                             ; запись очередного символа и атрибута
        INC BX
        CMP buffer[bx], 0                 ; пока есть символы
        JNZ loop1                         ; продолжать запись символов

loop2:
        POP DI                            ; восстановление модифицируемых регистров
        POP CX
        POP DX
        POP AX
        POP BX
        POP DS
        POP ES
        IRET                              ; возврат из обработчика
clock   ENDP                              ; конец процедуры обработчика

ending:                                   ; метка для определения размера резидентной части программы

start:
        MOV AX, 351Ch                    ; получение адреса старого обработчика
        INT 21h                          ; прерываний от таймера

        MOV WORD PTR prev, BX            ; сохранение смещения обработчика
        MOV WORD PTR prev + 2, ES        ; сохранение сегмента обработчика

        MOV AX, 251Ch                    ; установка адреса нового обработчика (AH = 25, AL = 1Ch - номер прерывания по таймеру)
        MOV DX, OFFSET clock             ; указание смещения нового обработчика
        INT 21h

        MOV DX, (ending - main + 10Fh) / 16 ; определение размера резидентной части программы в параграфах
        INT 27h                         ; функция DOS завершения резидентной программы

CODE    ENDS
        END main
