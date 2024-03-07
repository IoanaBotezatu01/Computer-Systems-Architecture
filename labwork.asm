bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fscanf,fprintf,fopen,fclose              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fscanf msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n dd 0
    len1 equ 5
    format db "The numbers are:%s",10,13,0
    filename db "convert.txt",0
    fd db -1
    accmode db "r"
    accmode1 db "w"
    len equ 100
    form1 db "%d",0
    form2 db "%s",0
    a times len1 dd 0
    
; our code starts here
segment code use32 class=code
    start:
    ;A. Read from a file a number n and then an array of n positive numbers. Print the elements of the array in base 8 on the console (standard output).

    ;Ex. File.in
    ;5
    ;10 20 15 8 33
    ;Will print:  12, 24, 17, 10, 41
    
    
        ; fopen("convert.txt","r")
        push dword accmode
        push dword filename
        call [fopen]
        add esp,4*2
        
        cmp EAX,0
        je end_p
        mov [fd],EAX
        
        push dword n
        push dword form1
        push dword [fd]
        call [fscanf]
        add esp,4*3
        
        push dword a
        push dword form2
        push dword [fd]
        call [fscanf]
        add esp,4*3
        
        push dword[fd]
        call [fclose]
        add esp,4
        
        push dword accmode1
        push dword filename
        call [fopen]
        add esp,4*2
        
        cmp EAX,0
        je end_p
        mov [fd],EAX
        
        push dword [a]
        push dword form2
        push dword [fd]
        call [fprintf]
        add esp,4*3
        
        push dword [fd]
        call [fclose]
        add esp,4
        
        
        
        end_p:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
