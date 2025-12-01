# Standard APIs

### Table of Contents

- [Standard APIs]
	- [1 Strings & Text Blocks](#1-strings--text-blocks)
		- [1.1 Initializing Strings](#11-initializing-strings)
		- [1.2 Special Characters and Escape Sequences](#12-special-characters-and-escape-sequences)
		- [1.3 Text Blocks](#13-text-blocks-since-java-15)
		- [1.4 Essential vs Incidental Whitespace](#14-formatting-essential-vs-incidental-whitespace)
		- [1.5 Line Count, Blank Lines, and Line Breaks](#15-line-count-blank-lines-and-line-breaks)
		- [1.6 Text Blocks & Escape Characters](#16-text-blocks--escape-characters)
		- [1.7 Common Text Block Errors](#17-common-errors-with-fixes)
		- [1.8 Rules for String Concatenation](#18-rules-for-string-concatenation)
		- [1.9 Core String Methods](#19-core-string-methods)
		  - [1.9.1 String Indexing](#191-string-indexing)
		  - [1.9.2 `length()` Method](#192-length-method)
		  - [1.9.3 Boundary Rules: Start vs End Index](#193-boundary-rules-start-index-vs-end-index)
		  - [1.9.4 Classification of Methods](#194-string-methods)
		  - [1.9.5 Methods Using Only Start Index (Inclusive)](#195-methods-using-only-start-index-inclusive)
		  - [1.9.6 Methods with Start Inclusive / End Exclusive](#196-methods-with-start-inclusive--end-exclusive)
		  - [1.9.7 Methods Operating on Entire String](#197-methods-that-operate-on-entire-string)
		  - [1.9.8 Character Access](#198-character-access)
		  - [1.9.9 Searching Methods](#199-searching)
		  - [1.9.10 Replacement Methods](#1910-replacement-methods)
		  - [1.9.11 Splitting and Joining](#1911-splitting-and-joining)
		  - [1.9.12 Methods Returning Arrays](#1912-methods-returning-arrays)
		  - [1.9.13 Indentation Methods](#1913-indentation)
		  - [1.9.14 Additional Examples](#1914-additional-examples)
	- [2. Arrays in Java](#2-arrays-in-java)
	  - [2.1 Declaring Arrays](#21-declaring-arrays)
	  - [2.2 Creating Arrays (Instantiation)](#22-creating-arrays-instantiation)
		- [2.2.1 Key Rules](#221-key-rules)
		- [2.2.2 Illegal Array Creation Examples](#222-illegal-array-creation-examples)
	  - [2.3 Default Values in Arrays](#23-default-values-in-arrays)
	  - [2.4 Accessing Elements](#24-accessing-elements)
		- [2.4.1 Common Exceptions](#241-common-exceptions)
	  - [2.5 Array Initialization Shorthands](#25-array-initialization-shorthands)
		- [2.5.1 Anonymous Array Creation](#251-anonymous-array-creation)
		- [2.5.2 Short Syntax (Only at Declaration)](#252-short-syntax-only-at-declaration)
	  - [2.6 Multidimensional Arrays (Arrays of Arrays)](#26-multidimensional-arrays-arrays-of-arrays)
		- [2.6.1 Declaration](#261-declaration)
		- [2.6.2 Creating a Rectangular Array](#262-creating-a-rectangular-array)
		- [2.6.3 Creating a Jagged (Irregular) Array](#263-creating-a-jagged-irregular-array)
	  - [2.7 Array Length vs String Length](#27-array-length-vs-string-length)
	  - [2.8 Array Reference Assignments](#28-array-reference-assignments)
		- [2.8.1 Assigning Compatible References](#281-assigning-compatible-references)
		- [2.8.2 Incompatible Assignments (Compile-Time Errors)](#282-incompatible-assignments-compile-time-errors)
		- [2.8.3 Covariance Runtime Danger: ArrayStoreException](#283-covariance-runtime-danger-arraystoreexception)
	  - [2.9 Comparing Arrays](#29-comparing-arrays)
	  - [2.10 Arrays Utility Methods](#210-arrays-utility-methods)
		- [2.10.1 `Arrays.toString()`](#2101-arraystostring)
		- [2.10.2 `Arrays.deepToString()`](#2102-arraysdeeptostring)
		- [2.10.3 `Arrays.sort()`](#2103-arrayssort)
		- [2.10.4 `Arrays.binarySearch()`](#2104-arraysbinarysearch)
	  - [2.11 Enhanced for-loop with Arrays](#211-enhanced-for-loop-with-arrays)
	  - [2.12 Common Certification Pitfalls](#212-common-certification-pitfalls)
		- [2.12.1 Accessing Out of Bounds](#2121-accessing-out-of-bounds)
		- [2.12.2 Using Short Array Initializer Incorrectly](#2122-using-short-array-initializer-incorrectly)
		- [2.12.3 Confusing `.length` and `.length()`](#2123-confusing-length-and-length)
		- [2.12.4 Forgetting Arrays Are Objects](#2124-forgetting-arrays-are-objects)
		- [2.12.5 Mixing Primitive and Wrapper Arrays](#2125-mixing-primitive-and-wrapper-arrays)
		- [2.12.6 Using `binarySearch` on Unsorted Arrays](#2126-using-binarysearch-on-unsorted-arrays)
		- [2.12.7 ArrayStoreException Due to Covariance](#2127-arraystoreexception-due-to-covariance)
	  - [2.13 Summary](#213-summary)
	- [3. Math APIs](#3-math-apis)
	  - [3.1 Maximum and Minimum between two values](#31-maximum-and-minimum-between-two-values)
	  - [3.2 Math.round()](#32-mathround)
	  - [3.3 Math.ceil() (Ceiling)](#33-mathceil-ceiling)
	  - [3.4 Math.floor() (Floor)](#34-mathfloor-floor)
	  - [3.5 Math.pow()](#35-mathpow)
	  - [3.6 Math.random()](#36-mathrandom)
	  - [3.7 Math.abs()](#37-mathabs)
	  - [3.8 Math.sqrt()](#371-mathsqrt)
	  - [3.9 Summary Table](#38-summary-table)



---

## 1 Strings & Text Blocks
 
### 1.1 Initializing Strings

In Java, a **String** is an object of the `java.lang.String` class, used to represent a sequence of characters.  
Strings are **immutable**, meaning that once created, their content cannot be changed. Any operation that seems to modify a string actually creates a new one.

You can create and initialize strings in several ways:

```java
String s1 = "Hello";                    // string literal
String s2 = new String("Hello");        // using constructor (not recommended)
String s3 = s1.toUpperCase();           // creates a new String ("HELLO")
```
> [!NOTE]
> - String literals are stored in the `String pool`, a special memory area used to avoid creating duplicate string objects.
> - Using the **new** keyword always creates a new object outside the pool.

### **The String Pool**

Because String are `immutable` and they are widely used in Java, they could easily occupy a huge amount of memory in a Java program;
In order to face this problem Java will reuse all the Strings which are declared as literals (see example above), storing them in a dedicated location of the JVM which is known as the `String Pool` or the `Intern Pool`.

Please Check [1.5.3 String Pool and Equality](../module-01/instantiating-types.md#153-string-pool-and-equality)

### 1.2 Special Characters and Escape Sequences

Strings can contain escape characters, which allow you to include special symbols or control characters (characters with a special meaning in Java).
An escape sequence starts with a backslash \.

> [!NOTE]
> **Table of Special Characters & Escape Sequences in Strings**

<table>
  <thead>
    <tr>
      <th>Escape</th>
      <th>Meaning</th>
      <th>Java Example</th>
      <th>Result</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>&#92;&quot;</code></td>
      <td>double quote</td>
      <td><code>"She said &#92;&quot;Hi&#92;&quot;"</code></td>
      <td><code>She said "Hi"</code></td>
    </tr>
    <tr>
      <td><code>&#92;&#92;</code></td>
      <td>backslash</td>
      <td><code>"C:&#92;&#92;Users&#92;&#92;Alex"</code></td>
      <td><code>C:\Users\Alex</code></td>
    </tr>
    <tr>
      <td><code>&#92;n</code></td>
      <td>newline (LF)</td>
      <td><code>"Hello&#92;nWorld"</code></td>
      <td>
        <code>Hello</code><br/>
        <code>World</code>
      </td>
    </tr>
    <tr>
      <td><code>&#92;r</code></td>
      <td>carriage return (CR)</td>
      <td><code>"A&#92;rB"</code></td>
      <td><code>CR before B</code></td>
    </tr>
    <tr>
      <td><code>&#92;t</code></td>
      <td>tab</td>
      <td><code>"Name&#92;tAge"</code></td>
      <td><code>Name&nbsp;&nbsp;&nbsp;&nbsp;Age</code></td>
    </tr>
    <tr>
      <td><code>&#92;&#39;</code></td>
      <td>single quote</td>
      <td><code>"It&#92;&#39;s ok"</code></td>
      <td><code>It's ok</code></td>
    </tr>
    <tr>
      <td><code>&#92;b</code></td>
      <td>backspace</td>
      <td><code>"AB&#92;bC"</code></td>
      <td><code>AC</code> (the <code>B</code> is removed visually)</td>
    </tr>
    <tr>
      <td><code>&#92;uXXXX</code></td>
      <td>Unicode code unit</td>
      <td><code>"&#92;u00A9"</code></td>
      <td><code>©</code></td>
    </tr>
  </tbody>
</table>


### 1.3 Text Blocks (since Java 15)

A text block is a multi-line string literal introduced to simplify writing large strings (such as HTML, JSON, or code) without the need to escape.
A text block starts and ends with three double quotes (""").
You can use text blocks everywhere you would use Strings.

```java
String html = """
    <html>
        <body>
            <p>Hello, world!</p>
        </body>
    </html>
    """;
```

> [!NOTE]
> - Text blocks automatically include line breaks and indentation for readability (Newlines are automatically normalized to \n).
> - Double quotes inside the block don’t need escaping.
> - The compiler interprets the content between the opening and closing triple quotes as the string’s value.

### 1.4 Formatting: Essential vs Incidental Whitespace

- **Essential whitespace**: the spaces and newlines that are part of the intended string content.
- **Incidental whitespace** is just indentation in your source.

```java
String text = """
        Line 1
        Line 2
        Line 3
        """;
```

> [!IMPORTANT]
> - **Leftmost character (baseline)**: The position of the first non-space character across all lines or the closing """ are the leftmost characters of the resulting string: all the spaces on the left of the 3 Lines are **Incidental whitespaces**;
> - The line immediately following the opening """ is not included in the output if it’s empty (typical formatting).
> - The newline before the closing """ is included in the content. This means the text block in the example ends with a newline after “Line 3” counting then, in total, 4 lines in the output.

- Output with line numbers (showing the trailing blank line):

```makefile
1: Line 1
2: Line 2
3: Line 3
4:
```

To suppress the trailing newline:

- a) Use a line continuation backslash at the end of the last content line;
- b) Put the ending three double quotes on the same line.

```java
String textNoTrail_1 = """
        Line 1
        Line 2
        Line 3\
        """;
		
// OR

String textNoTrail_2 = """
        Line 1
        Line 2
        Line 3""";
```

### 1.5 Line Count, Blank Lines, and Line Breaks

- Every visible line break inside the block becomes \n.
- Blank lines inside the block are preserved:

```java
String textNoTrail_0 = """
		Line 1  
		Line 2 \n
		Line 3 
		
		Line 4 
		""";
```

output:

```makefile
1: Line 1
2: Line 2
3:
4: Line 3
5:
6: Line 4
7:
```

### 1.6 Text Blocks & Escape Characters

Escapes still work inside text blocks when needed (e.g., backslashes, explicit escapes):

```java
String json = """
    {
      "name": "Alice",
      "path": "C:\\\\Users\\\\Alice"
    }\
    """;
```

You can also format a text block with placeholders:

```java
String card = """
    Name: %s
    Age:  %d
    """.formatted("Alice", 30);
```

### 1.7 Common Errors (with fixes)

```java
// ❌ Mismatched delimiters / missing closing triple quote
String bad = """
  Hello
World";      // ERROR — not a closing text block

// ✅ Fix
String ok = """
  Hello
  World
  """;
```

```java
// ❌ Text block require a line break after the opening """
String invalid = """Hello""";  // ERROR

// ✅ Fix
String valid = """
    Hello
    """;
```

```java
// ❌ Unescaped trailing backslash at end of a line inside the block
String wrong = """
    C:\Users\Alex\     // ERROR — backslash escapes the newline
    Documents
    """;

// ✅ Fix: escape backslashes, or avoid backslash at end of line
String correct = """
    C:\\Users\\Alex\\
    Documents\
    """;
```

### 1.8 Rules for String Concatenation

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

### 1.9 Core String methods

#### Strings — Indexing, Length, and Core Methods
 
Let's understand indexing rules and how Java handles substring boundaries.


#### 1.9.1 String Indexing

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


#### 1.9.2 `length()` Method

`length()` returns the **number of characters** in the string.

```java
String s = "hello";
System.out.println(s.length());  // 5
```

- The last valid index is `length() - 1`.


#### 1.9.3 Boundary Rules: Start Index vs End Index

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


#### 1.9.4 String Methods 

A structured and complete classification.


#### 1.9.5 Methods Using Only Start Index (Inclusive)

| Method | Description | Parameters | Index Rule | Example |
|--------|-------------|------------|------------|---------|
| `substring(int start)` | Returns substring from `start` to end | start | start = inclusive | `"abcdef".substring(2)` → `"cdef"` |
| `indexOf(String)` | First occurrence | — | — | `"Java".indexOf("a")` → 1 |
| `indexOf(String, start)` | Start searching at index | start | start = inclusive | `"banana".indexOf("a", 2)` → 3 |
| `lastIndexOf(String)` | Last occurrence | — | — | `"banana".lastIndexOf("a")` → 5 |
| `lastIndexOf(String, fromIndex)` | Search backward from index | fromIndex | fromIndex = inclusive | `"banana".lastIndexOf("a", 3)` → 3 |


#### 1.9.6 Methods with Start Inclusive / End Exclusive

These methods follow the same slicing behavior:

**start included**, **end excluded**

| Method | Description | Signature | Example |
|--------|-------------|-----------|---------|
| `substring(start, end)` | Extracts part of string | `(int start, int end)` | `"abcdef".substring(1,4)` → `"bcd"` |
| `regionMatches` | Compare substring regions | `(toffset, other, ooffset, len)` | `"Hello".regionMatches(1, "ell", 0, 3)` → `true` |
| `getBytes(int srcBegin, int srcEnd, byte[] dst, int dstBegin)` | Copies chars to byte array | start inclusive, end exclusive | Copies chars in `[srcBegin, srcEnd)` |
| `copyValueOf(char[] data, int offset, int count)` | Creates a new string | offset inclusive; offset+count exclusive | same rule as substring |


#### 1.9.7 Methods That Operate on Entire String

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


#### 1.9.8 Character Access

| Method | Description | Example |
|--------|-------------|---------|
| `charAt(int index)` | Returns char at index | `"Java".charAt(2)` → `'v'` |
| `codePointAt(int index)` | Unicode code point | useful for emojis |


#### 1.9.9 Searching

| Method | Description | Example |
|--------|-------------|---------|
| `contains(CharSequence)` | Substring test | `"hello".contains("ell")` → `true` |
| `startsWith(String)` | Prefix | `"abcdef".startsWith("abc")` → `true` |
| `startsWith(String, offset)` | Prefix at given index | `"abc".startsWith("b", 1)` → `true` |
| `endsWith(String)` | Suffix | `"abcdef".endsWith("def")` → `true` |


#### 1.9.10 Replacement Methods

| Method | Description | Example |
|--------|-------------|---------|
| `replace(char old, char new)` | Replace characters | `"banana".replace('a','o')` → `"bonono"` |
| `replace(CharSequence old, CharSequence new)` | Replace substrings | `"ababa".replace("aba","X")` → `"Xba"` |
| `replaceAll` | Regex replace all | `"a1a2".replaceAll("\\d","")` → `"aa"` |
| `replaceFirst` | First regex match only | `"a1a2".replaceFirst("\\d","")` → `"aa2"` |


#### 1.9.11 Splitting and Joining

| Method | Description | Example |
|--------|-------------|---------|
| `split(String regex)` | Split by regex | `"a,b,c".split(",")` → `["a","b","c"]` |
| `split(String regex, limit)` | Controlled split | limit < 0 keeps all |


#### 1.9.12 Methods Returning Arrays

| Method | Description | Example |
|--------|-------------|---------|
| `toCharArray()` | char[] | `"abc".toCharArray()` |
| `getBytes()` | byte[] from encoding | `"á".getBytes()` |


#### 1.9.13 Indentation

| Method | Description | Example |
|--------|-------------|---------|
| `indent(int numSpaces)` | `add` (positive numSpaces) or `removes` (negative numSpaces) the provided amount of blank spaces from the beginning of each line; A line break is also added, to the end of the string, if not already present | `str.indent(-20)` |
| `stripIndent()` | removes all incidental WHITESPACES. Does not add a line break at the end | `str.stripIndent()` |

Example:
```java
		var txtBlock = """
				
				    a
				      b
				     c""";
		
		var conc = " a\n" + " b\n" + " c";
		
		System.out.println("length: " + txtBlock.length());
		System.out.println(txtBlock);
		System.out.println("");
		String stripped1 = txtBlock.stripIndent();
		System.out.println(stripped1);
		System.out.println("length: " + stripped1.length());

		System.out.println("*********************");
		
		System.out.println("length: " + conc.length());
		System.out.println(conc);
		System.out.println("");
		String stripped2 = conc.stripIndent();
		System.out.println(stripped2);
		System.out.println("length: " + stripped2.length());
```

output:

```bash
length: 9

a
  b
 c


a
  b
 c
length: 9
*********************
length: 8
 a
 b
 c

a
b
c
length: 5
```


#### 1.9.14 Additional Examples

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

---

## 2. Arrays in Java

Arrays in Java are **fixed-size**, **indexed**, **ordered** collections of elements of the *same* type.  
They are considered **objects**, even when the elements are primitives.  


### 2.1 Declaring Arrays

You can declare an array in two ways:

```java
int[] a;      // preferred modern syntax
int b[];      // legal, older style
String[] names;
Person[] people;

// [] can be before or after the name: all the following declarations are equivalent.

int[] x;
int [] x1;
int []x2;
int x3[];
int x5 [];

// MULTIPLE ARRAYs DECLARATION

int[] arr1, arr2;   // Declares two arrays of int

WARNING!

int arr1[], arr2;   // This time (just moving the brackets) we obtain one variable of type array of int and the second one, arr2, of type int

```

**Declaring does NOT create the array** — it only creates a variable capable of referencing one.


### 2.2 Creating Arrays (Instantiation)

An array is created using `new` followed by the element type and the array length:

```java
int[] numbers = new int[5];
String[] words = new String[3];
```

### Key rules
- The length **must be non-negative** and specified at creation time.
- Length **cannot be changed later**.
- Array length can be any `int` expression:

```java
int size = 4;
double[] values = new double[size];
```

### Illegal array creation examples
```java
// int length = -1;          // Runtime exception: NegativeArraySizeException
// int[] arr = new int[-1]; 

// int[] arr = new int[2.5];  // Compile error: size must be int
```


### 2.3 Default Values in Arrays

Arrays (because they are objects) always receive **default initialization**:

| Element Type | Default Value |
|--------------|----------------|
| Numeric      | 0 |
| boolean      | false |
| char         | '\u0000' |
| Reference types | null |

Example:

```java
int[] nums = new int[3]; 
System.out.println(nums[0]); // 0

String[] s = new String[3];
System.out.println(s[0]);    // null
```


### 2.4 Accessing Elements

Elements are accessed using zero-based indexing:

```java
int[] a = new int[3];
a[0] = 10;
a[1] = 20;
System.out.println(a[1]); // 20
```

### Common Exceptions
- `ArrayIndexOutOfBoundsException` (runtime)

```java
// int[] x = new int[2];
// System.out.println(x[2]); // ❌ index 2 out of bounds
```

### 2.5 Array Initialization Shorthands

#### 2.5.1 Anonymous array creation
```java
int[] a = new int[] {1,2,3};
```

#### 2.5.2 Short syntax (only at declaration!)
```java
int[] b = {1,2,3};
```

> The short syntax *cannot* be used in assignment:

```java
// int[] c;
// c = {1,2,3};  // ❌ does not compile
```

### 2.6 Multidimensional Arrays (Arrays of Arrays)

Java implements multi-dimensional arrays as **arrays of arrays**.

### Declaration
```java
int[][] matrix;
String[][][] cube;
```

### Creating a rectangular array
```java
int[][] rect = new int[3][4]; // 3 rows, 4 columns each
```

### Creating a jagged (irregular) array
You can create rows with different lengths:

```java
int[][] jagged = new int[3][];
jagged[0] = new int[2];
jagged[1] = new int[5];
jagged[2] = new int[1];
```


### 2.7 Array Length vs String Length

- Arrays use **`.length`** (public final field)
- Strings use **`.length()`** (method)

**Common Pitfall**:

```java
// int x = arr.length;   // OK
// int y = s.length;     // ❌ does not compile: missing ()
```


### 2.8 Array Reference Assignments

### Assigning compatible references
```java
int[] a = {1,2,3};
int[] b = a; // both now point to the same array
```

Modifying one affects the other:

```java
b[0] = 99;
System.out.println(a[0]); // 99
```

### Incompatible assignments (compile-time errors)
```java
// int[] x = new int[3];
// long[] y = x;     // ❌ incompatible types
```

But array references follow normal inheritance rules:

```java
String[] s = new String[3];
Object[] o = s;      // OK: arrays are covariant
```

### Covariance runtime danger: ArrayStoreException
```java
Object[] objs = new String[3];
// objs[0] = Integer.valueOf(5); // ❌ ArrayStoreException
```


### 2.9 Comparing Arrays

`==` compares references (identity):  
```java
int[] a = {1,2};
int[] b = {1,2};
System.out.println(a == b); // false
```

`.equals()` in arrays **does not compare contents** (it behaves like `==`):  
```java
System.out.println(a.equals(b)); // false
```

To compare contents, use methods from `java.util.Arrays`:

```java
Arrays.equals(a, b);         // shallow comparison
Arrays.deepEquals(o1, o2);   // deep comparison for nested arrays
```


### 2.10 `Arrays` Utility Methods


### • `Arrays.toString()`
```java
System.out.println(Arrays.toString(new int[]{1,2,3})); // [1, 2, 3]
```

### • `Arrays.deepToString()` (for nested arrays)
```java
System.out.println(Arrays.deepToString(new int[][] {{1,2},{3,4}}));	// [[1, 2], [3, 4]]
```

### • `Arrays.sort()`
```java
int[] a = {4,1,3};
Arrays.sort(a); // [1,3,4]
```

> [!TIP]
> - Strings are sorted in alphabetical order
> - Numbers sort before letters and uppercase letters sort before lowercase letters: (numbers < uppercase < lowercase)
> - `null` is smaller of any other value

```java
String[] arr = {"AB", "ac", "Ba", "bA", "10", "99"};

Arrays.sort(arr);

System.out.println(Arrays.toString(arr));  // [10, 99, AB, Ba, ac, bA]
```

### • `Arrays.binarySearch()`
Requirements: array **must be sorted**, otherwise result is `unpredictable`.

```java
int[] a = {1,3,5,7};
int idx = Arrays.binarySearch(a, 5); // returns 2
```

When value not found → returns **-(insertionPoint) - 1**:

```java
int pos = Arrays.binarySearch(a, 4); // returns -3
```

Explanation: insertion at index 2 → return `-(2) - 1 = -3`.


### • `Arrays.compare()`

While the class `Arrays` contain an overloaded version of the method `equals()` which checks if two arrays contain the same elements (and of course are of the same size)

```java
System.out.println(Arrays.equals(new int[] {200}, new int[] {100}));	// false
System.out.println(Arrays.equals(new int[] {200}, new int[] {200}));	// true
System.out.println(Arrays.equals(new int[] {200}, new int[] {100, 200}));	// false
```

it offers also a `compare()` method with the following utilization rules:

- If the method gives a result `n < 0` --> first array is smaller than the second;
- If the method gives a result `n > 0` --> first array is bigger than the second;
- If the method gives a result `n == 0` --> arrays are equal;

Additional rules in the following example:

```java


int[] arr1 = new int[] {200, 300};
int[] arr2 = new int[] {200, 300, 400};
System.out.println(Arrays.compare(arr1, arr2));  // -1

int[] arr3 = new int[] {200, 300, 400};
int[] arr4 = new int[] {200, 300};
System.out.println(Arrays.compare(arr3, arr4));  // 1

String[] arr5 = new String[] {"200", "300", "aBB"};
String[] arr6 = new String[] {"200", "300", "ABB"};
System.out.println(Arrays.compare(arr5, arr6));     // Positive number: uppercase is smaller than lowercase

String[] arr7 = new String[] {"200", "300", "ABB"};
String[] arr8 = new String[] {"200", "300", "aBB"};
System.out.println(Arrays.compare(arr7, arr8));     // Negative number: uppercase is smaller than lowercase

String[] arr9 = null;
String[] arr10 = new String[] {"200", "300", "ABB"};
System.out.println(Arrays.compare(arr9, arr10));   // -1
```


### 2.11 Enhanced for-loop with Arrays

```java
for (int value : new int[]{1,2,3}) {
    System.out.println(value);
}
```

Rules:
- The right side must be an array or iterable.
- The loop variable must be compatible with element type.

Common error:
```java
// for (long v : new int[]{1,2}) {} // ❌ not allowed: int cannot widen to long in enhanced loop
```


### 2.12 Common Pitfalls

#### 2.12.1 Accessing out of bounds  
Throws `ArrayIndexOutOfBoundsException`.

#### 2.12.2 Using short array initializer incorrectly  
```java
// int[] x;
// x = {1,2}; // ❌ does not compile
```

#### 2.12.3 Confusing `.length` and `.length()`

#### 2.12.4 Forgetting arrays are objects

#### 2.12.5 Mixing primitive arrays and wrapper arrays  
```java
// int[] p = new Integer[3]; // ❌ incompatible
```

#### 2.12.6 Using binarySearch on unsorted arrays → unpredictable results

#### 2.12.7 Covariant array runtime exceptions (ArrayStoreException)

---

#### 2.13 Summary

Arrays in Java are:
- objects (even if holding primitives)
- fixed-size, indexed collections
- always initialized with default values
- type-safe but subject to covariance rules


---

## 3. Math APIs

The `java.lang.Math` class provides a set of static methods useful for numerical operations. 
These methods work with primitive numeric types. 
Below is a summary of the most frequently used ones, together with their overloaded forms.


### 3.1 `Maximum` and `Minimum` between two values

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

### 3.2 `Math.round()`

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

### 3.3 `Math.ceil()` (Ceiling)

Returns the **smallest double** value that is **≥ argument**.

Overloads:
- `double ceil(double value)`

Examples:
```java
Math.ceil(3.1);   // 4.0
Math.ceil(-3.1);  // -3.0
```

### 3.4 `Math.floor()` (Floor)

Returns the **largest double** value that is **≤ argument**.

Overloads:
- `double floor(double value)`

Examples:
```java
Math.floor(3.9);   // 3.0
Math.floor(-3.1);  // -4.0
```

### 3.5 `Math.pow()`

Raises a value to a power.

Overloads:
- `double pow(double base, double exponent)`

Examples:
```java
Math.pow(2, 3);      // 8.0
Math.pow(9, 0.5);    // 3.0  (square root)
Math.pow(10, -1);    // 0.1
```


### 3.6 `Math.random()`

Returns a **double in the range [0.0, 1.0)**.

Overloads:
- `double random()`

Examples:
```java
double r = Math.random();   // 0.0 <= r < 1.0

// Example: random int 0–9
int x = (int)(Math.random() * 10);
```

### 3.7 `Math.abs()`
Absolute value.

Overloads:
- `int abs(int)`
- `long abs(long)`
- `float abs(float)`
- `double abs(double)`

### 3.8 `Math.sqrt()`
Square root, returns a `double`.

```java
Math.sqrt(9);    // 3.0
Math.sqrt(-1);   // NaN
```

### 3.9 Summary Table

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


### 3.10 BigInteger and BigDecimal

The classes `BigInteger` and `BigDecimal` (in java.math) provide arbitrary-precision number types.
They are used when:

- primitive types (int, long, double, etc.) don’t have enough range, or
- floating-point rounding errors of float/double are not acceptable (e.g. money, financial calculations).

Both are `immutable`: every operation returns a new instance.

#### 3.10.1 Why double and float are not enough

Floating-point types (float, double) use a binary representation. Many decimal fractions can’t be represented exactly (like 0.1 or 0.2), so you get rounding errors:

```java
System.out.println(0.1 + 0.2); // 0.30000000000000004 
```

For tasks like financial calculations, this is unacceptable.
`BigDecimal` solves this by representing numbers using a decimal model with a configurable scale (number of digits after the decimal point).

#### 3.10.2 BigInteger — Arbitrary-Precision Integers

BigInteger represents integer values of any size, limited only by memory.

#### 3.10.3 Creating BigInteger

Common ways:

- From a long:
 - static BigInteger valueOf(long val)
- From a String:
 - BigInteger(String val) – decimal by default
 - BigInteger(String val, int radix) – with base (2, 8, 16, etc.)
- Random big value:
 - BigInteger(int numBits, Random rnd)

Examples:
```java
import java.math.BigInteger;
import java.util.Random;

BigInteger a = BigInteger.valueOf(10L);
BigInteger b = new BigInteger("12345678901234567890"); // decimal string
BigInteger c = new BigInteger("FF", 16); // 255 in base 16
BigInteger r = new BigInteger(128, new Random()); // random 128-bit number
```

#### 3.10.4 Operations (no operators!)

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

---






