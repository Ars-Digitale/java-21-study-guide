# 11. Math in Java

### Table of Contents

- [11. Math in Java](#11-math-in-java)
  - [11.1 Math APIs](#111-math-apis)
    - [11.1.1 Maximum and Minimum Between Two Values](#1111-maximum-and-minimum-between-two-values)
    - [11.1.2 Math.round](#1112-mathround)
    - [11.1.3 Math.ceil Ceiling](#1113-mathceil-ceiling)
    - [11.1.4 Math.floor Floor](#1114-mathfloor-floor)
    - [11.1.5 Math.pow](#1115-mathpow)
    - [11.1.6 Math.random](#1116-mathrandom)
    - [11.1.7 Math.abs](#1117-mathabs)
    - [11.1.8 Math.sqrt](#1118-mathsqrt)
    - [11.1.9 Summary Table](#1119-summary-table)
  - [11.2 BigInteger and BigDecimal](#112-biginteger-and-bigdecimal)
    - [11.2.1 Why double and float Are Not Enough](#1121-why-double-and-float-are-not-enough)
    - [11.2.2 BigInteger — Arbitrary-Precision Integers](#1122-biginteger--arbitrary-precision-integers)
    - [11.2.3 Creating BigInteger](#1123-creating-biginteger)
    - [11.2.4 Operations No Operators](#1124-operations-no-operators)


---

## 11.1 Math APIs

The `java.lang.Math` class provides a set of static methods useful for numerical operations. 
These methods work with primitive numeric types. 
Below is a summary of the most frequently used ones, together with their overloaded forms.


### 11.1.1 `Maximum` and `Minimum` between two values

Math.max() and Math.min() compare the two provided values and return the `Max` or `Min` between them;
There are 4 overloaded versions for each method:

```java
public static int min(int x, int y);
public static float min(float x, float y);
public static long min(long x, long y);
public static double min(double x, double y);

public static int max(int x, int y);
public static float max(float x, float y);
public static long max(long x, long y);
public static double max(double x, double y);
```

Example:
```java
System.out.println(Math.max(10.50, 7.5));   // 10.5
System.out.println(Math.min(10, -20));		// -20
```

### 11.1.2 `Math.round()`

`round()` returns the **nearest integer** to its argument, following standard rounding rules  
(0.5 and above → up, below 0.5 → down).

Overloads:
- `long round(double value)`
- `int round(float value)`


Examples:
```java
Math.round(3.2);    // 3   (returns long)
Math.round(3.6);    // 4
Math.round(-3.5f);  // -3  (float version returns int)
```

Note:  
- The **float** version returns an `int`  
- The **double** version returns a `long`

(e.g., `round(float)` returns an `int`, while `round(double)` returns a `long`)

### 11.1.3 `Math.ceil()` (Ceiling)

Returns the **smallest double** value that is **≥ argument**.

Overloads:
- `double ceil(double value)`

Examples:
```java
Math.ceil(3.1);   // 4.0
Math.ceil(-3.1);  // -3.0
```

### 11.1.4 `Math.floor()` (Floor)

Returns the **largest double** value that is **≤ argument**.

Overloads:
- `double floor(double value)`

Examples:
```java
Math.floor(3.9);   // 3.0
Math.floor(-3.1);  // -4.0
```

### 11.1.5 `Math.pow()`

Raises a value to a power.

Overloads:
- `double pow(double base, double exponent)`

Examples:
```java
Math.pow(2, 3);      // 8.0
Math.pow(9, 0.5);    // 3.0  (square root)
Math.pow(10, -1);    // 0.1
```


### 11.1.6 `Math.random()`

Returns a **double in the range [0.0, 1.0)**.

Overloads:
- `double random()`

Examples:
```java
double r = Math.random();   // 0.0 <= r < 1.0

// Example: random int 0–9
int x = (int)(Math.random() * 10);
```

### 11.1.7 `Math.abs()`
Absolute value.

Overloads:
- `int abs(int)`
- `long abs(long)`
- `float abs(float)`
- `double abs(double)`

### 11.1.8 `Math.sqrt()`
Square root, returns a `double`.

```java
Math.sqrt(9);    // 3.0
Math.sqrt(-1);   // NaN
```

### 11.1.9 Summary Table

| Method | Returns | Overloads | Notes |
|--------|---------|-----------|--------|
| `round()` | `int` or `long` | float, double | Nearest integer |
| `ceil()`  | double | double | Smallest ≥ value |
| `floor()` | double | double | Largest ≤ value |
| `pow()`   | double | double,double | Exponentiation |
| `random()` | double | none | 0.0 ≤ r < 1.0 |
| `min()`/`max()` | same type | int, long, float, double | Compare two values |
| `abs()` | same type | int, long, float, double | Absolute value |
| `sqrt()` | double | double | Square root |


## 11.2 BigInteger and BigDecimal

The classes `BigInteger` and `BigDecimal` (in java.math) provide arbitrary-precision number types.
They are used when:

- primitive types (int, long, double, etc.) don’t have enough range, or
- floating-point rounding errors of float/double are not acceptable (e.g. money, financial calculations).

Both are `immutable`: every operation returns a new instance.

### 11.2.1 Why double and float are not enough

Floating-point types (float, double) use a binary representation. Many decimal fractions can’t be represented exactly (like 0.1 or 0.2), so you get rounding errors:

```java
System.out.println(0.1 + 0.2); // 0.30000000000000004 
```

For tasks like financial calculations, this is unacceptable.
`BigDecimal` solves this by representing numbers using a decimal model with a configurable scale (number of digits after the decimal point).

### 11.2.2 BigInteger — Arbitrary-Precision Integers

BigInteger represents integer values of any size, limited only by memory.

### 11.2.3 Creating BigInteger

Common ways:

From a long:

    static BigInteger valueOf(long val)

From a String:

    BigInteger(String val)        // decimal by default
    BigInteger(String val, int radix)

Random big value:

    BigInteger(int numBits, Random rnd)


Examples:
```java
import java.math.BigInteger;
import java.util.Random;

BigInteger a = BigInteger.valueOf(10L);

// You can pass a long to either types, but double only to BigDecimal 

BigInteger g = BigInteger.valueOf(3000L);
BigDecimal p = BigDecimal.valueOf(3000L);
BigDecimal q = BigDecimal.valueOf(3000.00);

BigInteger b = new BigInteger("12345678901234567890"); // decimal string
BigInteger c = new BigInteger("FF", 16); // 255 in base 16
BigInteger r = new BigInteger(128, new Random()); // random 128-bit number
```

### 11.2.4 Operations (no operators!)

You cannot use `+`, `-`, `*`, `/`, `%` with BigInteger.
Instead, use methods (all return new instances):

- add(BigInteger val)
- subtract(BigInteger val)
- multiply(BigInteger val)
- divide(BigInteger val) – integer division
- remainder(BigInteger val)
- pow(int exponent)
- negate()
- abs()
- gcd(BigInteger val)
- compareTo(BigInteger val) – ordering

Example:
```java
BigInteger x = new BigInteger("100000000000000000000");
BigInteger y = new BigInteger("3");

BigInteger sum = x.add(y); // x + y
BigInteger prod = x.multiply(y); // x * y
BigInteger div = x.divide(y); // integer division
BigInteger rem = x.remainder(y); // modulus

if (x.compareTo(y) > 0) {
System.out.println("x is larger");
}
```
