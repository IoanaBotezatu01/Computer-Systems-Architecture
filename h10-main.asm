bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fclose,printf,fscanf        ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import fscanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    read_format db "%d",0
    print_format db "%d ",0
    fd dd -1
    filename db "numbers.txt",0
    accmode db "r",0
    a dd 0
    len equ 100
    p times len db 0
    n times len db 0
    nextline db " ",10,13,0
    

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
        
        mov edi,0   ;for positive numbers
        mov esi,0   ;for negative numbers
        read_loop:
            PUSH dword a
            push dword read_format
            push dword [fd]
            call [fscanf]
            add esp,4*3
            
            cmp eax,-1
            je end_loop
            
            
            
            cmp word[a],0
            jl negative
                mov bx, word[a]
                mov [p+edi],bx
                inc edi
                jmp after_n
            negative:
            mov bx,word[a]
            mov [n+esi],bx
            inc esi
            after_n:
            
          jmp read_loop
          end_loop:
          dec esi
          dec edi
          
         
         
          mov ebx,esi
          
          mov esi,0
          negative_loop:
        
              
              mov al,[n+esi]        ;eax=[n+esi]
              cbw
              cwde
            
              push eax
              push dword print_format
              call [printf]
              add esp,4*2
            
              inc esi
              dec ebx
              cmp ebx,0
              je end_negative
            
            
            
          jmp negative_loop
          end_negative:
          push dword nextline
          call [printf]
          add esp,4
          mov ebx,edi
          
          mov edi,0
          positive_loop:
        
              
              mov al,[p+edi]        ;eax=[p+esi]
              cbw
              cwde
              
              push eax
              push dword print_format
              call [printf]
              add esp,4*2
            
              inc edi
              dec ebx
              cmp ebx,0
              je end_p
            
            
            
          jmp positive_loop
            
        
        end_p:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
