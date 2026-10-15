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

ARRAY_SIZE        EQU 10
myArray           SDWORD ARRAY_SIZE DUP(?)  ; 부호 있는 32비트 정수 배열

seed              DWORD 12345               ; 난수 생성용 시드값
buffer            BYTE 16 DUP(0)            ; 정수 -> 문자열 변환 버퍼
newline           BYTE 13, 10               ; 줄바꿈 (\r\n)
space             BYTE ' '

.code
main PROC
    ; 콘솔 출력 핸들 가져오기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 난수 시드 초기화 (현재 시스템 시간 이용)
    INVOKE GetTickCount
    mov seed, eax

    ; ----------------------------------------------------
    ; [첫 번째 호출] j = 10, k = 50 범위의 난수 10개로 채우기
    ; ----------------------------------------------------
    mov esi, OFFSET myArray   ; 배열 포인터 (주소)
    mov ecx, ARRAY_SIZE       ; 요소 개수 N
    mov ebx, 10               ; 하한값 j
    mov edx, 50               ; 상한값 k

    call FillArray

    ; 첫 번째 결과 콘솔 출력
    mov esi, OFFSET myArray
    mov ecx, ARRAY_SIZE
    call PrintArray

    ; ----------------------------------------------------
    ; [두 번째 호출] j = -20, k = 20 범위의 난수 10개로 채우기
    ; ----------------------------------------------------
    mov esi, OFFSET myArray   ; 배열 포인터 (주소)
    mov ecx, ARRAY_SIZE       ; 요소 개수 N
    mov ebx, -20              ; 하한값 j
    mov edx, 20               ; 상한값 k

    call FillArray

    ; 두 번째 결과 콘솔 출력
    mov esi, OFFSET myArray
    mov ecx, ARRAY_SIZE
    call PrintArray

    INVOKE ExitProcess, 0
main ENDP


; ====================================================
; FillArray PROC
; [설명] j...k 범위(포함) 내의 난수를 생성하여 DWORD 배열을 채움
; 
; [입력 파라미터]
;   ESI : 배열 오프셋 (포인터)
;   ECX : 요소 개수 (N)
;   EBX : 하한값 (j)
;   EDX : 상한값 (k)
;
; [특징]
;   pushad / popad를 통해 모든 레지스터 값을 완전 보존
; ====================================================
FillArray PROC
    pushad                  ; 모든 레지스터 상태 보존

    ; 범위 크기 계산: R = (k - j) + 1
    mov eax, edx
    sub eax, ebx
    inc eax                 ; EAX = R (범위 크기)
    mov edi, eax            ; EDI = R

FillLoop:
    ; --- [자체 난수 생성 (LCG 알고리즘)] ---
    mov eax, seed
    imul eax, eax, 1103515245
    add eax, 12345
    mov seed, eax           ; 다음 난수를 위해 seed 업데이트

    ; EAX의 상위 비트 추출 및 양수화
    shr eax, 16
    and eax, 07FFFh

    ; 범위 [0 ~ R-1] 조정: EAX % R (EDI)
    xor edx, edx
    div edi                 ; EDX = EAX % EDI (나머지)

    ; 범위 [j ~ k] 로 평행이동: 나머지 + j
    add edx, ebx            ; EDX = (EAX % R) + j

    mov [esi], edx          ; 배열 요소에 값 저장
    add esi, 4              ; DWORD (4바이트) 다음 위치로 이동
    loop FillLoop

    popad                   ; 저장했던 모든 레지스터 값 복원
    ret
FillArray ENDP


; ====================================================
; PrintArray PROC (화면 출력용 보조 프로시저)
; ====================================================
PrintArray PROC
    pushad

PrintLoop:
    mov eax, [esi]
    call WriteIntCustom     ; EAX 정수값을 화면에 출력
    
    ; 공백(' ') 출력
    INVOKE WriteConsoleA, hStdOut, ADDR space, 1, ADDR bytesWritten, 0

    add esi, 4
    loop PrintLoop

    ; 줄바꿈(\r\n) 출력
    INVOKE WriteConsoleA, hStdOut, ADDR newline, 2, ADDR bytesWritten, 0

    popad
    ret
PrintArray ENDP


; ====================================================
; WriteIntCustom PROC
; EAX에 들어있는 부호 있는 32비트 정수를 아스키 문자열로 바꿔 콘솔 출력
; ====================================================
WriteIntCustom PROC
    pushad

    mov edi, OFFSET buffer
    mov ecx, 0              ; 자릿수 카운터

    ; 음수 판별
    cmp eax, 0
    jge Positive
    
    ; 음수인 경우 '-' 문자 먼저 출력 후 양수로 전환
    push eax
    mov byte ptr [edi], '-'
    INVOKE WriteConsoleA, hStdOut, edi, 1, ADDR bytesWritten, 0
    pop eax
    neg eax                 ; EAX = -EAX (절대값)

Positive:
    mov ebx, 10

ConvertLoop:
    xor edx, edx
    div ebx                 ; EAX / 10 -> quotient: EAX, remainder: EDX
    add dl, '0'             ; 나머지를 아스키 문자로 변환
    push edx                ; 스택에 저장 (역순 출력을 위함)
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