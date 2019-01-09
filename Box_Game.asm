org 100h
.model small
.stack 100h

.data
   
   col dw 35
   row dw 400
   n dw 0
   m dw 0
   valDX dw ?
   scSize dw 0
   
   ;Variables for box moving
   i dw 1
   j dw 1
   inittime dw 0
   
   initRow dw 400
   afterOp dw 0                                       
   
   hold dw 0
   holdAx dw 0
   
   randNum dw 0
   randTime dw 0
   
   ;Variables for scores
   score db 'Score: '
   distroyFlag db 0
   
   mHorPosition dw 0
   mVerPosition dw 0
   
   point db 1
   scStack db 0
   
   ;Message
   success db 'Congratulation, You have Broke Maximum Number of Box'
   gameOver db 'Game Over...!!!'
   
   ;Variable for lifeline
   p dw 35
   lfLimit db 0 
   
   
   
   
.code

jmp Main

drawBorder Proc
    
    mov cx, 30
    mov dx, 30
    
    mov ah, 0Ch  ;Write pixel function
    mov al, 10   ;Set Color 'Light Green'
    
    leftBorder:
        int 10h
        inc dx
        cmp dx, 400
        jle leftBorder
        ;mov dx, 30
    
    bottomBorder:
        int 10h
        inc cx
        cmp cx, 600
        jle bottomBorder
    
    rightBorder:
        int 10h
        dec dx
        cmp dx, 30
        jge rightBorder
        
    upBorder:
        int 10h
        dec cx
        cmp cx, 30
        jge upBorder
        
        mov cx, 500
        mov dx, 30
        
    drwLifeLine:
       
        int 10h
        inc dx
        cmp dx, 400
        jle drwLifeLine
    
            
     ret    
drawBorder endp


scoreBoard proc
     mov cx, 30
     mov dx, 402
     mov scSize, 290
     
     mov ah, 0Ch
     mov al, 14
     
     
     scoreRow:
       scoreColumn:
            int 10h
            inc cx
            cmp cx, 601
            jle scoreColumn
     
     inc dx
     mov cx, scSize
     inc scSize 
     cmp dx, 445
     jle ScoreRow
     
     
     
     mov si, @data  ;http://stanislavs.org/helppc/int_10-13.html
     
     mov ah, 13h
     mov al, 1
     mov bh, 0
     mov bl, 11101010b
     mov cx, 8
     
     mov dh, 26
     mov dl, 52
     mov es, si
     mov bp, offset score
     int 10h
     
     
     ret
    
scoreBoard endp 





drawBox Proc
    mov distroyFlag, 0
    mov ah, 0Ch
    mov al, 13
    
    mov dx, initRow
    
    drawRow:
        mov cx, randNum
        mov j, 0
          drawCol:
            
            int 10h
            inc cx
            inc j
            cmp j, 20
            jle drawCol
        
        dec dx    
        inc i
        cmp i, 20
        jle drawRow
        
        mov afterOp, dx
        
        ;call moveBox        
        
        call moveBoxTimer
        
      ret
        
drawBox endp


moveBoxTimer proc
;   mov dx, 4246h
;   mov cx, 0
;   mov ah, 86h
;   int 15h

   ; hold dw 0
;    holdAx dw 0
    
    mov hold, 0
    mov holdAx, 0

    mov ah, 0
    int 1ah
    
    mov inittime, dx
    
    L1: 
        mov hold, 0
        mov ah, 0
        int 1ah
        
        mov ax, dx
        sub dx, inittime
        mov hold, dx
        mov holdAx, ax
        
        call mouseInteruption
        cmp distroyFlag, 0
        jg Exit_2 
        
        cmp hold, 2
        jl L1
        
        
        mov cx, holdAx
        mov inittime, cx
        
        call moveBox
        
        cmp initRow, 30
        je Exit_2
        
        jmp L1
        
     Exit_2:
        ret 
    
moveBoxTimer endp




mouseInteruption proc
    
     
        
        mov ax, 03
        int 33h
        
        mov mHorPosition, cx
        mov mVerPosition, dx
        
        cmp bx, 1
        jge L10
        ret
        
     L10:
        mov bx, randNum
        cmp mHorPosition, bx
        jge L11
        ret
      
      L11:
        mov bx, randNum
        add bx, 21
        cmp mHorPosition, bx
        jle L12
        ret
        
      L12:
        mov ax, initRow
        cmp mVerPosition, ax 
        jle L13
        ret
        
      
      L13:
        mov ax, afterOp 
        cmp mVerPosition, ax
        jge L14
        ret
      
      L14:
        call distroyBox
        
        ret
        
        
    
mouseInteruption endp




moveBox proc
    ;Delete some row from the bottom of the row
    mov dx, initRow
    mov i, 1
    mov j, 1
    
    mov ah, 0Ch
    mov al, 0
    
    ;Deleting Loop
    
    delRow:
       mov cx, randNum
       mov j, 0
        delCol:
            int 10h
            inc cx
            inc j
            cmp j, 20
            jle delCol
       
       dec dx
       inc i
       cmp i, 5
       jle delRow
       mov initRow, dx
       
       cmp initRow, 30
       je Exit_1
       
       cmp afterOp, 30
       je delRow
       
     ;Appear some row to the upper side of the box
     mov dx, afterOp
     mov i, 1
     mov j, 1
     
     mov ah, 0Ch
     mov al, 13
     
     ;Appearing Loop
     appRow:
        mov cx, randNum
        mov j, 0
        appCol:
            int 10h
            inc cx
            inc j
            cmp j, 20
            jle appCol
        
        dec dx
        inc i
        cmp i, 5
        jle appRow
        mov afterOp, dx
        
        ;call moveBoxTimer       
      Exit_1:  
        ret
moveBox endp

 
distroyBox proc
   mov distroyFlag, 1
   
   mov dx, 31
   mov cx, randNum 
   
   mov ah, 0ch
   mov al, 0
   mov bx, 0
   
   mov i, 1
   mov j, 1
   
   disRow:
        mov cx, randNum
        mov j, 0
        disCol:
            int 10h
            inc cx
            inc j
            cmp j, 20
            jle disCol
         inc dx
         cmp dx, 399
         jle disRow
      
      ;add point, 1
;      cmp point, 6
;      je disExit
      
     
     mov cx, 465
     mov dx, 415
    
     mov ah, 0Ch
     mov al, 14d
    
     L30:
       
     mov cx, 465
     L31:
         inc cx
         int 10h
         cmp cx, 500
         jle L31
      
      inc dx
      cmp dx, 430
      jle L30
     
     
     mov ah, 0Ah
     mov al, point
     add al, 48
     mov bh, 0
     mov bl, 11101010b   ;1110 = Background Color, 1010 = Foreground Color
     mov cx, 1
     int 10h
     
      
     
     add point, 1
     cmp point, 9
     je disExit
            
   ret
   
   disExit:
        call stop
    
   ;call stop
distroyBox endp


lifeLine proc
    ;mov cx, p
;    mov dx, q
    
    mov lfLimit, 0
    mov ah, 0Ch
    mov al, 12d
    mov bx, 0
    
    mov dx, p
    lfCol:
        mov cx, 505
        lfRow:
            int 10h
            inc cx
            cmp cx, 595
            jle lfRow
        
        inc dx
        mov p, dx
        cmp dx, 395
        jge Exit_3
        inc lfLimit
        cmp lfLimit, 50
        jle lfCol       
    ret
    
    Exit_3:
        call gameOvr    
    
lifeLine endp


stop proc
;    mov ah, 1
;    int 21h
    
    mov si, @data  ;http://stanislavs.org/helppc/int_10-13.html
     
     mov ah, 13h
     mov al, 1
     mov bh, 0
     mov bl, 11101010b
     mov cx, 52
     
     mov dh, 12
     mov dl, 8
     mov es, si
     mov bp, offset success
     int 10h
    
    
    mov ah, 1
    int 21h
    
    mov ah, 4ch
    int 21h
    
stop endp

gameOvr proc
     
     mov si, @data  ;http://stanislavs.org/helppc/int_10-13.html
     
     mov ah, 13h
     mov al, 1
     mov bh, 0
     mov bl, 11101100b
     mov cx, 15
     
     mov dh, 12
     mov dl, 30
     mov es, si
     mov bp, offset gameOver
     int 10h
    
    
    mov ah, 1
    int 21h
    
    mov ah, 4ch
    int 21h    
    
gameOvr endp

;
;scErase proc
;    
;    mov cx, 465
;    mov dx, 415
;    
;    mov ah, 0Ch
;    mov al, 4d
;    
;    L30:
;       
;     mov cx, 465
;     L31:
;         inc cx
;         int 10h
;         cmp cx, 500
;         jle L31
;      
;      inc dx
;      cmp dx, 430
;      jle L30  
;    
;    call stop
;        
;    
;scErase endp



Main proc
    
    mov dx, @data
    mov ds, dx
    
    ;Set Video Mode
    mov ah, 0      ;int 10, 0   AH = 00
    mov al, 12h    ;            AL = 12h 640X400 color graphics (VGA)
    int 10h        ;Monitor Intruption
    
    
    mov ax, 1
    int 33h
    
    call drawBorder
    call scoreBoard
    
    ;call scErase
   
    
    _loop:
       
       
       mov i, 1
       mov j, 1
       mov initRow, 400
       
       mov ah, 0
       int 1ah
       
       mov randTime, dx
       
       mov ax, randTime
       mov bx, 480
       mov dx, 0
       div bx
       cmp dx, 35
       jle _loop

       
       mov randNum, dx
                      
                      
       call drawBox       
       ;popa
       cmp afterOp, 30
       je life
       jmp _loop
       
       life:
        call lifeLine
       
    jmp _loop    
    
    call stop
        
main endp

end Main