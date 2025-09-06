# Module 1: Java building Blocks

 
## 1. Class definition


A **Java class** is the fundamental building block of a Java program.
It represents a user-defined **type** which, as defined in programming language theory (see: [Syntax Building Blocks](syntax-building-blocks.md)), specifies the kind of data and the operations (methods) that this new type supports.<br>

A class serves as the blueprint — the definition of the new type — while objects are concrete instances of this type, created in memory at runtime.


A Java class is composed of two main elements, known as its **members**:

- **Fields** (or variables) — they represent the data that define the state of this newly created type.

- **Methods** (or functions) — they represent the operations that can be performed on this data.

Normally, each class is defined in its own **.java file**; for example, a class named Person will be defined in the corresponding file Person.java.

Any class that is independently defined in its own source file is called a **top-level class**.

Such a class can only be declared as public or package-private (i.e., with no access modifier).

A single file, however, may contain more than one class definition. In this case, only one class can be declared public, and the file name must match that class. 

Nested class, which are classes declared inside another class, can declare any access modifier: public, protected, private, default (package-private).


### a. `Person` class example

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

> **Identifiers explained:** 
> Mandatory = required by Java syntax,  
> Optional = not required by syntax; depends on design.  

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


> **Notes**
- In its simplest form, we could theoretically have a class with no methods and no fields. Although such a class would compile, it would hardly make much sense.

---

## 2. Access modifiers

In Java, an **access modifier** is a keyword that specifies the visibility (or accessibility) of a class, method, or field. It determines which other classes can use or see that element.

> **Table of the access modifiers available in Java**

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| public | Keyword / access modifier | Visible from any class in any package | Yes |
| no modifier (default) | Keyword / access modifier | Visible only within the same package	| Yes |
| protected |	Keyword / access modifier |	Visible within the same package and by subclasses (even in other packages) | Yes |
| private	| Keyword / access modifier	| Visible only within the same class | Yes |

---

## 3. Packages

**Java packages** are logical groupings of classes, interfaces, and sub-packages. They help organize large codebases, avoid name conflicts, and provide controlled access between different parts of an application.

### a. Organization and Purpose
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

> This declaration means the class must be located in the directory: **com/example/myapp/utils/**

### c. Belonging to the Same Package

Two classes belong to the same package if and only if:

- They are declared with the same package statement at the top of their source file.
- They are placed in the same directory of the source hierarchy.

Example:

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
```

> **Notes**

> \* imports all types in the package but not its subpackages.

You can always use the fully qualified name instead of importing:

```java
java.util.List myList = new java.util.ArrayList<>();
```

### e. Standard vs. User-Defined Packages

**Standard packages**: shipped with the JDK (e.g., java.lang, java.util, java.io).

**User-defined packages**: created by developers to organize application code.


