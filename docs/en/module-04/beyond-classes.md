# 17. Beyond Classes

### Table of Contents

- [17. Beyond Classes](#17-beyond-classes)
  - [17.1 Interfaces](#171-interfaces)
    - [17.1.1 What Interfaces Can Contain](#1711-what-interfaces-can-contain)
    - [17.1.2 Implementing an Interface](#1712-implementing-an-interface)
    - [17.1.3 Multiple Inheritance](#1713-multiple-inheritance)
    - [17.1.4 Interface Inheritance and Conflicts](#1714-interface-inheritance-and-conflicts)
    - [17.1.5 Default methods](#1715-default-methods)
    - [17.1.6 Static methods](#1716-static-methods)
    - [17.1.7 Private interface methods](#1717-private-interface-methods)
  - [17.2 Sealed, non-sealed, and final Types](#172-sealed-non-sealed-and-final-types)
    - [17.2.1 Rules](#1721-rules)
  - [17.3 Enums](#173-enums)
    - [17.3.1 Simple Enum Definition](#1731-simple-enum-definition)
    - [17.3.2 Complex Enums with State and Behavior](#1732-complex-enums-with-state-and-behavior)
    - [17.3.3 Enum Methods](#1733-enum-methods)
    - [17.3.4 Rules](#1734-rules)
  - [17.4 Records Java 16+](#174-records-java-16)
    - [17.4.1 Summary of Basic Rules for Records](#1741-summary-of-basic-rules-for-records)
    - [17.4.2 Long Constructor](#1742-long-constructor)
    - [17.4.3 Compact Constructor](#1743-compact-constructor)
    - [17.4.4 Pattern Matching for Records](#1744-pattern-matching-for-records)
    - [17.4.5 Nested Record Patterns and Matching Records with var and Generics](#1745-nested-record-patterns-and-matching-records-with-var-and-generics)
      - [17.4.5.1 Basic Nested Record Pattern](#17451-basic-nested-record-pattern)
      - [17.4.5.2 Nested Record Patterns with var](#17452-nested-record-patterns-with-var)
      - [17.4.5.3 Nested Record Patterns and Generics](#17453-nested-record-patterns-and-generics)
      - [17.4.5.4 Common Errors with Nested Record Patterns](#17454-common-errors-with-nested-record-patterns)
  - [17.5 Nested Classes in Java](#175-nested-classes-in-java)
    - [17.5.1 Static Nested Classes](#1751-static-nested-classes)
      - [17.5.1.1 Syntax and Access Rules](#17511-syntax-and-access-rules)
      - [17.5.1.2 Common Pitfalls](#17512-common-pitfalls)
    - [17.5.2 Inner Classes Non-Static Nested Classes](#1752-inner-classes-non-static-nested-classes)
      - [17.5.2.1 Syntax and Access Rules](#17521-syntax-and-access-rules)
      - [17.5.2.2 Common Pitfalls](#17522-common-pitfalls)
    - [17.5.3 Local Classes](#1753-local-classes)
      - [17.5.3.1 Characteristics](#17531-characteristics)
      - [17.5.3.2 Common Pitfalls](#17532-common-pitfalls)
    - [17.5.4 Anonymous Classes](#1754-anonymous-classes)
      - [17.5.4.1 Syntax and Usage](#17541-syntax-and-usage)
      - [17.5.4.2 Anonymous Class Extending a Class](#17542-anonymous-class-extending-a-class)
    - [17.5.5 Comparison of Nested Class Types](#1755-comparison-of-nested-class-types)


---

This chapter presents several advanced type mechanisms beyond the Java Class design: **interfaces**, **enums**, **sealed / non-sealed classes**, **records**, and **nested classes**. 

## 17.1 Interfaces

An **interface** in Java is a reference type that defines a contract of methods that a class agrees to implement. 

An `interface` is implicitly `abstract` and cannot be marked as `final`: as with top-level classes, an interface can declare visibility as `public` or `default` (package-private).

A Java class may implement any number of interfaces through the `implements` keyword.

An `interface` may in turn extend multiple interfaces using the `extends` keyword.

Interfaces enable abstraction, loose coupling, and multiple inheritance of type.

### 17.1.1 What Interfaces Can Contain

- **Abstract methods** (implicitly `public` and `abstract`)
- **Concrete methods**
	- **Default methods** (include code and are implicitly `public`)
	- **Static methods** (declared as `static`, include code and are implicitly `public`)
	- **Private methods** (Java 9+) for internal reuse
- **Constants** → implicitly `public static final` and initialized at declaration

```java
interface Calculator {
    int add(int a, int b);                 // abstract
    default int mult(int a, int b) {       // default method
        return a * b;
    }
    static double pi() { return 3.14; }    // static method
}
```

!!! warning
    Because interface abstract methods are implicitly `public`, you **cannot** reduce the access level on an implementing method.


### 17.1.2 Implementing an Interface

```java
class BasicCalc implements Calculator {
    public int add(int a, int b) { return a + b; }
}
```

!!! note
    **Every** abstract method must be implemented unless the class is abstract.


### 17.1.3 Multiple Inheritance

A class may implement multiple interfaces.

```java
interface A { void a(); }
interface B { void b(); }

class C implements A, B {
    public void a() {}
    public void b() {}
}
```


### 17.1.4 Interface Inheritance and Conflicts

If two interfaces provide `default` methods with the same signature, the implementing class must override the method.

```java
interface X { default void run() { } }
interface Y { default void run() { } }

class Z implements X, Y {
    public void run() { } // mandatory
}
```

If you still want to access a particular implementation of the inherited `default` method, you can use the following syntax:


```java
interface X { default int run() { return 1; } }
interface Y { default int run() { return 2; } }

class Z implements X, Y {
    public int useARun(){
		return Y.super.run();
	}
}
```
 
### 17.1.5 `Default` methods

A `default` method (declared with the `default` keyword) is a method that defines an implementation and can be overridden by a class implementing the interface.


- A default method include code and is implicitly `public`;
- A default method cannot be `abstract`, `static` or `final`;
- As we saw just above, if two interfaces provide default methods with the same signature, the implementing class must override the method;
- An implementig class may of course rely on the provided implementation of the `default` method without overriding it;
- The `default` method can be invoked on an instance of the implementing class and NOT as a `static` method of the containing interface;

### 17.1.6 `Static` methods

- An interface can provide `static methods` (through the keyword `static`) which are implicitly `public`;
- Static methods must include a method body and are accessed using the interface name;
- Static methods cannot be `abstract` or `final`;

### 17.1.7 `Private` interface methods

Among all the concrete methods that an interface can implement, we also have:

- **`private` methods**: visible only inside the declaring interface and which can only be invoked from a `non-static` context (`default` methods or other `non-static private methods`).
- **`private static` methods**: visible only inside the declaring interface and which can be invoked by any method of the enclosing interface.

---

## 17.2 Sealed, non-sealed, and final Types

`Sealed` classes and interfaces (Java 17+) restrict which other classes (or interfaces) can extend or implement them.

A `sealed type` is declared by placing the `sealed` modifier right before the class (or interface) keyword, and adding, after the Type name, the `permits` keyword followed by the list of types that can extend (or implement) it.

```java
public sealed class Shape permits Circle, Rectangle { }

final class Circle extends Shape { }

non-sealed class Rectangle extends Shape { }
```

### 17.2.1 Rules

- A sealed Type must declare all permitted subtypes.
- A permitted subtype must be **final**, **sealed**, or **non-sealed**; because interfaces cannot be final, they can only be marked `sealed` or `non-sealed` when extending a sealed interface.
- Sealed types must be declared in the same package (or named module) as their direct sub-types.

---

## 17.3 Enums

**Enums** define a fixed set of constant values. 

`Enums` can declare `fields`, `constructors`, and `methods` as regular classes do but **they can't be extended**.

The list of enum values must end with a semicolon `(;)` in case of `Complex Enums`, but this is not mandatory for `Simple Enums`.


### 17.3.1 `Simple` Enum Definition

```java
enum Day { MON, TUE, WED, THU, FRI, SAT, SUN } // semicolon not present
```


### 17.3.2 `Complex` Enums with State and Behavior

```java
enum Level {
    LOW(1), MEDIUM(5), HIGH(10); // mandatory semicolon
	
    private int code; 
	
    Level(int code) { this.code = code; }
	
    public int getCode() { return code; }
}

public static void main(String[] args) {
	Level.MEDIUM.getCode();		// invoking a method
}
```

### 17.3.3 Enum Methods


- `values()` – returns an array of all the constant values that can be used, for example, in a `for-each` loop
- `valueOf(String)` – returns constant by name
- `ordinal()` – index (int) of the constant

### 17.3.4 Rules

- Enum constructors are implicitly `private`;
- Enums can contain `static` and `instance` methods;
- Enums can implement `interfaces`;

---

## 17.4 Records (Java 16+)

A **record** is a special class designed to model immutable data: they are, in fact, implicitly **final**. 

You can't extend a record, but it is allowed to implement a regular or sealed interface.

It automatically provides:

- **private final fields** for each component
- **constructor** with parameters in the same order as in the record declaration;
- **getters** (named like fields)
- **`equals()`, `hashCode()`, `toString()`**: you are also permitted to override those methods
- **Records** can include `nested classes`, `interfaces`, `records`, `enums` and `annotations`

```java
public record Point(int x, int y) { }

var element = new Point(11, 22);

System.out.println(element.x);
System.out.println(element.y);
```

If you need additional validation or transformation of the provided fields, you can define a `long constructor` or a `compact constructor`.

### 17.4.1 Summary of Basic Rules for Records

A record may be declared in three locations:

- As a **top-level record** (directly in a package)
- As a **member record** (inside a class or interface)
- As a **local record** (inside a method)

All `member` and `local` record classes are implicitly `static`.

- A member record may redundantly declare `static`.
- A local record must not declare `static` explicitly.

Every record class is implicitly `final`.

- Declaring `final` explicitly is permitted but redundant.
- A record cannot be declared `abstract`, `sealed`, or `non-sealed`.

The direct superclass of every record is `java.lang.Record`.

- A record cannot declare an `extends` clause.
- A record cannot extend any other class.

Serialization of records differs from ordinary serializable classes.

- During deserialization, the canonical constructor is invoked.

The body of a record may contain:

- Constructors
- Methods
- Static fields
- Static initializer blocks

The body of a record must NOT contain:

- Instance field declarations
- Instance initializer blocks
- `abstract` methods
- `native` methods
```


### 17.4.2 Long Constructor

```java
public record Person(String name, int age) {

    public Person (String name, int age){
        if (age < 0) throw new IllegalArgumentException();
		this.name = name;
		this.age = age;
    }
}
```

You can still define overloaded constructors, as long as they ultimately delegate to the canonical one using `this(...)`:

```java
public record Point(int x, int y) {

    // Overloaded constructor (NOT canonical)
    public Point(int value) {
        this(value, value); // must call, in the first line, another overloaded constructor and, ultimately, the canonical one.
    }
}
```

!!! note
    - The compiler will not insert a constructor if you manually provide one with the same list of parameters in the defined order;
    - In this case, you must explicitly set every field manually;

### 17.4.3 Compact Constructor

You can define a `compact constructor` which implicitly sets all fields, while letting you perform validations and transformations on selected fields.

Java will execute the full constructor, setting all fields, after the compact constructor has completed.


```java
public record Person(String name, int age) {

    public Person {
        if (age < 0) throw new IllegalArgumentException();
		
		name = name.toUpperCase(); // This transformation is still (at this level of initialization) on the input parameter.
		
		// this.name = name; // ❌ Does not compile.
    }	
}
```

!!! warning
    - If you try to modify a Record field inside a Compact Constructor, your code will not compile


### 17.4.4 Pattern Matching for Records

When you use pattern matching with `instanceof` or with `switch`, a record pattern must specify:

- The record type;
- A pattern for each field of the record (matching the correct number of components, and compatible types);

Example record:

```java
Object obj = new Point(3, 5);

if (obj instanceof Point(int a, int b)) {
    System.out.println(a + b);   // 8
}
```

### 17.4.5 Nested Record Patterns and Matching Records with `var` and Generics

Nested record patterns allow you to destructure records that contain other records or complex types, extracting values recursively directly within the pattern itself.

They combine the power of `record` deconstruction with pattern matching, giving you a concise and expressive way to navigate hierarchical data structures.


#### 17.4.5.1 Basic Nested Record Pattern

If a record contains another record, you can destructure both at once:

```java
record Address(String city, String country) {}
record Person(String name, Address address) {}

void printInfo(Object obj) {

	switch (obj) {
		case Person(String n, Address(String c, String co)) -> System.out.println(n + " lives in " + c + ", " + co);
		default -> System.out.println("Unknown");
	}
}
```

In the example above, the `Person` pattern includes a nested `Address` pattern.

Both are matched structurally.

#### 17.4.5.2 Nested Record Patterns with `var`

Instead of specifying exact types for each field, you can use `var` inside the pattern to let the compiler infer the type. 

```java
	switch (obj) {
		case Person(var name, Address(var city, var country)) -> System.out.println(name + " — " + city + ", " + country);
	}
```

`var` in patterns works like `var` in local variables: it means "infer the type".

!!! warning
    - You still need the enclosing record type (Person, Address);
    - only the field types can be replaced with `var`.

#### 17.4.5.3 Nested Record Patterns and Generics

Record patterns also work with generic records.

```java
record Box<T>(T value) {}
record Wrapper(Box<String> box) {}

static void test(Object o) {
	switch (o) {
		case Wrapper(Box<String>(var v)) -> System.out.println("Boxed string: " + v);
		default -> System.out.println("Something else");
	}
}
```

In this example:

- The pattern requires exactly `Box<String>`, not `Box<Integer>`.
- Inside the pattern, `var v` captures the unboxed generic value.

#### 17.4.5.4 Common Errors with Nested Record Patterns

Mismatched record structure

```java
// ❌ ERROR: pattern does not match record structure
case Person(var n, var city) -> ...
```

`Person` has 2 fields, but one of them is a record. You must destructure correctly.

Wrong number of components

```java
// ❌ ERROR: Address has 2 components, not 1
case Person(var n, Address(var onlyCity)) -> ...
```

Generic mismatch

```java
// ❌ ERROR: expecting Box<String> but found Box<Integer>
case Wrapper(Box<Integer>(var v)) -> ...
```

Illegal placement of `var`

```java
// ❌ var cannot replace the record type itself
case var(Person(var n, var a)) -> ...
```

!!! note
    - `var` cannot stand in for the whole pattern, only for individual components.

---

## 17.5 Nested Classes in Java

Java supports several kinds of **nested classes** — classes declared inside another class.
  
They are a fundamental tool for encapsulation, code organization, event-handling patterns, and representing logical hierarchies.
  
A nested class always belongs to an **enclosing class** and has special accessibility and instantiation rules depending on its category.

Java defines four kinds of nested classes:

- **Static Nested Classes** – declared with `static` inside another class.
- **Inner Classes** (non-static **nested** classes).
- **Local Classes** – declared inside a block (method, constructor, or initializer).
- **Anonymous Classes** – unnamed classes created inline, usually to override a method or implement an interface.


!!! warning
    - `static` applies only to **nested member** classes
	- `Top-level` classes → cannot be static
	- `Local` classes (inside methods) → cannot be static
	- `Anonymous` classes → cannot be static
	- A `static nested` class cannot access instance members without an explicit outer object reference.
	

### 17.5.1 Static Nested Classes

A **static nested class** behaves like a top-level class that is namespaced inside its enclosing class.  
It **cannot** access instance members of the outer class but **can** access static members.  
It does **not** hold a reference to an instance of the enclosing class.

#### 17.5.1.1 Syntax and Access Rules

- Declared using `static class` inside another class.
- Can access only **static** members of the outer class.
- Does not have an implicit reference to the enclosing instance.
- Can be instantiated without an outer instance.

```java
class Outer {
    static int version = 1;

    static class Nested {
        void print() {
            System.out.println("Version: " + version); // OK: accessing static member
        }
    }
}

class Test {
    public static void main(String[] args) {
        Outer.Nested n = new Outer.Nested(); // No Outer instance required
        n.print();
    }
}
```

#### 17.5.1.2 Common Pitfalls

- Static nested classes **cannot access instance variables**:

```java
class Outer {
    int x = 10;
    static class Nested {
        void test() {
            // System.out.println(x); // ❌ Compile error
        }
    }
}
```

### 17.5.2 Inner Classes (Non-Static Nested Classes)

An **inner class** is associated with an instance of the outer class and can access **all members** of the outer class, including **private** ones.

#### 17.5.2.1 Syntax and Access Rules

- Declared without `static`.
- Has an implicit reference to the enclosing instance.
- Can access both static and instance members of the outer class.
- Since it is not static, it must be created through an instance of the enclosing class.


```java
class Outer {
    private int value = 100;

    class Inner {
        void print() {
            System.out.println("Value = " + value); // OK: accessing private
        }
    }

    void make() {
        Inner i = new Inner(); // OK inside the outer class
        i.print();
    }
}

class Test {
    public static void main(String[] args) {
        Outer o = new Outer();
        Outer.Inner i = o.new Inner(); // MUST be created from an instance
        i.print();
    }
}
```

#### 17.5.2.2 Common Pitfalls

- Inner classes **cannot declare static members** except **static final constants**.

```java
class Outer {
    class Inner {
        // static int x = 10;     // ❌ Compile error
        static final int OK = 10; // ✔ Allowed (constant)
    }
}
```

!!! warning
    - Instantiating an inner class WITHOUT an outer instance is illegal.


### 17.5.3 Local Classes

A **local class** is a nested class defined inside a block — most commonly a method.
  
It has no access modifier and is visible only within the block where it is declared.

#### 17.5.3.1 Characteristics

- Declared inside a method, constructor, or initializer.
- Can access members of the outer class.
- Can access local variables if they are **effectively final**.
- Cannot declare static members (except static final constants).

```java
class Outer {
    void compute() {
        int base = 5; // must be effectively final

        class Local {
            void show() {
                System.out.println(base); // OK
            }
        }

        new Local().show();
    }
}
```

#### 17.5.3.2 Common Pitfalls

- `base` must be effectively final; changing it breaks compilation.

```java
void compute() {
    int base = 5;
    base++; // ❌ Now base is NOT effectively final
    class Local {}
}
```

### 17.5.4 Anonymous Classes

An **anonymous class** is a one-off class created inline, usually to implement an interface or override a method without naming a new class.

#### 17.5.4.1 Syntax and Usage

- Created using `new` + type + body.
- Cannot have constructors (no name).
- Often used for event handling, callbacks, comparators.

```java
Runnable r = new Runnable() {
    @Override
    public void run() {
        System.out.println("Anonymous running");
    }
};
```

#### 17.5.4.2 Anonymous Class Extending a Class

```java
Button b = new Button("Click");
b.onClick(new ClickHandler() {
    @Override
    public void handle() {
        System.out.println("Handled!");
    }
});
```


### 17.5.5 Comparison of Nested Class Types

A quick table summarizing all kinds of nested classes.


|Type                | Has Outer Instance? | Can Access Outer Instance Members? | Can Have Static Members? | Typical Use |
|------------------- | ------------------- | ---------------------------------- | ------------------------- | --------------------------- |
|Static Nested       | No                  | No                                 | Yes                      | Namespacing, helpers |
|Inner Class         | Yes                 | Yes                                | No (except constants)     | Object-bound behavior |
|Local Class         | Yes                 | Yes                                | No                        | Temporary scoped classes |
|Anonymous Class     | Yes                 | Yes                                | No                        | Inline customization |



