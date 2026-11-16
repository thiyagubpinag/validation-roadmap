import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Java conversion of COBOL program CALCOPS1.
 * Sample calculator: add, subtract, multiply and divide, each in its own
 * method, with condition logic and boundary checks. Test cases are loaded in
 * {@link #main(String[])} (no file I/O); output is one DISPLAY line per test
 * case followed by a pass/fail summary.
 */
public class CalcOps1 {

    // WS-STATUS-CODE values (88-levels)
    private static final String STATUS_OK = "00";
    private static final String STATUS_OVERFLOW = "10";
    private static final String STATUS_DIVIDE_BY_ZERO = "20";
    private static final String STATUS_INVALID_OPERATION = "30";
    private static final String STATUS_OUT_OF_RANGE = "40";
    private static final String STATUS_NEGATIVE_RESULT = "50";
    private static final String STATUS_PRECISION_LOSS = "60";

    // PIC S9(7)V99 limits, PIC S9(9)V99 result limit (exclusive)
    private static final BigDecimal MAX_OPERAND = new BigDecimal("5000000.00");
    private static final BigDecimal MIN_OPERAND = new BigDecimal("-5000000.00");
    private static final BigDecimal PRECISION_FLOOR = new BigDecimal("0.1000");
    private static final BigDecimal RESULT_LIMIT = new BigDecimal("1000000000");
    private static final BigDecimal REMAINDER_LIMIT = new BigDecimal("10000000");

    private BigDecimal operandA = BigDecimal.ZERO;
    private BigDecimal operandB = BigDecimal.ZERO;
    private BigDecimal result = BigDecimal.ZERO;
    private BigDecimal remainder = BigDecimal.ZERO;
    private boolean allowNegative = false;
    private char opCode = ' ';
    private String statusCode = STATUS_OK;
    private String expectedStatus = STATUS_OK;
    private int testNo = 0;
    private int passCount = 0;
    private int failCount = 0;

    public static void main(String[] args) {
        new CalcOps1().mainPara();
    }

    // 0000-MAIN-PARA
    private void mainPara() {
        initializePara();
        // ---- ADDITION CASES ----
        loadCase('A', "100.00", "250.50", "00");
        loadCase('A', "0", "0", "00");
        loadCase('A', "4999999.99", "0.01", "00");
        loadCase('A', "5000000.01", "1.00", "40");
        loadCase('A', "-500.00", "200.00", "00");
        // ---- SUBTRACTION CASES ----
        loadCase('S', "500.00", "200.00", "00");
        loadCase('S', "100.00", "250.00", "50");
        loadCase('S', "75.00", "75.00", "00");
        loadCase('S', "-4999999.99", "1.00", "50");
        // ---- MULTIPLICATION CASES ----
        loadCase('M', "12.50", "4.00", "00");
        loadCase('M', "4999999.99", "4999999.99", "10");
        loadCase('M', "1234.56", "0", "00");
        loadCase('M', "0.01", "0.01", "60");
        // ---- DIVISION CASES ----
        loadCase('D', "100.00", "0", "20");
        loadCase('D', "100.00", "3.00", "00");
        loadCase('D', "1.00", "0.05", "60");
        loadCase('D', "4999999.99", "0.50", "00");
        // ---- INVALID OPERATION CODE ----
        loadCase('X', "1.00", "1.00", "30");
        displaySummary();
    }

    private void loadCase(char op, String a, String b, String expected) {
        opCode = op;
        operandA = new BigDecimal(a);
        operandB = new BigDecimal(b);
        expectedStatus = expected;
        runTestCase();
    }

    // 1000-INITIALIZE-PARA
    private void initializePara() {
        testNo = 0;
        passCount = 0;
        failCount = 0;
        allowNegative = false;
    }

    // 2000-RUN-TEST-CASE
    private void runTestCase() {
        testNo++;
        statusCode = STATUS_OK;
        result = BigDecimal.ZERO;
        remainder = BigDecimal.ZERO;
        switch (opCode) {
            case 'A':
                additionPara();
                break;
            case 'S':
                subtractionPara();
                break;
            case 'M':
                multiplyPara();
                break;
            case 'D':
                dividePara();
                break;
            default:
                statusCode = STATUS_INVALID_OPERATION;
                break;
        }
        reportResult();
    }

    private boolean operandAOutOfRange() {
        return operandA.compareTo(MAX_OPERAND) > 0 || operandA.compareTo(MIN_OPERAND) < 0;
    }

    private boolean operandBOutOfRange() {
        return operandB.compareTo(MAX_OPERAND) > 0 || operandB.compareTo(MIN_OPERAND) < 0;
    }

    // Stores a value into WS-RESULT PIC S9(9)V99; false means SIZE ERROR (result unchanged).
    private boolean storeResult(BigDecimal value, RoundingMode mode) {
        BigDecimal scaled = value.setScale(2, mode);
        if (scaled.abs().compareTo(RESULT_LIMIT) >= 0) {
            return false;
        }
        result = scaled;
        return true;
    }

    // 3000-ADDITION-PARA
    private void additionPara() {
        if (operandAOutOfRange()) {
            statusCode = STATUS_OUT_OF_RANGE;
        } else if (operandBOutOfRange()) {
            statusCode = STATUS_OUT_OF_RANGE;
        } else if (operandA.signum() == 0 && operandB.signum() == 0) {
            result = BigDecimal.ZERO;
            statusCode = STATUS_OK;
        } else {
            if (storeResult(operandA.add(operandB), RoundingMode.DOWN)) {
                statusCode = STATUS_OK;
            } else {
                statusCode = STATUS_OVERFLOW;
            }
        }
    }

    // 3100-SUBTRACTION-PARA
    private void subtractionPara() {
        if (operandAOutOfRange()) {
            statusCode = STATUS_OUT_OF_RANGE;
        } else if (operandBOutOfRange()) {
            statusCode = STATUS_OUT_OF_RANGE;
        } else if (operandA.compareTo(operandB) == 0) {
            result = BigDecimal.ZERO;
            statusCode = STATUS_OK;
        } else {
            if (!storeResult(operandA.subtract(operandB), RoundingMode.DOWN)) {
                statusCode = STATUS_OVERFLOW;
            }
            if (STATUS_OK.equals(statusCode)
                    && result.signum() < 0
                    && !allowNegative) {
                statusCode = STATUS_NEGATIVE_RESULT;
            }
        }
    }

    // 3200-MULTIPLY-PARA
    private void multiplyPara() {
        if (operandAOutOfRange()) {
            statusCode = STATUS_OUT_OF_RANGE;
        } else if (operandBOutOfRange()) {
            statusCode = STATUS_OUT_OF_RANGE;
        } else if (operandA.signum() == 0 || operandB.signum() == 0) {
            result = BigDecimal.ZERO;
            statusCode = STATUS_OK;
        } else {
            // ROUNDED: nearest, ties away from zero
            if (!storeResult(operandA.multiply(operandB), RoundingMode.HALF_UP)) {
                statusCode = STATUS_OVERFLOW;
            }
            if (STATUS_OK.equals(statusCode) && result.signum() == 0) {
                statusCode = STATUS_PRECISION_LOSS;
            }
        }
    }

    // 3300-DIVIDE-PARA
    private void dividePara() {
        if (operandAOutOfRange()) {
            statusCode = STATUS_OUT_OF_RANGE;
        } else if (operandBOutOfRange()) {
            statusCode = STATUS_OUT_OF_RANGE;
        } else if (operandB.signum() == 0) {
            statusCode = STATUS_DIVIDE_BY_ZERO;
        } else if (operandB.abs().compareTo(PRECISION_FLOOR) < 0) {
            statusCode = STATUS_PRECISION_LOSS;
        } else if (operandA.signum() == 0) {
            result = BigDecimal.ZERO;
            statusCode = STATUS_OK;
        } else {
            // Remainder is computed from the quotient truncated (not rounded) to 2 decimals
            BigDecimal truncatedQuotient = operandA.divide(operandB, 2, RoundingMode.DOWN);
            BigDecimal rawRemainder = operandA.subtract(truncatedQuotient.multiply(operandB));
            BigDecimal storedRemainder = rawRemainder.setScale(2, RoundingMode.DOWN);
            boolean quotientOk = storeResult(operandA.divide(operandB, 2, RoundingMode.HALF_UP),
                    RoundingMode.HALF_UP);
            boolean remainderOk = storedRemainder.abs().compareTo(REMAINDER_LIMIT) < 0;
            if (quotientOk && remainderOk) {
                remainder = storedRemainder;
            } else {
                statusCode = STATUS_OVERFLOW;
            }
        }
    }

    // 4000-REPORT-RESULT
    private void reportResult() {
        String displayResult = editResult(result);
        if (statusCode.equals(expectedStatus)) {
            passCount++;
            System.out.println("TEST " + twoDigits(testNo) + " OP=" + opCode
                    + " STATUS=" + statusCode
                    + " RESULT=" + displayResult + " PASS");
        } else {
            failCount++;
            System.out.println("TEST " + twoDigits(testNo) + " OP=" + opCode
                    + " STATUS=" + statusCode
                    + " EXPECTED=" + expectedStatus + " FAIL");
        }
    }

    // 9000-DISPLAY-SUMMARY
    private void displaySummary() {
        System.out.println("CALCOPS1 TESTS RUN : " + twoDigits(testNo));
        System.out.println("CALCOPS1 PASSED    : " + twoDigits(passCount));
        System.out.println("CALCOPS1 FAILED    : " + twoDigits(failCount));
    }

    // PIC 9(2)
    private static String twoDigits(int value) {
        return String.format("%02d", value % 100);
    }

    // PIC -(9)9.99 : 13 characters, floating minus sign, right-justified
    private static String editResult(BigDecimal value) {
        String text = value.abs().setScale(2, RoundingMode.DOWN).toPlainString();
        if (value.signum() < 0) {
            text = "-" + text;
        }
        return String.format("%13s", text);
    }
}
