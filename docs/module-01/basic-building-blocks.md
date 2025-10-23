# Module 1: Java building Blocks

### Table of Contents

- [1. Class definition](#1-class-definition)
- [2. Comments](#2-comments)
- [3. Access modifiers](#3-access-modifiers)
- [4. Packages](#4-packages)
- [5. The main Method](#5-the-main-method)
- [6. Compiling and running your code](#6-compiling-and-running-your-code)
- [7. Strings and Text blocks](#7-strings--text-blocks)

---
 
## 1. Class definition


A **Java class** is the fundamental building block of a Java program.
A class represents a type in Java. 
This type can be user-defined (created by the programmer) or predefined (coming from the Java standard library or external libraries). 
As described in programming language theory [see: Syntax Building Blocks](syntax-building-blocks.md), a type specifies the kind of data and the operations (methods) that it supports.

A class serves as the blueprint — the definition of the new type — while objects are concrete instances (implementations) of this type, created in memory at runtime.


A Java class is composed of two main elements, known as its **members**:

- **Fields** (or variables) — they represent the data that define the state of this newly created type.

- **Methods** (or functions) — they represent the operations that can be performed on this data.

Normally, each class is defined in its own **.java file**; for example, a class named Person will be defined in the corresponding file Person.java.

Any class that is independently defined in its own source file is called a **top-level class**.

Such a class can only be declared as public or package-private (i.e., with no access modifier).

A single file, however, may contain more than one class definition. **In this case, only one class can be declared public, and the file name must match that class**. 

**Nested class**, which are classes declared inside another class, can declare any access modifier: public, protected, private, default (package-private).



- Example:

```java
public class Person {

	// This is a comment: explains the code but is ignored by the compiler. See section below.

    // Field → defines data/state
    String personName;

    // Method → defines behavior (this one take a parameter, newName, in input but does not return a value)
    void setPersonName(String newName) {
		personName = newName;
    }
	
	// Method → defines behavior  (this one does not take parameters in input but does return a String)
	String getPersonName(){
		return personName;
	}
}
```

> [!NOTE]
> In its simplest form, we could theoretically have a class with no methods and no fields. Although such a class would compile, it would hardly make much sense.

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| public | Keyword / access modifier | determines which other classes can use or see that element | Mandatory (when absent is, by default, package-private) |
| class | Keyword | Declares a class type. | Mandatory |
| Person | Class name (identifier) | The name of the class. | Mandatory |
| personName | Field name (identifier) | Stores the name of the person. | Optional |
| String | Type / Keyword | Type of the field `personName` and of the parameter `newName`. | Mandatory |
| setPersonName, getPersonName | Method names (identifier) | name a behavior of the class. | Optional |
| newName | Parameter name (identifier) | input passed to the method `setPersonName`. | Mandatory (if the method needs a parameter) |
| return | Keyword | Exits a method and gives back a value. | Mandatory (in methods with a non-void return type) |
| void | Return Type / Keyword | Indicates the method does not return a value. | Mandatory (if the method does not return a value) |

> [!NOTE]
> Mandatory = required by Java syntax,  
> Optional = not required by syntax; depends on design. 

---

## 2. Comments

Comments are not executable code: they explains the code but are ignored by the compiler.

In Java there are 3 types of comments:

- **Single-line** comment;
- **Multiline** comment;
- **Javadoc** comment;

A **single-line comment** starts with 2 slashes: all the text after that, on the same line, is ignored by the compiler.

- Exapmle:

```java

// This is a single-line comment. It starts with 2 slashes and ends at the end of the line. 


```

A **multiline comment** includes anything between the symbols /* and */.

- Exapmle:

```java

/* 	
* This is a multi-line comment.
* It can span multiple lines.
* All the text between its opening and closing symbols is ignored by the compiler.
*
*/

```

A **Javadoc comment** is similar to a **multiline comment**, except it starts with /\*\*: all the text between its opening and closing symbols is processed by the Javadoc tool to generate API documentation.

```java

/**
 * This is a Javadoc comment
 *
 * This class represents a Person.
 * It stores a name and provides methods
 * to set and retrieve it.
 *
 * <p>Javadoc comments can include HTML tags,
 * and special annotations like @param and @return.</p>
 */

```

> [!WARNING] 
> In Java, every block comment must be properly closed with */.

- Example:

```java

/* valid block comment */

```

is fine, but

```java

/* */ */

```

will cause a compilation error because, while the first two symbols are part of the comment, the last symbol don't. The extra symbol */ is not valid syntax then and the compiler will complain. 

---

## 3. Access modifiers

In Java, an **access modifier** is a keyword that specifies the visibility (or accessibility) of a class, method, or field. It determines which other classes can use or see that element.

> [!NOTE]
> **Table of the access modifiers available in Java**

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| public | Keyword / access modifier | Visible from any class in any package | Yes |
| no modifier (default) | Keyword / access modifier | Visible only within the same package	| Yes |
| protected |	Keyword / access modifier |	Visible within the same package and by subclasses (even in other packages) | Yes |
| private	| Keyword / access modifier	| Visible only within the same class | Yes |

---

## 4. Packages

**Java packages** are logical groupings of classes, interfaces, and sub-packages. They help organize large codebases, avoid name conflicts, and provide controlled access between different parts of an application.

### a. Organization and Purpose
- Naming of packages follow the same rules of variable names. see: [Java Naming Rules](naming-rules.md)
- Packages are like **folders** for your Java source code.  
- They let you group related classes together (e.g., all utility classes in `java.util`, all networking classes in `java.net`).  
- By using packages, you can prevent **naming conflicts**: for example, you may have two classes named `Date`, but one is `java.util.Date` and another is `java.sql.Date`.

### b. Mapping with the File System and declaration of a package
- Packages map directly to the **directory hierarchy** on your file system.
- You declare the package at the top of the source file (**before any imports**).
- If you do not declare a package, the class belongs to the default package.
	- This is not recommended for real projects, since it complicates organization and imports.
	
- Example:

```java
package com.example.myapp.utils;

public class MyApp{

}
```

> [!IMPORTANT] 
> This declaration means the class must be located in the directory: **com/example/myapp/utils/MyApp.java**

### c. Belonging to the Same Package

Two classes belong to the same package if and only if:

- They are declared with the same package statement at the top of their source file.
- They are placed in the same directory of the source hierarchy.

- Example:

A class in package A.B.C; belongs to A.B.C only, not to A.B.
Classes in A.B cannot directly access **package-private** members of classes in A.B.C, because they are different packages.

Classes in the same package:

- Can access each other’s package-private members (i.e., members without an access modifier).
- Share the same namespace, so you don’t need to import them to use them.  

### d. Importing a Package

To use classes from another package, you need to import them:

- Example:

```java
import java.util.List;       // imports a specific class
import java.util.*;          // imports all classes in java.util

import java.nio.file.*.*     // ERROR! only one wildcard is allowed and it must be at the end!
```

> [!NOTE]
> The wildcard character  **\***  imports all types in the package but not its subpackages.

You can always use the fully qualified name instead of importing all the classes in that package:

```java
java.util.List myList = new java.util.ArrayList<>();
```

> [!NOTE]
> If you explicitely import a class name, it takes precedence over any wildcard import;
> if you want two use two class with the same name (ex. `Date` from java.util and from java.sql), it is better to use a fully qualified name import.

### e. Standard vs. User-Defined Packages

**Standard packages**: shipped with the JDK (e.g., java.lang, java.util, java.io).

**User-defined packages**: created by developers to organize application code.

---

## 5. The `main` Method

In Java, the `main` method serves as the **entry point** of a standalone application. Its correct declaration is critical for the JVM to recognize it:

### a. `main` method signature

Let's review the `main` method signature inside two of the simplest possible classes:

- Example: without optional modifiers

```java
public class MainFirstExample {

	public static void main(String[] args){
	
		System.out.print("Hello World!!");
	
	}

}
```

- Example: with both, optional, `final` modifiers

```java
public class MainSecondExample {

	public final static void main(final String options[]){
	
		System.out.print("Hello World!!");
	
	}

}
```

> [!NOTE]
> **Table of the access modifiers for the main method**

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| public | Keyword / Access Modifier | Makes the method accessible from anywhere. Required so the JVM can call it from outside the class. | Mandatory |
| static | Keyword | Means the method belongs to the class itself and can be called without creating an object. Required because the JVM has no object instance when starting the program. | Mandatory |
| final (before return type) | Modifier | Prevents the method from being overridden. It can legally appear before the return type, but it has no effect on `main` and is not required. | Optional |
| main | Method name (predefined) | The exact name that the JVM looks for as the entry point of the program. Must be spelled exactly as `main` (lowercase). | Mandatory |
| void | Return Type / Keyword | Declares that the method does not return any value to the JVM. | Mandatory |
| String[] args | Parameter list | An array of `String` values that holds the command-line arguments passed to the program. May also be written as `String args[]` or `String... args`. The parameter name (`args`) is arbitrary. | Mandatory (the parameter type is required, but the name can vary) |
| final (in parameter) | Modifier | Marks the parameter as unchangeable inside the method body (you cannot reassign `args` to another array). | Optional |


> [!IMPORTANT]
> Modifiers `public`, `static` (mandatory) and `final` (if present) can be swapped in order;  `public` and `static` can't be omitted.

---

## 6. Compiling and running your code


This chapter shows **correct, working** `javac` and `java` command lines for common situations in Java 21: single files, multiple files, packages, separate output directories, and classpath/module-path usage. Follow the directory layouts exactly.


> check your tools

```bash
javac -version   # should print: javac 21.x
java  -version   # should print: java version "21.0.7" ... (the output could be different depending on the implementation of the jvm you installed)
```


### a. Compiling one file, default package (single directory)

**Files**
```
.
└── Hello.java
```

**Hello.java**
```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Java 21!");
    }
}
```

**Compile (in the same directory)**
```bash
javac Hello.java
```

This command will create, in the same directory, a file with the same name of your ".java" file but with ".class" filename extension ; this is the bytecode file which will be interpreted and compiled by the jvm.

Once you have the .class file, in this case Hello.class, you ca run the program with:

**Run**
```bash
java Hello
```

> [!IMPORTANT]
> You don't have to specify the ".class" extension when executing the program



### b. Multiple files, default package (single directory)

**Files**
```
.
├── A.java
└── B.java
```

**Compile everything**
```bash
javac *.java
```

Or, if the classes belong to a specific package:

```bash
javac packagex/*.java
```

Or, specifying each of them

```bash
javac A.java B.java
```
and

```bash
javac packagex/A.java packagey/B.java
```

**Run the entry point**: The class which has a `main` method
```bash
java A    # if A has main(...)
# or
java B
```


> [!IMPORTANT]
> The path to your classes is, in Java, the **classpath**. You can specify the **classpath** with one of the following options:

- **-cp** `<classpath>`
- **-classpath** `<classpath>`
- **--class-path** `<classpath>`


### c. Code inside packages (standard src → out layout)

**Files**
```
.
├── src/
│   └── com/
│       └── example/
│           └── app/
│               └── Main.java
└── out/
```

> [!NOTE]
> The `src` and `out` folders are not part of our packages, being only the directory containing all our source files and the compiled .class files;

**Main.java**
```java
package com.example.app;

public class Main {
    public static void main(String[] args) {
        System.out.println("Packages done right.");
    }
}
```

**Compile to the same directory**
```bash
# Creates .class file just beside the source file
javac src/com/example/app/Main.java
```

### d. Compiling to another directory (`-d`)

`-d out` places compiled `.class` files into the `out/` directory, creating package subfolders that mirror your `package` names:

```bash
javac -d out -sourcepath src src/com/example/app/Main.java
```

**Run (use the classpath to point at out/)**
```bash
# Unix/macOS
java -cp out com.example.app.Main

# Windows
java -cp out com.example.app.Main
```

### e. Multiple files across packages (compile whole source tree)

**Files**
```
.
├── src/
│   └── com/
│       └── example/
│           ├── util/
│           │   └── Utils.java
│           └── app/
│               └── Main.java
└── out/
```

**Compile entire source tree to `out/`**
```bash
# Option A: point javac at the top package(s)
javac -d out   src/com/example/util/Utils.java   src/com/example/app/Main.java

# Option B: use -sourcepath to let javac find dependencies
javac -d out -sourcepath src   src/com/example/app/Main.java
```

> [!IMPORTANT]
> **-sourcepath** `<sourcepath>` tells `javac` where to look for other `.java` files that a given source depends on.

### f. Single-file source execution (quick runs without `javac`)

Java 21 (since Java 11) lets you run small programs directly from source:

```bash
# Default package only
java Hello.java
```

Multiple source files are allowed if they’re in the **default package** and in the **same directory**:

```bash
java Main.java Helper.java
```

> If you use **packages**, prefer compiling to `out/` and running with `-cp`.

### g. Passing Parameters to a Java program

You can send data to your Java program through the parameters of the `main` entry point.

As we learned before, the `main` method can receive an array of strings in the form: **String[] args**. See [the section on main](#a-main-method-signature).

**Main.java printing out two parameters received in input by the "main" method**: 
```java
package com.example.app;

public class Main {
    public static void main(String[] args) {
        System.out.println(args[0]);
        System.out.println(args[1]);
    }
}
```

To pass parameter, just type (for example):

```bash
java Main.java Hello World  #space are used to separate the two arguments
```

If you want to pass an argument containing spaces, just use quotes:

```bash
java Main.java Hello "World Mario" #space are used to separate the two arguments
```

> If you declare to use (in this case print) the first two element of the parameter's array (as in our previous example) but, in fact, you pass less arguments, the jvm will notify you of a problem through a `java.lang.ArrayIndexOutOfBoundsException`.

> If, on the other hand, you pass more arguments than the method expects, it will print out just the two (in this case) expected. 


## 7. Strings & Text Blocks

### 1. Initializing Strings

In Java, a **String** is an object of the `java.lang.String` class, used to represent a sequence of characters.  
Strings are **immutable**, meaning that once created, their content cannot be changed. Any operation that seems to modify a string actually creates a new one.

You can create and initialize strings in several ways:

```java
String s1 = "Hello";                    // string literal
String s2 = new String("Hello");        // using constructor (not recommended)
String s3 = s1.toUpperCase();           // creates a new String ("HELLO")
```
> [!NOTE]
> - String literals are stored in the String pool, a special memory area used to avoid creating duplicate string objects.
> - Using the **new** keyword always creates a new object outside the pool.

### 2. Special Characters and Escape Sequences

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


### 3. Text Blocks (since Java 15)

A text block is a multi-line string literal introduced to simplify writing large strings (such as HTML, JSON, or code) without the need to escaped.
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

### 4. Formatting: Essential vs Incidental Whitespace

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
> - The closing """ are the leftmost characters of the resulting string: all the spaces on the left of the 3 Lines are **Incidental whitespaces**;
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

a) Use a line continuation backslash at the end of the last content line;
b) Put the ending three double quotes on the same line.

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









