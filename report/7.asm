.386
.model flat, stdcall
option casemap:none

; ----------------------------------------------------
; Windows API 함수 선언 (Visual Studio 기본 제공)
; ----------------------------------------------------
GetStdHandle           PROTO STDCALL :DWORD
WriteConsoleA          PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
SetConsoleTextAttribute PROTO STDCALL :DWORD, :WORD
GetTickCount           PROTO STDCALL
ExitProcess            PROTO STDCALL :DWORD

INCLUDELIB kernel32.lib

.data
STD_OUTPUT_HANDLE EQU -11

; Windows Console Color Attributes (콘솔 색상 상수)
COLOR_WHITE       EQU 15    ; Bright White
COLOR_BLUE        EQU 9     ; Bright Blue
COLOR_GREEN       EQU 10    ; Bright Green

hStdOut           DWORD ?
bytesWritten      DWORD ?
seed              DWORD 12345

displayText       BYTE "Line ", 0
newline           BYTE 13, 10
buffer            BYTE 16 DUP(0)

.code
main PROC
    ; 콘솔 출력 핸들 가져오기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 난수 생성을 위한 시드값 초기화
    INVOKE GetTickCount
    mov seed, eax

    mov ecx, 20             ; 20줄 출력 루프

LineLoop:
    push ecx                ; 루프 카운터 보존

    ; ----------------------------------------------------
    ; 1. 0 ~ 9 사이의 난수 생성
    ; ----------------------------------------------------
    mov ebx, 0              ; 하한값 0
    mov edx, 9              ; 상한값 9
    call GenerateRandomVal  ; EAX에 0~9 사이의 난수 반환

    ; ----------------------------------------------------
    ; 2. 확률에 따른 색상 선택
    ;   - 0 ~ 2 (30%): White
    ;   - 3     (10%): Blue
    ;   - 4 ~ 9 (60%): Green
    ; ----------------------------------------------------
    cmp eax, 2
    jbe SelectWhite

    cmp eax, 3
    je  SelectBlue

    ; 4 ~ 9 인 경우
    mov dx, COLOR_GREEN
    jmp SetColor

SelectWhite:
    mov dx, COLOR_WHITE
    jmp SetColor

SelectBlue:
    mov dx, COLOR_BLUE

SetColor:
    ; 윈도우 콘솔 색상 변경 API 호출
    INVOKE SetConsoleTextAttribute, hStdOut, dx

    ; ----------------------------------------------------
    ; 3. 텍스트 및 라인 번호 출력
    ; ----------------------------------------------------
    mov esi, OFFSET displayText
    call PrintString

    ; 현재 줄 번호 출력 (1 ~ 20)
    mov eax, 21
    pop ecx
    push ecx
    sub eax, ecx            ; EAX = 21 - ECX
    call WriteIntCustom

    ; 줄바꿈
    mov esi, OFFSET newline
    call PrintString

    pop ecx                 ; 루프 카운터 복원
    loop LineLoop

    ; 프로그램 종료 전 콘솔 색상 원래대로(흰색) 복원
    INVOKE SetConsoleTextAttribute, hStdOut, COLOR_WHITE

    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; GenerateRandomVal PROC
; [설명] EBX ~ EDX 범위의 난수를 생성하여 EAX에 반환
; ====================================================
GenerateRandomVal PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov eax, edx
    sub eax, ebx
    inc eax
    mov edi, eax            ; EDI = 범위 크기 (10)

    mov eax, seed
    imul eax, eax, 1103515245
    add eax, 12345
    mov seed, eax

    shr eax, 16
    and eax, 07FFFh

    xor edx, edx
    div edi                 ; EDX = EAX % 10

    add edx, ebx            ; EDX = (EAX % 10) + 0
    mov eax, edx

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
GenerateRandomVal ENDP


; ====================================================
; WriteIntCustom PROC (정수 출력 보조 프로시저)
; ====================================================
WriteIntCustom PROC
    pushad
    mov edi, OFFSET buffer
    mov ebx, 10
    xor ecx, ecx

ConvertLoop:
    xor edx, edx
    div ebx
    add dl, '0'
    push edx
    inc ecx
    cmp eax, 0
    jnz ConvertLoop

PrintDigits:
    pop eax
    mov [edi], al
    push ecx
    INVOKE WriteConsoleA, hStdOut, edi, 1, ADDR bytesWritten, 0
    pop ecx
    loop PrintDigits

    popad
    ret
WriteIntCustom ENDP


; ====================================================
; PrintString PROC (문자열 출력 보조 프로시저)
; ====================================================
PrintString PROC
    pushad
    mov edi, esi
    xor ecx, ecx
StrLenLoop:
    cmp byte ptr [edi], 0
    je StrLenDone
    inc edi
    inc ecx
    jmp StrLenLoop
StrLenDone:
    INVOKE WriteConsoleA, hStdOut, esi, ecx, ADDR bytesWritten, 0
    popad
    ret
PrintString ENDP

END main