# CALCOPS1 Validation Roadmap & Target Architecture

This repository contains the end-to-end modernization, validation roadmap, and target production architecture for transforming legacy COBOL applications (`CALCOPS1.cbl`) into clean, maintainable, and decoupled Java domain services.

---

## 📌 Repository Overview

* **Source COBOL**: Legacy programs with arithmetic calculation policies and condition logic (`cobol/CALCOPS1.cbl`).
* **Converted Java**: Initial baseline Java conversion with procedural flow (`java/CalcOps1.java`).
* **Validation Tests**: JUnit 5 test harness verifying behavioral parity (`src/test/java/CalcOps1ValidateTest.java`).
* **Interactive Architecture & Roadmap Dashboards**: Visual HTML references under [`roadmap/`](roadmap/).
* **Business Rule Inventories & Documentation**: Structural rule documentation under [`docs/`](docs/).

---

## 🏗 Project Structure

```
├── cobol/
│   ├── CALCOPS1.cbl                     # Original COBOL calculator sample
│   └── LGACDB01.cbl                     # Core business logic reference
├── java/
│   └── CalcOps1.java                    # Initial converted Java procedural baseline
├── src/test/java/
│   └── CalcOps1ValidateTest.java        # JUnit 5 behavioral parity tests
├── roadmap/                             # Interactive Visual Dashboards & Architecture
│   ├── CALCOPS1-target-architecture.html# Target Production Architecture & Test Results
│   ├── CALCOPS1-business-rules.html     # Business rules & execution path visualizer
│   ├── CALCOPS1-function-hierarchy.html # Function → SubFunction → Rule hierarchy
│   ├── validate-agentic.html            # Agentic validation dashboard
│   └── validate-legacy.html             # Legacy validation dashboard
├── docs/                                # Business rule specifications & inventories
│   ├── business-rule/cobol/
│   └── program/cobol/
└── pom.xml                              # Maven configuration (Java 17, JUnit 5)
```

---

## 🚀 Target Production Architecture (Phase 2)

In the target production architecture, monolithic procedural methods are refactored into **pure, stateless domain services** where each business rule has:
1. **Isolated Entry Point**: Explicit static evaluation methods (`evaluate(...)`) without reflection or mutable state.
2. **Immutable Result Records**: Encapsulated `Result(value, statusCode)` preventing state pollution across downstream operations.
3. **Dedicated Test Suite**: 100% branch and boundary test coverage executed in sub-milliseconds.

### SubFunction 2.3: Extracted Arithmetic Policies

| Rule ID | Rule Name | Description | Status Outcomes |
| :--- | :--- | :--- | :--- |
| **2.3.1** | **Addition Policy** | Operand range check, dual-zero bypass, overflow validation | `00`, `10`, `40` |
| **2.3.2** | **Subtraction Policy** | Operand range check, equal operand shortcut, negative result policy | `00`, `10`, `40`, `50` |
| **2.3.3** | **Multiplication Policy** | Operand range check, zero operand bypass, precision floor loss | `00`, `10`, `40`, `60` |
| **2.3.4** | **Division Policy** | Divisor zero check, precision floor rejection, remainder capture | `00`, `10`, `20`, `40`, `60` |

---

## 📊 Visual Dashboards & Artifacts

Open the following files in any browser to explore the interactive visual architecture:

* [`roadmap/CALCOPS1-target-architecture.html`](roadmap/CALCOPS1-target-architecture.html): Production architecture, extracted rule components, syntax-highlighted code, and test matrices.
* [`roadmap/CALCOPS1-business-rules.html`](roadmap/CALCOPS1-business-rules.html): Business rule condition highlighter with numbered execution badges.
* [`roadmap/CALCOPS1-function-hierarchy.html`](roadmap/CALCOPS1-function-hierarchy.html): Visual tree linking Functions, SubFunctions, Rules, and Steps.

---

## 🧪 Running Tests & Validation

### Prerequisites
* Java 17+
* Apache Maven 3.8+

### Run Automated Tests
```bash
mvn clean test
```

### Run Direct Java Execution
```bash
mvn compile
java -cp target/classes CalcOps1
```

---

## 🛠 Tech Stack
* **Language**: Java 17
* **Testing Framework**: JUnit 5 (Jupiter 5.10.2)
* **Build Tool**: Apache Maven
* **Methodology**: IBM Winning Products & BMad Modernization Architecture
