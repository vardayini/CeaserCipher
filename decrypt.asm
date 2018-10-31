

org 100h

.MODEL SMALL
.STACK
;.386

.DATA
welcome_msg db "This is the decryption program$"


filename db 'output.txt',0 
filename2 db 'output2.txt',0
file_error db "Error, file not found!$"
string db 512 dup(0)    
len dw ?
endchar db '$'
handle dw 0

.CODE
.STARTUP

mov ah, 09h
lea dx, welcome_msg
int 21h 
 
 MOV dl, 10
MOV ah, 02h
INT 21h
MOV dl, 13
MOV ah, 02h
INT 21h




call deletefile
call createfile
call openfile
call filesize
call closefile
call openfile
call readfile
call closefile

         
lea si, string
mov cx, len
call decrypt


          
mov ah,09h
lea dx, string
int 21h 
      
call writefile
call closefile
         
mov ah,4ch
int 21h   
  
deletefile proc near    ;deletes existing output file

    mov ah,41h 
    lea dx,filename2 
    int 21h 
    jc error
    ret

deletefile endp   

createfile proc near   ;creates the outputfile 
               
    mov ah,3ch 
    mov cx,0 
    lea dx,filename2 
    int 21h 
    jc error 
    mov handle,ax
    ret
createfile endp 

openfile proc near     ; open file

    mov ax,3d02h   
    lea dx,filename
    int 21h
    jc error
    mov handle,ax
    ret

openfile endp 

filesize proc near
        
    mov ah, 42H               ; move file ptr 
    mov bx, handle           ; file handle
    xor cx, cx               ; clear CX
    xor dx, dx                ; 0 bytes to move
    mov al, 2                 ; relative to end
    int 21H                   ; move pointer to end. AX = file size
    jc error                  ; error if CF = 1        
    mov len,ax
    ret    
    
filesize endp    

           
readfile proc near     ; read from file

    mov ah,3fh
    mov bx,handle
    mov cx,len
    lea dx,string
    int 21h
    jc error
    ret

readfile endp
            
writefile proc near          ; write to file

mov ax,3d02h   
    lea dx,filename2
    int 21h
    jc error
    mov handle,ax      
    mov AH, 40H         
    mov BX, handle          
    mov CX, len           
    lea DX, string        
    int 21H             
     ret
writefile endp   
                
            ; close file
closefile proc near

    mov ah,3eh
    mov bx,handle
    int 21h
    ret

closefile endp

            ; encrypt the string
decrypt proc near

    mov ch, 0

    shift_char:
        cmp si, len
        je done
        sub [si],01
        inc si
    loop shift_char
    ret

decrypt endp

done proc near

    mov [si], "$"
    ret

done endp

           
error proc near         ;report error and terminate

    mov ah, 09h
    lea dx, file_error
    int 21h

    mov ax,4c00h
    int 21h

error endp

end

ret




