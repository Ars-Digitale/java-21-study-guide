# Java Data Types

As we saw before in the [Module 1: Syntax Building Blocks](module-01-syntax-building-blocks.md), Java has two categories of data types:

- **Primitive types**  
- **Reference types**

👉 For a complete overview of primitive types with their sizes, ranges, defaults, and examples, see the [Primitive Types Table](#primitive-types-table).

---

## Primitive Types

Primitives represent **single raw values** stored directly in memory.  
Each primitive type has a fixed size that determines how many bytes it occupies.

Conceptually, a primitive is just a **cell in memory** holding a value:

```
+-------+
|  42   |   ← value of type short (2 bytes in memory)
+-------+
```

---

## Reference Types

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

## Primitive Types Table

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

## Summary

- **Primitive** = actual value, stored directly in memory.  
- **Reference** = pointer to an object; the object itself may contain primitives and other references.  
- For details of primitives, see the [Primitive Types Table](#primitive-types-table).

---
