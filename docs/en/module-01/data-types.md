# 4. Java Data Types and Casting

### Table of Contents

- [4. Java Data Types and Casting](#4-java-data-types-and-casting)
  - [4.1 Primitive Types](#41-primitive-types)
  - [4.2 Reference Types](#42-reference-types)
  - [4.3 Primitive Types Table](#43-primitive-types-table)
  - [4.4 Notes](#44-notes)
  - [4.5 Recap](#45-recap)
  - [4.6 Arithmetic and Primitive Numeric Promotion](#46-arithmetic-and-primitive-numeric-promotion)
    - [4.6.1 Numeric Promotion Rules in Java](#461-numeric-promotion-rules-in-java)
      - [4.6.1.1 Rule 1 – Mixed Data Types → Smaller type promoted to larger type](#4611-rule-1--mixed-data-types--smaller-type-promoted-to-larger-type)
      - [4.6.1.2 Rule 2 – Integral + Floating-point → Integral promoted to floating-point](#4612-rule-2--integral--floating-point--integral-promoted-to-floating-point)
      - [4.6.1.3 Rule 3 – byte short and char are promoted to int during arithmetic](#4613-rule-3--byte-short-and-char-are-promoted-to-int-during-arithmetic)
      - [4.6.1.4 Rule 4 – Result type matches the promoted operand type](#4614-rule-4--result-type-matches-the-promoted-operand-type)
    - [4.6.2 Summary of Numeric Promotion Behavior](#462-summary-of-numeric-promotion-behavior)
      - [4.6.2.1 Key Takeaways](#4621-key-takeaways)
  - [4.7 Casting in Java](#47-casting-in-java)
    - [4.7.1 Primitive Casting](#471-primitive-casting)
      - [4.7.1.1 Widening Implicit Casting](#4711-widening-implicit-casting)
      - [4.7.1.2 Narrowing Explicit Casting](#4712-narrowing-explicit-casting)
    - [4.7.2 Data Loss Overflow and Underflow](#472-data-loss-overflow-and-underflow)
    - [4.7.3 Casting Values versus Variable](#473-casting-values-versus-variable)
    - [4.7.4 Reference Casting Objects](#474-reference-casting-objects)
      - [4.7.4.1 Upcasting Widening Reference Cast](#4741-upcasting-widening-reference-cast)
      - [4.7.4.2 Downcasting Narrowing Reference Cast](#4742-downcasting-narrowing-reference-cast)
    - [4.7.5 Key Points Summary](#475-key-points-summary)
    - [4.7.6 Examples](#476-examples)

---

As we saw before in the [Syntax Building Blocks](syntax-building-blocks.md), Java has two categories of data types:

- **Primitive types**  
- **Reference types**

👉 For a complete overview of primitive types with their sizes, ranges, defaults, and examples, see the [Primitive Types Table](#primitive-types-table).


## 4.1 Primitive Types

Primitives represent **single raw values** stored directly in memory.  
Each primitive type has a fixed size that determines how many bytes it occupies.

Conceptually, a primitive is just a **cell in memory** holding a value:

```
+-------+
|  42   |   ← value of type short (2 bytes in memory)
+-------+
```

---

## 4.2 Reference Types

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

## 4.3 Primitive Types Table

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

## 4.4 Notes

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

## 4.5 Recap

- **Primitive** = actual value, stored directly in memory.  
- **Reference** = pointer to an object; the object itself may contain primitives and other references.  
- For details of primitives, see the [Primitive Types Table](#primitive-types-table).

---

## 4.6 Arithmetic and Primitive Numeric Promotion

When applying arithmetic or comparison operators to **primitive data types**, Java automatically converts (or *promotes*) values to compatible types according to well-defined **numeric promotion rules**.

These rules ensure consistent calculations and prevent data loss when mixing different numeric types.

---

### 4.6.1 🔹 Numeric Promotion Rules in Java

#### 4.6.1.1 **Rule 1 – Mixed Data Types → Smaller type promoted to larger type**

If two operands belong to **different numeric data types**, Java automatically promotes the **smaller** type to the **larger** type before performing the operation.

| Example | Explanation |
|----------|--------------|
| `int x = 10; double y = 5.5;`<br>`double result = x + y;` | The `int` value `x` is promoted to `double`, so the result is a `double` (`15.5`). |

**Valid type promotion order (smallest → largest):**  
`byte → short → int → long → float → double`

---

#### 4.6.1.2 **Rule 2 – Integral + Floating-point → Integral promoted to floating-point**

If one operand is an **integral type** (`byte`, `short`, `char`, `int`, `long`) and the other is a **floating-point type** (`float`, `double`),  
the **integral value is promoted** to the **floating-point** type before the operation.

| Example | Explanation |
|----------|--------------|
| `float f = 2.5F; int n = 3;`<br>`float result = f * n;` | `n` (int) is promoted to `float`. The result is a `float` (`7.5`). |
| `double d = 10.0; long l = 3;`<br>`double result = d / l;` | `l` (long) is promoted to `double`. The result is a `double` (`3.333...`). |

---

#### 4.6.1.3 **Rule 3 – `byte`, `short`, and `char` are promoted to `int` during arithmetic**

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

#### 4.6.1.4 **Rule 4 – Result type matches the promoted operand type**

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

### 4.6.2 ✅ Summary of Numeric Promotion Behavior

| Situation | Promotion Result | Example |
|------------|------------------|----------|
| Mixing smaller and larger numeric types | Smaller type promoted to larger | `int + double → double` |
| Integral + Floating-point | Integral promoted to floating-point | `long + float → float` |
| `byte`, `short`, `char` arithmetic | Promoted to `int` | `byte + byte → int` |
| Result after promotion | Result matches promoted type | `float + long → float` |

---

#### 4.6.2.1 🧠 Key Takeaways

- Always consider **type promotion** when mixing data types in arithmetic.  
- For smaller types (`byte`, `short`, `char`), promotion to `int` is automatic when operands of an arithmetic operation containing variables.  
- Use **explicit casting** only when you are sure the result fits the target type.  
- Remember: **integer division truncates**, **floating-point division keeps decimals**.  
- Understanding promotion rules is crucial for avoiding **unexpected precision loss** or **compile-time errors** during the Java certification exam.

---

## 4.7 Casting in Java

**Casting** in Java is the process of **explicitly converting a value from one data type to another**.  
It allows a variable of one type to be **interpreted as another compatible type** either among **primitive types** or **reference types** within an inheritance hierarchy.

---

### 4.7.1 🔹 Primitive Casting

Primitive casting changes the data type of a **numeric value**.  
There are two kinds of primitive casting: **widening** and **narrowing**.

| Type | Description | Example | Explicit? | Risk |
|------|--------------|----------|------------|------|
| **Widening** | Converts a smaller type to a larger type | `int → double` | ❌ No | Safe |
| **Narrowing** | Converts a larger type to a smaller type | `double → int` | ✅ Yes | Possible data loss |

#### 4.7.1.1 Widening (Implicit) Casting**

Automatic conversion from a smaller to a larger compatible type.  
Handled by the compiler; no explicit syntax is required.

```java
int i = 100;
double d = i;   // implicit cast: int → double
System.out.println(d); // 100.0
```

✅ **Safe** – no data loss or overflow.

#### 4.7.1.2 Narrowing (Explicit) Casting**

Manual conversion from a larger type to a smaller type.  
Requires explicit syntax because data may be lost.

```java
double d = 9.78;
int i = (int) d;   // explicit cast: double → int
System.out.println(i); // 9
```

### 4.7.2 Data Loss, Overflow, and Underflow

In Java, **data loss** can occur when a value exceeds the storage capacity or precision of its data type.  
When performing arithmetic operations or explicit type casts, values may **overflow**, **underflow**, or **truncate**.

- **Overflow** happens when a result is **greater than the maximum** value of the type: 

```java
int x = Integer.MAX_VALUE + 1; // wraps to -2147483648

// When the number is too large to fit within the data type java "wraps around" to the lowest negative value of that type and start up counting from there 
```

- **Underflow** happens when a result is less than the minimum value of the type:

```java
int y = Integer.MIN_VALUE - 1; // wraps to 2147483647
```

- **Data truncation** occurs in narrowing conversions, where precision is lost:

```java
double d = 9.99;
int i = (int) d; // 9 (fraction dropped)
```
> [!NOTE]  
> Floating-point types (float, double) don’t wrap around; overflow results in Infinity, and underflow in 0.0.

### 4.7.3  Casting Values versus Variable

Even though Java interprets integer numeric literals as `int` by default, the compiler does NOT require casting when working with literals values that fit into the data type;

> [!NOTE]  
> (Floating-point numeric literals are interpreted by default as `double`

- Example:

```java
byte first = 10;		// OK
short second = 9 * 10;	// OK

long a = 5729685479;   // ❌ error: int literal out of range
long b = 5729685479L;  // ✅ long literal

float c = 3.14;        // ❌ error: double → float requires suffix or cast
float d = 3.14F;       // ✅ float literal

int e = 0x7FFF_FFFF;   // ✅ fits in int
int f = 0x8000_0000;   // ❌ error: out of int range (needs L)

double g = 1e3;        // ✅ double (1000.0)
float  h = 1e3F;       // ✅ float  (1000.0f)
```

Conversely, for the third rule we saw before [Promotion of variables to int with arithmetic operators](#rule-3--byte-short-and-char-are-promoted-to-int-during-arithmetic), when dealing with arithmetic operations with variables,
both operands are automatically promoted to `int`;

- Example:

```java
byte first = 10;		
short second = 9 + first;				// ❌ error: both operand are automatically promoted to int because the second operand in a variable

short second = (short) ( 9 + first ); 	// NOW OK 

short b = 10;	
short a = 5 + (short) b; 				// ❌ error: both operand are automatically promoted to int because the second operand in a variable

```
> [!WARNING]  
> Casting is a unary operation: without the parentheses enclosing (9 + first) it would only be applied to 9  

---

### 4.7.4 🔹 Reference Casting (Objects)

Casting also applies to **object references** within inheritance hierarchies.  
It doesn’t change the actual object in memory, only how it is interpreted by the program.

When dealing with "Object & References" you sou should keep in mind that:

- The object's actual type determines which properties the object contains in memory.
- The type of the reference used to access the object determines which methods and fields the Java program is allowed to access. 

#### 4.7.4.1 Upcasting (Widening Reference Cast)**

Conversion from a subclass reference to a superclass type.  
This is **implicit and always safe** because every subclass is an instance of its superclass.

```java
class Animal { }
class Dog extends Animal { }

Dog dog = new Dog();
Animal a = dog;  // implicit upcast
```

✅ Safe: `Dog` *is an* `Animal`.

#### 4.7.4.2 Downcasting (Narrowing Reference Cast)**

Conversion from a superclass reference back to a subclass type.  
This is **explicit** and may fail at runtime if the object is not actually an instance of the subclass.

```java
Animal a = new Dog();
Dog d = (Dog) a;   // explicit downcast → OK

Animal x = new Animal();
Dog d2 = (Dog) x;  // ⚠️ Runtime error: ClassCastException
```

Use the `instanceof` operator to check before casting:

```java
if (x instanceof Dog) {
    Dog safeDog = (Dog) x;
}
```

---

### 4.7.5 🧠 **Key Points Summary**

| Casting Type | Applies To | Direction | Syntax | Safe? | Performed By |
|---------------|-------------|------------|---------|--------|---------------|
| Widening Primitive | Primitives | small → large | Implicit | ✅ Yes | Compiler |
| Narrowing Primitive | Primitives | large → small | Explicit | ⚠️ No | Programmer |
| Upcasting | Objects | subclass → superclass | Implicit | ✅ Yes | Compiler |
| Downcasting | Objects | superclass → subclass | Explicit | ⚠️ Runtime check | Programmer |

---

### 4.7.6 ✅ **Examples**

```java
// Primitive casting
short s = 50;
int i = s;          // widening
byte b = (byte) i;  // narrowing

// Object casting
Object obj = "Hello";
String str = (String) obj; // OK, obj actually refers to a String
Object n = Integer.valueOf(10);
// String fail = (String) n;  // Runtime error: ClassCastException
```

---

**In summary:**  
- Casting is the mechanism to convert one type to another.  
- **Primitive casting** changes numeric types.  
- **Reference casting** changes the view of an object in a class hierarchy.  
- **Upcasting** is safe and implicit; **downcasting** must be checked and explicit.  
- Use `instanceof` to avoid runtime exceptions during downcasting.
