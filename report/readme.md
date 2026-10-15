# 어셈블리어 문제 풀이 (Assembly Question)

### 1.문제 (Question)
> **What will be the value of BX after the following instructions execute?**
> ```assembly
> mov bx, 0FFFFh
> and bx, 6Bh
> ```
> *(해석: 다음 명령어들이 실행된 후 BX 레지스터의 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov bx, 0FFFFh`**
   - `BX` 레지스터에 16진수 `0FFFFh`를 저장합니다.
   - 16비트 2진수로 변환: `1111 1111 1111 1111_2`

2. **`and bx, 6Bh`**
   - `BX` 레지스터의 기존 값과 16진수 `6Bh`(16비트 표기 시 `006Bh`)를 **비트 단위 AND 연산**합니다.
   - `6Bh`를 16비트 2진수로 변환: `0000 0000 0110 1011_2`

3. **비트 연산 과정 (Bitwise AND Operation)**
   - `AND` 연산은 대응되는 두 비트가 **모두 1일 때만 1**이 되고, 하나라도 0이면 0이 됩니다.
   - 어떤 값과 모든 비트가 1인 `0FFFFh`를 `AND` 연산하면 자기 자신의 값이 그대로 유지됩니다 ($X \text{ AND } 1 = X$).

$$
\begin{array}{rcc}
\text{BX (0FFFFh)} & : & 1111\ 1111\ 1111\ 1111_2 \\
\text{AND (006Bh)} & : & 0000\ 0000\ 0110\ 1011_2 \\
\hline
\text{결과 (006Bh)} & : & 0000\ 0000\ 0110\ 1011_2
\end{array}
$$

---

### 정답 (Answer)

**`006Bh`** (또는 **`6Bh`**)

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 2.문제 (Question)
> **What will be the value of BX after the following instructions execute?**
> ```assembly
> mov bx, 91BAh
> and bx, 92h
> ```
> *(해석: 다음 명령어들이 실행된 후 BX 레지스터의 값은 무엇이 듭니까?)*

---

### 풀이 (Solution)

1. **`mov bx, 91BAh`**
   - `BX` 레지스터에 16진수 `91BAh`를 저장합니다.
   - 16비트 2진수로 변환:
     - `9` = `1001`, `1` = `0001`, `B` = `1011`, `A` = `1010`
     - `1001 0001 1011 1010_2`

2. **`and bx, 92h`**
   - `BX` 레지스터의 값과 `92h`(16비트로 표현 시 `0092h`)를 **비트 단위 AND 연산**합니다.
   - 16비트 2진수로 변환:
     - `0` = `0000`, `0` = `0000`, `9` = `1001`, `2` = `0010`
     - `0000 0000 1001 0010_2`

3. **비트 연산 과정 (Bitwise AND Operation)**
   - 두 비트가 모두 `1`일 때만 결과가 `1`이 됩니다.

$$
\begin{array}{rcc}
\text{BX (91BAh)} & : & 1001\ 0001\ 1011\ 1010_2 \\
\text{AND (0092h)} & : & 0000\ 0000\ 1001\ 0010_2 \\
\hline
\text{결과 (0092h)} & : & 0000\ 0000\ 1001\ 0010_2
\end{array}
$$

   - **상위 8비트 연산:** $91_h \text{ AND } 00_h = 00_h$
   - **하위 8비트 연산:** $BA_h \text{ AND } 92_h = 92_h$
     - $B(1011_2) \text{ AND } 9(1001_2) = 9(1001_2)$
     - $A(1010_2) \text{ AND } 2(0010_2) = 2(0010_2)$

---

### 정답 (Answer)

**`0092h`** (또는 **`92h`**)

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 3.문제 (Question)
> **What will be the value of BX after the following instructions execute?**
> ```assembly
> mov bx, 0649Bh
> or  bx, 3Ah
> ```
> *(해석: 다음 명령어들이 실행된 후 BX 레지스터의 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov bx, 0649Bh`**
   - `BX` 레지스터에 16진수 `0649Bh` (또는 `649Bh`)를 저장합니다.
   - 16비트 2진수로 변환:
     - `6` = `0110`, `4` = `0100`, `9` = `1001`, `B` = `1011`
     - `0110 0100 1001 1011_2`

2. **`or bx, 3Ah`**
   - `BX` 레지스터의 값과 16진수 `3Ah`(16비트로 표현 시 `003Ah`)를 **비트 단위 OR 연산**합니다.
   - 16비트 2진수로 변환:
     - `0` = `0000`, `0` = `0000`, `3` = `0011`, `A` = `1010`
     - `0000 0000 0011 1010_2`

3. **비트 연산 과정 (Bitwise OR Operation)**
   - `OR` 연산은 대응되는 두 비트 중 **하나라도 1이면 1**이 되고, 둘 다 0일 때만 0이 됩니다.

$$
\begin{array}{rcc}
\text{BX (649Bh)} & : & 0110\ 0100\ 1001\ 1011_2 \\
\text{OR (003Ah)} & : & 0000\ 0000\ 0011\ 1010_2 \\
\hline
\text{결과 (64BBh)} & : & 0110\ 0100\ 1011\ 1011_2
\end{array}
$$

   - **상위 8비트 연산:** $64_h \text{ OR } 00_h = 64_h$ (어떤 값과 0을 OR 연산하면 자기 자신이 유지됨)
   - **하위 8비트 연산:** $9B_h \text{ OR } 3A_h = BB_h$
     - $9(1001_2) \text{ OR } 3(0011_2) = B(1011_2)$
     - $B(1011_2) \text{ OR } A(1010_2) = B(1011_2)$

---

### 정답 (Answer)

**`64BBh`** (또는 **`064BBh`**)

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 4.문제 (Question)
> **What will be the value of BX after the following instructions execute?**
> ```assembly
> mov bx, 029D6h
> xor bx, 8181h
> ```
> *(해석: 다음 명령어들이 실행된 후 BX 레지스터의 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov bx, 029D6h`**
   - `BX` 레지스터에 16진수 `029D6h` (또는 `29D6h`)를 저장합니다.
   - 16비트 2진수로 변환:
     - `2` = `0010`, `9` = `1001`, `D` = `1101`, `6` = `0110`
     - `0010 1001 1101 0110_2`

2. **`xor bx, 8181h`**
   - `BX` 레지스터의 값과 16진수 `8181h`를 **비트 단위 XOR 연산**합니다.
   - 16비트 2진수로 변환:
     - `8` = `1000`, `1` = `0001`, `8` = `1000`, `1` = `0001`
     - `1000 0001 1000 0001_2`

3. **비트 연산 과정 (Bitwise XOR Operation)**
   - `XOR` (배타적 논리합) 연산은 대응되는 두 비트가 **서로 다르면 1**, **같으면 0**이 됩니다.

$$
\begin{array}{rcc}
\text{BX (29D6h)} & : & 0010\ 1001\ 1101\ 0110_2 \\
\text{XOR (8181h)} & : & 1000\ 0001\ 1000\ 0001_2 \\
\hline
\text{결과 (A857h)} & : & 1010\ 1000\ 0101\ 0111_2
\end{array}
$$

   - **각 자릿수별 XOR 연산 상세:**
     - $2(0010_2) \text{ XOR } 8(1000_2) = A(1010_2)$
     - $9(1001_2) \text{ XOR } 1(0001_2) = 8(1000_2)$
     - $D(1101_2) \text{ XOR } 8(1000_2) = 5(0101_2)$
     - $6(0110_2) \text{ XOR } 1(0001_2) = 7(0111_2)$

---

### 정답 (Answer)

**`A857h`** (또는 **`0A857h`**)

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 5.문제 (Question)
> **What will be the value of EBX after the following instructions execute?**
> ```assembly
> mov ebx, 0AFAF649Bh
> or  ebx, 3A219604h
> ```
> *(해석: 다음 명령어들이 실행된 후 EBX 레지스터의 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov ebx, 0AFAF649Bh`**
   - 32비트 `EBX` 레지스터에 16진수 `0AFAF649Bh`를 저장합니다.
   - 2진수로 변환:
     - `1010 1111 1010 1111 0110 0100 1001 1011_2`

2. **`or ebx, 3A219604h`**
   - `EBX` 레지스터의 값과 16진수 `3A219604h`를 **비트 단위 OR 연산**합니다.
   - 2진수로 변환:
     - `0011 1010 0010 0001 1001 0110 0000 0100_2`

3. **비트 연산 과정 (Bitwise OR Operation)**
   - `OR` 연산은 대응되는 두 비트 중 **하나라도 1이면 1**이 되며, 둘 다 0일 때만 0이 됩니다.

$$
\begin{array}{rcc}
\text{EBX (AFAF649Bh)} & : & 1010\ 1111\ 1010\ 1111\ 0110\ 0100\ 1001\ 1011_2 \\
\text{OR (3A219604h)} & : & 0011\ 1010\ 0010\ 0001\ 1001\ 0110\ 0000\ 0100_2 \\
\hline
\text{결과 (BFAFF69Fh)} & : & 1011\ 1111\ 1010\ 1111\ 1111\ 0110\ 1001\ 1111_2
\end{array}
$$

   - **16진수 자릿수별 OR 연산 상세:**
     - `A (1010)` $\text{OR}$ `3 (0011)` = **`B (1011)`**
     - `F (1111)` $\text{OR}$ `A (1010)` = **`F (1111)`**
     - `A (1010)` $\text{OR}$ `2 (0010)` = **`A (1010)`**
     - `F (1111)` $\text{OR}$ `1 (0001)` = **`F (1111)`**
     - `6 (0110)` $\text{OR}$ `9 (1001)` = **`F (1111)`**
     - `4 (0100)` $\text{OR}$ `6 (0110)` = **`6 (0110)`**
     - `9 (1001)` $\text{OR}$ `0 (0000)` = **`9 (1001)`**
     - `B (1011)` $\text{OR}$ `4 (0100)` = **`F (1111)`**

---

### 정답 (Answer)

**`BFAFF69Fh`** (또는 **`0BFAFF69Fh`**)

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 6.문제 (Question)
> **What will be the value of RBX after the following instructions execute?**
> ```assembly
> mov rbx, 0AFAF649Bh
> xor rbx, 0FFFFFFFFh
> ```
> *(해석: 다음 명령어들이 실행된 후 RBX 레지스터의 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov rbx, 0AFAF649Bh`**
   - 64비트 `RBX` 레지스터에 16진수 `0AFAF649Bh`를 저장합니다.
   - 64비트 표현 시 상위 32비트는 `0`으로 채워집니다: `00000000AFAF649Bh`

2. **`xor rbx, 0FFFFFFFFh`**
   - `RBX` 레지스터의 값과 `0FFFFFFFFh` (64비트 표기 시 `00000000FFFFFFFFh`)를 **비트 단위 XOR 연산**합니다.
   - **XOR의 주요 특징:** 어떤 값과 `1`을 XOR 연산하면 **비트 반전(NOT)** 효과가 발생합니다. ($X \text{ XOR } 1 = \text{NOT } X$)

3. **비트 연산 과정 (Bitwise XOR Operation)**
   - **상위 32비트 연산:** `00000000h` $\text{XOR}$ `00000000h` = `00000000h`
   - **하위 32비트 연산:** `AFAF649Bh` $\text{XOR}$ `FFFFFFFFh` = 비트 반전 (각 16진수를 `F`에서 뺀 값)

$$
\begin{array}{rcc}
\text{RBX (00000000AFAF649Bh)} & : & 0000\ 0000\ \dots\ 1010\ 1111\ 1010\ 1111\ 0110\ 0100\ 1001\ 1011_2 \\
\text{XOR (00000000FFFFFFFFh)} & : & 0000\ 0000\ \dots\ 1111\ 1111\ 1111\ 1111\ 1111\ 1111\ 1111\ 1111_2 \\
\hline
\text{결과 (0000000050509B64h)} & : & 0000\ 0000\ \dots\ 0101\ 0000\ 0101\ 0000\ 1001\ 1011\ 0110\ 0100_2
\end{array}
$$

   - **하위 32비트 자릿수별 반전 상세:**
     - `A (1010)` $\rightarrow$ **`5 (0101)`**
     - `F (1111)` $\rightarrow$ **`0 (0000)`**
     - `A (1010)` $\rightarrow$ **`5 (0101)`**
     - `F (1111)` $\rightarrow$ **`0 (0000)`**
     - `6 (0110)` $\rightarrow$ **`9 (1001)`**
     - `4 (0100)` $\rightarrow$ **`B (1011)`**
     - `9 (1001)` $\rightarrow$ **`6 (0110)`**
     - `B (1011)` $\rightarrow$ **`4 (0100)`**

---

### 정답 (Answer)

**`0000000050509B64h`** (또는 **`50509B64h`**)

---


# 어셈블리어 문제 풀이 (Assembly Question)

### 7.문제 (Question)
> **In the following instruction sequence, show the resulting value of AL where indicated, in binary:**
> ```assembly
> mov  al, 01101111b
> and  al, 00101101b    ; a.
> 
> mov  al, 6Dh
> and  al, 4Ah          ; b.
> 
> mov  al, 00001111b
> or   al, 61h          ; c.
> 
> mov  al, 94h
> xor  al, 37h          ; d.
> ```
> *(해석: 다음 명령어 수행 과정에서 지정된 위치(a, b, c, d)의 AL 레지스터 결과값을 2진수로 나타내시오.)*

---

### 풀이 (Solution)

#### **a. `mov al, 01101111b` 후 `and al, 00101101b`**
- 두 2진수의 비트 단위 **AND** 연산 (둘 다 1일 때만 1)

$$
\begin{array}{rcc}
\text{AL} & : & 0110\ 1111_2 \\
\text{AND} & : & 0010\ 1101_2 \\
\hline
\text{결과} & : & 0010\ 1101_2
\end{array}
$$

---

#### **b. `mov al, 6Dh` 후 `and al, 4Ah`**
- 16진수를 2진수로 변환 후 **AND** 연산
  - `6Dh` = `0110 1101_2`
  - `4Ah` = `0100 1010_2`

$$
\begin{array}{rcc}
\text{AL (6Dh)} & : & 0110\ 1101_2 \\
\text{AND (4Ah)} & : & 0100\ 1010_2 \\
\hline
\text{결과} & : & 0100\ 1000_2
\end{array}
$$

---

#### **c. `mov al, 00001111b` 후 `or al, 61h`**
- `61h`를 2진수로 변환(`0110 0001_2`) 후 비트 단위 **OR** 연산 (하나라도 1이면 1)

$$
\begin{array}{rcc}
\text{AL} & : & 0000\ 1111_2 \\
\text{OR (61h)} & : & 0110\ 0001_2 \\
\hline
\text{결과} & : & 0110\ 1111_2
\end{array}
$$

---

#### **d. `mov al, 94h` 후 `xor al, 37h`**
- 16진수를 2진수로 변환 후 **XOR** 연산 (서로 다르면 1, 같으면 0)
  - `94h` = `1001 0100_2`
  - `37h` = `0011 0111_2`

$$
\begin{array}{rcc}
\text{AL (94h)} & : & 1001\ 0100_2 \\
\text{XOR (37h)} & : & 0011\ 0111_2 \\
\hline
\text{결과} & : & 1010\ 0011_2
\end{array}
$$

---

### 정답 (Answer)

- **a.** `00101101b`
- **b.** `01001000b`
- **c.** `01101111b`
- **d.** `10100011b`

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 8.문제 (Question)
> **In the following instruction sequence, show the resulting value of AL where indicated, in hexadecimal:**
> ```assembly
> mov  al, 7Ah
> not  al               ; a.
> 
> mov  al, 3Dh
> and  al, 74h          ; b.
> 
> mov  al, 9Bh
> or   al, 35h          ; c.
> 
> mov  al, 72h
> xor  al, 0DCh         ; d.
> ```
> *(해석: 다음 명령어 수행 과정에서 지정된 위치(a, b, c, d)의 AL 레지스터 결과값을 16진수로 나타내시오.)*

---

### 풀이 (Solution)

#### **a. `mov al, 7Ah` 후 `not al`**
- `NOT` 연산은 모든 비트를 반전(0은 1로, 1은 0으로)시킵니다.
  - `7Ah` = `0111 1010_2`

$$
\begin{array}{rcc}
\text{AL (7Ah)} & : & 0111\ 1010_2 \\
\hline
\text{NOT 결과} & : & 1000\ 0101_2 \rightarrow \mathbf{85_h}
\end{array}
$$

---

#### **b. `mov al, 3Dh` 후 `and al, 74h`**
- 비트 단위 **AND** 연산 (둘 다 1일 때만 1)
  - `3Dh` = `0011 1101_2`
  - `74h` = `0111 0100_2`

$$
\begin{array}{rcc}
\text{AL (3Dh)} & : & 0011\ 1101_2 \\
\text{AND (74h)} & : & 0111\ 0100_2 \\
\hline
\text{결과} & : & 0011\ 0100_2 \rightarrow \mathbf{34_h}
\end{array}
$$

---

#### **c. `mov al, 9Bh` 후 `or al, 35h`**
- 비트 단위 **OR** 연산 (하나라도 1이면 1)
  - `9Bh` = `1001 1011_2`
  - `35h` = `0011 0101_2`

$$
\begin{array}{rcc}
\text{AL (9Bh)} & : & 1001\ 1011_2 \\
\text{OR (35h)} & : & 0011\ 0101_2 \\
\hline
\text{결과} & : & 1011\ 1111_2 \rightarrow \mathbf{BF_h}
\end{array}
$$

---

#### **d. `mov al, 72h` 후 `xor al, 0DCh`**
- 비트 단위 **XOR** 연산 (서로 다르면 1, 같으면 0)
  - `72h` = `0111 0010_2`
  - `0DCh` = `1101 1100_2`

$$
\begin{array}{rcc}
\text{AL (72h)} & : & 0111\ 0010_2 \\
\text{XOR (0DCh)} & : & 1101\ 1100_2 \\
\hline
\text{결과} & : & 1010\ 1110_2 \rightarrow \mathbf{AE_h}
\end{array}
$$

---

### 정답 (Answer)

- **a.** `85h`
- **b.** `34h`
- **c.** `BFh`
- **d.** `AEh`

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 9.문제 (Question)
> **In the following instruction sequence, show the values of the Carry, Zero, and Sign flags where indicated:**
> ```assembly
> mov  al, 00001111b
> test al, 00000010b    ; a. CF=   ZF=   SF=
> 
> mov  al, 00000110b
> cmp  al, 00000101b    ; b. CF=   ZF=   SF=
> 
> mov  al, 00000101b
> cmp  al, 00000111b    ; c. CF=   ZF=   SF=
> ```
> *(해석: 다음 명령어 수행 과정에서 지정된 위치(a, b, c)의 Carry, Zero, Sign 플래그 값을 나타내시오.)*

---

### 플래그 개념 정리

- **`CF` (Carry Flag)**: 뺄셈 시 빌림(Borrow)이 발생하거나, 연산 결과 범위를 넘어설 때 1이 됨. (`TEST` 명령어 수행 시 무조건 0으로 초기화됨)
- **`ZF` (Zero Flag)**: 연산 결과가 `0`이면 1, 아니면 0이 됨.
- **`SF` (Sign Flag)**: 연산 결과의 최상위 비트(MSB)가 1이면(음수) 1, 0이면(양수) 0이 됨.

---

### 풀이 (Solution)

#### **a. `mov al, 00001111b` 후 `test al, 00000010b`**
- `TEST` 명령어는 두 피연산자를 비트 단위 **AND** 연산하지만, 결과값을 저장하지 않고 **플래그만 변경**합니다.
  - 연산: `00001111b AND 00000010b` = `00000010b`
- **플래그 판단:**
  - **CF = 0** : `TEST` 명령어는 항상 Carry Flag를 `0`으로 설정합니다.
  - **ZF = 0** : 연산 결과가 `00000010b`로 0이 아니므로 `0`입니다.
  - **SF = 0** : 연산 결과의 최상위 비트(MSB)가 `0`이므로 `0`입니다.

---

#### **b. `mov al, 00000110b` 후 `cmp al, 00000101b`**
- `CMP` 명령어는 **`(첫 번째 피연산자) - (두 번째 피연산자)`** 뺄셈을 수행하여 플래그를 설정합니다 (결과값은 저장 안 함).
  - 연산: $6 - 5 = 1$ (`00000110b - 00000101b` = `00000001b`)
- **플래그 판단:**
  - **CF = 0** : $6 \ge 5$ 이므로 빌림(Borrow)이 발생하지 않아 `0`입니다.
  - **ZF = 0** : 결과가 `1`로 0이 아니므로 `0`입니다.
  - **SF = 0** : 결과가 양수(MSB가 `0`)이므로 `0`입니다.

---

#### **c. `mov al, 00000101b` 후 `cmp al, 00000111b`**
- 뺄셈 연산 수행:
  - 연산: $5 - 7 = -2$ (`00000101b - 00000111b` = `11111110b` [2의 보수])
- **플래그 판단:**
  - **CF = 1** : $5 < 7$ 이므로 작은 수에서 큰 수를 빼 빌림(Borrow)이 발생하여 `1`이 됩니다.
  - **ZF = 0** : 결과가 `-2`로 0이 아니므로 `0`입니다.
  - **SF = 1** : 결과가 음수(`11111110b`의 최상위 비트 MSB가 `1`)이므로 `1`이 됩니다.

---

### 정답 (Answer)

- **a.** `CF = 0`, `ZF = 0`, `SF = 0`
- **b.** `CF = 0`, `ZF = 0`, `SF = 0`
- **c.** `CF = 1`, `ZF = 0`, `SF = 1`

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 10.문제 (Question)
> **Which conditional jump instruction executes a branch based on the contents of ECX?**
> *(해석: ECX 레지스터의 내용을 바탕으로 조건 분기(점프)를 실행하는 명령어는 무엇입니까?)*

---

### 풀이 (Solution)

어셈블리어에서 **`ECX` 레지스터의 값이 0인지 확인하여 분기(Jump)**하는 조건문 명령어는 **`JECXZ`** (Jump if ECX is Zero)입니다.

1. **작동 방식:**
   - `ECX` 레지스터의 값이 **`0`이면** 지정된 라벨(Target Label)로 점프합니다.
   - `ECX` 레지스터의 값이 **`0`이 아니면** 점프하지 않고 다음 명령어를 계속 실행합니다.
   - 플래그(Flags) 레지스터 상태를 따로 확인하거나 변경하지 않고, 오직 `ECX` 레지스터 내부의 값만 직접 검사합니다.

2. **관련 레지스터별 명칭:**
   - **`JCXZ`** : **CX** 레지스터(16비트)의 값이 0일 때 점프
   - **`JECXZ`** : **ECX** 레지스터(32비트)의 값이 0일 때 점프
   - **`JRCXZ`** : **RCX** 레지스터(64비트)의 값이 0일 때 점프

---

### 정답 (Answer)

**`JECXZ`** (또는 `JECXZ` / `LOOP` 계열 명령어)

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 11.문제 (Question)
> **How are JA and JNBE affected by the Zero and Carry flags?**
> *(해석: JA와 JNBE 명령어는 Zero 플래그와 Carry 플래그에 의해 어떤 영향을 받습니까?)*

---

### 풀이 (Solution)

1. **명령어의 의미:**
   - **`JA`** (Jump if Above): 앞의 값이 뒤의 값보다 **크면** 점프 (부호 없는 수 비교)
   - **`JNBE`** (Jump if Not Below or Equal): 앞의 값이 뒤의 값보다 **이하가 아니면(즉, 크면)** 점프
   - 두 명령어는 동일한 기계어(Opcode)를 사용하는 **동의어(Synonyms)**입니다.

2. **플래그 영향 조건:**
   - `CMP A, B` (내부적으로 $A - B$ 수행) 명령어 이후:
     - $A < B$ 이면 **`CF = 1`** (빌림 발생, Below)
     - $A = B$ 이면 **`ZF = 1`** (결과가 0, Equal)
   - 따라서 $A > B$ (Above / 크다) 조건을 만족하려면 **Carry 플래그와 Zero 플래그가 모두 0**이어야 합니다.

3. **분기 실행 조건:**
   - **`CF = 0` AND `ZF = 0`** 일 때 점프를 실행합니다.

---

### 정답 (Answer)

**`CF = 0` 이고 `ZF = 0` 일 때 분기(점프)가 실행됩니다.**  
*(They cause a jump only when both the Carry Flag (CF) and Zero Flag (ZF) are 0.)*

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 12.문제 (Question)
> **What will be the final value in EDX after this code executes?**
> ```assembly
> mov  edx, 1
> mov  eax, 7FFFh
> cmp  eax, 8000h
> jl   L1
> mov  edx, 0
> L1:
> ```
> *(해석: 이 코드가 실행된 후 EDX 레지스터의 최종 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov edx, 1`**
   - `EDX` 레지스터의 값을 `1`로 설정합니다. (`EDX = 1`)

2. **`mov eax, 7FFFh`**
   - 32비트 `EAX` 레지스터에 16진수 `7FFFh` (10진수로 $+32,767$)를 저장합니다.

3. **`cmp eax, 8000h`**
   - `EAX` 레지스터의 값(`00007FFFh` = $+32,767$)과 `8000h` (`00008000h` = $+32,768$)를 비교합니다.
   - 32비트 표현 시:
     - `EAX` = $+32,767$
     - 비교 대상 = $+32,768$

4. **`jl L1` (Jump if Less)**
   - `JL`은 **부호 있는(Signed) 수 비교**에서 앞의 값이 뒤의 값보다 **작을 때** `L1` 라벨로 점프합니다.
   - $+32,767 < +32,768$ 이므로 조건이 **참(True)**이 됩니다.
   - 따라서 아래의 `mov edx, 0` 명령어를 건너뛰고 `L1:` 라벨로 바로 점프합니다.

5. **최종 결과:**
   - `mov edx, 0` 명령어가 실행되지 않으므로, `EDX`는 처음에 저장된 값 **`1`**을 그대로 유지합니다.

---

### 정답 (Answer)

**`1`**

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 13.문제 (Question)
> **What will be the final value in EDX after this code executes?**
> ```assembly
> mov  edx, 1
> mov  eax, 7FFFh
> cmp  eax, 8000h
> jb   L1
> mov  edx, 0
> L1:
> ```
> *(해석: 이 코드가 실행된 후 EDX 레지스터의 최종 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov edx, 1`**
   - `EDX` 레지스터의 값을 `1`로 초기화합니다. (`EDX = 1`)

2. **`mov eax, 7FFFh`**
   - 32비트 `EAX` 레지스터에 `00007FFFh` ($32,767$)를 저장합니다.

3. **`cmp eax, 8000h`**
   - `EAX` 레지스터의 값(`00007FFFh`)과 `8000h` (`00008000h` = $32,768$)를 비교합니다.

4. **`jb L1` (Jump if Below)**
   - `JB`는 **부호 없는(Unsigned) 수 비교**에서 앞의 값이 뒤의 값보다 **작을 때 (Carry Flag = 1일 때)** `L1` 라벨로 점프합니다.
   - 부호 없는 10진수로 비교 시:
     - $32,767 < 32,768$
   - $32,767$은 $32,768$보다 작으므로 뺄셈 시 빌림(Borrow)이 발생하여 **`CF = 1`**이 되며, 조건이 **참(True)**이 됩니다.
   - 따라서 아래의 `mov edx, 0` 명령어를 건너뛰고 `L1:` 라벨로 바로 점프합니다.

5. **최종 결과:**
   - `mov edx, 0` 명령어가 실행되지 않으므로, `EDX`는 처음에 저장된 값 **`1`**을 그대로 유지합니다.

---

### 정답 (Answer)

**`1`**

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 14.문제 (Question)
> **What will be the final value in EDX after this code executes?**
> ```assembly
> mov  edx, 1
> mov  eax, 7FFFh
> cmp  eax, 0FFFF8000h
> jl   L2
> mov  edx, 0
> L2:
> ```
> *(해석: 이 코드가 실행된 후 EDX 레지스터의 최종 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov edx, 1`**
   - `EDX` 레지스터에 `1`을 저장합니다. (`EDX = 1`)

2. **`mov eax, 7FFFh`**
   - 32비트 `EAX` 레지스터에 `00007FFFh`를 저장합니다.
   - **부호 있는 32비트 정수 해석:** 최상위 비트(MSB)가 0이므로 **양수 $+32,767$**입니다.

3. **`cmp eax, 0FFFF8000h`**
   - `EAX`의 값(`00007FFFh`)과 `0FFFF8000h`를 비교합니다.
   - **`0FFFF8000h`의 부호 있는 32비트 정수 해석:**
     - 최상위 비트(MSB)가 1이므로 **음수**입니다.
     - 2의 보수를 구해보면 $-32,768$ 입니다.
   - 즉, **$+32,767$과 $-32,768$을 비교**하는 연산입니다.

4. **`jl L2` (Jump if Less)**
   - `JL`은 **부호 있는 수 비교**에서 앞의 값이 뒤의 값보다 **작을 때** 점프합니다.
   - 비교: $+32,767 < -32,768$ $\rightarrow$ **거짓 (False)**
   - 양수($+32,767$)가 음수($-32,768$)보다 크기 때문에 조건을 만족하지 않아서 **점프하지 않습니다.**

5. **`mov edx, 0` 실행**
   - 점프를 하지 않고 다음 줄로 넘어가므로 `mov edx, 0` 명령어가 실행되어 `EDX`의 값이 **`0`**으로 변경됩니다.

---

### 정답 (Answer)

**`0`**

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 15.문제 (Question)
> **(True/False): The following code will jump to the label named Target.**
> ```assembly
> mov  eax, -30
> cmp  eax, -50
> jg   Target
> ```
> *(해석: 다음 코드가 실행되면 Target 라벨로 점프합니까? 참/거짓으로 답하시오.)*

---

### 풀이 (Solution)

1. **`mov eax, -30`**
   - `EAX` 레지스터에 10진수 `-30`을 저장합니다.

2. **`cmp eax, -50`**
   - `EAX` 레지스터의 값(`-30`)과 `-50`을 비교합니다.

3. **`jg Target` (Jump if Greater)**
   - `JG`는 **부호 있는(Signed) 수 비교**에서 앞의 값이 뒤의 값보다 **크면** `Target` 라벨로 점프합니다.
   - 비교: $-30 > -50$
   - 음수 영역에서는 0에 가까운 수일수록 더 크므로, **`-30`은 `-50`보다 큽니다.**
   - 따라서 조건이 **참(True)**이 되어 `Target` 라벨로 **점프합니다.**

---

### 정답 (Answer)

**True**

---
# 어셈블리어 문제 풀이 (Assembly Question)

### 16.문제 (Question)
> **(True/False): The following code will jump to the label named Target.**
> ```assembly
> mov  eax, -42
> cmp  eax, 26
> ja   Target
> ```
> *(해석: 다음 코드가 실행되면 Target 라벨로 점프합니까? 참/거짓으로 답하시오.)*

---

### 풀이 (Solution)

1. **`mov eax, -42`**
   - 32비트 레지스터 `EAX`에 `-42`를 저장합니다.
   - `-42`를 32비트 16진수(2의 보수)로 표현하면 **`FFFFFFD6h`**가 됩니다.

2. **`cmp eax, 26`**
   - `EAX` 레지스터의 값(`FFFFFFD6h`)과 `26` (`0000001Ah`)을 비교합니다.

3. **`ja Target` (Jump if Above)**
   - **주의:** `JA`는 **부호 없는(Unsigned) 수 비교** 명령어입니다.
   - 피연산자들을 부호 없는 32비트 정수로 해석하면 다음과 같습니다:
     - `EAX` = `FFFFFFD6h` = $4,294,967,254$
     - 비교 대상 = `0000001Ah` = $26$
   - 부호 없는 수 크기 비교: $4,294,967,254 > 26$
   - $4,294,967,254$는 $26$보다 월등히 크기 때문에 조건이 **참(True)**이 되어 `Target` 라벨로 **점프합니다.**

---

### 정답 (Answer)

**True**

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 17.문제 (Question)
> **What will be the value of RBX after the following instructions execute?**
> ```assembly
> mov  rbx, 0FFFFFFFFFFFFFFFFh
> and  rbx, 80h
> ```
> *(해석: 다음 명령어가 실행된 후 RBX 레지스터의 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov rbx, 0FFFFFFFFFFFFFFFFh`**
   - 64비트 `RBX` 레지스터의 모든 비트를 `1`로 채웁니다.

2. **`and rbx, 80h`**
   - `RBX`와 16진수 `80h`를 비트 단위 **AND** 연산합니다.
   - 여기서 x86-64 명령어 집합(CPU 하드웨어)의 **부호 확장(Sign-Extension)** 규칙이 적용됩니다:
     - x86-64에서 64비트 레지스터에 대한 `AND` 명령어의 즉시값(Immediate) `80h`는 8비트 부호 있는 정수로 취급되어 **64비트로 부호 확장**됩니다.
     - `80h`는 2진수로 `1000 0000_2`이며, 최상위 비트(MSB)가 `1`입니다.
     - 따라서 64비트로 확장되면 앞자리가 모두 `1`로 채워져 **`FFFFFFFFFFFFFF80h`**가 됩니다.

$$
\begin{array}{rcc}
\text{RBX} & : & \text{FFFF\ FFFF\ FFFF\ FFFF}_h \\
\text{AND (부호 확장된 80h)} & : & \text{FFFF\ FFFF\ FFFF\ FF80}_h \\
\hline
\text{결과} & : & \mathbf{FFFF\ FFFF\ FFFF\ FF80_h}
\end{array}
$$

---

### 정답 (Answer)

- **하드웨어/어셈블러 인코딩 기준 (공식 정답):** `FFFFFFFFFFFFFF80h`
- **단순 비트 마스킹(개념적) 기준:** `0000000000000080h` (또는 `80h`)

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 18.문제 (Question)
> **What will be the value of RBX after the following instructions execute?**
> ```assembly
> mov  rbx, 0FFFFFFFFFFFFFFFFh
> and  rbx, 808080h
> ```
> *(해석: 다음 명령어가 실행된 후 RBX 레지스터의 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov rbx, 0FFFFFFFFFFFFFFFFh`**
   - 64비트 `RBX` 레지스터의 모든 비트를 `1`로 설정합니다.

2. **`and rbx, 808080h`**
   - 16진수 `808080h`는 32비트 표현으로 **`00808080h`**입니다.
   - x86-64 아키텍처 규칙에 따라 32비트 즉시값은 64비트로 **부호 확장(Sign-Extension)**됩니다.
   - `00808080h`의 32번째 비트(최상위 비트, MSB)는 **`0`**입니다:
     - 32비트 2진수: `0000 0000 1000 0000 1000 0000 1000 0000_2`
   - 최상위 비트가 `0`이므로, 64비트로 부호 확장되면 상위 32비트가 모두 **`0`**으로 채워져 **`0000000000808080h`**가 됩니다.

3. **비트 AND 연산 수행:**

$$
\begin{array}{rcc}
\text{RBX} & : & \text{FFFF\ FFFF\ FFFF\ FFFF}_h \\
\text{AND (부호 확장된 00808080h)} & : & \text{0000\ 0000\ 0080\ 8080}_h \\
\hline
\text{결과} & : & \mathbf{0000\ 0000\ 0080\ 8080_h}
\end{array}
$$

---

### 17번 문제와의 핵심 차이점 비교

- **17번 (`and rbx, 80h`)**: 8비트 `80h` (`1000 0000_2`)의 MSB가 **`1`**이므로 상위 비트가 `1`로 채워짐 $\rightarrow$ `FFFFFFFFFFFFFF80h`
- **18번 (`and rbx, 808080h`)**: 32비트 `00808080h`의 MSB가 **`0`**이므로 상위 비트가 `0`으로 채워짐 $\rightarrow$ `0000000000808080h`

---

### 정답 (Answer)

**`0000000000808080h`** (또는 `808080h`)

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 19.문제 (Question)
> **What will be the value of RBX after the following instructions execute?**
> ```assembly
> mov  rbx, 0FFFFFFFFFFFFFFFFh
> and  rbx, 80808080h
> ```
> *(해석: 다음 명령어가 실행된 후 RBX 레지스터의 값은 무엇이 됩니까?)*

---

### 풀이 (Solution)

1. **`mov rbx, 0FFFFFFFFFFFFFFFFh`**
   - 64비트 `RBX` 레지스터의 모든 비트를 `1`로 채웁니다.

2. **`and rbx, 80808080h`**
   - 16진수 `80808080h`는 32비트 즉시값(Immediate)입니다.
   - x86-64 아키텍처 규칙에 따라 32비트 즉시값은 64비트로 **부호 확장(Sign-Extension)**됩니다.
   - `80808080h`의 최상위 비트(MSB, 31번째 비트)를 확인하면:
     - 32비트 2진수: `1000 0000 1000 0000 1000 0000 1000 0000_2`
     - 최상위 비트(MSB)가 **`1`**입니다.
   - 최상위 비트가 `1`이므로, 64비트로 부호 확장할 때 상위 32비트가 모두 **`1` (`FFFFFFFFh`)**로 채워져 **`FFFFFFFF80808080h`**가 됩니다.

3. **비트 AND 연산 수행:**

$$
\begin{array}{rcc}
\text{RBX} & : & \text{FFFF\ FFFF\ FFFF\ FFFF}_h \\
\text{AND (부호 확장된 80808080h)} & : & \text{FFFF\ FFFF\ 8080\ 8080}_h \\
\hline
\text{결과} & : & \mathbf{FFFF\ FFFF\ 8080\ 8080_h}
\end{array}
$$

---

### 18번 vs 19번 차이점 한눈에 보기

| 문제 | 입력 즉시값 | 32비트 MSB | 64비트 부호 확장 결과 | 최종 `RBX` 값 |
| :--- | :--- | :---: | :--- | :--- |
| **18번** | `808080h` (`00808080h`) | **`0`** | `0000000000808080h` | `0000000000808080h` |
| **19번** | `80808080h` | **`1`** | `FFFFFFFF80808080h` | `FFFFFFFF80808080h` |

---

### 정답 (Answer)

**`FFFFFFFF80808080h`**

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 1.문제 (Question)
> **1. Write a single instruction that converts an ASCII digit in AL to its corresponding binary value. If AL already contains a binary value (00h to 09h), leave it unchanged.**  
> *(해석: AL에 저장된 ASCII 숫자 문자를 이에 대응하는 바이너리 값으로 변환하는 단일 명령어를 작성하시오. 만약 AL에 이미 바이너리 값(00h~09h)이 들어있다면 변경되지 않아야 합니다.)*

---

### 풀이 (Solution)

ASCII 숫자 문자와 바이너리 값의 비트 패턴을 비교하면 다음과 같습니다.

- **ASCII 숫자 ('0' ~ '9'):** `30h` ~ `39h` (2진수: `0011 0000b` ~ `0011 1001b`)
- **바이너리 숫자 (0 ~ 9):** `00h` ~ `09h` (2진수: `0000 0000b` ~ `0000 1001b`)

두 값의 차이는 **상위 4비트(High Nibble)**에 있습니다.
- ASCII 문자는 상위 4비트가 `0011` (`3h`)입니다.
- 바이너리 값은 상위 4비트가 `0000` (`0h`)입니다.
- 하위 4비트(Low Nibble)는 두 경우 모두 실제 숫자 값(`0`~`9`)을 나타냅니다.

따라서 비트 마스킹 연산인 **`AND` 명령어**를 사용하여 상위 4비트를 `0`으로 지우고(Clear), 하위 4비트만 남기면 됩니다.

1. **AL에 ASCII '5' (`35h`)가 들어있는 경우:**
   - `35h` (`0011 0101b`) AND `0Fh` (`0000 1111b`) -> `05h` (`0000 0101b`, 바이너리 5로 변환)

2. **AL에 이미 바이너리 `05h`가 들어있는 경우:**
   - `05h` (`0000 0101b`) AND `0Fh` (`0000 1111b`) -> `05h` (`0000 0101b`, 값 유지)

---

### 정답 (Answer)

```assembly
and al, 0Fh
```

또는 2진수 표기법 사용 시:

```assembly
and al, 00001111b
```

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 2.문제 (Question)
1. Write instructions that calculate the parity of a 32-bit memory operand. Hint: Use the formula presented earlier in this section: B0 XOR B1 XOR B2 XOR B3.

*(해석: 32비트 메모리 피연산자의 패리티를 계산하는 명령어를 작성하시오. 힌트: B0 XOR B1 XOR B2 XOR B3 공식을 사용하시오.)*

---

### 풀이 (Solution)

x86 아키텍처에서 패리티 플래그(PF)는 연산 결과의 하위 8비트(1바이트)에 포함된 1의 개수가 짝수인지(PF=1) 홀수인지(PF=0)를 판별합니다.

32비트(4바이트) 전체의 패리티를 구하려면 32비트를 구성하는 4개의 바이트(B0, B1, B2, B3)를 모두 XOR 연산하여 8비트 레지스터(AL)로 모아주면 됩니다.

1. B0 (첫 번째 바이트)를 AL에 로드합니다.
2. B1, B2, B3 (나머지 바이트들)을 AL과 순차적으로 XOR 연산합니다.
3. 마지막 XOR 연산이 끝난 후 패리티 플래그(PF)가 32비트 전체 데이터의 패리티 상태를 가지게 됩니다.

---

### 정답 (Answer)

`memVal`이라는 32비트 메모리 변수가 있을 때 작성하는 코드:

```assembly
mov al, BYTE PTR memVal
xor al, BYTE PTR memVal+1
xor al, BYTE PTR memVal+2
xor al, BYTE PTR memVal+3
```

---

### 참고 사항

위 코드 실행 직후 JP (Jump if Parity / 짝수) 또는 JNP (Jump if No Parity / 홀수) 명령어를 사용하여 조건 분기를 수행할 수 있습니다.

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 3.문제 (Question)
3. Given two bit-mapped sets named SetX and SetY, write a sequence of instructions that generate a bit string in EAX that represents members in SetX that are not members of SetY.

*(해석: SetX와 SetY라는 두 개의 비트 맵 집합이 주어졌을 때, SetY의 원소가 아니면서 SetX의 원소인 비트 문자열을 EAX에 생성하는 명령어 순서를 작성하시오.)*

---

### 풀이 (Solution)

집합론에서 **"SetX에는 속하지만 SetY에는 속하지 않는 원소들의 집합"**은 차집합 $SetX - SetY$ (또는 $SetX \cap SetY^c$)을 의미합니다.

이를 비트 연산으로 표현하면 다음과 같습니다:

- **SetY의 여집합 (SetY에 속하지 않음):** `NOT SetY`
- **SetX와 (NOT SetY)의 교집합:** `SetX AND (NOT SetY)`

따라서 다음과 같은 단계로 명령어를 작성할 수 있습니다:

1. `SetY` 값을 레지스터로 가져옵니다.
2. `NOT` 명령어로 비트를 반전시킵니다. (SetY에 없는 원소로 전환)
3. `AND` 명령어로 `SetX`와 비트 연산을 수행합니다.

---

### 정답 (Answer)

```assembly
mov eax, SetY
not eax
and eax, SetX
```

또는 두 레지스터를 사용하는 방법:

```assembly
mov eax, SetX
mov ebx, SetY
not ebx
and eax, ebx
```

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 4.문제 (Question)
4. Write instructions that jump to label L1 when the unsigned integer in DX is less than or equal to the integer in CX.

*(해석: DX에 있는 부호 없는 정수(Unsigned Integer)가 CX에 있는 정수보다 작거나 같을 때 L1 레이블로 점프하는 명령어를 작성하시오.)*

---

### 풀이 (Solution)

1. **비교 연산 (`CMP`):**
   - 먼저 `cmp dx, cx` 명령어를 통해 두 값을 비교합니다.
   - `CMP` 명령어는 내부적으로 `DX - CX` 연산을 수행하고 그 결과에 따라 상태 플래그(CF, ZF 등)를 설정합니다.

2. **부호 없는 정수(Unsigned) 조건 분기 명령어:**
   - 부호 없는 정수 비교에서 **"작거나 같다(less than or equal to)"**를 나타내는 명령어는 **`JBE`** (Jump if Below or Equal) 또는 **`JNA`** (Jump if Not Above)입니다.
   - `JBE` 명령어는 캐리 플래그(CF = 1) 또는 제로 플래그(ZF = 1)일 때 점프를 수행합니다.

---

### 정답 (Answer)

```assembly
cmp dx, cx
jbe L1
```

*(참고: `jbe L1` 대신 `jna L1`을 사용해도 동일하게 동작합니다.)* 

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 5.문제 (Question)
5. Write instructions that jump to label L2 when the signed integer in AX is greater than the integer in CX.

*(해석: AX에 있는 부호 있는 정수(Signed Integer)가 CX에 있는 정수보다 클 때 L2 레이블로 점프하는 명령어를 작성하시오.)*

---

### 풀i (Solution)

1. **비교 연산 (`CMP`):**
   - 먼저 `cmp ax, cx` 명령어를 사용하여 두 레지스터의 값을 비교합니다.

2. **부호 있는 정수(Signed) 조건 분기 명령어:**
   - 문제에서 **"부호 있는 정수(Signed Integer)"**라고 지정했으므로, 부호 없는 연산자(`JA`, `JAE` 등)가 아닌 **부호 있는 연산자**를 사용해야 합니다.
   - 부호 있는 정수 비교에서 **"크다(greater than)"**를 나타내는 명령어는 **`JG`** (Jump if Greater) 또는 **`JNLE`** (Jump if Not Less or Equal)입니다.
   - `JG` 명령어는 부호 플래그(SF), 오버플로 플래그(OF), 제로 플래그(ZF)의 상태를 조합하여 `AX > CX`일 때 점프합니다.

---

### 정답 (Answer)

```assembly
cmp ax, cx
jg L2
```

*(참고: `jg L2` 대신 `jnle L2`를 사용해도 동일하게 동작합니다.)*

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 6.문제 (Question)
6. Write instructions that first clear bits 0 and 1 in AL. Then, if the destination operand is equal to zero, the code should jump to label L3. Otherwise, it should jump to label L4.

*(해석: 먼저 AL의 비트 0과 비트 1을 0으로 지우는(Clear) 명령어를 작성하시오. 그런 다음 목적지 피연산자가 0과 같으면 L3 레이블로 점프하고, 그렇지 않으면 L4 레이블로 점프해야 합니다.)*

---

### 풀이 (Solution)

1. **비트 지우기 (`AND`):**
   - 하위 비트 0과 비트 1을 지우려면 마스크 값으로 `1111 1100b` (`0FCh`)를 준비하여 `AND` 연산을 수행합니다.
   - `AND` 연산은 연산 결과가 `0`이면 자동으로 **제로 플래그(ZF = 1)**를 설정합니다.

2. **조건 분기 (`JZ` / `JE` & `JMP`):**
   - `AND` 연산 직후 제로 플래그(ZF)가 설정되어 있으므로 별도의 `CMP` 명령어 없이 바로 점프 명령어를 사용할 수 있습니다.
   - `0`과 같으면 (`ZF = 1`) **`JZ L3`** (또는 `JE L3`)를 통해 L3로 점프합니다.
   - 그렇지 않은 경우(`ZF = 0`) 무조건 점프 명령어인 **`JMP L4`**를 통해 L4로 점프합니다.

---

### 정답 (Answer)

```assembly
and al, 11111100b
jz L3
jmp L4
```

*(참고: `11111100b` 대신 16진수 `0FCh`를 사용해도 됩니다: `and al, 0FCh`)*

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 7.문제 (Question)
7. Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that val1 and X are 32-bit variables.

```text
if( val1 > ecx ) AND ( ecx > edx ) 
   X = 1
else
   X = 2;
```

*(해석: 다음 의사코드를 어셈블리어로 구현하시오. 단락 평가(Short-circuit evaluation)를 사용하고, val1과 X는 32비트 변수라고 가정합니다.)*

---

### 풀이 (Solution)

1. **단락 평가 (Short-circuit Evaluation):**
   - 논리 AND 연산에서 **첫 번째 조건이 거짓이면 두 번째 조건을 검사하지 않고 바로 `else` 블록으로 이동**하는 방식입니다.

2. **비교 및 조건 점프:**
   - 부호 있는 정수(Signed Integer) 비교를 기준으로 **`>` (Greater)** 의 반대 조건인 **`<=` (Less than or Equal)** 일 때 `else` 레이블로 점프합니다 (`JLE` 명령어 사용).

3. **구현 단계:**
   - `val1`과 `ecx`를 비교하여 `val1 <= ecx` 이면 바로 `else`로 점프
   - `ecx`와 `edx`를 비교하여 `ecx <= edx` 이면 바로 `else`로 점프
   - 두 조건을 모두 만족하면 `X = 1` 대입 후 종료
   - `else` 부분에서 `X = 2` 대입

---

### 정답 (Answer)

```assembly
    cmp val1, ecx
    jle L_else        ; val1 <= ecx 이면 else로 점프 (단락 평가)

    cmp ecx, edx
    jle L_else        ; ecx <= edx 이면 else로 점프

    mov X, 1          ; 두 조건 모두 참일 때 X = 1
    jmp L_end

L_else:
    mov X, 2          ; 조건 중 하나라도 거짓일 때 X = 2

L_end:
```

*(참고: 부호 없는 정수(Unsigned) 기준일 경우 `jle` 대신 `jbe`를 사용합니다.)*

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 8.문제 (Question)
8. Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that X is a 32-bit variable.

```text
if( ebx > ecx ) OR ( ebx > val1 ) 
   X = 1
else
   X = 2
```

*(해석: 다음 의사코드를 어셈블리어로 구현하시오. 단락 평가(Short-circuit evaluation)를 사용하고, X는 32비트 변수라고 가정합니다.)*

---

### 풀이 (Solution)

1. **OR 연산의 단락 평가 (Short-circuit Evaluation):**
   - 논리 OR 연산에서는 **첫 번째 조건이 참이면 두 번째 조건을 검사하지 않고 바로 `then` (참) 블록으로 이동**합니다.

2. **비교 및 조건 점프:**
   - 부호 있는 정수(Signed Integer) 기준 **`>` (Greater)** 조건일 때 참(True)이므로 `JG` (Jump if Greater) 명령어를 사용합니다.

3. **구현 단계:**
   - `ebx`와 `ecx`를 비교하여 `ebx > ecx` 이면 즉시 `L_then`으로 점프 (`X = 1`)
   - 그렇지 않은 경우, `ebx`와 `val1`을 비교하여 `ebx > val1` 이면 `L_then`으로 점프 (`X = 1`)
   - 두 조건이 모두 거짓이면 `X = 2` 실행 후 종료

---

### 정답 (Answer)

```assembly
    cmp ebx, ecx
    jg L_then         ; ebx > ecx 이면 참(X = 1) 레이블로 점프 (단락 평가)

    cmp ebx, val1
    jg L_then         ; ebx > val1 이면 참(X = 1) 레이블로 점프

    mov X, 2          ; 두 조건 모두 거짓일 때 X = 2
    jmp L_end

L_then:
    mov X, 1          ; 조건 중 하나라도 참일 때 X = 1

L_end:
```

*(참고: 부호 없는 정수(Unsigned) 기준일 경우 `jg` 대신 `ja`를 사용합니다.)*

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 9.문제 (Question)
9. Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that X is a 32-bit variable.

```text
if( ebx > ecx AND ebx > edx ) OR ( edx > eax ) 
   X = 1
else
   X = 2
```

*(해석: 다음 의사코드를 어셈블리어로 구현하시오. 단락 평가(Short-circuit evaluation)를 사용하고, X는 32비트 변수라고 가정합니다.)*

---

### 풀이 (Solution)

이 문제는 `(A AND B) OR C` 형태의 복합 논리식으로, 단락 평가 흐름은 다음과 같습니다.

1. **`ebx > ecx` (A 조건) 검사:**
   - 거짓(`<=`)이면 AND 조건 전체가 거짓이 되므로, `B` 조건(`ebx > edx`)검사를 생략하고 **곧바로 `C` 조건(`edx > eax`) 검사로 건너뜁니다.**
2. **`ebx > edx` (B 조건) 검사:**
   - 참(`>`)이면 `(A AND B)` 부분이 참이 되므로 전체 OR 연산도 참이 됩니다. **`C` 조건 검사를 생략하고 바로 참(`X = 1`) 블록으로 점프합니다.**
3. **`edx > eax` (C 조건) 검사:**
   - 참(`>`)이면 참(`X = 1`) 블록으로 점프합니다.
   - 거짓이면 모든 조건이 실패했으므로 거짓(`X = 2`) 블록을 실행합니다.

---

### 정답 (Answer)

```assembly
    ; 1. (ebx > ecx) 검사
    cmp ebx, ecx
    jle L_checkC      ; 거짓(<=)이면 B 검사를 건너뛰고 C 검사로 이동

    ; 2. (ebx > edx) 검사
    cmp ebx, edx
    jg L_then         ; 참(>)이면 (A AND B)가 참이므로 바로 X = 1 로 점프 (단락 평가)

L_checkC:
    ; 3. (edx > eax) 검사
    cmp edx, eax
    jg L_then         ; 참(>)이면 X = 1 로 점프

    ; 모든 조건이 거짓인 경우
    mov X, 2          ; X = 2
    jmp L_end

L_then:
    mov X, 1          ; X = 1

L_end:
```

*(참고: 부호 없는 정수(Unsigned) 기준일 경우 `jg`/`jle` 대신 `ja`/`jbe`를 사용합니다.)*

---

# 어셈블리어 문제 풀이 (Assembly Question)

### 10.문제 (Question)
10. Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that A, B, and N are 32-bit signed integers. 

```text
while N > 0
  if N != 3 AND (N < A OR N > B)
     N = N – 2
  else
     N = N – 1
end while
```

*(해석: 다음 의사코드를 어셈블리어로 구현하시오. 단락 평가(Short-circuit evaluation)를 사용하고, A, B, N은 32비트 부호 있는 정수라고 가정합니다.)*

---

### 풀이 (Solution)

1. **`while (N > 0)` 루프 조건:**
   - `N <= 0` 이면 루프를 종료합니다 (`jle` 사용).

2. **`if N != 3 AND (N < A OR N > B)` 단락 평가 흐름:**
   - **`N == 3` 이면:** AND 연산의 첫 번째 조건이 거짓이므로 뒤의 OR 조건과 상관없이 무조건 `else` 블록(`N = N - 1`)으로 점프합니다.
   - **`N < A` 이면:** OR 조건 중 하나가 참이 되므로, 뒤의 `N > B` 조건을 검사하지 않고 바로 `then` 블록(`N = N - 2`)으로 점프합니다 (단락 평가).
   - **`N > B` 이면:** `then` 블록(`N = N - 2`)으로 점프합니다.
   - **위 조건들에 해당하지 않으면:** `else` 블록(`N = N - 1`)으로 건너뜁니다.

---

### 정답 (Answer)

```assembly
L_while:
    ; while (N > 0)
    cmp N, 0
    jle L_endwhile       ; N <= 0 이면 루프 종료

    ; 1. N != 3 검사
    cmp N, 3
    je L_else            ; N == 3 이면 AND 조건이 거짓이므로 else로 이동

    ; 2. N < A 검사
    cmp N, A
    jl L_then            ; N < A 이면 OR 조건이 참이므로 바로 then으로 이동 (단락 평가)

    ; 3. N > B 검사
    cmp N, B
    jg L_then            ; N > B 이면 then으로 이동

L_else:
    sub N, 1             ; N = N - 1
    jmp L_while          ; 루프 처음으로 이동

L_then:
    sub N, 2             ; N = N - 2
    jmp L_while          ; 루프 처음으로 이동

L_endwhile:
```
