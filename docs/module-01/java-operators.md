# Chapter 8: Java Operators

## 1. Definition

In Java, **operators** are special symbols that perform operations on variables and values.  
They are the building blocks of expressions and allow developers to manipulate data, compare values, perform arithmetic, and control logic flow.

An **expression** is a combination of operators and operands that produces a result.  
For example:
```java
int result = (a + b) * c;
```
Here, `+` and `*` are operators, and `a`, `b`, and `c` are operands.

---

## 2. Types of Operators

Java defines three types of operators, grouped by the number of operands they use:

| Type | Description | Examples |
|-----------|--------------|-----------|
| **Unary** | Operate on a single operand | `+x`, `-x`, `++x`, `--x`, `!flag`, `~num` |
| **Binary** | Operate on two operands | `a + b`, `a - b`, `x * y`, `x / y`, `x % y` |
| **Ternary** | Operate on three operands (only one in Java) | `condition ? valueIfTrue : valueIfFalse` |

---

## 3. Categories of Operators

Operators can also be gouped, by their purpose, in categories:

| Category | Description | Examples |
|-----------|--------------|-----------|
| **Assignment** | Assign values to variables | `=`, `+=`, `-=`, `*=`, `/=`, `%=` |
| **Relational** | Compare values | `==`, `!=`, `<`, `>`, `<=`, `>=` |
| **Logical** | Combine or invert boolean expressions | <code>&#124;&#124;</code>, <code>&amp;&amp;</code>, <code>!</code> |
| **Bitwise** | Manipulate bits | <code>&amp;</code>, <code>&#124;</code>, `^`, `~`, `<<`, `>>`, `>>>` |
| **Instanceof** | Test object type | `obj instanceof ClassName` |
| **Lambda** | Used in lambda expressions | `(x, y) -> x + y` |

---

## 4. Operator Precedence and Order of Evaluation

**Operator precedence** determines how operators are grouped in an expression — that is, which operations are performed first.  
**Associativity** (or **order of evaluation**) determines whether the expression is evaluated from **left to right** or **right to left** when operators have the same precedence.

Example:

```java
int result = 10 + 5 * 2;  // Multiplication happens before addition → result = 20
```

Parentheses `()` can be used to **override precedence**:

```java
int result = (10 + 5) * 2;  // Parentheses evaluated first → result = 30
```

> [!NOTE] 
> - Operator **precedence** is about *grouping*, not evaluation order.  
> - Use parentheses for clarity in complex expressions.

---

## 5. Summary Table of Java Operators

| Precedence (High → Low) | Type | Operators | Example | Evaluation Order | Applicable To |
|--------------------------|------|------------|----------|------------------|---------------|
| 1 | **Postfix Unary** | `expr++`, `expr--` | `x++` | Left → Right | Numeric types |
| 2 | **Prefix Unary** | `++expr`, `--expr` | `--x` | Left → Right | Numeric, boolean |
| 3 | **Other Unary** | `(type)`, `+`, `-`, `~`, `!` | `-x`, `!flag` | Right → Left | Numeric, boolean |
| 4 | **Cast** | `(Type)reference` | `(short) 22` | Right → Left | Numeric, boolean |
| 5 | **Multiplication/division/modulus** | `*`, `/`, `%` | `a * b` | Left → Right | Numeric types |
| 6 | **Additive** | `+`, `-` | `a + b` | Left → Right | Numeric, String (concatenation) |
| 7 | **Shift** | `<<`, `>>`, `>>>` | `a << 2` | Left → Right | Integral types |
| 8 | **Relational** | `<`, `>`, `<=`, `>=`, `instanceof` | `a < b`, `obj instanceof Person` | Left → Right | Numeric, reference |
| 9 | **Equality** | `==`, `!=` | `a == b` | Left → Right | All types (except boolean for `<`, `>`) |
| 10 | **Logical AND** | <code>&amp;</code> | `a & b` | Left → Right | Integral, boolean |
| 11 | **Logical exclusive OR** | `^` | `a ^ b` | Left → Right | Integral, boolean |
| 12 | **Logical inclusive OR** | <code>&#124;</code> | `a `<code>&#124;</code>` b` | Left → Right | Integral, boolean |
| 11 | **Logical AND** | `&&` | `a && b` | Left → Right | Boolean |
| 12 | **Logical OR** | `||` | `a || b` | Left → Right | Boolean |
| 13 | **Ternary (Conditional)** | `? :` | `a > b ? x : y` | Right → Left | All types |
| 14 | **Assignment** | `=`, `+=`, `-=`, `*=`, `/=`, `%=` | `x += 5` | Right → Left | All assignable types |

---

### ⚙️ Additional Notes

- **Short-circuit evaluation** applies to logical `&&` and `||`:  
  - `a && b` → `b` is evaluated *only if* `a` is `true`.  
  - `a || b` → `b` is evaluated *only if* `a` is `false`.
- **String concatenation (`+`)** has lower precedence than arithmetic `+` with numbers.
- Use parentheses `()` for readability — they don’t change semantics but make intent explicit.

---

**Summary:**  
Java operators define how expressions are computed.  
Understanding **precedence**, **associativity**, and **type applicability** is essential for writing correct and predictable code, and it’s a common topic in Java certification exams.
