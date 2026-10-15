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

BUFSIZE           EQU 128

; 암호화 키 (문제 예시 키 적용: "ABXmv#7")
key               BYTE "ABXmv#7", 0
keySize           DWORD ?

; 입출력 버퍼
plaintext         BYTE BUFSIZE DUP(0)
plainLen          DWORD ?

msgPrompt         BYTE "Enter plaintext: ", 0
msg1              BYTE "Original text:  ", 0
msg2              BYTE "Encrypted text: ", 0
msg3              BYTE "Decrypted text: ", 0
newline           BYTE 13, 10, 0

.code
main PROC
    ; 콘솔 입출력 핸들 구하기
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov hStdIn, eax
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 1. 키 길이 계산
    mov esi, OFFSET key
    call StrLen
    mov keySize, ecx

    ; 2. 사용자로부터 평문 입력받기
    mov esi, OFFSET msgPrompt
    call PrintString

    INVOKE ReadConsoleA, hStdIn, ADDR plaintext, BUFSIZE, ADDR bytesRead, 0
    
    ; 엔터키(\r\n) 제거 및 길이 계산
    mov esi, OFFSET plaintext
    call StrLen
    mov plainLen, ecx

    ; ----------------------------------------------------
    ; [1단계] 원문 출력
    ; ----------------------------------------------------
    mov esi, OFFSET msg1
    call PrintString
    mov esi, OFFSET plaintext
    call PrintString
    mov esi, OFFSET newline
    call PrintString

    ; ----------------------------------------------------
    ; [2단계] 암호화 (Encrypt)
    ; ----------------------------------------------------
    call TranslateBuffer

    mov esi, OFFSET msg2
    call PrintString
    mov esi, OFFSET plaintext
    call PrintString
    mov esi, OFFSET newline
    call PrintString

    ; ----------------------------------------------------
    ; [3단계] 복호화 (Decrypt - 동일한 XOR 키로 다시 수행)
    ; ----------------------------------------------------
    call TranslateBuffer

    mov esi, OFFSET msg3
    call PrintString
    mov esi, OFFSET plaintext
    call PrintString
    mov esi, OFFSET newline
    call PrintString

    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; TranslateBuffer PROC
; [설명] plaintext 버퍼의 각 바이트를 key 문자들과 순환하며 XOR 수행
; ====================================================
TranslateBuffer PROC
    pushad

    mov esi, OFFSET plaintext   ; 평문 버퍼 포인터
    mov ecx, plainLen           ; 전체 평문 길이
    cmp ecx, 0
    je  Done

    mov edi, 0                  ; 키 인덱스 (0으로 초기화)

XorLoop:
    ; key[edi] 문자를 AL에 가져옴
    mov ebx, OFFSET key
    mov al, [ebx + edi]

    ; plaintext[esi] 바이트와 XOR 연산
    xor [esi], al

    inc esi                     ; 다음 평문 바이트로 이동

    ; 키 인덱스 순환: edi = (edi + 1) % keySize
    inc edi
    cmp edi, keySize
    jne SkipReset
    mov edi, 0                  ; 키의 끝에 도달하면 처음(0)으로 리셋

SkipReset:
    loop XorLoop

Done:
    popad
    ret
TranslateBuffer ENDP


; ====================================================
; StrLen PROC (null 문전까지 또는 엔터키전까지 길이 계산)
; [입력] ESI : 문자열 주소
; [출력] ECX : 문자열 길이
; ====================================================
StrLen PROC
    push ebx
    push esi

    xor ecx, ecx
LenLoop:
    mov bl, [esi]
    cmp bl, 0
    je  LenDone
    cmp bl, 13                  ; Carriage Return (\r)
    je  LenDone
    cmp bl, 10                  ; Line Feed (\n)
    je  LenDone
    inc ecx
    inc esi
    jmp LenLoop

LenDone:
    ; 입력 버퍼에 남아있는 \r\n을 null 문자(0)로 대체
    mov byte ptr [esi], 0

    pop esi
    pop ebx
    ret
StrLen ENDP


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