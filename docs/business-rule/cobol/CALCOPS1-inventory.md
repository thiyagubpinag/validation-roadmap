# Business rules: Inventory

**Program:** CALCOPS1

**Total rules extracted:** 6

## Table of Contents

- [1. Purpose](#1-purpose)
- [2. Rule Inventory](#2-rule-inventory)
  - [2.1 Paragraph: 0000-MAIN-PARA](#21-paragraph-0000-main-para)
  - [2.2 Paragraph: 2000-RUN-TEST-CASE](#22-paragraph-2000-run-test-case)
  - [2.3 Paragraph: 3000-ADDITION-PARA](#23-paragraph-3000-addition-para)
  - [2.4 Paragraph: 3100-SUBTRACTION-PARA](#24-paragraph-3100-subtraction-para)
  - [2.5 Paragraph: 3200-MULTIPLY-PARA](#25-paragraph-3200-multiply-para)
  - [2.6 Paragraph: 3300-DIVIDE-PARA](#26-paragraph-3300-divide-para)

## 1. Purpose

This document is an inventory of all business rules extracted from CALCOPS1, organised at the Paragraph level. Each Paragraph contributes one or more named rule blocks, where each block captures a discrete business policy with its title, decision logic, conditions, actions, outcomes, and the exact source code that realises it. Key variables, when available, are annotated with their role (input or output) and their specific purpose within the rule. References to related Paragraphs called or invoked by each rule are also recorded.

## 2. Rule Inventory

### 2.1 Paragraph: 0000-MAIN-PARA

#### 2.1.1 Run arithmetic test scenarios with expected status outcomes

**Description:** Defines the set of business scenarios (addition, subtraction, multiplication, division and invalid operation) with operands and the status each is expected to produce, and runs each through the calculation engine. These encode the expected business behavior for range limits, negative results, overflow, precision loss, divide by zero and invalid operations.

**Core decision logic:**
- Addition within limits, including zero operands and negative operands, is expected to succeed ('00'); an operand above the maximum is expected to be out of range ('40')
- Subtraction producing a negative result is expected to yield negative result status ('50'); equal operands yield success
- Multiplication of very large operands is expected to overflow ('10'); a zero operand is expected to succeed; a tiny product is expected to be flagged as precision loss ('60')
- Division by zero is expected to yield '20'; a divisor below the precision floor is expected to yield '60'; normal divisions succeed
- An unknown operation code is expected to yield invalid operation ('30')

**Code:**
```cobol
           MOVE 'A' TO WS-OP-CODE
           MOVE 100.00 TO WS-OPERAND-A
           MOVE 250.50 TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'A' TO WS-OP-CODE
           MOVE ZERO TO WS-OPERAND-A
           MOVE ZERO TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'A' TO WS-OP-CODE
           MOVE +4999999.99 TO WS-OPERAND-A
           MOVE +0.01 TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'A' TO WS-OP-CODE
           MOVE +5000000.01 TO WS-OPERAND-A
           MOVE +1.00 TO WS-OPERAND-B
           MOVE '40' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'A' TO WS-OP-CODE
           MOVE -500.00 TO WS-OPERAND-A
           MOVE +200.00 TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'S' TO WS-OP-CODE
           MOVE 500.00 TO WS-OPERAND-A
           MOVE 200.00 TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'S' TO WS-OP-CODE
           MOVE 100.00 TO WS-OPERAND-A
           MOVE 250.00 TO WS-OPERAND-B
           MOVE '50' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'S' TO WS-OP-CODE
           MOVE 75.00 TO WS-OPERAND-A
           MOVE 75.00 TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'S' TO WS-OP-CODE
           MOVE -4999999.99 TO WS-OPERAND-A
           MOVE +1.00 TO WS-OPERAND-B
           MOVE '50' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'M' TO WS-OP-CODE
           MOVE 12.50 TO WS-OPERAND-A
           MOVE 4.00 TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'M' TO WS-OP-CODE
           MOVE +4999999.99 TO WS-OPERAND-A
           MOVE +4999999.99 TO WS-OPERAND-B
           MOVE '10' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'M' TO WS-OP-CODE
           MOVE 1234.56 TO WS-OPERAND-A
           MOVE ZERO TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'M' TO WS-OP-CODE
           MOVE +0.01 TO WS-OPERAND-A
           MOVE +0.01 TO WS-OPERAND-B
           MOVE '60' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'D' TO WS-OP-CODE
           MOVE 100.00 TO WS-OPERAND-A
           MOVE ZERO TO WS-OPERAND-B
           MOVE '20' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'D' TO WS-OP-CODE
           MOVE 100.00 TO WS-OPERAND-A
           MOVE 3.00 TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'D' TO WS-OP-CODE
           MOVE 1.00 TO WS-OPERAND-A
           MOVE +0.05 TO WS-OPERAND-B
           MOVE '60' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'D' TO WS-OP-CODE
           MOVE +4999999.99 TO WS-OPERAND-A
           MOVE +0.50 TO WS-OPERAND-B
           MOVE '00' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           MOVE 'X' TO WS-OP-CODE
           MOVE 1.00 TO WS-OPERAND-A
           MOVE 1.00 TO WS-OPERAND-B
           MOVE '30' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
```

**Variables:**

| Variable name | Role | Purpose |
|---|---|---|
| `WS-OP-CODE` | output | Selects the arithmetic operation to be exercised in each scenario. |
| `WS-OPERAND-A` | output | Holds the first operand for each scenario. |
| `WS-OPERAND-B` | output | Holds the second operand for each scenario. |
| `WS-EXPECTED-STATUS` | output | Holds the business status expected for each scenario. |

**Paragraphs:**

* 2000-RUN-TEST-CASE
### 2.2 Paragraph: 2000-RUN-TEST-CASE

#### 2.2.1 Dispatch arithmetic operation by operation code

**Description:** Selects the business calculation matching the requested operation (add, subtract, multiply, divide) and flags any unsupported operation code as an invalid operation.

**Core decision logic:**
- Addition, subtraction, multiplication and division codes route to their respective calculation rules
- Any other operation code results in an invalid operation status

**Code:**
```cobol
           EVALUATE TRUE
               WHEN OP-ADD
                   PERFORM 3000-ADDITION-PARA
               WHEN OP-SUBTRACT
                   PERFORM 3100-SUBTRACTION-PARA
               WHEN OP-MULTIPLY
                   PERFORM 3200-MULTIPLY-PARA
               WHEN OP-DIVIDE
                   PERFORM 3300-DIVIDE-PARA
               WHEN OTHER
                   SET STATUS-INVALID-OPERATION TO TRUE
           END-EVALUATE
```

**Variables:**

| Variable name | Role | Purpose |
|---|---|---|
| `WS-OP-CODE` | input | Operation code evaluated through its condition names to choose the calculation. |
| `WS-STATUS-CODE` | output | Set to invalid operation status when the operation code is not recognized. |

**Paragraphs:**

* 3000-ADDITION-PARA
* 3100-SUBTRACTION-PARA
* 3200-MULTIPLY-PARA
* 3300-DIVIDE-PARA
### 2.3 Paragraph: 3000-ADDITION-PARA

#### 2.3.1 Addition with operand range validation and zero shortcut

**Description:** Validates that both operands are within the permitted range, short-circuits the case where both are zero, and otherwise adds the operands, flagging overflow if the result cannot be held.

**Core decision logic:**
- Operand A or B outside the min/max operand limits yields out of range status
- Both operands zero yields a zero result with success
- Otherwise operands are added; size error yields overflow status, else success

**Code:**
```cobol
           EVALUATE TRUE
               WHEN WS-OPERAND-A > WS-MAX-OPERAND
                 OR WS-OPERAND-A < WS-MIN-OPERAND
                   SET STATUS-OUT-OF-RANGE TO TRUE
               WHEN WS-OPERAND-B > WS-MAX-OPERAND
                 OR WS-OPERAND-B < WS-MIN-OPERAND
                   SET STATUS-OUT-OF-RANGE TO TRUE
               WHEN WS-OPERAND-A = ZERO AND WS-OPERAND-B = ZERO
                   MOVE ZERO TO WS-RESULT
                   SET STATUS-OK TO TRUE
               WHEN OTHER
      *            RESULT FIELD IS WIDER THAN THE OPERANDS, SO
      *            SIZE ERROR IS A DEFENSIVE CHECK ONLY
                   ADD WS-OPERAND-A WS-OPERAND-B GIVING WS-RESULT
                       ON SIZE ERROR
                           SET STATUS-OVERFLOW TO TRUE
                       NOT ON SIZE ERROR
                           SET STATUS-OK TO TRUE
                   END-ADD
           END-EVALUATE
```

**Variables:**

| Variable name | Role | Purpose |
|---|---|---|
| `WS-OPERAND-A` | input | First addend validated against limits and added. |
| `WS-OPERAND-B` | input | Second addend validated against limits and added. |
| `WS-MAX-OPERAND` | input | Upper limit for permitted operands. |
| `WS-MIN-OPERAND` | input | Lower limit for permitted operands. |
| `WS-RESULT` | output | Receives the sum or zero. |

### 2.4 Paragraph: 3100-SUBTRACTION-PARA

#### 2.4.1 Subtraction with range validation and negative result policy

**Description:** Validates operand ranges, returns zero when operands are equal, otherwise subtracts B from A, flags overflow, and rejects negative results when negatives are not permitted.

**Core decision logic:**
- Operands outside limits yield out of range status
- Equal operands yield zero with success
- Size error yields overflow status
- Negative result when negatives are not allowed yields negative result status

**Code:**
```cobol
           EVALUATE TRUE
               WHEN WS-OPERAND-A > WS-MAX-OPERAND
                 OR WS-OPERAND-A < WS-MIN-OPERAND
                   SET STATUS-OUT-OF-RANGE TO TRUE
               WHEN WS-OPERAND-B > WS-MAX-OPERAND
                 OR WS-OPERAND-B < WS-MIN-OPERAND
                   SET STATUS-OUT-OF-RANGE TO TRUE
               WHEN WS-OPERAND-A = WS-OPERAND-B
                   MOVE ZERO TO WS-RESULT
                   SET STATUS-OK TO TRUE
               WHEN OTHER
                   SUBTRACT WS-OPERAND-B FROM WS-OPERAND-A
                       GIVING WS-RESULT
                       ON SIZE ERROR
                           SET STATUS-OVERFLOW TO TRUE
                   END-SUBTRACT
                   IF STATUS-OK
                       IF WS-RESULT < ZERO
                           AND NOT NEGATIVE-ALLOWED
                           SET STATUS-NEGATIVE-RESULT TO TRUE
                       END-IF
                   END-IF
           END-EVALUATE
```

**Variables:**

| Variable name | Role | Purpose |
|---|---|---|
| `WS-OPERAND-A` | input | Minuend validated and used in subtraction. |
| `WS-OPERAND-B` | input | Subtrahend validated and subtracted. |
| `WS-MAX-OPERAND` | input | Upper operand limit. |
| `WS-MIN-OPERAND` | input | Lower operand limit. |
| `WS-RESULT` | output | Receives the difference and is checked for negativity. |
| `WS-ALLOW-NEGATIVE` | input | Policy flag (via NEGATIVE-ALLOWED) controlling whether negative results are acceptable. |

### 2.5 Paragraph: 3200-MULTIPLY-PARA

#### 2.5.1 Multiplication with range validation, zero shortcut and precision loss detection

**Description:** Validates operand ranges, returns zero if either operand is zero, otherwise multiplies with rounding, flags overflow, and flags precision loss when a non-zero product rounds to zero.

**Core decision logic:**
- Operands outside limits yield out of range status
- Either operand zero yields zero result with success
- Size error yields overflow status
- Zero result from non-zero operands yields precision loss status

**Code:**
```cobol
           EVALUATE TRUE
               WHEN WS-OPERAND-A > WS-MAX-OPERAND
                 OR WS-OPERAND-A < WS-MIN-OPERAND
                   SET STATUS-OUT-OF-RANGE TO TRUE
               WHEN WS-OPERAND-B > WS-MAX-OPERAND
                 OR WS-OPERAND-B < WS-MIN-OPERAND
                   SET STATUS-OUT-OF-RANGE TO TRUE
               WHEN WS-OPERAND-A = ZERO OR WS-OPERAND-B = ZERO
                   MOVE ZERO TO WS-RESULT
                   SET STATUS-OK TO TRUE
               WHEN OTHER
                   MULTIPLY WS-OPERAND-A BY WS-OPERAND-B
                       GIVING WS-RESULT ROUNDED
                       ON SIZE ERROR
                           SET STATUS-OVERFLOW TO TRUE
                   END-MULTIPLY
                   IF STATUS-OK AND WS-RESULT = ZERO
                       SET STATUS-PRECISION-LOSS TO TRUE
                   END-IF
           END-EVALUATE
```

**Variables:**

| Variable name | Role | Purpose |
|---|---|---|
| `WS-OPERAND-A` | input | Multiplicand validated and multiplied. |
| `WS-OPERAND-B` | input | Multiplier validated and multiplied. |
| `WS-MAX-OPERAND` | input | Upper operand limit. |
| `WS-MIN-OPERAND` | input | Lower operand limit. |
| `WS-RESULT` | output | Receives the rounded product and is checked for precision loss. |

### 2.6 Paragraph: 3300-DIVIDE-PARA

#### 2.6.1 Division with range, zero divisor and precision floor validation

**Description:** Validates operand ranges, rejects zero divisors and divisors too small to preserve precision, returns zero for a zero dividend, and otherwise divides with rounding while capturing the remainder and flagging overflow.

**Core decision logic:**
- Operands outside limits yield out of range status
- Zero divisor yields divide by zero status
- Divisor with absolute value below precision floor yields precision loss status
- Zero dividend yields zero result with success
- Size error yields overflow status

**Code:**
```cobol
           EVALUATE TRUE
               WHEN WS-OPERAND-A > WS-MAX-OPERAND
                 OR WS-OPERAND-A < WS-MIN-OPERAND
                   SET STATUS-OUT-OF-RANGE TO TRUE
               WHEN WS-OPERAND-B > WS-MAX-OPERAND
                 OR WS-OPERAND-B < WS-MIN-OPERAND
                   SET STATUS-OUT-OF-RANGE TO TRUE
               WHEN WS-OPERAND-B = ZERO
                   SET STATUS-DIVIDE-BY-ZERO TO TRUE
               WHEN FUNCTION ABS(WS-OPERAND-B) < WS-PRECISION-FLOOR
                   SET STATUS-PRECISION-LOSS TO TRUE
               WHEN WS-OPERAND-A = ZERO
                   MOVE ZERO TO WS-RESULT
                   SET STATUS-OK TO TRUE
               WHEN OTHER
                   DIVIDE WS-OPERAND-A BY WS-OPERAND-B
                       GIVING WS-RESULT ROUNDED
                       REMAINDER WS-REMAINDER
                       ON SIZE ERROR
                           SET STATUS-OVERFLOW TO TRUE
                   END-DIVIDE
           END-EVALUATE
```

**Variables:**

| Variable name | Role | Purpose |
|---|---|---|
| `WS-OPERAND-A` | input | Dividend validated and divided. |
| `WS-OPERAND-B` | input | Divisor validated for zero and precision and used in division. |
| `WS-MAX-OPERAND` | input | Upper operand limit. |
| `WS-MIN-OPERAND` | input | Lower operand limit. |
| `WS-PRECISION-FLOOR` | input | Minimum absolute divisor allowed without precision loss. |
| `WS-RESULT` | output | Receives the quotient or zero. |
| `WS-REMAINDER` | output | Receives the division remainder. |

---

Generated by IBM Bob Premium Package for Z
