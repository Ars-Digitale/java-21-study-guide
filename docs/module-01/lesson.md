# Lesson 1: Java Building Block 
## Class definition


A **Java class** is the fundamental building block of a Java program.
It represents a user-defined **type** which, as defined in programming language theory (see: [Syntax Building Blocks](syntax-building-blocks.md)), specifies the kind of data and the operations (methods) that this new type supports.<br>
A class serves as the blueprint — the definition of the new type — while objects are concrete instances of this type, created in memory at runtime.


A Java class is composed of two main elements, known as its **members**:

- **Fields** (or variables) — they represent the data that define the state of this newly created type.

- **Methods** (or functions) — they represent the operations that can be performed on this data.


## 1) `Person` class example

```java
public class Person {

	// This is a comment: explains the code but is ignored by the compiler

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

## Identifiers explained

> **Legend:** 
> Mandatory = required by Java syntax,  
> Optional = not required by syntax; depends on design.  

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| class | Keyword | Declares a class type. | Mandatory |
| Person | Class name (identifier) | The name of the class. | Mandatory |
| personName | Field name (identifier) | Stores the name of the person. | Optional |
| String | Type / Keyword | Type of the field `name`. | Mandatory |
| setPersonName, getPersonName | Method names (identifier) | Name a behavior of the class. | Optional |
| newName | Parameter name (identifier) | nput passed to the method setPersonName. | Mandatory (if the method needs a parameter) |
| return | Keyword | Exits a method and gives back a value. | Mandatory (in methods with a non-void return type) |
| void | Return Type / Keyword | Indicates the method does not return a value. | Mandatory (if the method does not return a value) |


**Notes**
- In its simplest form, we could theoretically have a class with no methods and no fields. Although such a class would compile, it would hardly make much sense.
