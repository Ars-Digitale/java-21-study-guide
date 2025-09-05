<style>
  .kw { color:#005cc5; font-weight:600; }     /* keyword */
  .type { color:#6f42c1; font-weight:600; }   /* type name */
  .id { color:#1a7f37; }                      /* identifier (name) */
  .mand { color:#0b75d1; font-weight:700; }   /* mandatory */
  .opt { color:#b31d28; font-weight:700; }    /* optional */
</style>

# Lesson 1: Java Building Block 

## Class definition


A **Java class** is the fundamental building block of a Java program.
It represents a user-defined **type** which, as defined in programming language theory [See Syntax Building Blocks](syntax-building-bloks), specifies the kind of data and the operations (methods) that this new type supports.<br>
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
| <span class="kw">class</span> | Keyword | Declares a class type. | <span class="mand">Mandatory</span> |
| <span class="id">Person</span> | Class name (identifier) | The name of the class. | <span class="mand">Mandatory</span> |
| <span class="id">name</span> | Field (identifier) | Stores the name of the person. | <span class="opt">Optional</span> |
| <span class="type">String</span> | Type | Type of the field `name`. | <span class="mand">Mandatory</span> |
| <span class="id">sayHello</span> | Method (identifier) | Defines a behavior of the class. | <span class="opt">Optional</span> |
| <span class="kw">void</span> | Return type | Indicates the method does not return a value. | <span class="mand">Mandatory</span> |


**Notes**
- In its simplest form, we could theoretically have a class with no methods and no fields. Although such a class would compile, it would hardly make much sense.
