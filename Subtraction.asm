section .data
    phone dd 46             ; Number to add to
    id dd 28                ; Number being added
    buffer db 11 dup(0)      ; Buffer to store the ASCII characters (10 digits + null terminator)
    msg db "The subtraction of 46 and 28 is: " ; Message
    len equ $ - msg         ; bytes required for the length of the message
    
    sign db "-"         ;sign char
    lens equ $ - sign   ; getting the sign's size

section .text
global _start

_start:

    mov ecx, msg
    mov edx, len
    mov ebx, 1
    mov eax, 4
    int 0x80                ;printing message
    
    ; Convert the number to ASCII and store in buffer
    mov eax, [phone]        ; Load the number into eax
    mov ebx, [id]           ;load id into ebx
    cmp eax, ebx            ;compare eax with ebx
    jl less                 ; if eax is less than ebx it will jump to less
    jmp subtraction
    
less:                   ;prints the negative sign
    mov ecx, sign       
    mov edx, lens
    mov ebx, 1
    mov eax, 4
    int 0x80
    
    mov eax,[id]        
    mov ebx,[phone]     ;switch registers to make the subtraction
    
    
subtraction:
    sub eax,ebx
    lea edi, [buffer + 9]    ; Point edi to the second to last byte of the buffer

convert_loop:
    xor edx, edx             ; Clear edx for division
    mov ebx, 10              ; Set divisor to 10
    div ebx                  ; Divide eax by 10, result in eax, remainder in edx
    add dl, '0'              ; Convert remainder to ASCII
    dec edi                  ; Move buffer pointer backwards
    mov [edi], dl            ; Store ASCII character in buffer
    test eax, eax            ; Check if the quotient is 0
    jnz convert_loop         ; If not, continue loop

    ; Print the number
    mov eax, 4               ; sys_write
    mov ebx, 1               ; File descriptor: stdout
    mov ecx, edi             ; Pointer to the first character in the buffer
    mov edx, 10              ; Number of characters to print
    sub edx, edi             ; Adjust count based on where we stored the first character
    add edx, buffer          ; Correct the count
    int 0x80                 ; Make syscall

    ; Exit the program
    mov eax, 1               ; sys_exit
    xor ebx, ebx             ; Exit status
    int 0x80                 ; Make syscall
