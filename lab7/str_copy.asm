GLOBAL str_copy
SEGMENT .TEXT 
; Директива SECTION/SEGMENT указывает, в какую секцию 
; выходного файла будет ассемблирован код (.text - для кода)

str_copy:
	MOV RCX, RDX
  
    CMP RSI, RDI
    JE exit				;(если равно, ZF = 1)
    
    LEA RAX, [RSI]		;В RAX загружаем адрес начала исходной строки
    ADD RAX, RDX		;Получаем адрес конца строки

    CMP RAX, RDI
    JG reverse			;(если больше)

    REP MOVSB
    JMP exit

reverse:
	ADD RSI, RDX
	DEC RSI

	ADD RDI, RDX
	DEC RDI

	STD					;DF = 1 (регистры уменьшаются)

	REP MOVSB

 exit:
    RET

 ;MOVSB - Записать в ячейку по адресу ES:(E)DI 
 ;байт из ячейки с адресом DS:(E)SI

 ;REP MOVSB - Записать по адресу ES:(E)DI блок из (E)CX байт, 
 ;считываемый по адресу DS:(E)SI

 ;The first six integer arguments (from the left) are passed in 
 ;RDI, RSI, RDX, RCX, R8, and R9, in that order
