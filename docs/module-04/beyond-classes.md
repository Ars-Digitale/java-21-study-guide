# Beyond Classes

### Table of Contents

- [Beyond Classes]
	- [1. Interfaces](#1-interfaces)
	  - [1.1 What Interfaces Can Contain](#11-what-interfaces-can-contain)
	  - [1.2 Implementing an Interface](#12-implementing-an-interface)
	  - [1.3 Multiple Inheritance](#13-multiple-inheritance)
	  - [1.4 Interface Inheritance and Conflicts](#14-interface-inheritance-and-conflicts)
	  - [1.5 Default methods](#15-default-methods)
	  - [1.6 Static methods](#16-static-methods)
	  - [1.7 Private interface methods](#17-private-interface-methods)
	- [2. Sealed and non-sealed Types](#2-sealed-and-non-sealed-types)
	  - [2.1 Rules](#21-rules)
	- [3. Enums](#3-enums)
	  - [3.1 Simple Enum Definition](#31-simple-enum-definition)
	  - [3.2 Complex Enums with State and Behavior](#32-complex-enums-with-state-and-behavior)
	  - [3.3 Enum Methods](#33-enum-methods)
	  - [3.4 Rules](#34-rules)
	- [4. Records (Java 16+)](#4-records-java-16)
	  - [4.1 Long Constructor](#41-long-constructor)
	  - [4.2 Compact Constructor](#42-compact-constructor)
	  - [4.3 Pattern Matching for Records](#43-pattern-matching-for-records)
	  - [4.4 Nested Record Patterns and Matching Records with var and Generics](#44-nested-record-patterns-and-matching-records-with-var-and-generics)
		- [4.4.1 Basic Nested Record Pattern](#441-basic-nested-record-pattern)
		- [4.4.2 Nested Record Patterns with var](#442-nested-record-patterns-with-var)
		- [4.4.3 Nested Record Patterns and Generics](#443-nested-record-patterns-and-generics)
		- [4.4.4 Common Errors with Nested Record Patterns](#444-common-errors-with-nested-record-patterns)
	- [5. Nested Classes in Java](#5-nested-classes-in-java)
	  - [5.1 Static Nested Classes](#51-static-nested-classes)
		- [5.1.1 Syntax and Access Rules](#511-syntax-and-access-rules)
		- [5.1.2 Common Pitfalls](#512-common-pitfalls)
	  - [5.2 Inner Classes (Non-Static Nested Classes)](#52-inner-classes-non-static-nested-classes)
		- [5.2.1 Syntax and Access Rules](#521-syntax-and-access-rules)
		- [5.2.2 Common Pitfalls](#522-common-pitfalls)
	  - [5.3 Local Classes](#53-local-classes)
		- [5.3.1 Characteristics](#531-characteristics)
		- [5.3.2 Common Pitfalls](#532-common-pitfalls)
	  - [5.4 Anonymous Classes](#54-anonymous-classes)
		- [5.4.1 Syntax and Usage](#541-syntax-and-usage)
		- [5.4.2 Anonymous Class Extending a Class](#542-anonymous-class-extending-a-class)
	  - [5.5 Comparison of Nested Class Types](#55-comparison-of-nested-class-types)

---

This chapter presents several advanced type mechanisms beyond the Java Class design: **interfaces**, **enums**, **sealed / non-sealed classes**, **records**, and **nested classes**. 

## 1. Interfaces

An **interface** in Java is a reference type that defines a contract of methods that a class agrees to implement. 

An interface is implicitly `abstract` and cannot be marked as `final`: as with top-level classes, an interface can declare visibility of type `public` or `default (package private)`.

A Java class may implement any number of interface through the `implements` keyword.

An `interface` may in turn extend multiple interfaces using the `extends` keyword.

Interfaces enable abstraction, loose coupling, and multiple inheritance of type.

### 1.1 What Interfaces Can Contain

- **Abstract methods** (implicitly `public` and `abstract`)
- **Concrete methods**
	- **Default methods** (include code and is implicitly `public`)
	- **Static methods** (declared as `static`, include code and is implicitly `public`)
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

> [!WARNING]
> - Because interface abstract methods are implicitly `public`, you CAN'T reduce the access level on an implementing method

### 1.2 Implementing an Interface

```java
class BasicCalc implements Calculator {
    public int add(int a, int b) { return a + b; }
}
```

> [!NOTE]
> - **Every** abstract method must be implemented unless the class is abstract.


### 1.3 Multiple Inheritance

A class may implement multiple interfaces.

```java
interface A { void a(); }
interface B { void b(); }

class C implements A, B {
    public void a() {}
    public void b() {}
}
```


### 1.4 Interface Inheritance and Conflicts

If two interfaces provide default methods with the same signature, the implementing class must override the method.

```java
interface X { default void run() { } }
interface Y { default void run() { } }

class Z implements X, Y {
    public void run() { } // mandatory
}
```

In case you would still access a particular implementation of the `inherited default` method, you can do it through the following syntax:

```java
interface X { default int run() { } }
interface Y { default int run() { } }

class Z implements X, Y {
    public int useARun(){
		return Y.super.run();
	}
}
```
 
### 1.5 Default methods

A `default` method (declared with the `default` keyword) is a method that define an implementation and can be `overridden` by a class implementing the interface. 

- A default method include code and is implicitly `public`;
- A default method cannot be `abstract`, `static` or `final`;
- As we saw just above, if two interfaces provide default methods with the same signature, the implementing class must override the method;
- An implementig class may of course rely on the provided implementation of the `default` method without overriding it;
- The `default` method can be invoked on an instance of the implementing class and NOT as a `static` method of the containing interface;

### 1.6 Static methods

- An interface can provide `static methods` (through the keyword `static`) which are implicitly `public`;
- Static methods must include a method body and are accessed through the reference of the interface name;
- Static methods cannot be `abstract` or `final`;

### 1.7 Private interface methods

Among all the concrete methods that an interface can implement we have also:

- **`private` methods**: visible only inside the declaring interface and which can only be invoked from a `non-static` context (`default` methods or other `non-static private methods`).
- **`private static` methods**: visible only inside the declaring interface and which can be invoked by any method of the enclosing interface.

## 2. Sealed and non-sealed Types

Sealed classes and interfaces (Java 17+) restrict which other classes (or interfaces) can extend or implement them.

A sealed type is declared by placing the `sealed` modifier right before the class (or interface) keyword, and adding, after the Type name, the `permits` keyword followed by the list of types that can extend (or implement) it.

```java
public sealed class Shape permits Circle, Rectangle { }

final class Circle extends Shape { }

non-sealed class Rectangle extends Shape { }
```

### 2.1 Rules

- A sealed Type must declare all permitted Sub-Types.
- A permitted sub-type must be **final**, **sealed**, or **non-sealed**; because interfaces cannot be final, they can only be marked `sealed` or `non-sealed` when extending a sealed interface.
- Sealed Types must be declared in the same package (or named module) as their direct sub-types.

---

## 3. Enums

**Enums** define a fixed set of constant values. 

Enums can declare fields, constructors, and methods as regular classes do but they can't be extended.

The list of enum values must end with a semicolon `(;)` in case of `Complex Enums`, but this is not mandatory for `Simple Enums`.

### 3.1 `Simple` Enum Definition

```java
enum Day { MON, TUE, WED, THU, FRI, SAT, SUN }
```


### 3.2 `Complex` Enums with State and Behavior

```java
enum Level {
    LOW(1), MEDIUM(5), HIGH(10);
	
    private int code; 
	
    Level(int code) { this.code = code; }
	
    public int getCode() { return code; }
}

public static void main(String[] args) {
	Level.MEDIUM.getCode();		// invoking a method
}
```

### 3.3 Enum Methods

- `values()` – returns an array of all the constants values that can be used, for example, in a `for-each` loop
- `valueOf(String)` – returns constant by name
- `ordinal()` – index (int) of the constant

### 3.4 Rules

- Enum Constructors are implicitly `private`;
- Enum can contain `static` and `instance` methods;
- Enums can implement `interfaces`;

---

## 4. Records (Java 16+)

A **record** is a special class designed to model immutable data: they are, in fact, implicitly **final**. 

You can't extend or inherit a record but it is allowed to implement a regular or sealed interface.

It automatically provides:

- **private final fields** for each component
- **constructor** with parameters in the same order as in the record declaration;
- **getters** (named like fields)
- **`equals()`, `hashCode()`, `toString()`**: you are also permitted to override those methods
- Records can can include `nested classes`, `interfaces`, `records`, `enums` and `annotations`

```java
public record Point(int x, int y) { }

var element = new Point(11, 22);

System.out.println(element.x);
System.out.println(element.y);
```

In case you need additional validation or tranformation over the provided fields, you can declare: `Long Constructors` or `Compact Constructors`.

### 4.1 Long Constructor

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

>[!NOTE]
> - The compiler will not insert a constructor if you manually provide one with the same list of parameters in the defined order;
> - In this case, you must explicitly set every field manually;

### 4.2 Compact Constructor

You can define a Compact constructor which implicitly set all fields, while letting you perform validations and transformations on some target fields.
Java will execute the full constructor, setting all fields, after the Compact COnstructor has completed.

```java
public record Person(String name, int age) {

    public Person {
        if (age < 0) throw new IllegalArgumentException();
		
		name = name.toUpperCase(); // This transformation is still (at this level of initialization) on the input parameter.
		
		// this.name = name; // ❌ Does not compile.
    }	
}
```

> [!WARNING]
> - If you try to modify a Record field inside a Compact Constructor, your code will not compile


### 4.3 Pattern Matching for Records

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

### 4.4 Nested Record Patterns and Matching Records with `var` and Generics

Nested record patterns allow you to destructure records that contain other records or complex types, extracting values recursively directly within the pattern itself.

They combine the power of `record` deconstruction with pattern matching, giving you a concise and expressive way to navigate hierarchical data structures.

#### 4.4.1 Basic Nested Record Pattern

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

Here above the `Person` pattern includes a nested `Address` pattern. 
Both are matched structurally.

#### 4.4.2 Nested Record Patterns with `var`

Instead of specifying exact types for each field, you can use `var` inside the pattern to let the compiler infer the type. 

```java
	switch (obj) {
		case Person(var name, Address(var city, var country)) -> System.out.println(name + " — " + city + ", " + country);
	}
```

`var` in patterns works like `var` in local variables: it means "infer the type".

> [!WARNING]
> - You still need the enclosing record type (Person, Address); 
> - only the field types can be replaced with `var`.

#### 4.4.3 Nested Record Patterns and Generics

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

#### 4.4.4 Common Errors with Nested Record Patterns

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
case Wrapper(Box<String>(var v)) -> ...
```

Illegal placement of `var`

```java
// ❌ var cannot replace the record type itself
case var(Person(var n, var a)) -> ...
```

> [!NOTE]
> - `var` cannot stand in for the whole pattern, only for individual components.

---

## 5. Nested Classes in Java

Java supports several kinds of **nested classes** — classes declared inside another class.  
They are a fundamental tool for encapsulation, code organization, event-handling patterns, and representing logical hierarchies.  
A nested class always belongs to an **enclosing class** and has special accessibility and instantiation rules depending on its category.

Java defines four kinds of nested classes:

- **Static Nested Classes** – declared with `static` inside another class.
- **Inner Classes** (non-static nested classes).
- **Local Classes** – declared inside a block (method, constructor, or initializer).
- **Anonymous Classes** – unnamed classes created inline, usually to override a method or implement an interface.


### 5.1 Static Nested Classes

A **static nested class** behaves like a top-level class that is namespaced inside its enclosing class.  
It **cannot** access instance members of the outer class but **can** access static members.  
It does **not** hold a reference to an instance of the enclosing class.

#### 5.1.1 Syntax and Access Rules

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

#### 5.1.2 Common Pitfalls

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

### 5.2 Inner Classes (Non-Static Nested Classes)

An **inner class** is associated with an instance of the outer class and can access **all members** of the outer class, including **private** ones.

#### 5.2.1 Syntax and Access Rules

- Declared without `static`.
- Has an implicit reference to the enclosing instance.
- Can access both static and instance members of the outer class.
- Since it is not static, it has to be called through an instance of the enclosing class.

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

#### 5.2.2 Common Pitfalls

- Inner classes **cannot declare static members** except **static final constants**.

```java
class Outer {
    class Inner {
        // static int x = 10;     // ❌ Compile error
        static final int OK = 10; // ✔ Allowed (constant)
    }
}
```

> [!WARNING]
> - Instantiating an inner class WITHOUT an outer instance is illegal.


### 5.3 Local Classes

A **local class** is a nested class defined inside a block — most commonly a method.  
It has no access modifier and is visible only within the block where it is declared.

#### 5.3.1 Characteristics

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

#### 5.3.2 Common Pitfalls

- `base` must be effectively final; changing it breaks compilation.

```java
void compute() {
    int base = 5;
    base++; // ❌ Now base is NOT effectively final
    class Local {}
}
```

## 5.4 Anonymous Classes

An **anonymous class** is a one-off class created inline, usually to implement an interface or override a method without naming a new class.

#### 5.4.1 Syntax and Usage

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

#### 5.4.2 Anonymous Class Extending a Class

```java
Button b = new Button("Click");
b.onClick(new ClickHandler() {
    @Override
    public void handle() {
        System.out.println("Handled!");
    }
});
```


### 5.5 Comparison of Nested Class Types

A quick table summarizing all kinds of nested classes.

```text
Type                | Has Outer Instance? | Can Access Outer Instance Members? | Can Have Static Members? | Typical Use
------------------- | ------------------- | ---------------------------------- | ------------------------- | ---------------------------
Static Nested       | No                  | No                                 | Yes                      | Namespacing, helpers
Inner Class         | Yes                 | Yes                                | No (except constants)     | Object-bound behavior
Local Class         | Yes                 | Yes                                | No                        | Temporary scoped classes
Anonymous Class     | Yes                 | Yes                                | No                        | Inline customization
```

---

