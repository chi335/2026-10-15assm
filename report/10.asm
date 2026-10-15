.386
.model flat, stdcall
option casemap:none

; ----------------------------------------------------
; Windows API 함수 선언 (Visual Studio 기본 제공)
; ----------------------------------------------------
GetStdHandle      PROTO STDCALL :DWORD
WriteConsoleA     PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
ExitProcess       PROTO STDCALL :DWORD

INCLUDELIB kernel32.lib

.data
STD_OUTPUT_HANDLE EQU -11
hStdOut           DWORD ?
bytesWritten      DWORD ?
buffer            BYTE 16 DUP(0)

; 테스트용 10바이트 배열 선언
; Array 1: 짝수 패리티 (1, 1, 2, 2, 3, 3, 4, 4, 5, 5 -> 전체 1 비트 개수 짝수)
arrayEven         BYTE 1, 1, 2, 2, 3, 3, 4, 4, 5, 5
lenEven           EQU $ - arrayEven

; Array 2: 홀수 패리티 (1, 1, 2, 2, 3, 3, 4, 4, 5, 4 -> 전체 1 비트 개수 홀수)
arrayOdd          BYTE 1, 1, 2, 2, 3, 3, 4, 4, 5, 4
lenOdd            EQU $ - arrayOdd

; 출력용 메시지
msg1              BYTE "Test 1 (Even Parity Array): EAX = ", 0
msg2              BYTE "Test 2 (Odd Parity Array) : EAX = ", 0
msgTrue           BYTE " (1 = True / Even Parity)", 13, 10, 0
msgFalse          BYTE " (0 = False / Odd Parity)", 13, 10, 0

.code
main PROC
    ; 콘솔 출력 핸들 구하기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; ----------------------------------------------------
    ; [테스트 1] 짝수 패리티 배열 검사 (예상 결과: EAX = 1)
    ; ----------------------------------------------------
    mov esi, OFFSET arrayEven   ; 배열 포인터
    mov ecx, lenEven            ; 배열 길이
    call CheckParity

    push eax                    ; 결과 보존
    mov esi, OFFSET msg1
    call PrintString
    pop eax

    call WriteIntCustom
    cmp eax, 1
    je  PrintTrue1
    mov esi, OFFSET msgFalse
    call PrintString
    jmp Test2

PrintTrue1:
    mov esi, OFFSET msgTrue
    call PrintString

Test2:
    ; ----------------------------------------------------
    ; [테스트 2] 홀수 패리티 배열 검사 (예상 결과: EAX = 0)
    ; ----------------------------------------------------
    mov esi, OFFSET arrayOdd    ; 배열 포인터
    mov ecx, lenOdd             ; 배열 길이
    call CheckParity

    push eax                    ; 결과 보존
    mov esi, OFFSET msg2
    call PrintString
    pop eax

    call WriteIntCustom
    cmp eax, 1
    je  PrintTrue2
    mov esi, OFFSET msgFalse
    call PrintString
    jmp EndProgram

PrintTrue2:
    mov esi, OFFSET msgTrue
    call PrintString

EndProgram:
    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; CheckParity PROC
; [설명] 배열에 포함된 전체 1 비트의 총 개수 패리티를 검사함
;
; [입력]
;   ESI : 바이트 배열 포인터
;   ECX : 배열 요소 개수(길이)
;
; [출력]
;   EAX : 1 (True / 짝수 패리티), 0 (False / 홀수 패리티)
;
; [특징]
;   EAX를 제외한 모든 레지스터 값 보존
; ====================================================
CheckParity PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov al, 0               ; 패리티 누적용 레지스터 초기화

ParityLoop:
    xor al, [esi]           ; 각 바이트를 XOR 연산 (1의 개수의 짝/홀 특성 유지)
    inc esi
    loop ParityLoop

    ; 누적된 AL 값의 패리티 플래그(PF) 검사
    test al, al             ; PF(Parity Flag) 갱신
    jp  IsEven              ; JP / JPE : Parity Even (1 비트 개수가 짝수일 때 분기)

    ; 홀수 패리티(Odd)인 경우
    mov eax, 0
    jmp ParityDone

IsEven:
    ; 짝수 패리티(Even)인 경우
    mov eax, 1

ParityDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CheckParity ENDP


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