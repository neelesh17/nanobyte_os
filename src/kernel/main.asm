org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start: 
	jmp main

;
; Prints a string to the screen
; Params:
;	- ds:si points to string
;
puts:
	; saves registers we will modify
	push si
	push ax

.loop:
	lodsb				; loads nect charcter to al
	or al, al			; verify if next character is null?
	jz .done

	mov ah, 0x0e		; call bios interrupt
	int 0x10

	jmp .loop
.done:
	pop ax
	pop si
	ret


main:
	; setup data segments
	mov ax, 0  ; can't write to ds/es directly
	mov ds, ax
	mov es, ax

	; setup stack
	mov ss, ax
	mov sp, 0x7C00   ; stack grows downwards from where we loaded in memory

	;print message
	mov si, msg_hello_world
	call puts

	hlt

.halt:
	jmp .halt


msg_hello_world: db 'Hello world!', ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
