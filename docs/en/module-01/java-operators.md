# 5. Java Operators

### Table of Contents

- [5. Java Operators](#5-java-operators)
  - [5.1 Definition](#51-definition)
  - [5.2 Types of Operators](#52-types-of-operators)
  - [5.3 Categories of Operators](#53-categories-of-operators)
  - [5.4 Operator Precedence and Order of Evaluation](#54-operator-precedence-and-order-of-evaluation)
  - [5.5 Summary Table of Java Operators](#55-summary-table-of-java-operators)
    - [5.5.1 Additional Notes](#551-additional-notes)
  - [5.6 Unary Operators](#56-unary-operators)
    - [5.6.1 Categories of Unary Operators](#561-categories-of-unary-operators)
    - [5.6.2 Examples](#562-examples)
  - [5.7 Binary Operators](#57-binary-operators)
    - [5.7.1 Categories of Binary Operators](#571-categories-of-binary-operators)
    - [5.7.2 Division and Modulus Operators](#572-division-and-modulus-operators)
    - [5.7.3 The Return Value of an Assignment Operator](#573-the-return-value-of-an-assignment-operator)
    - [5.7.4 Compound Assignment Operators](#574-compound-assignment-operators)
    - [5.7.5 Equality Operators == and !=](#575-equality-operators--and-)
      - [5.7.5.1 Equality with Primitive Types](#5751-equality-with-primitive-types)
      - [5.7.5.2 Equality with Reference Types Objects](#5752-equality-with-reference-types-objects)
    - [5.7.6 The instanceof Operator](#576-the-instanceof-operator)
      - [5.7.6.1 Compile-Time Check vs Runtime Check](#5761-compile-time-check-vs-runtime-check)
      - [5.7.6.2 Pattern Matching for instanceof](#5762-pattern-matching-for-instanceof)
      - [5.7.6.3 Flow Scoping & Short-Circuit Logic](#5763-flow-scoping--short-circuit-logic)
      - [5.7.6.4 Arrays and Reifiable Types](#5764-arrays-and-reifiable-types)
  - [5.8 Ternary Operator](#58-ternary-operator)
    - [5.8.1 Syntax](#581-syntax)
    - [5.8.2 Example](#582-example)
    - [5.8.3 Nested Ternary Example](#583-nested-ternary-example)
    - [5.8.4 Notes](#584-notes)


---

## 5.1 Definition

In Java, **operators** are special symbols that perform operations on variables and values.  
They are the building blocks of expressions and allow developers to manipulate data, compare values, perform arithmetic, and control logic flow.

An **expression** is a combination of operators and operands that produces a result.  
For example:
```java
int result = (a + b) * c;
```
Here, `+` and `*` are operators, and `a`, `b`, and `c` are operands.

---

## 5.2 Types of Operators

Java defines three types of operators, grouped by the number of operands they use:

| Type | Description | Examples |
|-----------|--------------|-----------|
| **Unary** | Operate on a single operand | `+x`, `-x`, `++x`, `--x`, `!flag`, `~num` |
| **Binary** | Operate on two operands | `a + b`, `a - b`, `x * y`, `x / y`, `x % y` |
| **Ternary** | Operate on three operands (only one in Java) | `condition ? valueIfTrue : valueIfFalse` |

---

## 5.3 Categories of Operators

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

## 5.4 Operator Precedence and Order of Evaluation

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

## 5.5 Summary Table of Java Operators 

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

### 5.5.1 ⚙️ Additional Notes

- **String concatenation (`+`)** has lower precedence than arithmetic `+` with numbers.
- Use parentheses `()` for precedence and readability — they don’t change semantics but make intent explicit.

---

## 5.6 Unary Operators

Unary operators operate on **a single operand** to produce a new value.  
They are used for operations like incrementing/decrementing, negating a value, inverting a boolean, or performing bitwise complement.

### 5.6.1 Categories of Unary Operators

| Operator | Name | Description | Example | Result |
|-----------|------|-------------|----------|---------|
| `+` | Unary plus | Indicates a positive value (usually redundant). | `+x` | Same as `x` |
| `-` | Unary minus | Indicates a literal number is negative or negates an expression. | `-5` | `-5` |
| `++` | Increment | Increases a variable by 1. Can be prefix or postfix. | `++x`, `x++` | `x+1` |
| `--` | Decrement | Decreases a variable by 1. Can be prefix or postfix. | `--x`, `x--` | `x-1` |
| `!` | Logical complement | Inverts a boolean value. | `!true` | `false` |
| `~` | Bitwise complement | Inverts each bit of an integer. | `~5` | `-6` |
| `(type)` | Cast | Converts value to another type. | `(int) 3.9` | `3` |

### 5.6.2 Examples

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

## 5.7 Binary Operators

Binary operators require **two operands**.  
They perform arithmetic, relational, logical, bitwise, and assignment operations.

### 5.7.1 Categories of Binary Operators

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

**Some Examples**

Arithmetic Example:
```java
int a = 10, b = 4;
System.out.println(a + b);  // 14
System.out.println(a - b);  // 6
System.out.println(a * b);  // 40
System.out.println(a / b);  // 2
System.out.println(a % b);  // 2
```

Relational Example:
```java
int a = 5, b = 8;
System.out.println(a < b);   // true
System.out.println(a >= b);  // false
System.out.println(a == b);  // false
System.out.println(a != b);  // true
```

Logical Example:
```java
boolean x = true, y = false;
System.out.println(x && y);  // false
System.out.println(x || y);  // true
System.out.println(!x);      // false
```

Bitwise Example:
```java
int a = 5;   // 0101
int b = 3;   // 0011
System.out.println(a & b);  // 1  (0001)
System.out.println(a | b);  // 7  (0111)
System.out.println(a ^ b);  // 6  (0110)
System.out.println(a << 1); // 10 (1010)
System.out.println(a >> 1); // 2  (0010)
```

### 5.7.2 Division and Modulus Operators

The modulus operator is the remainder when two numbers are divided.
If two numbers divide evenly, the reminder is 0: for example **10 % 5** is 0.
On the other hand, **13 % 4** gives the reminder of 1.

We can use modulus with negative numbers according to the following rules:

- if the **divisor** is negative (Ex: 7 % -5), then the sign is ignored and the result is **2**;
- if the **dividend** is negative (Ex: -7 % 5), then the sign is preserved and the result is **-2**;

```java
System.out.println(8 % 5);      // GIVES 3
System.out.println(10 % 5); 	// GIVES 0
System.out.println(10 % 3); 	// GIVES 1    
System.out.println(-10 % 3); 	// GIVES -1    
System.out.println(10 % -3); 	// GIVES 1   
System.out.println(-10 % -3); 	// GIVES -1 

System.out.println(8 % 9);      // GIVES 8
System.out.println(3 % 4);      // GIVES 3    
System.out.println(2 % 4);      // GIVES 2
System.out.println(-8 % 9);     // GIVES -8


```

### 5.7.3 The Return Value of an Assignment Operator

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

### 5.7.4 Compound Assignment Operators

**Compound assignment operators** in Java combine an arithmetic or bitwise operation with assignment in a single step.  
Instead of writing `x = x + 5`, you can use the shorthand `x += 5`.  
They automatically perform **type casting** to the left-hand variable type when necessary.

Common compound operators include:  
`+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`, and `>>>=`.

```java
int x = 10;

// Arithmetic compound assignments
x += 5;   // same as x = x + 5 → x = 15
x -= 3;   // same as x = x - 3 → x = 12
x *= 2;   // same as x = x * 2 → x = 24
x /= 4;   // same as x = x / 4 → x = 6
x %= 5;   // same as x = x % 5 → x = 1

// Bitwise compound assignments
int y = 6;   // 0110 (binary)
y &= 3;      // y = y & 3 → 0110 & 0011 = 0010 → y = 2
y |= 4;      // y = y | 4 → 0010 | 0100 = 0110 → y = 6
y ^= 5;      // y = y ^ 5 → 0110 ^ 0101 = 0011 → y = 3

// Shift compound assignments
int z = 8;   // 0000 1000
z <<= 2;     // z = z << 2 → 0010 0000 → z = 32
z >>= 1;     // z = z >> 1 → 0001 0000 → z = 16
z >>>= 2;    // z = z >>> 2 → 0000 0100 → z = 4

// Type casting example
byte b = 10;
// b = b + 1;   // ❌ compile-time error: int result cannot be assigned to byte
b += 1;         // ✅ works: implicit cast back to byte
```

### 5.7.5 Equality Operators (`==` and `!=`)

The **equality operators** in Java `==` (equal to) and `!=` (not equal to) are used to compare two operands for equality.  
However, their behavior differs **depending on whether they are applied to primitive types or reference types (objects)**.

#### 5.7.5.1 Equality with Primitive Types

When comparing **primitive values**, `==` and `!=` compare the **actual stored values**.

```java
int a = 5, b = 5;
System.out.println(a == b);  // true  → both have the same value
System.out.println(a != b);  // false → values are equal
```
> [!IMPORTANT]
> - If the operands are of different numeric types, Java automatically promotes them to a common type before comparison.
> - However, comparing float and double can produce unexpected results due to precision errors (check example below)

```java
int x = 10;
double y = 10.0;
System.out.println(x == y);  // true → x promoted to double (10.0)


double d = 0.1 + 0.2;
System.out.println(d == 0.3); // false → floating-point rounding issue
```

#### 5.7.5.2 Equality with Reference Types (Objects)

For objects, == and != compare references, not object content.
They return true only if both references point to the exact same object in memory.

```java
String s1 = new String("Java");
String s2 = new String("Java");
System.out.println(s1 == s2);      // false → different objects in memory
System.out.println(s1 != s2);      // true  → not the same reference
```

Even if two objects have identical content, == compares their **addresses**, not values.
To compare the **contents** of objects, use the **.equals()** method instead.

```java
System.out.println(s1.equals(s2)); // true → same string content
```

**Special Case: null and String Literals**

- Any reference can be compared with null using == or !=.

```java
String text = null;
System.out.println(text == null);  // true
```

- String literals are interned by the Java Virtual Machine (JVM):
This means identical literal strings may point to the same reference in memory:

 ```java
String a = "Java";
String b = "Java";
System.out.println(a == b);       // true → same interned literal
```

- Equality with Mixed Types:
When using == between operands of different categories (e.g., primitive vs. object),
the compiler tries to perform unboxing if one of them is a **wrapper class**.

```java
Integer i = 100;
int j = 100;
System.out.println(i == j);   // true → unboxed before comparison
```

### 5.7.6 The `instanceof` Operator
 
`instanceof` is a **relational operator** that tests whether a reference value is an **instance of** a given **reference type** at runtime.  
It returns a `boolean`.

```java
Object o = "Java";
boolean b1 = (o instanceof String);   // true
boolean b2 = (o instanceof Number);   // false
```

**null** behavior:
If expr is null, **expr instanceof Type** is always **false**.

```java
Object n = null;
System.out.println(n instanceof Object);  // false
```

#### 5.7.6.1 Compile-Time Check vs Runtime Check

- At compile time, the compiler rejects inconvertible types (types that cannot possibly relate at runtime).
- At runtime, if the compile-time check passed, the JVM evaluates the actual object type.

```java
// ❌ Compile-time error: inconvertible types (String is unrelated to Integer)

boolean bad = ("abc" instanceof Integer);

// ✅ Compiles, but runtime result depends on actual object:

Number num = Integer.valueOf(10);
System.out.println(num instanceof Integer); // true at runtime
System.out.println(num instanceof Double);  // false at runtime
```

#### 5.7.6.2 Pattern Matching for instanceof

Java supports type patterns with instanceof, which both test and bind the variable when the test succeeds.
Adding a variable after the type instructs the compiler to treat it as Pattern Matching

Syntax (pattern form):

```java
Object obj = "Hello";

if (obj instanceof String str) {
	// Adding the variable str after the type instructs the compiler to treat it as Pattern Matching
	
    System.out.println(str.toUpperCase()); // identifier is in scope here, of type Type: (safe: str is a String here). 
}
```

Key properties

- If the test succeeds, the pattern variable (e.g., s) is definitely assigned and in scope in the true branch.
- Pattern variables are implicitly final (cannot be reassigned).
- The name must not clash with an existing variable in the same scope.


#### 5.7.6.3 Flow Scoping & Short-Circuit Logic

- Pattern variables become available based on flow analysis:

```java
Object obj = "data";

// Negated test, variable available in the else branch
if (!(obj instanceof String s)) {
    // s not in scope here
} else {
    System.out.println(s.length()); // s is in scope here
}

// With &&, pattern variable can be used on the right side if the left side established it
if (obj instanceof String s && s.length() > 3) {
    System.out.println(s.substring(0, 3)); // s in scope
}

// With ||, the pattern variable is NOT safe on the right side (short-circuit may fail to establish it)
if (obj instanceof String s || s.length() > 3) {  // ❌ s not in scope here
    // ...
}

// Parentheses can help group logic
if ((obj instanceof String s) && s.contains("a")) { // ✅ s in scope after grouped test
    System.out.println(s);
}
```

- Pattern matching with `null` evaluates, like always for `instanceof`, to `false`

```java
String str = null;

// Regular instanceof
if (str instanceof String) {  
	System.out.print("NOT EXECUTED"); // instanceof evaluates to false
}

// Pattern matching
if (str instanceof String s) {  
	System.out.print("NOT EXECUTED"); // instanceof still evaluates to false
}
```

- Supported Types

The type of the pattern variable must be a subtype, a supertype or of the same type of the reference variable.

```java
Number num = Short.valueOf(10);

if (num instanceof String s) {}  // ❌ Compile-time error
if (num instanceof Short s) {}   // ✅ Ok
if (num instanceof Object s) {}  // ✅ Ok
if (num instanceof Number s) {}  // ✅ Ok

```

#### 5.7.6.4 Arrays and Reifiable Types

instanceof works with arrays (which are reifiable) and with erased or wildcard generic forms.
**Reifiable types** are those whose runtime representation fully preserves their type (e.g., raw types, arrays, non-generic classes, wildcard ?). 
Due to type erasure, List<String> cannot be tested directly at runtime.

```java
Object arr = new int[]{1,2,3};
System.out.println(arr instanceof int[]); // true

Object list = java.util.List.of(1,2,3);
// System.out.println(list instanceof List<Integer>); // ❌ Compile-time error: parameterized type not reifiable
System.out.println(list instanceof java.util.List<?>); // ✅ true
```

---

## 5.8 Ternary Operator

The **ternary operator** (`? :`) is the only operator in Java that takes **three operands**.  
It acts as a concise form of an `if-else` statement.

### 5.8.1 Syntax
```java
condition ? expressionIfTrue : expressionIfFalse;
```

### 5.8.2 Example

```java
int age = 20;
String access = (age >= 18) ? "Allowed" : "Denied";
System.out.println(access);  // "Allowed"
```

### 5.8.3 Nested Ternary Example

```java
int score = 85;
String grade = (score >= 90) ? "A" :
               (score >= 75) ? "B" :
               (score >= 60) ? "C" : "F";
System.out.println(grade);  // "B"
```

### 5.8.4 Notes

> [!WARNING]
> - Nested ternary expressions can reduce readability. Use parentheses for clarity.  
> - The ternary operator returns a **value**, unlike `if-else`, which is a statement.
