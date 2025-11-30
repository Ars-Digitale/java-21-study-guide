# Standard APIs

### 1. Strings

### 1.1 Rules for String Concatenation

As introduced in the chapter on  
[Java Operators](../module-01/java-operators.md), the symbol `+` normally represents **arithmetic addition** when used with numeric operands.  

However, when applied to **Strings**, the same operator performs **string concatenation** — that is, it creates a new string by joining operands together.

Since the operator `+` may appear in expressions where both **numbers** and **strings** are present, Java applies a specific set of rules to determine whether `+` means *numeric addition* or *string concatenation*.

### **Concatenation Rules**

1. **If both operands are numeric**, `+` performs **numeric addition**.

2. **If at least one operand is a `String`**, the `+` operator performs **string concatenation**.

3. **Evaluation is strictly left-to-right**, because `+` is **left-associative**.  
   This means that once a `String` appears on the left side of the expression, all subsequent `+` operations become concatenations.

> [!TIPS]
> Because evaluation is left-to-right, the position of the first String operand determines the rest of the expression.

Examples

```java

// *** Pure numeric addition

int a = 10 + 20;        // 30
double b = 1.5 + 2.3;   // 3.8



// *** String concatenation when at least one operand is a String

String s = "Hello" + " World";  // "Hello World"
String t = "Value: " + 10;      // "Value: 10"



// *** Left-to-right evaluation affects the result

System.out.println(1 + 2 + " apples"); 
// 3 + " apples"  → "3 apples"

System.out.println("apples: " + 1 + 2); 
// "apples: 1" + 2 → "apples: 12"



// *** Adding parentheses changes the meaning

System.out.println("apples: " + (1 + 2)); 
// parentheses force numeric addition → "apples: 3"



// *** Mixed types with multiple operands

String result = 10 + 20 + "" + 30 + 40;
// (10 + 20) = 30
// 30 + ""  = "30"
// "30" + 30 = "3030"
// "3030" + 40 = "303040"

System.out.println(1 + 2 + "3" + 4 + 5);
// Step 1: 1 + 2 = 3
// Step 2: 3 + "3" = "33"
// Step 3: "33" + 4 = "334"
// Step 4: "334" + 5 = "3345"



// *** null is represented as a string when concatenated

System.out.println("AB" + null);
// ABnull
```

### 1.2 Relevant String methods

#### Strings — Indexing, Length, and Core Methods

Java’s `String` class represents **immutable** sequences of Unicode characters.  
Let's understanding indexing rules and how Java handles substring boundaries.


#### 1.2.1 String Indexing

Strings in Java use **zero-based indexing**, meaning:

- The **first** character is at index **0**
- The **last** character is at index **length() - 1**
- Accessing any index outside this range causes a  
  **`StringIndexOutOfBoundsException`**

Example:
```java
String s = "Java";
// Indexes:  0    1    2    3
// Chars:    J    a    v    a

char c = s.charAt(2); // 'v'
```


#### 1.2.2 `length()` Method

`length()` returns the **number of characters** in the string.

```java
String s = "hello";
System.out.println(s.length());  // 5
```

- The last valid index is `length() - 1`.


#### 1.2.3 Boundary Rules: Start Index vs End Index

Many String methods use **two indices**:

- ✔️ Start index — **inclusive**  
- ✔️ End index — **exclusive**

Meaning:

substring(start, end) includes characters from index start up to BUT NOT including index end.

- **Start index must be ≥ 0 and ≤ length() - 1**
- **End index may be equal to `length()`** (the “invisible end-of-string position” when "End index exclusive" apply)
- **End index must not exceed `length()`**
- **Start index must never be greater than end index**


Example:
```java
String s = "abcdef";
s.substring(1, 4); // "bcd" (indexes 1,2,3)
```

This rule applies to most substring-based methods.


#### 1.2.4 String Methods 

A structured and complete classification.


#### 1.2.5 Methods Using Only Start Index (Inclusive)

| Method | Description | Parameters | Index Rule | Example |
|--------|-------------|------------|------------|---------|
| `substring(int start)` | Returns substring from `start` to end | start | start = inclusive | `"abcdef".substring(2)` → `"cdef"` |
| `indexOf(String)` | First occurrence | — | — | `"Java".indexOf("a")` → 1 |
| `indexOf(String, start)` | Start searching at index | start | start = inclusive | `"banana".indexOf("a", 2)` → 3 |
| `lastIndexOf(String)` | Last occurrence | — | — | `"banana".lastIndexOf("a")` → 5 |
| `lastIndexOf(String, fromIndex)` | Search backward from index | fromIndex | fromIndex = inclusive | `"banana".lastIndexOf("a", 3)` → 3 |


#### 1.2.6 Methods with Start Inclusive / End Exclusive

These methods follow the same slicing behavior:

**start included**, **end excluded**

| Method | Description | Signature | Example |
|--------|-------------|-----------|---------|
| `substring(start, end)` | Extracts part of string | `(int start, int end)` | `"abcdef".substring(1,4)` → `"bcd"` |
| `regionMatches` | Compare substring regions | `(toffset, other, ooffset, len)` | `"Hello".regionMatches(1, "ell", 0, 3)` → `true` |
| `getBytes(int srcBegin, int srcEnd, byte[] dst, int dstBegin)` | Copies chars to byte array | start inclusive, end exclusive | Copies chars in `[srcBegin, srcEnd)` |
| `copyValueOf(char[] data, int offset, int count)` | Creates a new string | offset inclusive; offset+count exclusive | same rule as substring |


#### 1.2.7 Methods That Operate on Entire String

| Method | Description | Example |
|--------|-------------|---------|
| `toUpperCase()` | Uppercase version | `"java".toUpperCase()` → `"JAVA"` |
| `toLowerCase()` | Lowercase version | `"JAVA".toLowerCase()` → `"java"` |
| `trim()` | Removes leading/trailing whitespace | `"  hi  ".trim()` → `"hi"` |
| `strip()` | Unicode-aware trimming | `"  hi\u2003".strip()` → `"hi"` |
| `stripLeading()` | Removes leading whitespace | `"  hi".stripLeading()` → `"hi"` |
| `stripTrailing()` | Removes trailing whitespace | `"hi  ".stripTrailing()` → `"hi"` |
| `isBlank()` | Empty or whitespace only | `"  ".isBlank()` → `true` |
| `isEmpty()` | Length == 0 | `"".isEmpty()` → `true` |


#### 1.2.8 Character Access

| Method | Description | Example |
|--------|-------------|---------|
| `charAt(int index)` | Returns char at index | `"Java".charAt(2)` → `'v'` |
| `codePointAt(int index)` | Unicode code point | useful for emojis |


#### 1.2.9 Searching

| Method | Description | Example |
|--------|-------------|---------|
| `contains(CharSequence)` | Substring test | `"hello".contains("ell")` → `true` |
| `startsWith(String)` | Prefix | `"abcdef".startsWith("abc")` → `true` |
| `startsWith(String, offset)` | Prefix at given index | `"abc".startsWith("b", 1)` → `true` |
| `endsWith(String)` | Suffix | `"abcdef".endsWith("def")` → `true` |


#### 1.2.10 Replacement Methods

| Method | Description | Example |
|--------|-------------|---------|
| `replace(char old, char new)` | Replace characters | `"banana".replace('a','o')` → `"bonono"` |
| `replace(CharSequence old, CharSequence new)` | Replace substrings | `"ababa".replace("aba","X")` → `"Xba"` |
| `replaceAll` | Regex replace all | `"a1a2".replaceAll("\\d","")` → `"aa"` |
| `replaceFirst` | First regex match only | `"a1a2".replaceFirst("\\d","")` → `"aa2"` |


#### 1.2.11 Splitting and Joining

| Method | Description | Example |
|--------|-------------|---------|
| `split(String regex)` | Split by regex | `"a,b,c".split(",")` → `["a","b","c"]` |
| `split(String regex, limit)` | Controlled split | limit < 0 keeps all |


#### 1.2.12 Methods Returning Arrays

| Method | Description | Example |
|--------|-------------|---------|
| `toCharArray()` | char[] | `"abc".toCharArray()` |
| `getBytes()` | byte[] from encoding | `"á".getBytes()` |


#### 1.2.13 Indentation

| Method | Description | Example |
|--------|-------------|---------|
| `indent(int numSpaces)` | add (positive numSpaces) or removes (negative numSpaces) the provided amount of blank spaces from the beginning of each line; A line break is also added, to the end of the string if not already present | `"abc".toCharArray()` |
| `getBytes()` | byte[] from encoding | `"á".getBytes()` |

#### 1.2.13 Additional Examples

Example 1 — Extract `[start, end)`
```java
String s = "012345";
System.out.println(s.substring(2, 5));
// includes 2,3,4 → prints "234"
```

Example 2 — Searching from a start index
```java
String s = "hellohello";
int idx = s.indexOf("lo", 5); // search begins at index 5
```

Example 3 — Common Pitfall
```java
String s = "abcd";
System.out.println(s.substring(1,1)); // "" empty string
System.out.println(s.substring(3, 2)); // ❌ Exception: start index (3) > end index (2)

System.out.println("abcd".substring(2, 4)); // "cd" — includes indexes 2 and 3; 4 is excluded but legal here

System.out.println("abcd".substring(2, 5)); // ❌ StringIndexOutOfBoundsException (end index 5 is invalid)
```

