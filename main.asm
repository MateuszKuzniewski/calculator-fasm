format ELF64

section '.rodata'
_window_width equ 400
_window_height equ 600
_color_dark_grey equ 0xFF181818
_color_white equ 0xFFFFFFFF
_color_black equ 0xFF000000
_button_size equ 90
_button_gap equ 15
_title db "Fasm Calculator", 10, 0
_text_array db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '-', '*', '/', '='

section '.data' writeable
_text_tmp db 0, 0

section '.text' executable
public _start

extrn _exit
extrn WindowShouldClose
extrn CloseWindow
extrn BeginDrawing 
extrn EndDrawing 
extrn InitWindow        ; InitWindow(int width, int height, const char *title)
extrn ClearBackground   ; ClearBackground(Color color)
extrn DrawRectangle     ; DrawRectangle(int posX, int posY, int width, int height, Color color)
extrn DrawText          ; DrawText(const char *text, int posX, int posY, int fontSize, Color color)

_start:
    and rsp, -16
    mov rdi, _window_width
    mov rsi, _window_height
    mov rdx, _title 
    call InitWindow
    
.draw_window:
    call WindowShouldClose
    test rax, rax
    jnz .over
    
    call BeginDrawing
    mov rdi, _color_dark_grey 
    call ClearBackground
    xor r12, r12
    
.rect_loop_row:
    cmp r12, 4 
    jge .rect_loop_row_exit

    xor r13, r13 
    
.rect_loop_col:
    cmp r13, 4
    jge .rect_loop_col_exit
    
    mov rax, r12
    imul rax, 4
    add rax, r13

    mov rsi, _text_array
    movzx rbx, byte [rsi + rax]
    mov byte [_text_tmp], bl
    mov byte [_text_tmp + 1], 0

    ; x
    mov rax, r13
    imul rax, _button_size + _button_gap
    mov rdi, rax

    ; y
    mov rax, r12
    inc rax ; row + 1
    imul rax, _button_size + _button_gap
    mov rsi, _window_height
    sub rsi, rax

    mov rdx, _button_size
    mov rcx, _button_size
    mov r8, _color_white
    call DrawRectangle

    mov rdi, _text_tmp          ; text
    mov rax, r13
    imul rax, _button_size + _button_gap 
    mov rsi, rax                ; width 
    add rsi, 30                 ; width offset to center text

    mov rax, r12
    inc rax ; row + 1
    imul rax, _button_size + _button_gap
    mov rdx, _window_height     ; height 
    sub rdx, rax                
    add rdx, 15                 ; height offset to center text

    mov rcx, 60                 ; font size
    mov r8, _color_dark_grey    ; colour
    call DrawText

    inc r13
    jmp .rect_loop_col

.rect_loop_col_exit:
    inc r12
    jmp .rect_loop_row

.rect_loop_row_exit:
    call EndDrawing
    jmp .draw_window

.over:
    call CloseWindow
    xor rdi, rdi
    call _exit

