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

; 각 자릿수별 최소/최대 허용 범위 배열 (1~5번째 자리)
minRange          BYTE 5, 2, 4, 1, 3
maxRange          BYTE 9, 5, 8, 4, 6

; 테스트용 5자리 PIN 배열들 (바이트 배열 형태)
pin1              BYTE 5, 2, 4, 1, 3   ; Valid (모두 정상)
pin2              BYTE 4, 3, 5, 3, 4   ; Invalid (1번째 자리가 4 < 5)
pin3              BYTE 6, 4, 5, 3, 5   ; Invalid (5번째 자리가 5까지여야 하나 5? 아니 문제에선 5번째 자리가 3~6이므로 정상 범위지만, 예를들어 7 등)
                                       ; 문제 예시: 64535 -> 5번째 자리가 범위 3~6 내이지만, 문제 지문의 64535의 마지막 자리가 5일 때
                                       ; 만약 지문 64535가 Invalid라면 지문의 표나 예시에 약간 오류가 있을 수 있으나
                                       ; 명확한 테스트를 위해 범위를 벗어난 값을 배치합니다.
pin3_fixed        BYTE 6, 4, 5, 3, 8   ; Invalid (5번째 자리가 8 > 6)
pin4              BYTE 7, 1, 6, 2, 4   ; Invalid (2번째 자리가 1 < 2)

; 출력용 메시지
msgPin            BYTE "PIN Validation Test: ", 0
msgValid          BYTE " -> Valid PIN (EAX = 0)", 13, 10, 0
msgInvalid        BYTE " -> Invalid PIN at Digit Position: ", 0
newline           BYTE 13, 10, 0

.code
main PROC
    ; 콘솔 출력 핸들 가져오기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; ----------------------------------------------------
    ; Test 1: pin1 (5, 2, 4, 1, 3) -> 예상: Valid (0)
    ; ----------------------------------------------------
    mov esi, OFFSET pin1
    call RunTest

    ; ----------------------------------------------------
    ; Test 2: pin2 (4, 3, 5, 3, 4) -> 예상: Invalid at Position 1
    ; ----------------------------------------------------
    mov esi, OFFSET pin2
    call RunTest

    ; ----------------------------------------------------
    ; Test 3: pin3_fixed (6, 4, 5, 3, 8) -> 예상: Invalid at Position 5
    ; ----------------------------------------------------
    mov esi, OFFSET pin3_fixed
    call RunTest

    ; ----------------------------------------------------
    ; Test 4: pin4 (7, 1, 6, 2, 4) -> 예상: Invalid at Position 2
    ; ----------------------------------------------------
    mov esi, OFFSET pin4
    call RunTest

    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; Validate_PIN PROC
; [설명] 5자리 PIN 번호의 각 자릿수가 허용 범위 내에 있는지 검사
; 
; [입력 파라미터]
;   ESI : 5바이트 PIN 배열의 시작 포인터
;
; [리턴값]
;   EAX : 모두 유효하면 0, 유효하지 않으면 잘못된 자릿수 위치(1~5)
;
; [특징]
;   EAX를 제외한 모든 레지스터(EBX, ECX, EDX, ESI, EDI) 보존
; ====================================================
Validate_PIN PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov ecx, 5              ; 5자리 검사
    mov edi, 0              ; 배열 인덱스 (0 ~ 4)

ValidateLoop:
    mov al, [esi + edi]     ; 현재 PIN 자릿수 가져오기

    ; 최소값 비교 (al < minRange[edi])
    mov bl, [minRange + edi]
    cmp al, bl
    jb  InvalidDigit        ; Unsigned Less 인 경우 범위를 벗어남

    ; 최대값 비교 (al > maxRange[edi])
    mov bh, [maxRange + edi]
    cmp al, bh
    ja  InvalidDigit        ; Unsigned Greater 인 경우 범위를 벗어남

    inc edi
    loop ValidateLoop

    ; 모든 자릿수가 유효한 경우
    mov eax, 0
    jmp ValidationDone

InvalidDigit:
    ; 범위를 벗어난 위치 반환 (인덱스 edi는 0~4이므로 +1 하여 1~5로 변환)
    mov eax, edi
    inc eax

ValidationDone:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
Validate_PIN ENDP


; ====================================================
; RunTest PROC (테스트 실행 및 결과 출력 보조 프로시저)
; ====================================================
RunTest PROC
    pushad

    ; PIN 배열을 Validate_PIN에 전달 (ESI에 이미 주소가 들어있음)
    call Validate_PIN       ; EAX에 결과값 리턴

    push eax                ; 리턴된 EAX 저장

    ; PIN 숫자들 출력
    mov esi, OFFSET msgPin
    call PrintString

    pop eax
    push eax                ; EAX 보존하며 결과 판별
    
    cmp eax, 0
    jne PrintError

    ; Valid 출력
    mov esi, OFFSET msgValid
    call PrintString
    jmp TestDone

PrintError:
    ; Invalid 및 위치 번호 출력
    mov esi, OFFSET msgInvalid
    call PrintString
    call WriteIntCustom
    mov esi, OFFSET newline
    call PrintString

TestDone:
    pop eax
    popad
    ret
RunTest ENDP


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