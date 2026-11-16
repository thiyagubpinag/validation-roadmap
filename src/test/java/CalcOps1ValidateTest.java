import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;

import org.junit.jupiter.api.Test;

/**
 * Validation test for CalcOps1 (converted from COBOL CALCOPS1).
 * Scenario: first addition test case (100.00 + 250.50, expected status "00").
 * Values are taken from CALCOPS1_resource_mapper.yaml (implied-decimal V99 values
 * "000010000" = 100.00, "000025050" = 250.50, "00000035050" = 350.50).
 */
class CalcOps1ValidateTest {

    private static void setField(Object target, String name, Object value) throws Exception {
        Field f = CalcOps1.class.getDeclaredField(name);
        f.setAccessible(true);
        f.set(target, value);
    }

    private static Object getField(Object target, String name) throws Exception {
        Field f = CalcOps1.class.getDeclaredField(name);
        f.setAccessible(true);
        return f.get(target);
    }

    private static void invoke(Object target, String name) throws Exception {
        Method m = CalcOps1.class.getDeclaredMethod(name);
        m.setAccessible(true);
        m.invoke(target);
    }

    @Test
    void additionInRangeProducesExpectedResultAndCounters() throws Exception {
        CalcOps1 calc = new CalcOps1();

        // program_input (mock values from the resource mapper)
        setField(calc, "opCode", 'A');
        setField(calc, "operandA", new BigDecimal("100.00"));
        setField(calc, "operandB", new BigDecimal("250.50"));
        setField(calc, "expectedStatus", "00");

        // 1000-INITIALIZE-PARA then 2000-RUN-TEST-CASE
        invoke(calc, "initializePara");

        PrintStream originalOut = System.out;
        ByteArrayOutputStream captured = new ByteArrayOutputStream();
        System.setOut(new PrintStream(captured));
        try {
            invoke(calc, "runTestCase");
        } finally {
            System.setOut(originalOut);
        }

        // program_expected_output
        assertEquals(0, new BigDecimal("350.50").compareTo((BigDecimal) getField(calc, "result")));
        assertEquals(1, getField(calc, "testNo"));
        assertEquals(1, getField(calc, "passCount"));
        assertEquals(0, getField(calc, "failCount"));
        assertEquals("00", getField(calc, "statusCode"));

        String line = captured.toString().trim();
        assertEquals("TEST 01 OP=A STATUS=00 RESULT=       350.50 PASS", line);
    }

    @Test
    void mainFirstDisplayLineReportsFirstAdditionCasePassing() {
        PrintStream originalOut = System.out;
        ByteArrayOutputStream captured = new ByteArrayOutputStream();
        System.setOut(new PrintStream(captured));
        try {
            CalcOps1.main(new String[0]);
        } finally {
            System.setOut(originalOut);
        }

        String[] lines = captured.toString().split("\\R");
        assertTrue(lines.length > 0);
        assertEquals("TEST 01 OP=A STATUS=00 RESULT=       350.50 PASS", lines[0]);
    }
}
