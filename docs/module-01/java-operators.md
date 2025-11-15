# Java Operators

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
| **Logical** | Combine or invert boolean expressions | <code>&#124;</code>, <code>&amp;</code>, <code>^</code> |
| **Conditional** | Combine or invert boolean expressions | <code>&#124;&#124;</code>, <code>&amp;&amp;</code> |
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
> - Use parentheses for precedence and clarity in complex expressions.

---

## 5. Summary Table of Java Operators 

| Precedence (High → Low) | Type | Operators | Example | Evaluation Order | Applicable To |
|--------------------------|------|------------|----------|------------------|---------------|
| 1 | **Postfix Unary** | `expr++`, `expr--` | `x++` | Left → Right | Numeric types |
| 2 | **Prefix Unary** | `++expr`, `--expr` | `--x` | Left → Right | Numeric |
| 3 | **Other Unary** | `(type)`, `+`, `-`, `~`, `!` | `-x`, `!flag` | Right → Left | Numeric, boolean |
| 4 | **Cast Unary** | `(Type) reference` | `(short) 22` | Right → Left | reference, primitive |
| 5 | **Multiplication/division/modulus** | `*`, `/`, `%` | `a * b` | Left → Right | Numeric types |
| 6 | **Additive** | `+`, `-` | `a + b` | Left → Right | Numeric, String (concatenation) |
| 7 | **Shift** | `<<`, `>>`, `>>>` | `a << 2` | Left → Right | Integral types |
| 8 | **Relational** | `<`, `>`, `<=`, `>=`, `instanceof` | `a < b`, `obj instanceof Person` | Left → Right | Numeric, reference |
| 9 | **Equality** | `==`, `!=` | `a == b` | Left → Right | All types (except boolean for `<`, `>`) |
| 10 | **Logical AND** | <code>&amp;</code> | `a & b` | Left → Right | boolean |
| 11 | **Logical exclusive OR** | `^` | `a ^ b` | Left → Right | boolean |
| 12 | **Logical inclusive OR** | <code>&#124;</code> | `a `<code>&#124;</code>` b` | Left → Right | boolean |
| 13 | **Conditional AND** | <code>&amp;&amp;</code> | `a`<code>&amp;&amp;</code>`b` | Left → Right | boolean |
| 14 | **Conditional OR** | <code>&#124;&#124;</code> | `a`<code>&#124;&#124;</code>`b` | Left → Right | boolean |
| 15 | **Ternary (Conditional)** | `? :` | `a > b ? x : y` | Right → Left | All types |
| 16 | **Assignment** | `=`, `+=`, `-=`, `*=`, `/=`, `%=` | `x += 5` | Right → Left | All assignable types |
| 17 | **Arrow operator** | `->` | `multiple contexts` | Right → Left | Multiple contexts |

---

### ⚙️ Additional Notes

- **String concatenation (`+`)** has lower precedence than arithmetic `+` with numbers.
- Use parentheses `()` for precedence and readability — they don’t change semantics but make intent explicit.

---

## 6. Unary Operators

Unary operators operate on **a single operand** to produce a new value.  
They are used for operations like incrementing/decrementing, negating a value, inverting a boolean, or performing bitwise complement.

### 6.1 Categories of Unary Operators

| Operator | Name | Description | Example | Result |
|-----------|------|-------------|----------|---------|
| `+` | Unary plus | Indicates a positive value (usually redundant). | `+x` | Same as `x` |
| `-` | Unary minus | Indicates a literal number is negative or negates an expression. | `-5` | `-5` |
| `++` | Increment | Increases a variable by 1. Can be prefix or postfix. | `++x`, `x++` | `x+1` |
| `--` | Decrement | Decreases a variable by 1. Can be prefix or postfix. | `--x`, `x--` | `x-1` |
| `!` | Logical complement | Inverts a boolean value. | `!true` | `false` |
| `~` | Bitwise complement | Inverts each bit of an integer. | `~5` | `-6` |
| `(type)` | Cast | Converts value to another type. | `(int) 3.9` | `3` |

### 6.2 Examples

```java
int x = 5;
System.out.println(++x);  // 6  (prefix: increment (or decrement) first the value by one and then returns the NEW value)
System.out.println(x++);  // 6  (postfix: increment the value by one and then returns the ORIGINAL value)
System.out.println(x);    // 7

boolean flag = false;
System.out.println(!flag);  // true

int a = 5;                  // binary: 0000 0101
System.out.println(~a);     // -6 → binary: 1111 1010
```

> [!NOTE]
> - Prefix (`++x`) prefix: increment (or decrement) first the value by one and then returns the NEW value.  
> - Postfix (`x++`) postfix: increment the value by one and then returns the ORIGINAL value.  
> - The `!` and `~` operators can only be applied to `boolean` and `numeric` types respectively.

---

## 7. Binary Operators

Binary operators require **two operands**.  
They perform arithmetic, relational, logical, bitwise, and assignment operations.

### 7.1 Categories of Binary Operators

| Category | Operators | Example | Description |
|-----------|------------|----------|--------------|
| **Arithmetic** | `+`, `-`, `*`, `/`, `%` | `a + b` | Basic math operations. |
| **Relational** | `<`, `>`, `<=`, `>=`, `==`, `!=` | `a < b` | Compare values. |
| **Logical (boolean)** | <code>&amp;</code>, <code>&#124;</code>, `^` | `a `<code>&amp;</code>` b` | See note below |
| **Conditional** |  <code>&amp;&amp;</code>, <code>&#124;&#124;</code> | `a `<code>&amp;&amp;</code>` b` |  See note below  |
| **Bitwise (integral)** | <code>&amp;</code>, <code>&#124;</code>, `^`, `<<`, `>>`, `>>>` | `a << 2` | Operate on bits. |
| **Assignment** | `=`, `+=`, `-=`, `*=`, `/=`, `%=` | `x += 3` | Modify and assign. |
| **String Concatenation** | `+` | `"Hello " + name` | Joins strings together. |

> [!NOTE]
> **Logical operators**: 
> - **AND** ( x **&** b ) true if both operands are true; 
> - **INCLUSIVE OR** ( x **|** y ) only false if both operands are false; 
> - **EXCLUSIVE OR** ( x **^** y ) true if the operands are different.  


> [!NOTE]
> **Conditional (short-circuit) operators** applies to `&&` and `||`:  
> - `a && b` → `b` is evaluated *only if* `a` is `true`.  
> - `a || b` → `b` is evaluated *only if* `a` is `false`.

### 7.2 The Return Value of an Assignment Operator

In Java, the **assignment operator (`=`)** not only stores a value in a variable —  
it also **returns the assigned value** as the result of the entire expression.

This means that the assignment operation itself can be **used as part of another expression**,  
such as inside an `if` statement, a loop condition, or even another assignment.

```java
int x;
int y = (x = 10);   // the assignment (x = 10) returns 10
System.out.println(y);  // 10

// x = 10 assigns 10 to x.
// The expression (x = 10) evaluates to 10.
// That value is then assigned to y.
// So both x and y end up with the same value (10).
```

Because assignment returns a value, it can also appear inside an **if** statement.
However, this often leads to logical errors if used unintentionally.

```java
boolean flag = false;

if (flag = true) {
    System.out.println("This will always execute!");
}

// Here the condition (flag = true) assigns true to flag, and then evaluates to true, so the if block always runs.

// Correct usage (comparison instead of assignment):

if (flag == true) {
    System.out.println("Condition checked, not assigned");
}
```



### 7.3 Examples

#### Arithmetic Example
```java
int a = 10, b = 4;
System.out.println(a + b);  // 14
System.out.println(a - b);  // 6
System.out.println(a * b);  // 40
System.out.println(a / b);  // 2
System.out.println(a % b);  // 2
```

#### Relational Example
```java
int a = 5, b = 8;
System.out.println(a < b);   // true
System.out.println(a >= b);  // false
System.out.println(a == b);  // false
System.out.println(a != b);  // true
```

#### Logical Example
```java
boolean x = true, y = false;
System.out.println(x && y);  // false
System.out.println(x || y);  // true
System.out.println(!x);      // false
```

#### Bitwise Example
```java
int a = 5;   // 0101
int b = 3;   // 0011
System.out.println(a & b);  // 1  (0001)
System.out.println(a | b);  // 7  (0111)
System.out.println(a ^ b);  // 6  (0110)
System.out.println(a << 1); // 10 (1010)
System.out.println(a >> 1); // 2  (0010)
```

---

## 8. Ternary Operator

The **ternary operator** (`? :`) is the only operator in Java that takes **three operands**.  
It acts as a concise form of an `if-else` statement.

### 8.1 Syntax
```java
condition ? expressionIfTrue : expressionIfFalse;
```

### 8.2 Example

```java
int age = 20;
String access = (age >= 18) ? "Allowed" : "Denied";
System.out.println(access);  // "Allowed"
```

### 8.3 Nested Ternary Example

```java
int score = 85;
String grade = (score >= 90) ? "A" :
               (score >= 75) ? "B" :
               (score >= 60) ? "C" : "F";
System.out.println(grade);  // "B"
```

### 8.4 Notes

> [!WARNING]
> - Nested ternary expressions can reduce readability. Use parentheses for clarity.  
> - The ternary operator returns a **value**, unlike `if-else`, which is a statement.
