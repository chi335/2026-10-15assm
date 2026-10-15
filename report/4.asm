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

gradeAverage      DWORD ?
credits           DWORD ?

inputBuffer       BYTE 16 DUP(0)

; 안내 및 결과 메시지
promptGrade       BYTE "Enter grade average (0-400): ", 0
promptCredits     BYTE "Enter credits (1-30): ", 0

errMsgCredits     BYTE "Error: Credits must be between 1 and 30.", 13, 10, 0
msgCanRegister    BYTE "The student can register.", 13, 10, 0
msgCannotRegister BYTE "The student cannot register.", 13, 10, 0

.code
main PROC
    ; 콘솔 입출력 핸들 가져오기
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov hStdIn, eax
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; ----------------------------------------------------
    ; 1. 사용자로부터 평균 성적(Grade Average) 입력받기
    ; ----------------------------------------------------
    mov esi, OFFSET promptGrade
    call PrintString
    call ReadIntCustom
    mov gradeAverage, eax

    ; ----------------------------------------------------
    ; 2. 사용자로부터 신청 학점(Credits) 입력받기
    ; ----------------------------------------------------
    mov esi, OFFSET promptCredits
    call PrintString
    call ReadIntCustom
    mov credits, eax

    ; ----------------------------------------------------
    ; 3. Credits 범위 검증 (1 ~ 30 사이여야 함)
    ; ----------------------------------------------------
    cmp credits, 1
    jl  InvalidCredits      ; credits < 1 이면 에러

    cmp credits, 30
    jg  InvalidCredits      ; credits > 30 이면 에러

    ; ----------------------------------------------------
    ; 4. 수강 신청 자격 평가 (.IF / .ELSEIF 없이 CMP와 JUMP로만 작성)
    ;
    ; 수강 신청 가능 조건:
    ;   - GradeAverage > 350
    ;   - OR Credits <= 12
    ;   - OR (GradeAverage > 250 AND Credits <= 16)
    ; ----------------------------------------------------
    
    ; 조건 1: gradeAverage > 350 인가?
    cmp gradeAverage, 350
    jg  CanRegister

    ; 조건 2: credits <= 12 인가?
    cmp credits, 12
    jle CanRegister

    ; 조건 3: gradeAverage > 250 이면서 credits <= 16 인가?
    cmp gradeAverage, 250
    jle CannotRegister      ; gradeAverage <= 250 이면 탈락

    cmp credits, 16
    jle CanRegister         ; credits <= 16 이면 등록 가능

    ; 위 조건에 모두 해당하지 않으면 등록 불가
    jmp CannotRegister

; --- 평가 결과 출력 부분 ---
CanRegister:
    mov esi, OFFSET msgCanRegister
    call PrintString
    jmp QuitProgram

CannotRegister:
    mov esi, OFFSET msgCannotRegister
    call PrintString
    jmp QuitProgram

InvalidCredits:
    mov esi, OFFSET errMsgCredits
    call PrintString

QuitProgram:
    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; ReadIntCustom PROC
; [설명] 콘솔 키보드로 입력받은 문자열 숫자를 정수로 변환하여 EAX에 반환
; ====================================================
ReadIntCustom PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    INVOKE ReadConsoleA, hStdIn, ADDR inputBuffer, 16, ADDR bytesRead, 0

    mov esi, OFFSET inputBuffer
    xor eax, eax            ; EAX = 변환할 정수값 (0으로 초기화)
    xor ebx, ebx

ParseLoop:
    mov bl, byte ptr [esi]
    
    ; 줄바꿈(\r, \n)이나 문자열 끝을 만나면 종료
    cmp bl, 13
    je  ParseDone
    cmp bl, 10
    je  ParseDone
    cmp bl, 0
    je  ParseDone

    ; '0' ~ '9' 사이의 숫자인지 확인
    cmp bl, '0'
    jl  ParseDone
    cmp bl, '9'
    jg  ParseDone

    ; 아스키 문자를 숫자 값으로 변환: EAX = (EAX * 10) + (bl - '0')
    sub bl, '0'
    imul eax, 10
    add eax, ebx

    inc esi
    jmp ParseLoop

ParseDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
ReadIntCustom ENDP


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