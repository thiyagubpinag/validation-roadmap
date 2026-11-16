# Business rules: Overview

**Program:** CALCOPS1

## Table of Contents

- [1. Purpose](#1-purpose)
- [2. Function: Controlled Arithmetic Processing](#2-function-controlled-arithmetic-processing)
  - [2.1 SubFunction: Operation Selection and Validation](#21-subfunction-operation-selection-and-validation)
  - [2.2 SubFunction: Operand Range Control](#22-subfunction-operand-range-control)
  - [2.3 SubFunction: Arithmetic Calculation Policies](#23-subfunction-arithmetic-calculation-policies)
- [3. Function: Arithmetic Behavior Verification](#3-function-arithmetic-behavior-verification)
  - [3.1 SubFunction: Expected-Outcome Scenario Testing](#31-subfunction-expected-outcome-scenario-testing)

## 1. Purpose
This document presents a program-level functional view of the business logic in CALCOPS1. Business rules are organised into a Function → SubFunction → Business Rule hierarchy representing the business functions performed in the program. Semantically related rules are consolidated into named SubFunctions that group related business capabilities, and purely technical or setup logic is excluded. Each rule documents its purpose, ordered execution steps with conditions, actions, and outcomes, references to the contributing source paragraphs, and the business significance of each rule.

## 2. Function: Controlled Arithmetic Processing

### 2.1 SubFunction: Operation Selection and Validation

#### 2.1.1 Business Rule: Supported Operation Recognition

##### 2.1.1.1 Purpose
Ensures each calculation request is routed to the business calculation matching its requested operation (addition, subtraction, multiplication, division). Any operation code outside this supported set is rejected as an invalid operation rather than being processed, so no unsupported calculation produces a result.

##### 2.1.1.2 Rule Steps
1. Match the requested operation code to a supported calculation
   - Conditions: `WS-OP-CODE` identifies addition, subtraction, multiplication or division.
   - Actions: Route the request to the corresponding calculation rule (addition, subtraction, multiplication or division).
   - Outcomes: The request is processed by the correct arithmetic policy.
   - Relevant Paragraphs: 2000-RUN-TEST-CASE, 3000-ADDITION-PARA, 3100-SUBTRACTION-PARA, 3200-MULTIPLY-PARA, 3300-DIVIDE-PARA
2. Reject unsupported operation codes
   - Conditions: `WS-OP-CODE` does not match any supported operation.
   - Actions: Set `WS-STATUS-CODE` to the invalid operation status ('30').
   - Outcomes: The request is flagged as an invalid operation and no calculation is performed.
   - Relevant Paragraphs: 2000-RUN-TEST-CASE

##### 2.1.1.3 Business Significance
If routing fails or unsupported codes are accepted, calculations could run under the wrong policy or return meaningless results with no clear error signal. Downstream consumers rely on the invalid-operation status to distinguish a bad request from a calculation failure.

### 2.2 SubFunction: Operand Range Control

#### 2.2.1 Business Rule: Operand Limit Enforcement

##### 2.2.1.1 Purpose
Every arithmetic operation (addition, subtraction, multiplication, division) requires both operands to fall within the permitted minimum and maximum limits before any calculation is attempted. This is a single shared policy applied consistently across all four operations.

##### 2.2.1.2 Rule Steps
1. Check operand A and operand B against the permitted limits
   - Conditions: `WS-OPERAND-A` or `WS-OPERAND-B` is above `WS-MAX-OPERAND` or below `WS-MIN-OPERAND`.
   - Actions: Stop the calculation and set the out-of-range status ('40').
   - Outcomes: Out-of-range inputs are rejected before computation.
   - Relevant Paragraphs: 3000-ADDITION-PARA, 3100-SUBTRACTION-PARA, 3200-MULTIPLY-PARA, 3300-DIVIDE-PARA, 0000-MAIN-PARA (scenario: addition with operand above maximum expected '40')

##### 2.2.1.3 Business Significance
Without consistent range enforcement, oversized or undersized inputs could produce unreliable results or overflows, undermining the integrity of all calculated values and any dependent financial or operational figures.

### 2.3 SubFunction: Arithmetic Calculation Policies

#### 2.3.1 Business Rule: Addition Policy

##### 2.3.1.1 Purpose
Adds two validated operands, short-circuiting the trivial all-zero case, and reports overflow if the sum cannot be held in the result field.

##### 2.3.1.2 Rule Steps
1. Apply operand range validation
   - Conditions: Operands outside `WS-MIN-OPERAND`/`WS-MAX-OPERAND`.
   - Actions: Set out-of-range status.
   - Outcomes: Rejected as out of range (see 1.2.1).
   - Relevant Paragraphs: 3000-ADDITION-PARA
2. Zero shortcut
   - Conditions: `WS-OPERAND-A` and `WS-OPERAND-B` are both zero.
   - Actions: Set `WS-RESULT` to zero and set success ('00').
   - Outcomes: Zero result with success, no addition performed.
   - Relevant Paragraphs: 3000-ADDITION-PARA
3. Add and check for overflow
   - Conditions: Operands valid and not both zero.
   - Actions: Compute `WS-RESULT` = A + B; if a size error occurs set overflow status ('10'), otherwise set success ('00').
   - Outcomes: Successful sum or overflow indication. Negative and zero operands within limits succeed.
   - Relevant Paragraphs: 3000-ADDITION-PARA, 0000-MAIN-PARA

##### 2.3.1.3 Business Significance
Incorrect handling would let truncated sums be reported as valid totals, silently corrupting downstream amounts.

#### 2.3.2 Business Rule: Subtraction Policy with Negative Result Control

##### 2.3.2.1 Purpose
Subtracts operand B from A, handles equal operands as zero, flags overflow, and enforces the policy on whether negative differences are acceptable.

##### 2.3.2.2 Rule Steps
1. Apply operand range validation
   - Conditions: Operands outside limits.
   - Actions: Set out-of-range status.
   - Outcomes: Rejected as out of range (see 1.2.1).
   - Relevant Paragraphs: 3100-SUBTRACTION-PARA
2. Equal operand shortcut
   - Conditions: `WS-OPERAND-A` equals `WS-OPERAND-B`.
   - Actions: Set `WS-RESULT` to zero and success ('00').
   - Outcomes: Zero difference reported as success.
   - Relevant Paragraphs: 3100-SUBTRACTION-PARA, 0000-MAIN-PARA
3. Subtract and check for overflow
   - Conditions: Operands valid and unequal.
   - Actions: Compute `WS-RESULT` = A − B; on size error set overflow status ('10').
   - Outcomes: Difference produced or overflow flagged.
   - Relevant Paragraphs: 3100-SUBTRACTION-PARA
4. Enforce negative result policy
   - Conditions: `WS-RESULT` is negative and `WS-ALLOW-NEGATIVE` (NEGATIVE-ALLOWED) is not set.
   - Actions: Set negative result status ('50').
   - Outcomes: Negative differences are rejected when the policy disallows them; otherwise the result is accepted.
   - Relevant Paragraphs: 3100-SUBTRACTION-PARA, 0000-MAIN-PARA

##### 2.3.2.3 Business Significance
Failing to apply the negative-result policy could allow impossible balances or quantities (e.g., negative amounts) to flow downstream undetected.

#### 2.3.3 Business Rule: Multiplication Policy with Precision Loss Detection

##### 2.3.3.1 Purpose
Multiplies two validated operands with rounding, returns zero when either operand is zero, flags overflow, and detects cases where a genuine non-zero product is rounded away to zero.

##### 2.3.3.2 Rule Steps
1. Apply operand range validation
   - Conditions: Operands outside limits.
   - Actions: Set out-of-range status.
   - Outcomes: Rejected as out of range (see 1.2.1).
   - Relevant Paragraphs: 3200-MULTIPLY-PARA
2. Zero operand shortcut
   - Conditions: `WS-OPERAND-A` or `WS-OPERAND-B` is zero.
   - Actions: Set `WS-RESULT` to zero and success ('00').
   - Outcomes: Zero product reported as success.
   - Relevant Paragraphs: 3200-MULTIPLY-PARA, 0000-MAIN-PARA
3. Multiply with rounding and check overflow
   - Conditions: Operands valid and non-zero.
   - Actions: Compute rounded `WS-RESULT` = A × B; on size error set overflow status ('10').
   - Outcomes: Product produced or overflow flagged (very large operands overflow).
   - Relevant Paragraphs: 3200-MULTIPLY-PARA, 0000-MAIN-PARA
4. Detect precision loss
   - Conditions: `WS-RESULT` is zero although both operands are non-zero.
   - Actions: Set precision loss status ('60').
   - Outcomes: Tiny products are flagged instead of being reported as a true zero.
   - Relevant Paragraphs: 3200-MULTIPLY-PARA, 0000-MAIN-PARA

##### 2.3.3.3 Business Significance
Without precision-loss detection, small but real values could be reported as zero and treated as exact, causing under-statement of amounts.

#### 2.3.4 Business Rule: Division Policy with Zero Divisor and Precision Floor Controls

##### 2.3.4.1 Purpose
Divides a validated dividend by a validated divisor, rejecting divisors that are zero or too small to preserve precision, handling a zero dividend, and capturing the remainder with rounding.

##### 2.3.4.2 Rule Steps
1. Apply operand range validation
   - Conditions: Operands outside limits.
   - Actions: Set out-of-range status.
   - Outcomes: Rejected as out of range (see 1.2.1).
   - Relevant Paragraphs: 3300-DIVIDE-PARA
2. Reject zero divisor
   - Conditions: `WS-OPERAND-B` equals zero.
   - Actions: Set divide-by-zero status ('20').
   - Outcomes: Division is not attempted.
   - Relevant Paragraphs: 3300-DIVIDE-PARA, 0000-MAIN-PARA
3. Reject divisor below precision floor
   - Conditions: Absolute value of `WS-OPERAND-B` is below `WS-PRECISION-FLOOR`.
   - Actions: Set precision loss status ('60').
   - Outcomes: Divisors too small to yield a reliable quotient are rejected.
   - Relevant Paragraphs: 3300-DIVIDE-PARA, 0000-MAIN-PARA
4. Zero dividend shortcut
   - Conditions: `WS-OPERAND-A` is zero.
   - Actions: Set `WS-RESULT` to zero and success ('00').
   - Outcomes: Zero quotient reported as success.
   - Relevant Paragraphs: 3300-DIVIDE-PARA
5. Divide with rounding, capture remainder, check overflow
   - Conditions: Operands valid, divisor acceptable, dividend non-zero.
   - Actions: Compute rounded `WS-RESULT` = A ÷ B and populate `WS-REMAINDER`; on size error set overflow status ('10'), otherwise success ('00').
   - Outcomes: Quotient and remainder returned, or overflow flagged.
   - Relevant Paragraphs: 3300-DIVIDE-PARA

##### 2.3.4.3 Business Significance
Failing to block zero or near-zero divisors risks runtime failures or wildly inaccurate quotients, and mishandling the remainder can cause allocation or reconciliation differences.

## 3. Function: Arithmetic Behavior Verification

### 3.1 SubFunction: Expected-Outcome Scenario Testing

#### 3.1.1 Business Rule: Scenario-Based Validation of Expected Status Outcomes

##### 3.1.1.1 Purpose
Defines a catalogue of business scenarios covering addition, subtraction, multiplication, division and invalid operations, each with operands and the status it should produce, and runs each through the calculation engine to confirm the arithmetic policies behave as specified.

##### 3.1.1.2 Rule Steps
1. Define scenarios with expected statuses
   - Conditions: Each scenario specifies `WS-OP-CODE`, `WS-OPERAND-A`, `WS-OPERAND-B` and `WS-EXPECTED-STATUS`.
   - Actions: Execute each scenario through the operation dispatch.
   - Outcomes: Each business behavior is exercised against its expected status.
   - Relevant Paragraphs: 0000-MAIN-PARA, 2000-RUN-TEST-CASE
2. Addition expectations
   - Conditions: Addition scenarios.
   - Actions: Expect '00' for in-limit, zero and negative operands; '40' for an operand above maximum.
   - Outcomes: Confirms addition range and success policy.
   - Relevant Paragraphs: 0000-MAIN-PARA
3. Subtraction expectations
   - Conditions: Subtraction scenarios.
   - Actions: Expect '50' for negative results; success for equal operands.
   - Outcomes: Confirms negative-result policy.
   - Relevant Paragraphs: 0000-MAIN-PARA
4. Multiplication expectations
   - Conditions: Multiplication scenarios.
   - Actions: Expect '10' for very large operands, '00' for a zero operand, '60' for a tiny product.
   - Outcomes: Confirms overflow, zero shortcut and precision loss handling.
   - Relevant Paragraphs: 0000-MAIN-PARA
5. Division and invalid operation expectations
   - Conditions: Division and unknown-code scenarios.
   - Actions: Expect '20' for division by zero, '60' for divisor below precision floor, success for normal divisions, '30' for an unknown operation code.
   - Outcomes: Confirms divisor controls and invalid operation handling.
   - Relevant Paragraphs: 0000-MAIN-PARA, 2000-RUN-TEST-CASE

##### 3.1.1.3 Business Significance
These scenarios act as the executable specification of calculation behavior. If they are incomplete or wrong, regressions in range, overflow, precision or negative-result policies may go undetected and reach production calculations.

---

Generated by IBM Bob Premium Package for Z
