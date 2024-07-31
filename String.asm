section .data
message db "Luke Russel"
second db " is the best teacher!"
section .text
global _start
_start:
 
    mov ecx, message ; Point to the start of the message

find_end:
    mov al, [ecx]   ; Get a character from the message
    cmp al, 0       ; Check if it's the null terminator
    jz adjust       ; If yes, adjust pointer to last character
    inc ecx         ; Otherwise, move to the next character
    jmp find_end    ;repeats

adjust:
    dec ecx         ; Move back to point to the last character
    
print:
    mov al, [ecx]   ; Move the last character into al
    cmp al,0        ;compare al with 0
    jz exit         ;jumps to exit when al is 0 (reaches the end)
    mov edx, 1      ; We're going to print just this one character
    mov ebx, 1      ; File descriptor for stdout
    mov eax, 4      ; System call number for sys_write
    int 0x80        ; Make the system call to print the character
    dec ecx         ;goes to the previous character of the string
    
    jmp print       ;will keep going, even automatically go into 'second' since null operator is not reached in message

exit:
    mov eax, 1      ; System call number for exit
    xor ebx, ebx    ; Exit status 0
    int 0x80        ; Make the system call to exit
