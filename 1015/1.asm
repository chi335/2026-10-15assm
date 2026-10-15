; =======================================================
; Visual Studio MASM x86 Assembly Template
; =======================================================
.386
.model flat, stdcall
.stack 4096

; 종료 처리를 위해 Windows API 선언 (필요시 사용)
ExitProcess PROTO, dwExitCode:DWORD

.data
    ; 필요한 변수나 문자열을 선언하는 공간입니다.
    msg     db "Hello, Assembly Interrupt/System Call!", 0

.code
main PROC
    ; --- 실행할 어셈블리 코드를 작성하는 공간 (.code 블록 안쪽) ---

    mov eax, 10         ; 예시 연산
    add eax, 20

    ; 프로그램 안전 종료 (Windows API ExitProcess 호출)
    INVOKE ExitProcess, 0

main ENDP
END main                ; 파일의 가장 마지막 줄 (프로그램의 진입점 지정)