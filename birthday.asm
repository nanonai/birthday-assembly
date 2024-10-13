section .data
    prompt:    db "Please enter a size for the birthday cake ( s ∈ Z and 64 ≥ s ≥ 4 ):", 0
    pro_len:   equ $-prompt
    line:      db "-------------------------------------------------------------------", 10
    line_len:  equ $-line
    msg:       db "Here is your cake!", 10
    msg_len:   equ $-msg
    end:       db 0x1B, '[33m', "HAPPY BIRTHDAY!!!", 0x1B, '[0m', 10
    end_len:   equ $-end
    fire:      db "*", 0
    candle:    db "|", 0
    space:     db " ", 0
    ver:       db 0x1B, '[35m', "|", 0x1B, '[0m', 0
    v_len:     equ $-ver
    top:       db 0x1B, '[35m', "‾", 0x1B, '[0m', 0
    t_len:     equ $-top
    hor:       db 0x1B, '[35m', "_", 0x1B, '[0m', 0
    h_len:     equ $-hor
    inva:      db 0x1B, '[31m', "Size entered is invalid, must be a number and bigger than 3 and smaller than 65!", 10, 0x1B, '[0m', 0
    i_len:     equ $-inva
    br:        db 0xA, 0
    buffer:    db 100, 0
    cakesize:  db 100, 0

section .text
    global _start

_start:
    mov byte [buffer], 100
    mov byte [cakesize], 100

    mov ecx, prompt
    mov edx, pro_len
    call print

    mov ecx, buffer
    mov edx, 100
    call get

    mov eax, 0
    mov edi, buffer
    call validate
    cmp ebx, 9
    je invalid
    mov [cakesize], eax

    mov esi, [cakesize]
    mov edi, 2
    cmp esi, 4
    jl invalid
    cmp esi, 64
    jg invalid

    cmp esi, 6
    jge candle_three
    jmp draw

candle_three:
    mov edi, 3

    cmp esi, 8
    jge candle_four
    jmp draw

candle_four:
    mov edi, 4
    jmp draw

draw:
    mov ecx, line
    mov edx, line_len
    call print

    mov ecx, msg
    mov edx, msg_len
    call print
fire_draw:
    push edi
    push esi
    dec edi
fire_space:
    cmp esi, 0
    je candle_draw
    dec esi
    mov ecx, space
    mov edx, 1
    call print
fire_fire:
    cmp esi, 1
    je candle_draw
    dec esi
    mov ecx, fire
    mov edx, 1
    call print
    jmp fire_space
candle_draw:
    mov ecx, br
    mov edx, 1
    call print
    pop esi
    push esi
candle_space:
    cmp edi, 0
    je cake_first
    cmp esi, 0
    je candle_row_done
    dec esi
    mov ecx, space
    mov edx, 1
    call print
candle_candle:
    cmp edi, 0
    je cake_first
    cmp esi, 1
    je candle_row_done
    dec esi
    mov ecx, candle
    mov edx, 1
    call print
    jmp candle_space
candle_row_done:
    dec edi
    jmp candle_draw
cake_first:
    pop esi
    pop edi
    push esi
    sub esi, edi
    mov edi, esi
    pop esi
    push esi
    mov ecx, ver
    mov edx, v_len
    call print
    dec esi
    dec edi
f_top_loop:
    cmp esi, 1
    je f_last
    dec esi
    mov ecx, top
    mov edx, t_len
    call print
    jmp f_top_loop
f_last:
    mov ecx, ver
    mov edx, v_len
    call print
    pop esi
    push esi
    mov ecx, br
    mov edx, 1
    call print
cake_between:
    cmp edi, 1
    je cake_last
    dec edi
    dec esi
    mov ecx, ver
    mov edx, v_len
    call print
b_space_loop:
    cmp esi, 1
    je b_last
    dec esi
    mov ecx, space
    mov edx, 1
    call print
    jmp b_space_loop
b_last:
    mov ecx, ver
    mov edx, v_len
    call print
    pop esi
    push esi
    mov ecx, br
    mov edx, 1
    call print
    jmp cake_between
cake_last:
    mov ecx, ver
    mov edx, v_len
    call print
    dec esi
l_hor_loop:
    cmp esi, 1
    je l_last
    dec esi
    mov ecx, hor
    mov edx, h_len
    call print
    jmp l_hor_loop
l_last:
    mov ecx, ver
    mov edx, v_len
    call print
    mov ecx, br
    mov edx, 1
    call print

done:
    mov ecx, end
    mov edx, end_len
    call print
    jmp exit

invalid:
    mov ecx, line
    mov edx, line_len
    call print

    mov ecx, inva
    mov edx, i_len
    call print
    jmp _start

print:
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

get:
    mov eax, 3
    mov ebx, 0
    int 0x80
    ret

exit:
    mov eax, 1
    mov ebx, 0
    int 0x80

validate:
    xor eax, eax
    xor ebx, ebx
v_loop:
    movzx edx, byte [edi]
    cmp edx, 0xA
    je v_done
    cmp edx, '9'
    ja invalid_done
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc edi
    jmp v_loop
v_done:
    mov ebx, 0
    ret
invalid_done:
    mov ebx, 9
    ret
