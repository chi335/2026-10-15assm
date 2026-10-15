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

; 메뉴 출력 메시지
menuMsg BYTE 13, 10
        BYTE "==============================", 13, 10
        BYTE "     Boolean Calculator       ", 13, 10
        BYTE "==============================", 13, 10
        BYTE "1. x AND y", 13, 10
        BYTE "2. x OR y", 13, 10
        BYTE "3. NOT x", 13, 10
        BYTE "4. x XOR y", 13, 10
        BYTE "5. Exit program", 13, 10
        BYTE "==============================", 13, 10
        BYTE "Enter your choice (1-5): ", 0

invalidMsg BYTE "Invalid choice! Please select 1-5.", 13, 10, 0
newline    BYTE 13, 10, 0
inputBuf   BYTE 16 DUP(0)

; 각 연산별 출력 메시지
msgAND  BYTE "Performing: x AND y operation...", 13, 10, 0
msgOR   BYTE "Performing: x OR y operation...", 13, 10, 0
msgNOT  BYTE "Performing: NOT x operation...", 13, 10, 0
msgXOR  BYTE "Performing: x XOR y operation...", 13, 10, 0
msgExit BYTE "Exiting program. Goodbye!", 13, 10, 0

; ----------------------------------------------------
; [핵심] Table-Driven Selection 구조체 테이블 정의
; 1바이트(입력문자 '1'~'5') + 4바이트(프로시저 주소) = 엔트리당 5바이트
; ----------------------------------------------------
CaseTable BYTE '1'
          DWORD ProcessAND
          BYTE '2'
          DWORD ProcessOR
          BYTE '3'
          DWORD ProcessNOT
          BYTE '4'
          DWORD ProcessXOR
          BYTE '5'
          DWORD ProcessExit

NumberOfEntries EQU 5
EntrySize       EQU 5       ; '1'(1바이트) + 주소(4바이트)

.code
main PROC
    ; 콘솔 입출력 핸들 가져오기
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov hStdIn, eax
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

MenuLoop:
    ; 1. 메뉴 출력
    mov esi, OFFSET menuMsg
    call PrintString

    ; 2. 사용자 입력 받기 (문자 1개)
    call ReadCharCustom      ; 입력 문자가 AL 레지스터에 저장됨

    ; 3. Table-Driven Selection (테이블 조회 실행)
    mov esi, OFFSET CaseTable
    mov ecx, NumberOfEntries

LookupLoop:
    cmp al, [esi]            ; 입력한 문자와 테이블의 메뉴 항목 비교
    jne NextEntry            ; 다르면 다음 엔트리로 이동

    ; 일치하는 항목을 찾은 경우: 해당 프로시저 간접 호출
    call DWORD PTR [esi + 1] ; [esi + 1]의 4바이트 프로시저 주소 호출

    ; '5'(Exit)를 눌렀으면 프로그램 종료
    cmp al, '5'
    je  EndProgram
    
    jmp MenuLoop             ; 연산 수행 후 다시 메뉴로 이동

NextEntry:
    add esi, EntrySize       ; 다음 테이블 엔트리로 이동 (5바이트)
    loop LookupLoop

    ; 테이블에 없는 입력인 경우 오류 메시지 출력
    mov esi, OFFSET invalidMsg
    call PrintString
    jmp MenuLoop

EndProgram:
    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; 연산 수행 알림 프로시저들 (각각의 메뉴에 매핑됨)
; ====================================================
ProcessAND PROC
    pushad
    mov esi, OFFSET msgAND
    call PrintString
    popad
    ret
ProcessAND ENDP

ProcessOR PROC
    pushad
    mov esi, OFFSET msgOR
    call PrintString
    popad
    ret
ProcessOR ENDP

ProcessNOT PROC
    pushad
    mov esi, OFFSET msgNOT
    call PrintString
    popad
    ret
ProcessNOT ENDP

ProcessXOR PROC
    pushad
    mov esi, OFFSET msgXOR
    call PrintString
    popad
    ret
ProcessXOR ENDP

ProcessExit PROC
    pushad
    mov esi, OFFSET msgExit
    call PrintString
    popad
    ret
ProcessExit ENDP


; ====================================================
; ReadCharCustom PROC
; [설명] 사용자로부터 문자 하나를 입력받아 AL에 반환
; ====================================================
ReadCharCustom PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    INVOKE ReadConsoleA, hStdIn, ADDR inputBuf, 16, ADDR bytesRead, 0
    mov al, byte ptr [inputBuf]     ; 첫 번째 문자를 AL에 대입

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