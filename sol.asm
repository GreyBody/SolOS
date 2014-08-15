   mov ax, 0x07C0
   mov ds, ax
   mov es, ax

   mov	 ah, 6; 
   mov	 al, 0 ;
   mov	 bh, 09h; 
   mov	 cx, 0 ; 
   mov	 dl, 79;
   mov	 dh, 24;
   int	 10h ;
   call welcomemsg
 
 mainloop:
   mov si, prompt
   call print_string
 
   mov di, buffer
   call get_string
 
   mov si, buffer
   cmp byte [si], 0
   je mainloop
 
   mov si, buffer
   mov di, cmd_hi
   call strcmp
   jc .helloworld
 
   mov si, buffer
   mov di, cmd_help
   call strcmp
   jc .help

   mov si, buffer
   mov di, cmd_info
   call strcmp
   jc .info

   mov si, buffer
   mov di, cmd_cls
   call strcmp
   jc .cls

   mov si, buffer
   mov di, cmd_date
   call strcmp
   jc .getDate
 
   mov si,badcommand
   call print_string 
   jmp mainloop  
 
 .helloworld:
   mov si, msg_helloworld
   call print_string
 
   jmp mainloop
 
 .help:
   mov si, msg_help0
   call print_string
   mov si, msg_help1
   call print_string
   mov si, msg_help2
   call print_string
   mov si, msg_help3
   call print_string
   mov si, msg_help4
   call print_string

   jmp mainloop

 .info:
   mov si, msg_info0
   call print_string
   mov si, msg_info1
   call print_string
   mov si, msg_info2
   call print_string
   mov si, msg_info3
   call print_string

   jmp mainloop

 .cls:
   call clear_screen
   jmp mainloop

welcomemsg:
   mov si, welcome
   call print_string
   call mainloop
 
 welcome db 'SolOS v1', 0x0D, 0x0A, 0
 msg_helloworld db 'Hello', 0x0D, 0x0A, 0
 badcommand db 'Bad command entered.', 0x0D, 0x0A, 0
 prompt db '>', 0
 cmd_hi db 'hi', 0
 cmd_help db 'help', 0
 cmd_info db 'sysinfo', 0
 cmd_cls db 'scrref', 0
 msg_help0 db 'System Commands:', 0x0D, 0x0A, 0
 msg_help1 db 'sysinfo - Displays system info', 0x0D, 0x0A, 0
 msg_help2 db 'help - Lists system commands', 0x0D, 0x0A, 0
 msg_help3 db 'hi - Says Hello', 0x0D, 0x0A, 0
 msg_help4 db 'scrref - Clear the screen', 0x0D, 0x0A, 0
 msg_info0 db 'SolOS', 0x0D, 0x0A, 0
 msg_info1 db 'Version: 1', 0x0D, 0x0A, 0
 msg_info2 db 'build: 0', 0x0D, 0x0A, 0
 msg_info3 db 'Developer: GreyBody', 0x0D, 0x0A, 0
 buffer times 64 db 0


 
 print_string:
   lodsb
 
   or al, al
   jz .done
 
   mov ah, 0x0E
   int 0x10
 
   jmp print_string
 
 .done:
   ret

 clear_screen:
   mov ah, 2
   mov bh, 0
   mov dh, 0
   mov dl, 0
   int 10h

 get_string:
   xor cl, cl
 
 .loop:
   mov ah, 0
   int 0x16
 
   cmp al, 0x08
   je .backspace
 
   cmp al, 0x0D
   je .done
 
   cmp cl, 0x3F
   je .loop
 
   mov ah, 0x0E
   int 0x10
 
   stosb
   inc cl
   jmp .loop
 
 .backspace:
   cmp cl, 0
   je .loop
 
   dec di
   mov byte [di], 0
   dec cl
 
   mov ah, 0x0E
   mov al, 0x08
   int 10h
 
   mov al, ' '
   int 10h
 
   mov al, 0x08
   int 10h
 
   jmp .loop
 
 .done:
   mov al, 0
   stosb
 
   mov ah, 0x0E
   mov al, 0x0D
   int 0x10
   mov al, 0x0A
   int 0x10
 
   ret

 strcmp:
 .loop:
   mov al, [si]
   mov bl, [di]
   cmp al, bl
   jne .notequal
 
   cmp al, 0
   je .done
 
   inc di
   inc si
   jmp .loop
 
 .notequal:
   clc
   ret
 
 .done: 	
   stc
   ret

   times 1022-($-$$) db 0
   dw 0AA55h