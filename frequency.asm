bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fscanf,fopen,fclose,printf          ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fscanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fd dd -1
    filename db "char.txt",0
    accmode db "r",0
    read_format db "%s",0
    print_format db "%s",0
    len equ 100
    text times 100 db 0
    s db 0
    n dd 0
    nr_format db "%d",0
    fr times 100 db 0
    max db 0
    

; our code starts here
segment code use32 class=code
    start:
        push dword accmode
        push dword filename
        call [fopen]
        add esp,4*2
        
        cmp eax,0
        je end_p
        mov [fd],eax
        
        
       
        push dword text
        push dword read_format
        push dword [fd]
        call [fscanf]
        add esp,4*3
       
        
        

        push dword [fd]
        call [fclose]
        add esp,4
        
        ;Count the characters
        mov esi,0
        count:
        mov dl,0x00
        mov al,[text+esi]
        cmp al,dl
        je end_c
        inc esi
        jmp count
        end_c:
        
        mov ecx,esi
        mov esi,0
        frequecy:
        
        mov bl,[text+esi]
        sub bl,'a'
        mov [n],bl
        mov edi,[n]
        cmp [max],bl
        ja next
        mov [max],bl
        next:
        add byte[fr+edi],1
        inc esi
        loop frequecy
        
        mov ebx,26
        mov edi,0
        
        printfr:
        xor eax,eax
        mov al,[fr+edi]
        
        push eax
        push dword nr_format
        call [printf]
        add esp,4*2
        inc edi
        cmp ebx,0
        je end_loop
        jmp printfr
       end_loop:
       
       
        push dword text    
        push dword print_format
        call [printf]
        add esp,4*2
        
        
        
        
        end_p:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
