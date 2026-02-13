# 9. Strings in Java

### Table of Contents

- [9. Strings in Java](#9-strings-in-java)
  - [9.1 Strings & Text Blocks](#91-strings--text-blocks)
    - [9.1.1 Strings](#911-strings)
      - [9.1.1.1 Initializing Strings](#9111-initializing-strings)
      - [9.1.1.2 The String Pool](#9112-the-string-pool)
      - [9.1.1.3 Special Characters and Escape Sequences](#9113-special-characters-and-escape-sequences)
      - [9.1.1.4 Rules for String Concatenation](#9114-rules-for-string-concatenation)
      - [9.1.1.5 Concatenation Rules](#9115-concatenation-rules)
    - [9.1.2 Text Blocks since Java 15](#912-text-blocks-since-java-15)
      - [9.1.2.1 Formatting Essential vs Incidental Whitespace](#9121-formatting-essential-vs-incidental-whitespace)
      - [9.1.2.2 Line Count Blank Lines and Line Breaks](#9122-line-count-blank-lines-and-line-breaks)
      - [9.1.2.3 Text Blocks and Escape Characters](#9123-text-blocks--escape-characters)
      - [9.1.2.4 Common Errors with fixes](#9124-common-errors-with-fixes)
  - [9.2 Core String Methods](#92-core-string-methods)
    - [9.2.1 String Indexing](#921-string-indexing)
    - [9.2.2 length Method](#922-length-method)
    - [9.2.3 Boundary Rules Start Index vs End Index](#923-boundary-rules-start-index-vs-end-index)
    - [9.2.4 Methods Using Only Start Index Inclusive](#924-methods-using-only-start-index-inclusive)
    - [9.2.5 Methods with Start Inclusive End Exclusive](#925-methods-with-start-inclusive--end-exclusive)
    - [9.2.6 Methods That Operate on Entire String](#926-methods-that-operate-on-entire-string)
    - [9.2.7 Character Access](#927-character-access)
    - [9.2.8 Searching](#928-searching)
    - [9.2.9 Replacement Methods](#929-replacement-methods)
    - [9.2.10 Splitting and Joining](#9210-splitting-and-joining)
    - [9.2.11 Methods Returning Arrays](#9211-methods-returning-arrays)
    - [9.2.12 Indentation](#9212-indentation)
    - [9.2.13 Additional Examples](#9213-additional-examples)

---

## 9.1 Strings & Text Blocks

### 9.1.1 Strings

#### 9.1.1.1 Initializing Strings

In Java, a **String** is an object of the `java.lang.String` class, used to represent a sequence of characters.
  
Strings are **immutable**: once created, their content cannot be changed. Any operation that seems to modify a string actually creates a new one.

You can create and initialize strings in several ways:

```java
String s1 = "Hello";                    // string literal
String s2 = new String("Hello");        // using constructor (not recommended)
String s3 = s1.toUpperCase();           // creates a new String ("HELLO")
```

!!! note
    - String literals are stored in the `String pool`, a special memory area used to avoid creating duplicate string objects.
    - Using the `new` keyword always creates a new object outside the pool.

#### 9.1.1.2 The String Pool

Because `String` objects are immutable and widely used, they could easily occupy a large amount of memory in a Java program.
  
To reduce duplication, Java reuses all strings that are declared as literals (see example above), storing them in a dedicated area of the JVM known as the **String Pool** or **Intern Pool**.

Please check the Paragraph: "**6.4.3 String Pool and Equality**" in Chapter: [6. Instantiating Types](../module-01/instantiating-types.md) for a deeper explanation and examples.

#### 9.1.1.3 Special Characters and Escape Sequences

Strings can contain escape characters, which allow you to include special symbols or control characters (characters with a special meaning in Java).  
An escape sequence starts with a backslash `\`.

!!! note
    **Table of Special Characters & Escape Sequences in Strings**

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

#### 9.1.1.4 Rules for String Concatenation

As introduced in the Chapter on [5. Java Operators](../module-01/java-operators.md), the symbol `+` normally represents **arithmetic addition** when used with numeric operands.

However, when applied to **Strings**, the same operator performs **string concatenation** — it creates a new string by joining operands together.

Since the operator `+` may appear in expressions where both numbers and strings are present, Java applies a specific set of rules to determine whether `+` means *numeric addition* or *string concatenation*.

#### 9.1.1.5 Concatenation Rules

- If both operands are numeric, `+` performs **numeric addition**.
- If at least one operand is a `String`, the `+` operator performs **string concatenation**.
- Evaluation is strictly left-to-right, because `+` is **left-associative**.  

This means that once a `String` appears on the left side of the expression, all subsequent `+` operations become concatenations.

!!! tip
    Because evaluation is left-to-right, the position of the first `String` operand determines how the rest of the expression is evaluated.

- Examples

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
String out = "3030" + 40; // "303040"

System.out.println(1 + 2 + "3" + 4 + 5);
// Step 1: 1 + 2 = 3
// Step 2: 3 + "3" = "33"
String r = "33" + 4;  // "334"
// Step 4: "334" + 5 = "3345"



// *** null is represented as a string when concatenated

System.out.println("AB" + null);
// ABnull
```

### 9.1.2 Text Blocks (since Java 15)

A text block is a multi-line string literal introduced to simplify writing large strings (such as HTML, JSON, or code) without the need for many escape sequences.
  
A text block starts and ends with three double quotes (`"""`).
  
You can use text blocks everywhere you would use strings.

```java
String html = """
    <html>
        <body>
            <p>Hello, world!</p>
        </body>
    </html>
    """;
```

!!! note
    - Text blocks automatically include line breaks and indentation for readability. Newlines are normalized to `\n`.
    - Double quotes inside the block usually don’t need escaping.
    - The compiler interprets the content between the opening and closing triple quotes as the string’s value.

#### 9.1.2.1 Formatting: Essential vs Incidental Whitespace

- **Essential whitespace**: spaces and newlines that are part of the intended string content.
- **Incidental whitespace**: indentation in your source code that you don’t conceptually consider part of the text.

```java
String text = """
        Line 1
        Line 2
        Line 3
        """;
```

!!! important
    - **Leftmost character (baseline)**: the position of the first non-space character across all lines (or the closing `"""`) defines the indentation baseline. Spaces to the left of this baseline are considered incidental and are removed.
    - The line immediately following the opening `"""` is not included in the output if it’s empty (typical formatting).
    - The newline before the closing `"""` is included in the content.  
      In the example above, the resulting string ends with a newline after `"Line 3"`: there are 4 lines in total.

Output with line numbers (showing the trailing blank line):

```text
1: Line 1
2: Line 2
3: Line 3
4:
```

To suppress the trailing newline:

- Use a line-continuation backslash at the end of the last content line.
- Put the ending triple quotes on the same line as the last content.

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

#### 9.1.2.2 Line Count, Blank Lines, and Line Breaks

- Every visible line break inside the block becomes `\n`.
- Blank lines inside the block are preserved.

```java
String textNoTrail_0 = """
        Line 1  
        Line 2 \n
        Line 3 
        
        Line 4 
        """;
```

Output:

```text
1: Line 1
2: Line 2
3:
4: Line 3
5:
6: Line 4
7:
```

#### 9.1.2.3 Text Blocks & Escape Characters

Escape sequences still work inside text blocks when needed (for example, for backslashes or explicit control characters).

```java
String json = """
    {
      "name": "Alice",
      "path": "C:\\\\Users\\\\Alice"
    }\
    """;
```

You can also format a text block using placeholders and `formatted()`:

```java
String card = """
    Name: %s
    Age:  %d
    """.formatted("Alice", 30);
```

#### 9.1.2.4 Common Errors (with fixes)

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
// ❌ Text blocks require a line break after the opening """
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

---

## 9.2 Core String Methods


#### 9.2.1 String Indexing

Strings in Java use **zero-based indexing**, meaning:

- The first character is at index `0`
- The last character is at index `length() - 1`
- Accessing any index outside this range causes a `StringIndexOutOfBoundsException`

- Example:

```java
String s = "Java";
// Indexes:  0    1    2    3
// Chars:    J    a    v    a

char c = s.charAt(2); // 'v'
```

### 9.2.2 `length()` Method

`length()` returns the number of characters in the string.

```java
String s = "hello";
System.out.println(s.length());  // 5
```

The last valid index is always `length() - 1`.

### 9.2.3 Boundary Rules: Start Index vs End Index

Many String methods use two indices:

- **Start index** — inclusive
- **End index** — exclusive

In other words, `substring(start, end)` includes characters from index `start` up to, but not including, index `end`.

- Start index must be `>= 0` and `<= length() - 1`
- End index may be equal to `length()` (the “virtual” position after the last character).
- End index must not exceed `length()`.
- Start index must never be greater than end index.

- Example:

```java
String s = "abcdef";
s.substring(1, 4); // "bcd" (indexes 1,2,3)
```

This rule applies to most substring-based methods.

### 9.2.4 Methods Using Only Start Index (Inclusive)

| Method | Description | Parameters | Index Rule | Example |
| --- | --- | --- | --- | --- |
| substring(int start) | Returns substring from start to end | start | start inclusive | "abcdef".substring(2) → "cdef" |
| indexOf(String) | First occurrence | — | — | "Java".indexOf("a") → 1 |
| indexOf(String, start) | Start searching at index | start | start inclusive | "banana".indexOf("a", 2) → 3 |
| lastIndexOf(String) | Last occurrence | — | — | "banana".lastIndexOf("a") → 5 |
| lastIndexOf(String, fromIndex) | Search backward from index | fromIndex | fromIndex inclusive | "banana".lastIndexOf("a", 3) → 3 |

### 9.2.5 Methods with Start Inclusive / End Exclusive

These methods follow the same slicing behavior: `start` included, `end` excluded.

| Method | Description | Signature | Example |
| --- | --- | --- | --- |
| substring(start, end) | Extracts part of string | (int start, int end) | "abcdef".substring(1,4) → "bcd" |
| regionMatches | Compares substring regions | (toffset, other, ooffset, len) | "Hello".regionMatches(1, "ell", 0, 3) → true |
| getBytes(int srcBegin, int srcEnd, byte[] dst, int dstBegin) | Copies chars to byte array | start inclusive, end exclusive | Copies chars in [srcBegin, srcEnd) |
| copyValueOf(char[] data, int offset, int count) | Creates a new string | offset inclusive; offset+count exclusive | Same rule as substring |

### 9.2.6 Methods That Operate on Entire String

| Method | Description | Example |
| --- | --- | --- |
| toUpperCase() | Uppercase version | "java".toUpperCase() → "JAVA" |
| toLowerCase() | Lowercase version | "JAVA".toLowerCase() → "java" |
| trim() | Removes leading/trailing whitespace | "  hi  ".trim() → "hi" |
| strip() | Unicode-aware trimming | "  hi\u2003".strip() → "hi" |
| stripLeading() | Removes leading whitespace | "  hi".stripLeading() → "hi" |
| stripTrailing() | Removes trailing whitespace | "hi  ".stripTrailing() → "hi" |
| isBlank() | True if empty or whitespace only | "  ".isBlank() → true |
| isEmpty() | True if length == 0 | "".isEmpty() → true |

### 9.2.7 Character Access

| Method | Description | Example |
| --- | --- | --- |
| charAt(int index) | Returns char at index | "Java".charAt(2) → 'v' |
| codePointAt(int index) | Returns Unicode code point | Useful for emojis or characters beyond BMP |

### 9.2.8 Searching

| Method | Description | Example |
| --- | --- | --- |
| contains(CharSequence) | Substring test | "hello".contains("ell") → true |
| startsWith(String) | Prefix | "abcdef".startsWith("abc") → true |
| startsWith(String, offset) | Prefix at index | "abc".startsWith("b", 1) → true |
| endsWith(String) | Suffix | "abcdef".endsWith("def") → true |

### 9.2.9 Replacement Methods

| Method | Description | Example |
| --- | --- | --- |
| replace(char old, char new) | Replace characters | "banana".replace('a','o') → "bonono" |
| replace(CharSequence old, CharSequence new) | Replace substrings | "ababa".replace("aba","X") → "Xba" |
| replaceAll(String regex, String replacement) | Regex replace all | "a1a2".replaceAll("\\d","") → "aa" |
| replaceFirst(String regex, String replacement) | First regex match only | "a1a2".replaceFirst("\\d","") → "aa2" |

### 9.2.10 Splitting and Joining

| Method | Description | Example |
| --- | --- | --- |
| split(String regex) | Split by regex | "a,b,c".split(",") → ["a","b","c"] |
| split(String regex, int limit) | Split with limit | limit < 0 keeps all trailing empty strings |

### 9.2.11 Methods Returning Arrays

| Method | Description | Example |
| --- | --- | --- |
| toCharArray() | Returns char[] | "abc".toCharArray() |
| getBytes() | Returns byte[] using platform/default encoding | "á".getBytes() |

### 9.2.12 Indentation

| Method | Description | Example |
| --- | --- | --- |
| indent(int numSpaces) | Adds (positive) or removes (negative) spaces from the beginning of each line; also adds a line break at the end if not already present | str.indent(-20) |
| stripIndent() | Removes all incidental leading whitespace from each line; does not add a final line break | str.stripIndent() |

- Example:

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

Output:

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

### 9.2.13 Additional Examples

- Example 1 — Extract `[start, end)`

```java
String s = "012345";
System.out.println(s.substring(2, 5));
// includes 2,3,4 → prints "234"
```

- Example 2 — Searching from a start index

```java
String s = "hellohello";
int idx = s.indexOf("lo", 5); // search begins at index 5
```

- Example 3 — Common pitfalls

```java
String s = "abcd";
System.out.println(s.substring(1,1)); // "" empty string
System.out.println(s.substring(3, 2)); // ❌ Exception: start index (3) > end index (2)

System.out.println("abcd".substring(2, 4)); // "cd" — includes indexes 2 and 3; 4 is excluded but legal here

System.out.println("abcd".substring(2, 5)); // ❌ StringIndexOutOfBoundsException (end index 5 is invalid)
```

