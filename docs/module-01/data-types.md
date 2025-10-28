# Java Data Types

As we saw before in the [Module 1: Syntax Building Blocks](syntax-building-blocks.md), Java has two categories of data types:

- **Primitive types**  
- **Reference types**

👉 For a complete overview of primitive types with their sizes, ranges, defaults, and examples, see the [Primitive Types Table](#primitive-types-table).

---

## 1. Primitive Types

Primitives represent **single raw values** stored directly in memory.  
Each primitive type has a fixed size that determines how many bytes it occupies.

Conceptually, a primitive is just a **cell in memory** holding a value:

```
+-------+
|  42   |   ← value of type short (2 bytes in memory)
+-------+
```

---

## 2. Reference Types

A reference type does not hold the object itself, but a **reference (pointer)** to it.  
The reference has a fixed size (JVM-dependent, often 4 or 8 bytes), which points to a memory location where the actual object is stored.

Example: a `String` reference variable points to a string object in the heap, which internally is composed of an array of `char` primitives.

Diagram:

```
Reference (4 or 8 bytes)
+---------+
| address | ───────────────►  Object in Heap
+---------+                  +-------------------+
                             |   "Hello"         |
                             | ['H','e','l','l','o']  ← array of char
                             +-------------------+
```

---

## 3. Primitive Types Table

| Keyword  | Type      | Size      | Min Value                  | Max Value                  | Default Value | Example |
|----------|-----------|-----------|----------------------------|----------------------------|---------------|---------|
| `byte`   | 8-bit int | 1 byte    | –128                       | 127                        | 0             | `byte b = 100;` |
| `short`  | 16-bit int| 2 bytes   | –32,768                    | 32,767                     | 0             | `short s = 2000;` |
| `int`    | 32-bit int| 4 bytes   | –2,147,483,648 (`–2^31`)   | 2,147,483,647 (`2^31–1`)   | 0             | `int i = 123456;` |
| `long`   | 64-bit int| 8 bytes   | –2^63                      | 2^63–1                     | 0L            | `long l = 123456789L;` |
| `float`  | 32-bit FP | 4 bytes   | see note                   | see note                   | 0.0f          | `float f = 3.14f;` |
| `double` | 64-bit FP | 8 bytes   | see note                   | see note                   | 0.0          | `double d = 2.718;` |
| `char`   | UTF-16    | 2 bytes   | `'\u0000'` (0)             | `'\uffff'` (65,535)        | `'\u0000'`    | `char c = 'A';` |
| `boolean`| true/false| JVM-dep. (often 1 byte) | `false` | `true` | false | `boolean b = true;` |

---

### Notes

`float` and `double` do not have fixed integer bounds like integral types.  
Instead, they follow the IEEE 754 standard:

- **Smallest positive nonzero values**:  
  - `Float.MIN_VALUE ≈ 1.4E–45`  
  - `Double.MIN_VALUE ≈ 4.9E–324`  

- **Largest finite values**:  
  - `Float.MAX_VALUE ≈ 3.4028235E+38`  
  - `Double.MAX_VALUE ≈ 1.7976931348623157E+308`  

They also support special values: **`+Infinity`**, **`-Infinity`**, and **`NaN`** (Not a Number).

- **FP** = floating point.  
- `boolean` size is JVM-dependent but behaves logically as `true`/`false`.  
- Default values apply to **fields** (class variables). Local variables must be explicitly initialized before use.

---

## Recap

- **Primitive** = actual value, stored directly in memory.  
- **Reference** = pointer to an object; the object itself may contain primitives and other references.  
- For details of primitives, see the [Primitive Types Table](#primitive-types-table).

---

## 4. Arithmetic and Primitive Numeric Promotion

When applying arithmetic or comparison operators to **primitive data types**, Java automatically converts (or *promotes*) values to compatible types according to well-defined **numeric promotion rules**.

These rules ensure consistent calculations and prevent data loss when mixing different numeric types.

---

### 🔹 Numeric Promotion Rules in Java

#### **Rule 1 – Mixed Data Types → Smaller type promoted to larger type**

If two operands belong to **different numeric data types**, Java automatically promotes the **smaller** type to the **larger** type before performing the operation.

| Example | Explanation |
|----------|--------------|
| `int x = 10; double y = 5.5;`<br>`double result = x + y;` | The `int` value `x` is promoted to `double`, so the result is a `double` (`15.5`). |

**Valid type promotion order (smallest → largest):**  
`byte → short → int → long → float → double`

---

#### **Rule 2 – Integral + Floating-point → Integral promoted to floating-point**

If one operand is an **integral type** (`byte`, `short`, `char`, `int`, `long`) and the other is a **floating-point type** (`float`, `double`),  
the **integral value is promoted** to the **floating-point** type before the operation.

| Example | Explanation |
|----------|--------------|
| `float f = 2.5F; int n = 3;`<br>`float result = f * n;` | `n` (int) is promoted to `float`. The result is a `float` (`7.5`). |
| `double d = 10.0; long l = 3;`<br>`double result = d / l;` | `l` (long) is promoted to `double`. The result is a `double` (`3.333...`). |

---

#### **Rule 3 – `byte`, `short`, and `char` are promoted to `int` during arithmetic**

When performing arithmetic **with variables** (not literal constants) of type `byte`, `short`, or `char`,  
Java automatically promotes them to **`int`**, even if **both operands are smaller than `int`**.

| Example | Explanation |
|----------|--------------|
| `byte a = 10, b = 20;`<br>`byte c = a + b;` | ❌ Compile-time error: result of `a + b` is `int`, not `byte`. Must cast → `byte c = (byte)(a + b);` |
| `short s1 = 1000, s2 = 2000;`<br>`short sum = (short)(s1 + s2);` | The operands are promoted to `int`, so explicit casting is required to assign to `short`. |
| `char c1 = 'A', c2 = 2;`<br>`int result = c1 + c2;` | `'A'` (65) and `2` are promoted to `int`, result = `67`. |

> [!NOTE]  
> This rule applies only when **using variables**.  
> When **using constant literals**, the compiler can sometimes evaluate the expression at compile time and assign it safely.

```java
byte a = 10 + 20;   // ✅ OK: constant expression fits in byte
byte b = 10;
byte c = 20;
byte d = b + c;     // ❌ Error: b + c is evaluated at runtime → int
```

---

#### **Rule 4 – Result type matches the promoted operand type**

After promotions are applied, and both operands are of the same type,  
the **result** of the expression has that **same promoted type**.

| Example | Explanation |
|----------|--------------|
| `int i = 5; double d = 6.0;`<br>`var result = i * d;` | `i` is promoted to `double`, result is `double`. |
| `float f = 3.5F; long l = 4L;`<br>`var result = f + l;` | `l` is promoted to `float`, result is `float`. |
| `int x = 10, y = 4;`<br>`var div = x / y;` | Both are `int`, result = `int` (`2`), fractional part truncated. |

> [!WARNING]  
> Integer division always produces an **integer result**.  
> To obtain a decimal result, **at least one operand must be floating-point**:
> ```java
> double result = 10.0 / 4; // ✅ 2.5
> int result = 10 / 4;      // ❌ 2 (fraction discarded)
> ```

---

### ✅ Summary of Numeric Promotion Behavior

| Situation | Promotion Result | Example |
|------------|------------------|----------|
| Mixing smaller and larger numeric types | Smaller type promoted to larger | `int + double → double` |
| Integral + Floating-point | Integral promoted to floating-point | `long + float → float` |
| `byte`, `short`, `char` arithmetic | Promoted to `int` | `byte + byte → int` |
| Result after promotion | Result matches promoted type | `float + long → float` |

---

### 🧠 Key Takeaways

- Always consider **type promotion** when mixing data types in arithmetic.  
- For smaller types (`byte`, `short`, `char`), promotion to `int` is automatic and unavoidable.  
- Use **explicit casting** only when you are sure the result fits the target type.  
- Remember: **integer division truncates**, **floating-point division keeps decimals**.  
- Understanding promotion rules is crucial for avoiding **unexpected precision loss** or **compile-time errors** during the Java certification exam.


