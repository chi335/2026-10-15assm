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

ARRAY_SIZE        EQU 10
; 테스트용 부호 있는 32비트 정수 배열 (음수, 0, 양수 포함)
myArray           SDWORD -10, 20, 5, -5, 15, 30, 0, 50, -25, 8

msg1              BYTE "Test 1 Sum (range 0..20): ", 0
msg2              BYTE "Test 2 Sum (range -20..10): ", 0
newline           BYTE 13, 10
buffer            BYTE 16 DUP(0)

.code
main PROC
    ; 콘솔 출력 핸들 가져오기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; ----------------------------------------------------
    ; [첫 번째 테스트] 범위: 0 ~ 20 (j = 0, k = 20)
    ; 해당 요소: 20, 5, 15, 0, 8 -> 예상 합계 = 48
    ; ----------------------------------------------------
    mov esi, OFFSET msg1
    call PrintString

    mov esi, OFFSET myArray   ; 배열 주소 (포인터)
    mov ecx, ARRAY_SIZE       ; 배열 크기 N
    mov ebx, 0                ; 하한값 j
    mov edx, 20               ; 상한값 k

    call SumRange             ; 결과는 EAX에 반환됨

    call WriteIntCustom       ; EAX 출력
    mov esi, OFFSET newline
    call PrintString

    ; ----------------------------------------------------
    ; [두 번째 테스트] 범위: -20 ~ 10 (j = -20, k = 10)
    ; 해당 요소: -10, 5, -5, 0, 8 -> 예상 합계 = -2
    ; ----------------------------------------------------
    mov esi, OFFSET msg2
    call PrintString

    mov esi, OFFSET myArray   ; 배열 주소 (포인터)
    mov ecx, ARRAY_SIZE       ; 배열 크기 N
    mov ebx, -20              ; 하한값 j
    mov edx, 10               ; 상한값 k

    call SumRange             ; 결과는 EAX에 반환됨

    call WriteIntCustom       ; EAX 출력
    mov esi, OFFSET newline
    call PrintString

    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; SumRange PROC
; [설명] j...k 범위 내의 배열 요소들의 합을 계산하여 반환
; 
; [입력 파라미터]
;   ESI : 배열 오프셋 (포인터)
;   ECX : 배열 크기 (N)
;   EBX : 하한값 (j)
;   EDX : 상한값 (k)
;
; [리턴값]
;   EAX : 범위 내 요소들의 총합
;
; [특징]
;   EAX(결과값)를 제외한 모든 레지스터(EBX, ECX, EDX, ESI, EDI) 보존
; ====================================================
SumRange PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    xor edi, edi            ; EDI = 누적 합계 (0으로 초기화)

SumLoop:
    mov eax, [esi]          ; 배열의 현재 요소 읽어오기

    ; [esi] >= j (EBX) 이고 [esi] <= k (EDX) 인지 부호 있는 비교(Signed Compare)
    cmp eax, ebx
    jl SkipElement          ; eax < j 이면 누적에서 제외 (jl: signed less)

    cmp eax, edx
    jg SkipElement          ; eax > k 이면 누적에서 제외 (jg: signed greater)

    add edi, eax            ; 범위 내에 있으면 누적합에 더함

SkipElement:
    add esi, 4              ; DWORD(4바이트) 다음 요소 위치로 이동
    loop SumLoop

    mov eax, edi            ; 최종 계산 결과(합계)를 EAX에 복사

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
SumRange ENDP


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
; EAX: 출력할 32비트 부호 있는 정수
; ====================================================
WriteIntCustom PROC
    pushad
    mov edi, OFFSET buffer

    cmp eax, 0
    jge Positive

    ; 음수인 경우 '-' 문자 출력 후 절대값으로 변경
    push eax
    mov byte ptr [edi], '-'
    INVOKE WriteConsoleA, hStdOut, edi, 1, ADDR bytesWritten, 0
    pop eax
    neg eax                 ; EAX = -EAX

Positive:
    mov ebx, 10
    xor ecx, ecx

ConvertLoop:
    xor edx, edx
    div ebx                 ; EAX / 10
    add dl, '0'
    push edx                ; 자릿수를 스택에 저장
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