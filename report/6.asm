.386
.model flat, stdcall
option casemap:none

; ----------------------------------------------------
; Windows API 함수 선언 (Visual Studio 기본 제공)
; ----------------------------------------------------
GetStdHandle      PROTO STDCALL :DWORD
WriteConsoleA     PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
ReadConsoleA      PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
ExitProcess       PROTO STDCALL :DWORD

INCLUDELIB kernel32.lib

.data
STD_INPUT_HANDLE  EQU -10
STD_OUTPUT_HANDLE EQU -11

hStdIn            DWORD ?
hStdOut           DWORD ?
bytesWritten      DWORD ?
bytesRead         DWORD ?

; 메뉴 및 프롬프트 메시지
menuMsg BYTE 13, 10
        BYTE "==============================", 13, 10
        BYTE "     Boolean Calculator (2)   ", 13, 10
        BYTE "==============================", 13, 10
        BYTE "1. x AND y", 13, 10
        BYTE "2. x OR y", 13, 10
        BYTE "3. NOT x", 13, 10
        BYTE "4. x XOR y", 13, 10
        BYTE "5. Exit program", 13, 10
        BYTE "==============================", 13, 10
        BYTE "Enter your choice (1-5): ", 0

promptX     BYTE "Enter 32-bit Hex value for x: ", 0
promptY     BYTE "Enter 32-bit Hex value for y: ", 0
resultMsg   BYTE "Result: ", 0
invalidMsg  BYTE "Invalid choice! Please select 1-5.", 13, 10, 0
msgExit     BYTE "Exiting program. Goodbye!", 13, 10, 0
newline     BYTE 13, 10, 0

inputBuf    BYTE 32 DUP(0)
hexBuf      BYTE 16 DUP(0)

; ----------------------------------------------------
; Table-Driven Selection 테이블 정의
; 엔트리당 5바이트: [메뉴문자(1B)] + [프로시저주소(4B)]
; ----------------------------------------------------
CaseTable BYTE '1'
          DWORD AND_op
          BYTE '2'
          DWORD OR_op
          BYTE '3'
          DWORD NOT_op
          BYTE '4'
          DWORD XOR_op
          BYTE '5'
          DWORD ProcessExit

NumberOfEntries EQU 5
EntrySize       EQU 5

.code
main PROC
    ; 콘솔 입출력 핸들 구하기
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov hStdIn, eax
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

MenuLoop:
    mov esi, OFFSET menuMsg
    call PrintString

    call ReadCharCustom      ; 입력 문자가 AL에 리턴됨

    mov esi, OFFSET CaseTable
    mov ecx, NumberOfEntries

LookupLoop:
    cmp al, [esi]
    jne NextEntry

    ; 일치하는 항목 호출
    call DWORD PTR [esi + 1]

    cmp al, '5'
    je  EndProgram
    jmp MenuLoop

NextEntry:
    add esi, EntrySize
    loop LookupLoop

    mov esi, OFFSET invalidMsg
    call PrintString
    jmp MenuLoop

EndProgram:
    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; 1. AND_op : x AND y 연산
; ====================================================
AND_op PROC
    pushad

    ; x 입력받기
    mov esi, OFFSET promptX
    call PrintString
    call ReadHexCustom
    mov ebx, eax            ; EBX = x

    ; y 입력받기
    mov esi, OFFSET promptY
    call PrintString
    call ReadHexCustom      ; EAX = y

    ; x AND y 수행
    and eax, ebx

    ; 결과 출력
    mov esi, OFFSET resultMsg
    call PrintString
    call WriteHexCustom
    mov esi, OFFSET newline
    call PrintString

    popad
    ret
AND_op ENDP


; ====================================================
; 2. OR_op : x OR y 연산
; ====================================================
OR_op PROC
    pushad

    ; x 입력받기
    mov esi, OFFSET promptX
    call PrintString
    call ReadHexCustom
    mov ebx, eax            ; EBX = x

    ; y 입력받기
    mov esi, OFFSET promptY
    call PrintString
    call ReadHexCustom      ; EAX = y

    ; x OR y 수행
    or eax, ebx

    ; 결과 출력
    mov esi, OFFSET resultMsg
    call PrintString
    call WriteHexCustom
    mov esi, OFFSET newline
    call PrintString

    popad
    ret
OR_op ENDP


; ====================================================
; 3. NOT_op : NOT x 연산
; ====================================================
NOT_op PROC
    pushad

    ; x 입력받기
    mov esi, OFFSET promptX
    call PrintString
    call ReadHexCustom      ; EAX = x

    ; NOT x 수행
    not eax

    ; 결과 출력
    mov esi, OFFSET resultMsg
    call PrintString
    call WriteHexCustom
    mov esi, OFFSET newline
    call PrintString

    popad
    ret
NOT_op ENDP


; ====================================================
; 4. XOR_op : x XOR y 연산
; ====================================================
XOR_op PROC
    pushad

    ; x 입력받기
    mov esi, OFFSET promptX
    call PrintString
    call ReadHexCustom
    mov ebx, eax            ; EBX = x

    ; y 입력받기
    mov esi, OFFSET promptY
    call PrintString
    call ReadHexCustom      ; EAX = y

    ; x XOR y 수행
    xor eax, ebx

    ; 결과 출력
    mov esi, OFFSET resultMsg
    call PrintString
    call WriteHexCustom
    mov esi, OFFSET newline
    call PrintString

    popad
    ret
XOR_op ENDP


; ====================================================
; 5. ProcessExit : 종료 프로시저
; ====================================================
ProcessExit PROC
    pushad
    mov esi, OFFSET msgExit
    call PrintString
    popad
    ret
ProcessExit ENDP


; ====================================================
; ReadHexCustom PROC
; [설명] 콘솔에서 16진수 문자열(예: A5F, 00FF1234 등)을 입력받아
;        32비트 정수로 변환하여 EAX에 반환
; ====================================================
ReadHexCustom PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    INVOKE ReadConsoleA, hStdIn, ADDR inputBuf, 32, ADDR bytesRead, 0

    mov esi, OFFSET inputBuf
    xor eax, eax            ; 결과 저장용 레지스터 (0 초기화)

ParseHexLoop:
    mov bl, byte ptr [esi]

    ; 엔터키(\r, \n) 또는 문자열 끝 판별
    cmp bl, 13
    je  ParseHexDone
    cmp bl, 10
    je  ParseHexDone
    cmp bl, 0
    je  ParseHexDone

    ; '0' ~ '9'
    cmp bl, '0'
    jl  CheckUpper
    cmp bl, '9'
    jg  CheckUpper
    sub bl, '0'
    jmp ShiftAndAdd

CheckUpper:
    ; 'A' ~ 'F'
    cmp bl, 'A'
    jl  CheckLower
    cmp bl, 'F'
    jg  CheckLower
    sub bl, 'A'
    add bl, 10
    jmp ShiftAndAdd

CheckLower:
    ; 'a' ~ 'f'
    cmp bl, 'a'
    jl  ParseHexDone
    cmp bl, 'f'
    jg  ParseHexDone
    sub bl, 'a'
    add bl, 10

ShiftAndAdd:
    shl eax, 4              ; 기존 값 * 16 (왼쪽으로 4비트 시프트)
    movzx ebx, bl
    add eax, ebx            ; 현재 4비트 값 더하기

    inc esi
    jmp ParseHexLoop

ParseHexDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
ReadHexCustom ENDP


; ====================================================
; WriteHexCustom PROC
; [설명] EAX에 담긴 32비트 정수값을 8자리 16진수 문자열로 콘솔에 출력
; ====================================================
WriteHexCustom PROC
    pushad

    mov edi, OFFSET hexBuf
    mov ecx, 8              ; 32비트 정수 = 8자리 16진수 (4비트 * 8)

HexLoop:
    rol eax, 4              ; 가장 높은 4비트를 제일 낮은 4비트로 회전
    mov edx, eax
    and edx, 0Fh            ; 하위 4비트만 추출

    ; 0-9 혹은 A-F 변환
    cmp dl, 9
    jbe Digit
    add dl, 'A' - 10
    jmp StoreChar

Digit:
    add dl, '0'

StoreChar:
    mov [edi], dl
    inc edi
    loop HexLoop

    ; 8자리 16진수 문자열 출력
    INVOKE WriteConsoleA, hStdOut, ADDR hexBuf, 8, ADDR bytesWritten, 0

    popad
    ret
WriteHexCustom ENDP


; ====================================================
; ReadCharCustom PROC (단일 문자 입력 보조 프로시저)
; ====================================================
ReadCharCustom PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    INVOKE ReadConsoleA, hStdIn, ADDR inputBuf, 16, ADDR bytesRead, 0
    mov al, byte ptr [inputBuf]

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
ReadCharCustom ENDP


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