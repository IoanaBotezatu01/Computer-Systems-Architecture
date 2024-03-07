bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0110111000101100b      ;6E2C h = 28204d
    b dd 0

; our code starts here
segment code use32 class=code
    start:
        ;Given the word A, compute the doubleword B as follows:
        ;1->the bits 28-31 of B have the value 1;
        ;2->the bits 24- 25 and 26-27 of B are the same as the bits 8-9 of A
        ;3->the bits 20-23 of B are the invert of the bits 0-3 of A ;
        ;4->the bits 16-19 of B have the value 0
        ;5->the bits 0-15 of B are the same as the bits 16-31 of B
        
        
        
        mov AX,[a]
        mov DX,0        ; we convert the word "a" into a doubleword
        push DX
        push AX
        pop EAX         ;EAX= a =0000000000000000 0110111000101100b
        
        ;1: bits: 28-31 (have the value 1)
        or EBX,11110000000000000000000000000000b    ; we force the value of the bits 28-31 to be equal to 1
        
        
        ;2: bits:24-25 and 26-27(same bits as 8-9 of "a")
        ;the bits 8-9 of "a" are:"10"
        
        rol EAX,16     ;EAX= 011011(10)00101100 0000000000000000b -the 8-9 bits are now 24-25
        
        mov ECX,EAX     ;we isolate the bits 24-25
        and ECX,00000011000000000000000000000000b       ;ECX=000000(10)00000000 0000000000000000b
        or EBX,ECX      ;EBX=111100(10)00000000 0000000000000000b
        
        
        rol EAX,2    ;EAX=1011(10)0010110000 0000000000000001b-te bits 8-9 of "a" are now 26-27
        
        mov ECX,EAX     ;we isolate the bits 26-27
        and ECX,00001100000000000000000000000000b       ;ECX=0000(10)0000000000 0000000000000000b
        or EBX,ECX      ;EBX=1111(10)1000000000 0000000000000000b
        
        
        ;3: bits:20-23 (invert of the bits 0-3 of "a")
        mov EAX,[a]     ;EAX= a =0000000000000000 0110111000101100b
        not EAX         ; we invert the value of "a" => EAX=1111111111111111 1001000111010011b
        ;we have to isolate the bits 0-3:
        and EAX, 00000000000000000000000000001111b     ;EAX=0000000000000000 000000000000(0011)b
        
        
        rol EAX,20      ;the inverted bits 0-3 become 20-23     ;EAX=00000000(0011)0000 0000000000000000b
        or EBX,EAX      ;EBX=11111010(0011)0000 0000000000000000b
        
        
        ;4: bits:16-19(have the value 0)
        and EBX,11111111111100001111111111111111b       ; we force the bits 16-19 to be 0
        
        
        ;5: bits 0-15(are the same as the bits 16-31 of B)
        mov EAX,EBX
       
        shr EAX,16      ;we move the bits 16 position to the right so all the bits of the high word are now in the low word
        or EBX,EAX      ;EBX=1111101000110000 1111101000110000b =FA30 FA30h = 4197513776 d
        
        mov [b],EBX
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
