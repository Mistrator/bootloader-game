[bits 16] ; Use 16-bit mode
[org 0x7c00] ; "origin": assume that the program will be loaded starting from address 0x7c00

init:
    mov ah, 0x00 ; Set video mode (also clears the screen)
    mov al, 0x03 ; Text, 80x25, 16 fg / 8 bg colors
    int 0x10
    
main_loop:
    ; Limit framerate
    ; Read system clock ticks: increments about once every 55 ms, so we get
    ; about 18.2 ticks per second
    mov ah, 0x00
    int 0x1a
    cmp dx, [prev_tick_low]
    je main_loop
    mov [prev_tick_low], dx

    ; Clear screen
    mov ah, 0x06 ; Clear screen rectangle
    mov al, 0x00 ; Blank entire rectange
    mov bh, 0x07 ; Video attribute: white-on-black
    mov cl, 0x4f ; Rectangle lower-right x
    mov ch, 0x18 ; Rectangle lower-right y
    mov dx, 0x0000 ; Rectangle upper-left x and y
    int 0x10
    
    ; Draw the ball
    mov ah, 0x02 ; Set cursor position
    mov bh, 0x00 ; Video page 0
    mov dh, [ball_y]
    mov dl, [ball_x]
    int 0x10
    mov ah, 0x0a ; Write character to cursor location
    mov al, 0x2a ; Character '*'
    mov bh, 0x00 ; Video page 0
    mov cx, 0x0001 ; Repeat once
    int 0x10
    
    jmp main_loop

prev_tick_low dw 0 ; The lower word of previous system clock tick reading

ball_x db 4
ball_y db 6

ball_vx db 1
ball_vy db 1

times 510-($-$$) db 0 ; Zero-fill so that we have 510 bytes at this point
dw 0xaa55 ; Magic bytes which tell BIOS that the program is bootable
