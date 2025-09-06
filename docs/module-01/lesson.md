# Lesson 1: Java building Blocks

 
## 1. Class definition


A **Java class** is the fundamental building block of a Java program.
It represents a user-defined **type** which, as defined in programming language theory (see: [Syntax Building Blocks](syntax-building-blocks.md)), specifies the kind of data and the operations (methods) that this new type supports.<br>
A class serves as the blueprint — the definition of the new type — while objects are concrete instances of this type, created in memory at runtime.


A Java class is composed of two main elements, known as its **members**:

- **Fields** (or variables) — they represent the data that define the state of this newly created type.

- **Methods** (or functions) — they represent the operations that can be performed on this data.

Normally, each class is defined in its own .java file; for example, a class named Person will be defined in the corresponding file Person.java.

Any class that is independently defined in its own source file is called a **top-level class**.

Such a class can only be declared as public or package-private (i.e., with no access modifier).

A single file, however, may contain more than one class definition. In this case, only one class can be declared public, and the file name must match that class. 

Nested class, which are classes declared inside another class, can declare any access modifier: public, protected, private, default (package-private).

## 2. Access Modifiers

In Java, an **access modifier** is a keyword that specifies the visibility (or accessibility) of a class, method, or field. It determines which other classes can use or see that element.

> **Table of the access modifiers in Java**

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| public | Keyword / access modifier | Visible from any class in any package | Yes |
| no modifier (default) | Keyword / access modifier | Visible only within the same package	| Yes |
| protected |	Keyword / access modifier |	Visible within the same package and by subclasses (even in other packages) | Yes |
| private	| Keyword / access modifier	| Visible only within the same class | Yes |

---

### `Person` class example

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

---

### Identifiers explained

> **Legend:** 
> Mandatory = required by Java syntax,  
> Optional = not required by syntax; depends on design.  

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| public | Keyword / access modifier | determines which other classes can use or see that element | Mandatory (when absent is, by default, package-private |
| class | Keyword | Declares a class type. | Mandatory |
| Person | Class name (identifier) | The name of the class. | Mandatory |
| personName | Field name (identifier) | Stores the name of the person. | Optional |
| String | Type / Keyword | Type of the field `personName` and of the parameter `newName`. | Mandatory |
| setPersonName, getPersonName | Method names (identifier) | name a behavior of the class. | Optional |
| newName | Parameter name (identifier) | input passed to the method `setPersonName`. | Mandatory (if the method needs a parameter) |
| return | Keyword | Exits a method and gives back a value. | Mandatory (in methods with a non-void return type) |
| void | Return Type / Keyword | Indicates the method does not return a value. | Mandatory (if the method does not return a value) |


**Notes**
- In its simplest form, we could theoretically have a class with no methods and no fields. Although such a class would compile, it would hardly make much sense.
