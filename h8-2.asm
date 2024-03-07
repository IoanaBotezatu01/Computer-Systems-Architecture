bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fclose,fprintf,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll  ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fd dd -1
    accmode db "w",0
    filename db "sum.txt",0
    format db "The sum is %d",10,13,0
    text db "g63d3ygj9 j.9ht6"
    len equ $-text
    s dw 0
    

; our code starts here
segment code use32 class=code
    start:
        ;A file name and a text (which can contain any type of character) are given in data segment. Calculate the sum of digits in the text. Create a file with the given name and write the result to file.
        mov edx,0
        mov ECX,len
        mov ESI,0
        jecxz end_s
        sum:
            mov Al,[text+esi]
            cmp Al,48
            je add0
                cmp al,49
                je add1
                    cmp al,50
                    je add2
                        cmp al,51
                        je add3
                            cmp al,52
                            je add4
                                cmp al,53
                                je add5
                                    cmp al,54
                                    je add6
                                        cmp al,55
                                        je add7
                                            cmp al,56
                                            je add8
                                                cmp al,57
                                                je add9
                                                jmp end_c
                                                add9:
                                                add edx,9
                                                jmp end_c
                                            add8:
                                            add edx,8
                                            jmp end_c
                                        add7:
                                        add edx,7
                                        jmp end_c
                                    add6:
                                    add edx,6
                                    jmp end_c
                                add5:
                                add edx,5
                                jmp end_c
                            add4:
                            add edx,4
                            jmp end_c
                        add3:
                        add edx,3
                        jmp end_c
                    add2:
                    add edx,2
                    jmp end_c
                add1:
                add edx,1
                jmp end_c
            add0:
                ADD edx,0
        end_c:
        inc ESI
        loop sum
        end_s:
        mov [s],edx
        
        
        ;fopen("sum.txt","w")
        push dword accmode
        push dword filename
        call [fopen]
        add esp,4*2
        
        ;fd=EAX
        cmp EAX,0
        je end_p
        mov [fd],EAX
        
        ;fprintf(fd,"The sum is %d")
        push dword [s]
        push dword format
        push dword [fd]
        call [fprintf]
        add esp,4*3
        
        ;fclose(fd)
        push dword [fd]
        call [fclose]
        add esp,4
        
        end_p:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
