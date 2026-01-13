# 2. Basic Language Java Building Blocks


### Table of Contents



- [2. Basic Language Java Building Blocks](#2-basic-language-java-building-blocks)
  - [2.1 Class Definition](#21-class-definition)
  - [2.2 Comments](#22-comments)
  - [2.3 Access Modifiers](#23-access-modifiers)
  - [2.4 Packages](#24-packages)
    - [2.4.1 Organization and Purpose](#241-organization-and-purpose)
    - [2.4.2 Mapping with the File System and Declaration of a Package](#242-mapping-with-the-file-system-and-declaration-of-a-package)
    - [2.4.3 Belonging to the Same Package](#243-belonging-to-the-same-package)
    - [2.4.4 Importing from a Package](#244-importing-from-a-package)
    - [2.4.5 Static Imports](#245-static-imports)
      - [2.4.5.1 Precedence Rules](#2451-precedence-rules)
    - [2.4.6 Standard vs. User-Defined Packages](#246-standard-vs-user-defined-packages)
  - [2.5 The main Method](#25-the-main-method)
    - [2.5.1 main Method Signature](#251-main-method-signature)
  - [2.6 Compiling and Running Your Code](#26-compiling-and-running-your-code)
    - [2.6.1 Compiling One File, Default Package (Single Directory)](#261-compiling-one-file-default-package-single-directory)
    - [2.6.2 Multiple Files, Default Package (Single Directory)](#262-multiple-files-default-package-single-directory)
    - [2.6.3 Code Inside Packages (standard src → out layout)](#263-code-inside-packages-standard-src--out-layout)
    - [2.6.4 Compiling to Another Directory (-d)](#264-compiling-to-another-directory--d)
    - [2.6.5 Multiple Files Across Packages (Compile Whole Source Tree)](#265-multiple-files-across-packages-compile-whole-source-tree)
    - [2.6.6 Single-File Source Execution (Quick Runs Without javac)](#266-singlefile-source-execution-quick-runs-without-javac)
    - [2.6.7 Passing Parameters to a Java Program](#267-passing-parameters-to-a-java-program)



---

This chapter introduces the essential structural elements of a Java program:
`classes`, `methods`, `comments`, `access modifiers`, `packages`, the `main` method, and the basic command-line tools (`javac` and `java`).

These are the minimum concepts needed to write, compile, organize, and run Java code in the JDK — without any IDE.
 
## 2.1 Class definition


A Java `class` is the fundamental building block of a Java program.
A class represents a **type** in Java: it defines structure (`fields`) and behavior (`methods`).

A `class` is a **blueprint**, while `objects` are **concrete instances** created at runtime.

A Java class is composed of two main elements, known as its **members**:
- **Fields** (or variables) — they represent the data that define the state of this newly created type.
- **Methods** (or functions) — they represent the operations that can be performed on this data.

Normally, each class is defined in its own "**.java**" file; for example, a class named Person will be defined in the corresponding file Person.java.

Any class that is independently defined in its own source file is called a **top-level class**.

Such a class can only be declared as `public` or `package-private` (i.e., with no access modifier).

A single file, however, may contain more than one class definition. **In this case, only one class can be declared public, and the file name must match that class**. 

**Nested class**, which are classes declared inside another class, can declare any access modifier: `public`, `protected`, `private`, `default` (package-private).



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

## 2.2 Comments

Comments are not executable code: they **explain** the code but are ignored by the compiler.

In Java there are 3 types of comments:
- Single-line (`//`)
- Multi-line (`/* ... */`)
- Javadoc (`/** ... */`)


A **single-line comment** starts with 2 slashes: all the text after that, on the same line, is ignored by the compiler.

- Example:

```java

// This is a single-line comment. It starts with 2 slashes and ends at the end of the line. 


```

A **multiline comment** includes anything between the symbols /* and */.

- Example:

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

will cause a compilation error because, while the first two symbols are part of the comment, the last symbol don't. The extra symbol `*/` is not valid syntax then and the compiler will complain. 

---

## 2.3 Access modifiers

In Java, an **access modifier** is a keyword that specifies the visibility (or accessibility) of a **class**, **method**, or **field**. It determines which other classes can use or see that element.

> [!NOTE]
> **Table of the access modifiers available in Java**

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| public | Keyword / access modifier | Visible from any class in any package | Yes |
| no modifier (default) | Keyword / access modifier | Visible only within the same package	| Yes |
| protected |	Keyword / access modifier |	Visible within the same package and by subclasses (even in other packages) | Yes |
| private	| Keyword / access modifier	| Visible only within the same class | Yes |

> [!TIP]
> **private > default > protected > public**  
> Think “visibility grows outward”.

---

## 2.4 Packages

**Java packages** are logical groupings of classes, interfaces, and sub-packages. They help organize large codebases, avoid name conflicts, and provide controlled access between different parts of an application.

### 2.4.1 Organization and Purpose
- Naming of packages follow the same rules of variable names. see: [Java Naming Rules](naming-rules.md)
- Packages are like **folders** for your Java source code.  
- They let you group related classes together (e.g., all utility classes in `java.util`, all networking classes in `java.net`).  
- By using packages, you can prevent **naming conflicts**: for example, you may have two classes named `Date`, but one is `java.util.Date` and another is `java.sql.Date`.

### 2.4.2 Mapping with the File System and declaration of a package
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

### 2.4.3 Belonging to the Same Package

Two classes belong to the same package if and only if:

- They are declared with the same package statement at the top of their source file.
- They are placed in the same directory of the source hierarchy.

- Example:

A class in package A.B.C; belongs to A.B.C only, not to A.B.
Classes in A.B cannot directly access **package-private** members of classes in A.B.C, because they are different packages.

Classes in the same package:

- Can access each other’s package-private members (i.e., members without an access modifier).
- Share the same namespace, so you don’t need to import them to use them.  

Example: Two files in the same package

```java
// File: src/com/example/tools/Tool.java
package com.example.tools;

public class Tool {
    static void hello() { System.out.println("Hi!"); }
}
```

```java
// File: src/com/example/tools/Runner.java
package com.example.tools;

public class Runner {
    public static void main(String[] args) {
        Tool.hello();    // OK: same package, no import needed
    }
}
```

### 2.4.4 Importing from a Package

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

### 2.4.5 Static imports


In addition to importing classes from a package, Java allows another kind of import: the **static import**.  
A *static import* lets you import **static members** of a class — such as static methods and static variables — so you can use them **without referencing the class name**.

You may import either **specific** static members or use a **wildcard** to import all static members of a class.


Example — Specific Static Import

```java
import static java.util.Arrays.asList;   // Imports Arrays.asList()

public class Example {

    List<String> arr = asList("first", "second");
    // We can call asList() directly, without using Arrays.asList()
}
```


Example — Static Import of a Constant

```java
import static java.lang.Math.PI;
import static java.lang.Math.sqrt;

public class Circle {
    double radius = 3;

    double area = PI * radius * radius;
    double diagonal = sqrt(2); 
}
```


Example — Wildcard Static Import

```java
import static java.lang.Math.*;

public class Calculator {
    double x = sqrt(49);   // 7.0
    double y = max(10, 20); 
    double z = random();   // calls Math.random()
}
```

Wildcard static imports behave exactly like normal wildcard imports:  
they bring **all static members** of the class into scope.

> [!REMEMBER]
> You can **always** call a static member with the class name:
> `Math.sqrt(16)` always works — even if imported statically.



#### 2.4.5.1 Precedence Rules

If the current class already declares a method or variable with the same name as the statically imported one:

- The **local member takes precedence**.
- The imported static member is **shadowed**.

Example:

```java
import static java.lang.Math.max;

public class Test {

    static int max(int a, int b) {   // local version
        return a > b ? a : b;
    }

    void run() {
        System.out.println(max(2, 5));  
        // Calls the LOCAL max(), not Math.max()
    }
}
```


> [!WARNING]
> - A static import **must** follow the exact syntax: `import static`.
> - The compiler forbids importing **two static members with the same simple name** if it creates ambiguity — even if they come from different classes or packages.

Example — **Not allowed**:

```java
import static java.util.Collections.emptyList;
import static java.util.List.of;

// ❌ ERROR: both methods have the same name `of()`
import static java.util.Set.of;
```

The compiler does not know which `of()` you intend to call → compilation fails.


>[!TIP]
> - Static imports are fine but **should not create confusion** — the exam may test ambiguous cases.
> - If two static imports introduce the same name, **any attempt to use that name causes a compile error**.
> - Static imports do **not** import classes, only static members.
> - You can still call the static member using the class name even if statically imported.

Example:

```java
import static java.lang.Math.sqrt;

double a = sqrt(16);        // imported
double b = Math.sqrt(25);   // fully qualified — always allowed
```


### 2.4.6 Standard vs. User-Defined Packages

**Standard packages**: shipped with the JDK (e.g., java.lang, java.util, java.io).

**User-defined packages**: created by developers to organize application code.

---

## 2.5 The `main` Method

In Java, the `main` method serves as the **entry point** of a standalone application. Its correct declaration is critical for the JVM to recognize it:

### 2.5.1 `main` method signature

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
>
> Java treats `String[] args` and `String... args` the same.  
> Both compile and run correctly as entry points.


---

## 2.6 Compiling and running your code


This chapter shows **correct, working** `javac` and `java` command lines for common situations in Java 21: single files, multiple files, packages, separate output directories, and classpath/module-path usage. 

Follow the directory layouts exactly.


> check your tools

```bash
javac -version   # should print: javac 21.x
java  -version   # should print: java version "21.0.7" ... (the output could be different depending on the implementation of the jvm you installed)
```

> [!WARNING]
> When running a class inside a package, **java requires the fully qualified name**, NEVER the path:
>
> `java com.example.app.Main` ✔
> 
> `java src/com/example/app/Main` ❌


### 2.6.1 Compiling one file, default package (single directory)

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

Once you have the .class file, in this case Hello.class, you can run the program with:

**Run**
```bash
java Hello
```

> [!IMPORTANT]
> You don't have to specify the ".class" extension when executing the program



### 2.6.2 Multiple files, default package (single directory)

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


### 2.6.3 Code inside packages (standard src → out layout)

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

### 2.6.4 Compiling to another directory (`-d`)

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

### 2.6.5 Multiple files across packages (compile whole source tree)

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


### 2.6.6 Single-file source execution (quick runs without `javac`)

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


### 2.6.7 Passing Parameters to a Java program

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

To pass parameters, just type (for example):

```bash
java Main.java Hello World  #spaces are used to separate the two arguments
```

If you want to pass an argument containing spaces, just use quotes:

```bash
java Main.java Hello "World Mario" #space are used to separate the two arguments
```

> If you declare to use (in this case print) the first two element of the parameter's array (as in our previous example) but, in fact, you pass less arguments, the jvm will notify you of a problem through a `java.lang.ArrayIndexOutOfBoundsException`.

> If, on the other hand, you pass more arguments than the method expects, it will print out just the two (in this case) expected. 

> `args.length` tells you how many arguments were provided.









