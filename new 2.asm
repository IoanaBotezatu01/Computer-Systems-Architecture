bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; a,b,c-byte; e-doubleword; x-qword-unsgined
    a db 10
    b db 3
    c db 7
    e dd 25
    x dq 100


; our code starts here
segment code use32 class=code
    start:
        ; (a+a+b*c*100+x)/(a+10)+e*a=(20+2100+100)/20+250
        ;2220/20+250=111+250=361
        mov AL,[a]
        add AL,[a];AL=a+a
        cbw;AX=a+a    word
        cwde;EAX=a+a     dword
        mov EBX,EAX     ; EAX=a+a
        
        mov AL,[b]
        mov CL,[c]
        imul CL;AX=b*c      word
        mov CX,100
        imul CX;DX:AX=b*c*100  dword
        
        push DX
        PUSH AX
        POP EAX ;EAX=b*c*100
        
        add EAX,EBX;EAX=(a+a+b*c*100)
        cdq;EDX:EAX=(a+a+b*c*100)     qword
        
        mov EBX, dword [x+0]
        mov ECX, dword [x+4]
        
        add EAX,EBX
        adc EDX,ECX;EDX:EAX=(a+a+b*c*100+x)    qword
        
        push EDX
        push EAX
        
        
        
        mov AL,[a]
        add AL,10;AL=a+10     byte
        cbw;AX=a+10           word
        cwde;EAX=(a+10)       dword
        
        mov ebx,eax;ebx=(a+10)
        
        pop EAX
        pop EDX
        
        idiv EBX;EDX:EAX/EBX= EAX  =(a+a+b*c*100+x)/(a+10)    dword
        mov ECX,EAX;ECX=(a+a+b*c*100+x)/(a+10)
        
        
        mov AL,[a]
        cbw;AX=a     word
        cwde;EAX=a
        
        mov EBX,[e]
        imul EBX;EDX:EAX=EAX*EBX=a*e   qword
        
        mov EBX,ECX     ;EBX=(a+a+b*c*100+x)/(a+10)
        cdq       ;ECX:EBX=(a+a+b*c*100+x)/(a+10)    qword
         
        add EAX,EBX
        adc EDX,ECX     ;EDX:EAX=(a+a+b*c*100+x)/(a+10)+e*a
        
        
        
   
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program