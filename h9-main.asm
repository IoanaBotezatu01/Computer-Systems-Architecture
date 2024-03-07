bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fclose,fopen,printf,fscanf              ; tell nasm that exit exists even if we won't be defining it
extern double
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fclose msvcrt.dll
import fopen msvcrt.dll
import printf msvcrt.dll
import fscanf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fd dd -1
    accmode db "r",0
    filename db "string.txt",0
    format db"The final string is:%s",10,13,0
    n dd 0
    read_format db "%d",0
    sir times 10 db 0
    revsir times 10 db 0
    nr db 0
; our code starts here
segment code use32 class=code
    start:
        ; Read from file numbers.txt a string of numbers. Build a string D wich contains the readen numbers doubled and in reverse order that they were read. Display the string on the screen.
        ;Ex: s: 12, 2, 4, 5, 0, 7 => 14, 0, 10, 8, 4, 24
        
        push dword accmode
        push dword filename
        call [fopen]
        add esp,4*2
        
        cmp eax,0
        je end_p
        mov [fd],EAX
        
        mov edi,0
        
        read_loop:
        pushad
        push dword n
        push dword read_format
        push dword [fd]
        call[fscanf]
        add esp,4*3
        cmp EAX,-1
        je end_loop
        
        
        push dword [n]
        call double
        
        mov ebx,[n]
        
        add  dword [nr],1
        mov [sir+edi],ebx
        inc edi
        popad
        jmp read_loop
        
        end_loop:
        
        push dword [fd]
        call [fclose]
        add esp,4
        
        mov edi,0
        mov ecx,dword [nr]
        move_loop:
            mov ebx,[sir+ecx]
            mov [revsir+edi],ebx
            dec ecx
            inc edi
            jecxz end_move_loop
        jmp move_loop
        end_move_loop:
        
        push dword revsir
        push dword format
        call [printf]
        add esp,4*2
        
        
        
        
        end_p:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
