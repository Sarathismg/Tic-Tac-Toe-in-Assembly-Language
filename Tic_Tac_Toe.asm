.MODEL SMALL

draw_row Macro x,pageno
    Local LL1
    ; draws a line in row x from col 96 to col 224
   
    MOV BH,pageno
    MOV CX, 96
    MOV DX, x
    MOV AH, 0CH
    MOV AL, 3
    
LL1: INT 10h
    INC CX
    CMP CX, 224
    JL LL1
    EndM
    
draw_row_full Macro x,pageno,colstart,colend
    Local L1
    
    MOV AH, 0CH
    MOV AL, 1
    MOV BH,pageno
    MOV CX, colstart
    MOV DX, x
L1: INT 10h
    INC CX
    CMP CX, colend
    JL L1
    EndM
    
draw_col Macro y,pageno
    Local LL2

    MOV AH, 0CH
    MOV AL, 3
    MOV BH,pageno
    MOV CX, y
    
    MOV DX, 45
    
LL2: INT 10h
    INC DX
    CMP DX,171
    JL LL2
    EndM

draw_col_full Macro y,pageno,rowstart,rowend
    Local l2
  
    MOV AH, 0CH
    MOV AL, 1
    MOV BH,pageno
    MOV CX, y
    MOV DX, rowstart
L2: INT 10h
    INC DX
    CMP DX, rowend
    JL L2
    EndM
    
check_menu_game Macro 
    Local checkmenu,stop
    ;menu =0 means in game,1 means restartplayer,2 means go to menu,5 means restartpc
    cmp dx,185
    jl stop
    
    cmp dx,200
    jg stop
    
    cmp cx,60
    jg checkmenu
    
    mov menu,1
    jmp stop
    
    checkmenu:
    cmp cx,260
    jl stop
    
    mov menu,2
    
    
stop:
    EndM

.Stack 100h

.Data
    X DW ?
    Y DW ?
    ZRO DW ?
    CROSS DW ?
    counter dw ?
    counter2 dw ?
    COY DW 43,43,43,85,85,85,127,127,127
    COX DW 97,139,181,97,139,181,97,139,181
    RES DW 0,0,0,0,0,0,0,0,0
    CASES DW 0,0,0,0,0,0,0,0
    WIN DW 0
    mover dw ?
    playerget dw ?
    menu dw 2
    pcwon dw 0
    manwon dw 0
    pl1won dw 0
    pl2won dw 0
    draw dw ?
    msg1 db "You win!!!!!$"
    msg2 db "You lost!!!!!$"
    msg3 db "It's a Draw!!!!!$"
    msg4 db "Player 1 won!$"
    msg5 db "Player 2 won!$"
    moving db "Player 1 move!$"
    moving2 db "Player 2 move!$"
    restart db "RESTART$"
    menubar db "MENU$"
    MMSG4 DB "TIC TAC TOE$"
    MMSG5 DB "PLAYER V PLAYER$"
    MMSG6 DB "PLAY VS COMPUTER$"
    MMSG7 DB "EXIT$"
    MMSG8 DB "PLAYER 1 WON - $";START AT (8X15)
    MMSG9 DB "PLAYER 2 WON - $"
    MMSG10 DB "DRAW - $";START AT (8X7)
    MMSG11 DB "YOU WON - $";START AT (8X10)
    MMSG12 DB "COMPUTER WON - $";START AT (8X16)
    

.Code

OUTDEC PROC ;OUTPUT IN BX
    
PUSH AX
PUSH BX
PUSH CX
PUSH DX 
    
MOV CX,0

CMP BX,0
JNE WHILE2_

MOV DL,30H
MOV AH,2
INT 21H
JMP END_WHILE3


WHILE2_:

CMP BX,0
JE END_WHILE2

MOV AX,BX
XOR DX,DX
MOV BX,10
DIV BX
MOV BX,AX
PUSH DX
INC CX

JMP WHILE2_

END_WHILE2:

LOOP1_:

POP DX
ADD DX,30H
MOV AH,2
INT 21H

LOOP LOOP1_

END_WHILE3:

MOV AH,2
MOV DL,0DH
INT 21H
MOV DL,0AH
INT 21H 


POP DX
POP CX
POP BX
POP AX

RET

OUTDEC ENDP 



SHOWSCORE1 PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    PUSH COUNTER
    
    MOV AH,2
    MOV DH,0
    MOV DL,0
    MOV BH,0
    INT 10H
    
    
    LEA DX,MMSG8
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DH,0
    MOV DL,15
    MOV BH,0
    INT 10H
    
    MOV BX,PL1WON
    CALL OUTDEC
    
    MOV AH,2
    MOV DH,2
    MOV DL,0
    MOV BH,0
    INT 10H
    
    LEA DX,MMSG9
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DH,2
    MOV DL,15
    MOV BH,0
    INT 10H
    
    MOV BX,PL2WON
    CALL OUTDEC
    
    MOV AH,2
    MOV DH,4
    MOV DL,0
    MOV BH,0
    INT 10H
    
    LEA DX,MMSG10
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DH,4
    MOV DL,7
    MOV BH,0
    INT 10H
    
    MOV BX,DRAW
    CALL OUTDEC
    
    draw_row_full 11,0,0,154
    draw_row_full 27,0,0,154
    draw_row_full 43,0,0,90

    draw_col_full 154,0,0,28
    draw_col_full 90,0,27,44
    
    POP COUNTER
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

    RET
SHOWSCORE1 ENDP


SHOWSCORE2 PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    PUSH COUNTER
    
    MOV AH,2
    MOV DH,0
    MOV DL,0
    MOV BH,0
    INT 10H
    
    
    LEA DX,MMSG11
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DH,0
    MOV DL,10
    MOV BH,0
    INT 10H
    
    MOV BX,MANWON
    CALL OUTDEC
    
    MOV AH,2
    MOV DH,2
    MOV DL,0
    MOV BH,0
    INT 10H
    
    LEA DX,MMSG12
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DH,2
    MOV DL,15
    MOV BH,0
    INT 10H
    
    MOV BX,PCWON
    CALL OUTDEC
    
    MOV AH,2
    MOV DH,4
    MOV DL,0
    MOV BH,0
    INT 10H
    
    LEA DX,MMSG10
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DH,4
    MOV DL,7
    MOV BH,0
    INT 10H
    
    MOV BX,DRAW
    CALL OUTDEC
    
    
    draw_row_full 11,0,0,154
    draw_row_full 27,0,0,154
    draw_row_full 43,0,0,90
    
    draw_col_full 154,0,0,28
    draw_col_full 90,0,27,44
    
    POP COUNTER
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

    RET
SHOWSCORE2 ENDP



MENUMENU PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    PUSH COUNTER
    
    MOV AH, 0
    MOV AL, 13
    INT 10h
    
    ;select palette    
    MOV AH, 0BH
    MOV BH, 1
    MOV BL, 1
    INT 10h
    ;set bgd color
    MOV BH, 0
    MOV BL, 4
    INT 10h
   
    MOV CX,92
    MOV DX,64
    MOV AL,1
    MOV AH,0CH
    MOV BH,0
    
    ;BOX1- ROW 64-84,COL 92-220
    ;BOX2- ROW 98-118,COL 90-228
    ;BOX3- ROW 130-150,COL 130-170
    
    MENUBOX11:
    
    CMP CX,220
    JG ENDMENUBOX11
    INT 10H
    
    INC CX
    JMP MENUBOX11
    
    ENDMENUBOX11:
    
    MENUBOX12:
    
    CMP DX,84
    JG ENDMENUBOX12
    INT 10H
    
    INC DX
    JMP MENUBOX12
    
    ENDMENUBOX12:
    
    MENUBOX13:
    
    CMP CX,92
    JL ENDMENUBOX13
    INT 10H
    
    DEC CX
    JMP MENUBOX13
    
    ENDMENUBOX13:
    
    MENUBOX14:
    
    CMP DX,64
    JL ENDMENUBOX14
    INT 10H
    
    DEC DX
    JMP MENUBOX14
    
    ENDMENUBOX14:
    
    MOV CX,90
    MOV DX,98
    
    MENUBOX21:
    
    CMP CX,228
    JG ENDMENUBOX21
    INT 10H
    
    INC CX
    JMP MENUBOX21
    
    ENDMENUBOX21:
    
    MENUBOX22:
    
    CMP DX,118
    JG ENDMENUBOX22
    INT 10H
    
    INC DX
    JMP MENUBOX22
    
    ENDMENUBOX22:
    
    MENUBOX23:
    
    CMP CX,90
    JL ENDMENUBOX23
    INT 10H
    
    DEC CX
    JMP MENUBOX23
    
    ENDMENUBOX23:
    
    MENUBOX24:
    
    CMP DX,98
    JL ENDMENUBOX24
    INT 10H
    
    DEC DX
    JMP MENUBOX24
    
    ENDMENUBOX24:
    
    MOV CX,130
    MOV DX,130
    
    MENUBOX31:
    
    CMP CX,170
    JG ENDMENUBOX31
    INT 10H
    
    INC CX
    JMP MENUBOX31
    
    ENDMENUBOX31:
    
    MENUBOX32:
    
    CMP DX,150
    JG ENDMENUBOX32
    INT 10H
    
    INC DX
    JMP MENUBOX32
    
    ENDMENUBOX32:
    
    MENUBOX33:
    
    CMP CX,130
    JL ENDMENUBOX33
    INT 10H
    
    DEC CX
    JMP MENUBOX33
    
    ENDMENUBOX33:
    
    MENUBOX34:
    
    CMP DX,130
    JL ENDMENUBOX34
    INT 10H
    
    DEC DX
    JMP MENUBOX34
    
    ENDMENUBOX34:
   
    MOV AH,2
    MOV DH,2
    MOV DL,14
    MOV BH,0
    INT 10H
    
    MOV SI,0
    MSG4LOOP:
    
    CMP MMSG4[SI],"$"
    JE ENDMSG4LOOP
    
    MOV AH,9
    MOV BH,0
    MOV AL,MMSG4[SI]
    MOV CX,1
    MOV BL,14
    INT 10H
    
    MOV AH,2
    ADD DL,1
    INT 10H
    
    INC SI
    JMP MSG4LOOP
    
    ENDMSG4LOOP:
    
    
    MOV AH,2
    MOV DH,9
    MOV DL,12
    MOV BH,0
    INT 10H
    
    MOV SI,0
    MSG5LOOP:
    
    CMP MMSG5[SI],"$"
    JE ENDMSG5LOOP
    
    MOV AH,9
    MOV BH,0
    MOV AL,MMSG5[SI]
    MOV CX,1
    MOV BL,9
    INT 10H
    
    MOV AH,2
    ADD DL,1
    INT 10H
    
    INC SI
    JMP MSG5LOOP
    
    ENDMSG5LOOP:
    
    
    MOV AH,2
    MOV DH,13
    MOV DL,12
    MOV BH,0
    INT 10H
    
    MOV SI,0
    MSG6LOOP:
    
    CMP MMSG6[SI],"$"
    JE ENDMSG6LOOP
    
    MOV AH,9
    MOV BH,0
    MOV AL,MMSG6[SI]
    MOV CX,1
    MOV BL,9
    INT 10H
    
    MOV AH,2
    ADD DL,1
    INT 10H
    
    INC SI
    JMP MSG6LOOP
    
    ENDMSG6LOOP:
    
    
    MOV AH,2
    MOV DH,17
    MOV DL,17
    MOV BH,0
    INT 10H
    
    MOV SI,0
    MSG7LOOP:
    
    CMP MMSG7[SI],"$"
    JE ENDMSG7LOOP
    
    MOV AH,9
    MOV BH,0
    MOV AL,MMSG7[SI]
    MOV CX,1
    MOV BL,10
    INT 10H
    
    MOV AH,2
    ADD DL,1
    INT 10H
 
    INC SI
    JMP MSG7LOOP
    
   
    ENDMSG7LOOP:
    
    looperz:
    mov ax,1
    int 33h
    mov bx,0
    mov ax,3
    int 33h
    cmp bx,1
    jne looperz
    
    shr cx,1
    cmp cx,92
    jl checkbox2
    cmp cx,220
    jg checkbox2
    cmp dx,64
    jl checkbox2
    cmp dx,84
    jg checkbox2
    mov menu,1
    jmp krait
    
    checkbox2:
    cmp cx,90
    jl checkbox3
    cmp cx,228
    jg checkbox3
    cmp dx,98
    jl checkbox3
    cmp dx,118
    jg checkbox3
    mov menu,5
    jmp krait
    
    checkbox3:
    cmp cx,130
    jl checkbox4
    cmp cx,170
    jg checkbox4
    cmp dx,130
    jl checkbox4
    cmp dx,150
    jg checkbox4
    mov menu,3
    jmp krait
    
    checkbox4:
    jmp looperz
    
    
    krait:
    POP COUNTER
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX


    RET
MENUMENU ENDP

DECIDER PROC
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX,0
    
    MOV AX,RES
    ADD AX,RES+2
    ADD AX,RES+4
    MOV CASES[BX],AX
    ADD BX,2
    
    MOV AX,RES+6
    ADD AX,RES+8
    ADD AX,RES+10
    MOV CASES[BX],AX
    ADD BX,2
    
    MOV AX,RES+12
    ADD AX,RES+14
    ADD AX,RES+16
    MOV CASES[BX],AX
    ADD BX,2
    
    MOV AX,RES
    ADD AX,RES+6
    ADD AX,RES+12
    MOV CASES[BX],AX
    ADD BX,2
    
    MOV AX,RES+2
    ADD AX,RES+8
    ADD AX,RES+14
    MOV CASES[BX],AX
    ADD BX,2
    
    MOV AX,RES+4
    ADD AX,RES+10
    ADD AX,RES+16
    MOV CASES[BX],AX
    ADD BX,2
    
    MOV AX,RES
    ADD AX,RES+8
    ADD AX,RES+16
    MOV CASES[BX],AX
    ADD BX,2
    
    MOV AX,RES+4
    ADD AX,RES+8
    ADD AX,RES+12
    MOV CASES[BX],AX
    ADD BX,2
    
    MOV BX,0
    
    DECIDE_WHILE:
    
    CMP BX,18
    JGE END_DECIDE_WHILE
    
    CMP CASES[BX],3
    JE EKJITSE
    
    CMP CASES[BX],12
    JE DUIJITSE
    
    JMP HOYNAII
    
    EKJITSE:
    
    MOV WIN,1
    JMP END_DECIDE_WHILE
    
    DUIJITSE:
    
    MOV WIN,2
    JMP END_DECIDE_WHILE
    
    
    HOYNAII:
    
    ADD BX,2
    JMP DECIDE_WHILE
    
    END_DECIDE_WHILE:
    
    
    POP DX
    POP CX
    POP BX
    POP AX
    
    
    RET

DECIDER ENDP

    
set_display_mode Proc
; sets display mode and draws boundary
    MOV AH, 0
    MOV AL, 13; 320x200 4 color
    INT 10h
; select palette    
    MOV AH, 0BH
    MOV BH, 1
    MOV BL, 0
    INT 10h
; set bgd color
    MOV BH, 0
    MOV BL, 1
    INT 10h
; draw boundary


    draw_row 87,0
    draw_row 129,0
    draw_col 139,0
    draw_col 181,0
    draw_row_full 185,0,0,60
    draw_row_full 200,0,0,60
    draw_col_full 60,0,185,200
    mov ah,2
    mov bh,0
    mov dh,24
    mov dl,0
    int 10h
    mov ah,9
    lea dx,restart
    int 21h
    draw_row_full 185,0,260,320
    draw_row_full 200,0,260,320
    draw_col_full 260,00,185,200
    mov ah,2
    mov bh,0
    mov dh,24
    mov dl,74
    int 10h
    mov ah,9
    lea dx,menubar
    int 21h
    
    
    
    RET
set_display_mode EndP


RAND_GEN PROC
    
    ;MOD INPUT IN AX , OUTPUT ALSO IN AX
    
    PUSH BX
    PUSH CX
    PUSH DX
    
    
    MOV BX,AX
    
    MOV AH,2CH
    INT 21H
    
    MOV CL,DL
    MOV CH,0
    
    MOV DX,0
    MOV AX,CX
    DIV BX
    
    MOV AX,DX
    
    POP DX
    POP CX
    POP BX
    
    RET

RAND_GEN ENDP






draw_cross Proc
    ;INPUT ONLY THE NUMBER IN BX, BX IS THE BOX NUMBER
    ;
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH counter
    
    mov ah,0ch
    mov al,1
    mov bh,0;pageno
    ADD BX,BX
    ;=============
    ;draw -45 degree line
    mov cx,COX[BX]
    mov dx,COY[BX]
    add cx,6
    add dx,6
    mov counter,0
    
    crossloop1:
    int 10h
    inc cx
    inc dx
    inc counter
    cmp counter,30
    jl crossloop1
    
    ;=========
    ;draw 45 degree line
    
    ;ADD BX,BX
    mov cx,COX[BX]
    mov dx,COY[BX]
    add cx,42
    sub cx,6
    add dx,6
    mov counter,0
    
    crossloop2:
    int 10h
    dec cx
    inc dx
    inc counter
    cmp counter,30
    jl crossloop2
    
    ;-------
    
    POP counter
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
    
draw_cross ENDP


DRAW_ZERO PROC ; INPUT SI ONLY 
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH counter
    
    
    ;  MOV SI,ZRO
    SHL SI,1
    MOV DX,COY[SI]
    MOV CX,COX[SI]
    
    ADD CX,11
    ADD DX,8
    
    MOV COUNTER,0
    
    UPPER_ZERO_LINE:
    
    CMP COUNTER,20
    JGE END_UPPER_ZERO_LINE
    
    MOV AH,0CH
    MOV AL,1
    MOV BH,0
    INT 10H
    
    INC CX
    INC COUNTER
    JMP UPPER_ZERO_LINE
   
    END_UPPER_ZERO_LINE:
  
    MOV CX,COX[SI]
    MOV DX,COY[SI]
    
    ADD CX,11
    ADD DX,38
    
    MOV COUNTER,0
    
    LOWER_ZERO_LINE:
    
    CMP COUNTER,20
    JGE END_LOWER_ZERO_LINE
    
    MOV AH,0CH
    MOV AL,1
    MOV BH,0
    INT 10H
    
    INC CX
    INC COUNTER
    JMP LOWER_ZERO_LINE
   
    END_LOWER_ZERO_LINE:
    
    MOV CX,COX[SI]
    MOV DX,COY[SI]
    
    ADD CX,11
    ADD DX,8
    
    MOV COUNTER,0
    
    LEFT_ZERO_LINE:
    
    CMP COUNTER,30
    JGE END_LEFT_ZERO_LINE
    
    MOV AH,0CH
    MOV AL,1
    MOV BH,0
    INT 10H
    
    INC DX
    INC COUNTER
    JMP LEFT_ZERO_LINE
   
    END_LEFT_ZERO_LINE:
    
    MOV CX,COX[SI]
    MOV DX,COY[SI]
    
    ADD CX,31
    ADD DX,8
    
    MOV COUNTER,0
      
    RIGHT_ZERO_LINE:
    
    CMP COUNTER,31
    JGE END_RIGHT_ZERO_LINE
    
    MOV AH,0CH
    MOV AL,1
    MOV BH,0
    INT 10H
    
    INC DX
    INC COUNTER
    JMP RIGHT_ZERO_LINE
   
    END_RIGHT_ZERO_LINE:
    
    POP counter
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    
    RET
    
DRAW_ZERO ENDP

optimal_move proc

    push bx
    push cx
    push dx
    push si
    push di
    
chkrow1:
    mov dx,0
    add dx,res[0]
    add dx,res[2]
    add dx,res[4]
    cmp dx,8
    jne chkrow2
    cmp res[0],0
    jne setres2
    mov res[0],4
    mov ax,0
    jmp bishallaf
   setres2:
    cmp res[2],0
    jne setres4
    mov res[2],4
    mov ax,1
    jmp bishallaf
   setres4:
    mov res[4],4
    mov ax,2
    jmp bishallaf
chkrow2:
    mov dx,0
    add dx,res[6]
    add dx,res[8]
    add dx,res[10]
    cmp dx,8
    jne chkrow3
    cmp res[6],0
    jne setres8
    mov res[6],4
    mov ax,3
    jmp bishallaf
    setres8:
    cmp res[8],0
    jne setres10
    mov res[8],4
    mov ax,4
    jmp bishallaf
    setres10:
    mov res[10],4
    mov ax,5
    jmp bishallaf 
 
 chkrow3:
    mov dx,0
    add dx,res[12]
    add dx,res[14]
    add dx,res[16]
    cmp dx,8
    jne chkcol1
    cmp res[12],0
    jne setres14
    mov res[12],4
    mov ax,6
    jmp bishallaf
    setres14:
    cmp res[14],0
    jne setres16
    mov res[14],4
    mov ax,7
    jmp bishallaf
    setres16:
    mov res[16],4
    mov ax,8
    jmp bishallaf 

 chkcol1:
    mov dx,0
    add dx,res[0]
    add dx,res[6]
    add dx,res[12]
    cmp dx,8
    jne chkcol2
    mov di,6
    neg di
    col1loop:
    add di,6
    cmp res[di],0
    jne col1loop
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallaf

 
    chkcol2:
    mov dx,0
    add dx,res[2]
    add dx,res[8]
    add dx,res[14]
    cmp dx,8
    jne chkcol3
    mov di,4
    neg di
    col2loop:
    add di,6
    cmp res[di],0
    jne col2loop
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallaf    
     
    
    chkcol3:
    mov dx,0
    add dx,res[4]
    add dx,res[10]
    add dx,res[16]
    cmp dx,8
    jne chkdia1
    mov di,2
    neg di
    col3loop:
    add di,6
    cmp res[di],0
    jne col3loop
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallaf
    
    chkdia1:
    mov dx,0
    add dx,res[0]
    add dx,res[8]
    add dx,res[16]
    cmp dx,8
    jne chkdia2
    mov di,8
    neg di
    dia1loop:
    add di,8
    cmp res[di],0
    jne dia1loop
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallaf
    
    chkdia2:
    mov dx,0
    add dx,res[12]
    add dx,res[8]
    add dx,res[4]
    cmp dx,8
    jne hobena
    
    mov di,0
    dia2loop:
    add di,4
    cmp res[di],0
    jne dia2loop
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallaf
    
    hobena:
    mov ax,4
    neg ax
    
    bishallaf:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    RET
optimal_move ENDP
    
 
optimal_defend proc

    push bx
    push cx
    push dx
    push si
    push di
    
chkrow1d:
    mov dx,0
    add dx,res[0]
    add dx,res[2]
    add dx,res[4]
    cmp dx,2
    jne chkrow2d
    cmp res[0],0
    jne setres2d
    mov res[0],4
    mov ax,0
    jmp bishallafd
    setres2d:
    cmp res[2],0
    jne setres4d
    mov res[2],4
    mov ax,1
    jmp bishallafd
    setres4d:
    mov res[4],4
    mov ax,2
    jmp bishallafd
    chkrow2d:
    mov dx,0
    add dx,res[6]
    add dx,res[8]
    add dx,res[10]
    cmp dx,2
    jne chkrow3d
    cmp res[6],0
    jne setres8d
    mov res[6],4
    mov ax,3
    jmp bishallafd
    setres8d:
    cmp res[8],0
    jne setres10d
    mov res[8],4
    mov ax,4
    jmp bishallafd
    setres10d:
    mov res[10],4
    mov ax,5
    jmp bishallafd 
 
    chkrow3d:
    mov dx,0
    add dx,res[12]
    add dx,res[14]
    add dx,res[16]
    cmp dx,2
    jne chkcol1d
    cmp res[12],0
    jne setres14d
    mov res[12],4
    mov ax,6
    jmp bishallafd
    setres14d:
    cmp res[14],0
    jne setres16d
    mov res[14],4
    mov ax,7
    jmp bishallafd
    setres16d:
    mov res[16],4
    mov ax,8
    jmp bishallafd 

    chkcol1d:
    mov dx,0
    add dx,res[0]
    add dx,res[6]
    add dx,res[12]
    cmp dx,2
    jne chkcol2d
    mov di,6
    neg di
    col1loopd:
    add di,6
    cmp res[di],0
    jne col1loopd
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallafd

 
    chkcol2d:
    mov dx,0
    add dx,res[2]
    add dx,res[8]
    add dx,res[14]
    cmp dx,2
    jne chkcol3d
    mov di,4
    neg di
    col2loopd:
    add di,6
    cmp res[di],0
    jne col2loopd
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallafd    
     
    
    chkcol3d:
    mov dx,0
    add dx,res[4]
    add dx,res[10]
    add dx,res[16]
    cmp dx,2
    jne chkdia1d
    mov di,2
    neg di
    col3loopd:
    add di,6
    cmp res[di],0
    jne col3loopd
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallafd
    
    chkdia1d:
    mov dx,0
    add dx,res[0]
    add dx,res[8]
    add dx,res[16]
    cmp dx,2
    jne chkdia2d
    mov di,8
    neg di
    dia1loopd:
    add di,8
    cmp res[di],0
    jne dia1loopd
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallafd
    
    chkdia2d:
    mov dx,0
    add dx,res[12]
    add dx,res[8]
    add dx,res[4]
    cmp dx,2
    jne hobenad
    
    mov di,0
    dia2loopd:
    add di,4
    cmp res[di],0
    jne dia2loopd
    mov res[di],4
    shr di,1
    mov ax,di
    jmp bishallafd
    
    hobenad:
    mov ax,4
    neg ax
    
    bishallafd:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    RET
optimal_defend ENDP   

start_game proc

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ;clear already the mouse input in buffer
    statix:
     mov ax,1
     int 33h
     mov bx,0
     mov ax,3
     int 33h
     cmp bx,0
     jne statix
    
    
    
    ;cleared
    
    
    mov bx,0
    mov WIN,0
    mov menu,0
    ;reseting the array for players
    setzero:
        mov RES[BX],0
        add bx,2
        cmp bx,17
        jl setzero
        
    CALL set_display_mode
    
    CALL SHOWSCORE2
   
    
    ;==================
    ;randomization call needed
    ;returns in ax
    ;if ax = 1,player 1 gets cross,moves first
    ;else pc moves first having cross
    ;playerget = 1,if gets cross,else it is 2
    mov ax,2
    call rand_gen
    inc ax
    ;===================
    
    mov counter,0
    mov mover,ax
    mov playerget,ax
    GAMELOOP:
    cmp mover,1
    je case1
    tinkon:jmp case2
    case1:;moves player1 as mover=1 means player1 move . It loops until gets a valid input
        
        mov ax,1
        int 33h
        mov bx,0
        mov ax,3
        int 33h
        cmp bx,1
        jne case1
        
        ;we need to make cx half
        shr cx,1
        ;shr dx,1
        check_menu_game
        cmp menu,0
        je trail
        jmp jumpfinishp
        trail: 
        mov si,0
    search:
        cmp cx,COX[si]
        jl badde
        mov bx,COX[SI]
        add bx,42
        cmp cx,BX
        jge badde
        cmp dx,COY[SI]
        jl badde
        mov bx,COY[SI]
        ADD BX,42
        cmp dx,bx
        jge badde
        ;;si is the current mouse position
        cmp RES[si],0
        jne case1
        jmp okayhere
     badde:
        add si,2
        cmp si,17
        jge case1
        jmp search
        
     okayhere:
        mov ax,2
        int 33h
        mov RES[SI],1;GOT BY PLAYER1       
        shr si,1
        cmp playerget,1
        jne plzero
        mov bx,si
        CALL draw_cross
        mov mover,2
        
        JMP REDIRECT
        
        plzero:
        ;change 
        mov SI,si
        CALL DRAW_ZERO
        mov mover,2
        ;change
        JMP REDIRECT
        
     case2:
        ;PC MOVING CODES
        ;call rand with parameter 9 in ax,got a random number in ax from 0-8
        CALL optimal_move
        cmp ax,0
        jge finisher
        CALL optimal_defend
        cmp ax,0
        jge finisher
        
        rand_check:
        mov ax,9
        call RAND_GEN
        ;;take ax in bx
        ;push bx
        
        cmp counter,0
        jne ttr
        
        mov ax,4
        
        ttr:
        
        mov bx,ax
        add bx,bx
       
        cmp RES[bx],0
        jne rand_check
        mov RES[bx],4
        shr bx,1
        
        finisher:
        ;just draw the zero or one
        cmp playerget,1
        je plzeropc
        mov bx,ax
        CALL draw_cross
        mov mover,1
        
        JMP REDIRECT
        
        plzeropc:
        ;change 
        mov SI,ax
        CALL DRAW_ZERO
        mov mover,1
        ;change
        JMP REDIRECT
        ;mov mover,1
        
     
    REDIRECT:
       
        
        CALL DECIDER
        CMP WIN,0
        JNE sss
        
        inc counter
        CMP counter,9
        JGE sss
        
        JMP GAMELOOP
    sss:
    
        mov ah,02
        mov bh,0
        mov dh,22
        mov dl,13
        int 10h
    
        cmp win,0
        je sss1
        
        cmp win,1
        je sss2
        
        cmp win,2
        je sss3
        
        jmp endsss
        
        sss1:
        lea dx,msg3
        mov ah,9
        int 21h
        INC DRAW
        jmp endsss
        
        sss2:
        lea dx,msg1
        mov ah,9
        int 21h
        INC MANWON
        jmp endsss
    
        sss3:
        lea dx,msg2
        mov ah,9
        int 21h
        INC PCWON
        jmp endsss 
        
      endsss:
;--=-=-=-=-=-=-=-=-=--=-
       CALL SHOWSCORE2
       mov ax,1
       int 33h
       mov bx,0
       mov ax,3
       int 33h
       cmp bx,1
      jne endsss
      shr cx,1
      check_menu_game
      cmp menu,0
      je endsss
        
  jumpfinishp:
  cmp menu,1;restartplayer
  jne another
  mov menu,5;make it restartpc
        
  another:  
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        
    start_game endp
    
    
    start_game_player proc

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
     ;clear already the mouse input in buffer
     statix2:
     mov ax,1
     int 33h
     mov bx,0
     mov ax,3
     int 33h
     cmp bx,0
     jne statix2
    
    
    ;cleared
    
    
    mov bx,0
    mov WIN,0
    mov menu,0
    ; 
    ;reseting the array for players
    setzerop:
        mov RES[BX],0
        add bx,2
        cmp bx,17
        jl setzerop
        
    CALL set_display_mode
    
    
    CALL SHOWSCORE1
    
    
    ;==================
    ;randomization call needed
    ;returns in ax
    ;if ax = 1,player 1 gets cross,moves first
    ;else pc moves first having cross
    ;playerget = 1,if gets cross,else it is 2
    MOV AX,1
    mov ax,2
    call rand_gen
    inc ax
    ;===================
    
    mov counter,0
    mov mover,ax
    mov playerget,ax
    GAMELOOP1:
    ;cmp mover,1
    ; jne case2
    case1p:;moves player1 as mover=1 means player1 move . It loops until gets a valid input
        cmp mover,1
        jne other
        mov ah,02
        mov bh,0
        mov dh,22
        mov dl,13
        int 10h
        mov ah,9
        lea dx,moving
        int 21h
        jmp stdddd
        other:
        mov ah,02
        mov bh,0
        mov dh,22
        mov dl,13
        int 10h
        mov ah,9
        lea dx,moving2
        int 21h
        stdddd:
        mov ax,1
        int 33h
        mov bx,0
        mov ax,3
        int 33h
        cmp bx,1
        jne case1p
        
        ;we need to make cx half
        shr cx,1
        ;shr dx,1
        check_menu_game
        cmp menu,0
        je stator
        jmp jumpfinish
        stator:
        mov si,0
        searchp:
        cmp cx,COX[si]
        jl baddep
        mov bx,COX[SI]
        add bx,42
        cmp cx,BX
        jge baddep
        cmp dx,COY[SI]
        jl baddep
        mov bx,COY[SI]
        ADD BX,42
        cmp dx,bx
        jge baddep
        ;;si is the current mouse position
        cmp RES[si],0
        je easer
        jmp case1p
        easer:
        jmp okayherep
        baddep:
        add si,2
        cmp si,17
        jl marvel
        jmp case1p
        marvel:
        jmp searchp
        
     okayherep:
        mov ax,2
        int 33h
        cmp mover,1
        jne jumperr
        mov RES[SI],1       
        shr si,1
        mov bx,si
        CALL draw_cross
         mov mover,2
        
         JMP REDIRECTp
         
         jumperr:
         mov RES[si],4
         shr si,1
         mov si,si
         CALL DRAW_ZERO
         MOV MOVER,1
         JMP REDIRECTp
   
         
     
        REDIRECTp:
        
        mov ah,02
        mov bh,0
        mov dh,22
        mov dl,13
        int 10h
        
        CALL DECIDER
        CMP WIN,0
        JNE sssp
        
        inc counter
        CMP counter,9
        JGE sssp
      
        
        JMP GAMELOOP1
        sssp:
    
        cmp win,0
        je sss1p
        
        cmp win,1
        je sss2p
        
        cmp win,2
        je sss3p
        
    jmp endsssp
        
    sss1p:
        lea dx,msg3
        mov ah,9
        int 21h
        INC DRAW
    jmp endsssp
        
    sss2p:
        lea dx,msg4
        mov ah,9
        int 21h
        INC PL1WON
    jmp endsssp
    
    sss3p:
        lea dx,msg5
        mov ah,9
        int 21h
        INC PL2WON
    jmp endsssp 
        
        endsssp:
        CALL SHOWSCORE1

        mov ax,1
        int 33h
        mov bx,0
        mov ax,3
        int 33h
        cmp bx,1
        jne endsssp
    
        shr cx,1
        check_menu_game
        cmp menu,0
        je endsssp
    
     jumpfinish:   
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        
        start_game_player endp
        
        
;=========

;========

MAIN PROC
    ;Local looper
    ;
    ;============
    ;remember menu=0 means game is running,menu=1 means man vs man restart,menu = 2 means gotomenu,menu = 3 means exit,menu = 5 means pc
    ;==========
    ;
    MOV AX,@DATA
    MOV DS,AX
    ;call start_game
     mov ax,0
    int 33h
    
    loopers: 
    
   ; CALL start_game
    cmp menu,1
    jne call2
    call start_game_player
    jmp loopers
    
    call2:cmp menu,2
    jne call31
    mov pcwon,0
    mov manwon,0
    mov pl1won,0
    mov pl2won,0
    mov draw,0
    call menumenu
    jmp loopers
    
    call31:cmp menu,5
    jne call3
    call start_game
    jmp loopers
    
    
    call3:cmp menu,3
    je gone
    
    call loopers
    ; mov ah,00
    ;int 16h ;wait for keypress
    gone: mov ah,4ch
    int 21h
   
    MAIN ENDP

 end main