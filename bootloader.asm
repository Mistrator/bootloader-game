[bits 16] ; use 16-bit mode
[org 0x7c00] ; "origin": assume that the program will be loaded starting from address 0x7c00

init:
    mov ah, 0x00 ; set video mode (also clears the screen)
    mov al, 0x03 ; text, 80x25, 16 fg / 8 bg colors
    int 0x10

times 510-($-$$) db 0 ; zero-fill so that we have 510 bytes at this point
dw 0xaa55 ; "declare word": write data to output file
