StkSeg  SEGMENT PARA STACK 'STACK'
        DB      200h DUP (?)
StkSeg  ENDS
;
DataS   SEGMENT WORD 'DATA'
HelloMessage    DB   13                ;������ ��������� � ���. ������
                DB   10                ;��������� ������ �� ���. ������
                DB   'Hello, world !'  ;����� ���������
                DB   '$'               ;������������ ��� ������� DOS
DataS   ENDS
;
Code    SEGMENT WORD 'CODE'
        ASSUME  CS:Code, DS:DataS
DispMsg:
        mov   AX,DataS                 ;�������� � AX ������ �������� ������
        mov   DS,AX                    ;��������� DS
        mov   DX,OFFSET HelloMessage   ;DS:DX - ����� ������
        mov   AH,9                     
        mov   CX,3                 
Triple:
	int 21h
	LOOP Triple                   
                          
       	mov   AH,7
	int   21h
	mov   AH,4Ch                   ;��=4Ch ��������� �������
        int   21h                      
Code    ENDS
        END   DispMsg

