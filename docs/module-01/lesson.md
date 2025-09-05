# Lesson 1: Java Building Block 
## Class definition


A **Java class** is the fundamental building block of a Java program.
It represents a user-defined **type** which, as defined in programming language theory (see:[Syntax Building Blocks](syntax-building-bloks)), specifies the kind of data and the operations (methods) that this new type supports.<br>
A class serves as the blueprint — the definition of the new type — while objects are concrete instances of this type, created in memory at runtime.


A Java class is composed of two main elements, known as its **members**:

- **Fields** (or variables) — they represent the data that define the state of this newly created type.

- **Methods** (or functions) — they represent the operations that can be performed on this data.


## 1) `Person` class example

```java
public class Person {

    // Field → defines data/state
    String name;

    // Method → defines behavior
    void sayHello() {
        System.out.println("Hello, my name is " + name);
    }
}
```

---

## Identifiers explained

> **Legend:** <span class="mand">Mandatory</span> = required by Java syntax,  
> <span class="opt">Optional</span> = not required by syntax; depends on design.  

| Token / Identifier | Category | Meaning | Optional? |
|---|---|---|---|
| <span>class</span> | Keyword | Declares a class type. | <span>Mandatory</span> |
| <span>Person</span> | Class name (identifier) | The name of the class. | <span>Mandatory</span> |
| <span>name</span> | Field (identifier) | Stores the name of the person. | <span>Optional</span> |
| <span>String</span> | Type | Type of the field `name`. | <span>Mandatory</span> |
| <span>sayHello</span> | Method (identifier) | Defines a behavior of the class. | <span>Optional</span> |
| <span>void</span> | Return type | Indicates the method does not return a value. | <span>Mandatory</span> |


**Notes**
- In its simplest form, we could theoretically have a class with no methods and no fields. Although such a class would compile, it would hardly make much sense.
