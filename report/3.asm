.386
.model flat, stdcall
option casemap:none

; ----------------------------------------------------
; Windows API 함수 선언 (Visual Studio 기본 제공)
; ----------------------------------------------------
GetStdHandle      PROTO STDCALL :DWORD
WriteConsoleA     PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
GetTickCount      PROTO STDCALL
ExitProcess       PROTO STDCALL :DWORD

INCLUDELIB kernel32.lib

.data
STD_OUTPUT_HANDLE EQU -11
hStdOut           DWORD ?
bytesWritten      DWORD ?

seed              DWORD 12345
buffer            BYTE 16 DUP(0)

msgScore          BYTE "Score: ", 0
msgGrade          BYTE " -> Grade: ", 0
newline           BYTE 13, 10

.code
main PROC
    ; 콘솔 출력 핸들 가져오기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 난수 생성용 시드 초기화 (시스템 시각 이용)
    INVOKE GetTickCount
    mov seed, eax

    mov ecx, 10             ; 10개 점수 생성 반복문

TestLoop:
    push ecx                ; 루프 카운터 보존

    ; ----------------------------------------------------
    ; 50 ~ 100 범위의 난수 생성 (j = 50, k = 100)
    ; ----------------------------------------------------
    mov ebx, 50             ; 하한값 j
    mov edx, 100            ; 상한값 k
    call GenerateRandomVal  ; 생성된 점수는 EAX에 반환됨

    push eax                ; 생성된 점수 스택에 임시 보존

    ; 1. "Score: [점수]" 출력
    mov esi, OFFSET msgScore
    call PrintString
    mov eax, [esp]          ; 스택에서 점수 복사
    call WriteIntCustom

    ; 2. " -> Grade: " 출력
    mov esi, OFFSET msgGrade
    call PrintString

    ; 3. CalcGrade 프로시저 호출
    pop eax                 ; EAX = 점수
    call CalcGrade          ; AL 레지스터에 'A' ~ 'F' 학점 반환

    ; 4. 학점 문자 출력 (AL에 저장된 아스키 문자를 화면에 출력)
    mov buffer, al
    INVOKE WriteConsoleA, hStdOut, ADDR buffer, 1, ADDR bytesWritten, 0

    ; 5. 줄바꿈
    mov esi, OFFSET newline
    call PrintString

    pop ecx                 ; 루프 카운터 복원
    loop TestLoop

    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; CalcGrade PROC
; [설명] 0 ~ 100 사이의 점수를 받아 알파벳 학점 문자 반환
; 
; [입력 파라미터]
;   EAX : 점수 (0 ~ 100)
;
; [리턴값]
;   AL  : 학점 문자 ('A', 'B', 'C', 'D', 'F')
;
; [범위 기준]
;   90 ~ 100 : 'A'
;   80 ~ 89  : 'B'
;   70 ~ 79  : 'C'
;   60 ~ 69  : 'D'
;    0 ~ 59  : 'F'
;
; [특징]
;   AL(리턴값)을 제외한 모든 레지스터 보존
; ====================================================
CalcGrade PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    cmp eax, 90
    jge GradeA
    cmp eax, 80
    jge GradeB
    cmp eax, 70
    jge GradeC
    cmp eax, 60
    jge GradeD

    ; 60점 미만은 F
    mov al, 'F'
    jmp GradeDone

GradeA:
    mov al, 'A'
    jmp GradeDone
GradeB:
    mov al, 'B'
    jmp GradeDone
GradeC:
    mov al, 'C'
    jmp GradeDone
GradeD:
    mov al, 'D'

GradeDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
CalcGrade ENDP


; ====================================================
; GenerateRandomVal PROC
; [설명] EBX(하한) ~ EDX(상한) 범위의 난수를 생성하여 EAX에 반환
; ====================================================
GenerateRandomVal PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; 범위 크기 계산: R = (k - j) + 1
    mov eax, edx
    sub eax, ebx
    inc eax
    mov edi, eax            ; EDI = R (51)

    ; 난수 계산 (LCG 알고리즘)
    mov eax, seed
    imul eax, eax, 1103515245
    add eax, 12345
    mov seed, eax

    shr eax, 16
    and eax, 07FFFh

    xor edx, edx
    div edi                 ; EDX = EAX % R

    add edx, ebx            ; EDX = (EAX % R) + j
    mov eax, edx            ; EAX에 결과 담기

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
GenerateRandomVal ENDP


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


; ====================================================
; WriteIntCustom PROC (정수 출력 보조 프로시저)
; ====================================================
WriteIntCustom PROC
    pushad
    mov edi, OFFSET buffer

    cmp eax, 0
    jge Positive

    push eax
    mov byte ptr [edi], '-'
    INVOKE WriteConsoleA, hStdOut, edi, 1, ADDR bytesWritten, 0
    pop eax
    neg eax

Positive:
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

END main