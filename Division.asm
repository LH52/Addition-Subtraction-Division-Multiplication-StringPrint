section .data
    phone dd 46             ; Number to being divided
    id dd 28                ; Number being added
    buffer db 11 dup(0)      ; Buffer to store the ASCII characters (10 digits + null terminator)
    msg db "The division of 46 by 28 is: " ; Message
    len equ $ - msg         ; bytes required for the length of the message

section .text
global _start

_start:

    mov ecx, msg
    mov edx, len
    mov ebx, 1
    mov eax, 4
    int 0x80                ;this section is for printing the initial message
    
    ; Convert the number to ASCII and store in buffer
    mov edx,0               ;clear edx for division
    mov eax, [phone]        ; Load the number into eax
    mov ecx, [id]           ;load number into ecx
    div ecx                 ;divide eax by ecx
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
