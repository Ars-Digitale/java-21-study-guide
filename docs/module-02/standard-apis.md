# Standard APIs

### Table of Contents

- [Standard APIs]()
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

