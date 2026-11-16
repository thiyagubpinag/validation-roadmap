      ******************************************************************
      * PROGRAM : CALCOPS1                                             *
      * PURPOSE : SAMPLE CALCULATOR. ADD, SUBTRACT, MULTIPLY AND       *
      *           DIVIDE, EACH IN ITS OWN PARAGRAPH, WITH CONDITION    *
      *           LOGIC AND BOUNDARY CHECKS.                           *
      * INPUT   : TEST CASES LOADED IN 0000-MAIN-PARA (NO FILE I/O)    *
      * OUTPUT  : DISPLAY LINES PER TEST CASE AND A PASS/FAIL SUMMARY  *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CALCOPS1.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-OPERAND-A              PIC S9(7)V99 COMP-3 VALUE ZERO.
       01  WS-OPERAND-B              PIC S9(7)V99 COMP-3 VALUE ZERO.
       01  WS-RESULT                 PIC S9(9)V99 COMP-3 VALUE ZERO.
       01  WS-REMAINDER              PIC S9(7)V99 COMP-3 VALUE ZERO.
       01  WS-MAX-OPERAND            PIC S9(7)V99 COMP-3
                                     VALUE +5000000.00.
       01  WS-MIN-OPERAND            PIC S9(7)V99 COMP-3
                                     VALUE -5000000.00.
       01  WS-PRECISION-FLOOR        PIC S9V9(4)  COMP-3
                                     VALUE +0.1000.
       01  WS-ALLOW-NEGATIVE         PIC X(1)  VALUE 'N'.
           88  NEGATIVE-ALLOWED                VALUE 'Y'.
       01  WS-OP-CODE                PIC X(1)  VALUE SPACE.
           88  OP-ADD                          VALUE 'A'.
           88  OP-SUBTRACT                     VALUE 'S'.
           88  OP-MULTIPLY                     VALUE 'M'.
           88  OP-DIVIDE                       VALUE 'D'.
       01  WS-STATUS-CODE            PIC X(2)  VALUE '00'.
           88  STATUS-OK                       VALUE '00'.
           88  STATUS-OVERFLOW                 VALUE '10'.
           88  STATUS-DIVIDE-BY-ZERO           VALUE '20'.
           88  STATUS-INVALID-OPERATION        VALUE '30'.
           88  STATUS-OUT-OF-RANGE             VALUE '40'.
           88  STATUS-NEGATIVE-RESULT          VALUE '50'.
           88  STATUS-PRECISION-LOSS           VALUE '60'.
       01  WS-EXPECTED-STATUS        PIC X(2)  VALUE '00'.
       01  WS-TEST-NO                PIC 9(2)  VALUE ZERO.
       01  WS-PASS-COUNT             PIC 9(2)  VALUE ZERO.
       01  WS-FAIL-COUNT             PIC 9(2)  VALUE ZERO.
       01  WS-DISPLAY-RESULT         PIC -(9)9.99.

       PROCEDURE DIVISION.
       0000-MAIN-PARA.
           PERFORM 1000-INITIALIZE-PARA
      *    ---- ADDITION CASES ----
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
      *    ---- SUBTRACTION CASES ----
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
      *    ---- MULTIPLICATION CASES ----
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
      *    ---- DIVISION CASES ----
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
      *    ---- INVALID OPERATION CODE ----
           MOVE 'X' TO WS-OP-CODE
           MOVE 1.00 TO WS-OPERAND-A
           MOVE 1.00 TO WS-OPERAND-B
           MOVE '30' TO WS-EXPECTED-STATUS
           PERFORM 2000-RUN-TEST-CASE
           PERFORM 9000-DISPLAY-SUMMARY
           STOP RUN.

       1000-INITIALIZE-PARA.
           MOVE ZERO TO WS-TEST-NO
           MOVE ZERO TO WS-PASS-COUNT
           MOVE ZERO TO WS-FAIL-COUNT
           MOVE 'N' TO WS-ALLOW-NEGATIVE.

       2000-RUN-TEST-CASE.
           ADD 1 TO WS-TEST-NO
           SET STATUS-OK TO TRUE
           MOVE ZERO TO WS-RESULT
           MOVE ZERO TO WS-REMAINDER
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
           PERFORM 4000-REPORT-RESULT.

       3000-ADDITION-PARA.
      *    CONDITION AND BOUNDARY CHECKS BEFORE ARITHMETIC
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
           END-EVALUATE.

       3100-SUBTRACTION-PARA.
      *    CONDITION AND BOUNDARY CHECKS BEFORE ARITHMETIC
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
           END-EVALUATE.

       3200-MULTIPLY-PARA.
      *    CONDITION AND BOUNDARY CHECKS BEFORE ARITHMETIC
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
           END-EVALUATE.

       3300-DIVIDE-PARA.
      *    CONDITION AND BOUNDARY CHECKS BEFORE ARITHMETIC
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
           END-EVALUATE.

       4000-REPORT-RESULT.
           MOVE WS-RESULT TO WS-DISPLAY-RESULT
           IF WS-STATUS-CODE = WS-EXPECTED-STATUS
               ADD 1 TO WS-PASS-COUNT
               DISPLAY 'TEST ' WS-TEST-NO ' OP=' WS-OP-CODE
                   ' STATUS=' WS-STATUS-CODE
                   ' RESULT=' WS-DISPLAY-RESULT ' PASS'
           ELSE
               ADD 1 TO WS-FAIL-COUNT
               DISPLAY 'TEST ' WS-TEST-NO ' OP=' WS-OP-CODE
                   ' STATUS=' WS-STATUS-CODE
                   ' EXPECTED=' WS-EXPECTED-STATUS ' FAIL'
           END-IF.

       9000-DISPLAY-SUMMARY.
           DISPLAY 'CALCOPS1 TESTS RUN : ' WS-TEST-NO
           DISPLAY 'CALCOPS1 PASSED    : ' WS-PASS-COUNT
           DISPLAY 'CALCOPS1 FAILED    : ' WS-FAIL-COUNT.
