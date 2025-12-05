# Beyond Classes

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


### 1.3 Multiple Inheritance of Type

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
- As we saw just above, if two interfaces provide default methods with the same signature, the implementing class must override the method.
- An implementig class may of course rely on the provided implementation of the `default` method without overriding it.
- The `default` method can be invoked on an instance of the implementing class and NOT as a `static` method of the containing interface.

### 1.6 Static methods

- An interface can provide `static methods` (through the keyword `static`) which are implicitly `public`;
- Static methods must include a method body and are accessed through the reference of the interface name.
- Static methods cannot be `abstract` or `final`;

### 1.7 Private interface methods

Among all the concrete methods that an interface can implement we have also:

- **`private` methods**: visible only inside the declaring interface and which can only be invoked from a `non-static` context (`default` methods or other `non-static private methods`) 
- **`private static`** methods: visible only inside the declaring interface and which can be invoked by any method of the enclosing interface.

## 2. Sealed and non-sealed Types

Sealed classes and interfaces (Java 17+) restrict which other classes (or interfaces) can extend or implement them.

```java
public sealed class Shape permits Circle, Rectangle { }
final class Circle extends Shape { }
non-sealed class Rectangle extends Shape { }
```

A sealed type is declared by placing the `sealed` modifier right before the class (or interface) keyword, and adding, after the Type name, the `permits` keyword followed by the list of types that can extend (or implement) it.

 
### 2.1 Rules

- A sealed Type must declare all permitted Sub-Types.
- A permitted sub-type must be **final**, **sealed**, or **non-sealed**: because interfaces cannot be final, when extending a sealed interface they can only be marked `sealed` or `non-sealed`.
- Sealed Types must be declared in the same package (or named module) as their direct sub-types.
- 

## 3. Enums

**Enums** define a fixed set of constant values. They are full-fledged classes with fields, constructors, and methods.

### 3.1 Basic Enum Definition

```java
enum Day { MON, TUE, WED, THU, FRI, SAT, SUN }
```


### 3.2 Enums with State and Behavior

```java
enum Level {
    LOW(1), MEDIUM(5), HIGH(10);
    private int code; 
    Level(int code) { this.code = code; }
    public int getCode() { return code; }
}
```


### 3.3 Enum Methods

- `values()` – returns all constants
- `valueOf(String)` – returns constant by name
- `ordinal()` – index of the constant



## 4. Records (Java 16+)

A **record** is a special class designed to model immutable data. It automatically provides:

- **private final fields** for each component
- **constructor**
- **getters** (named like fields)
- **`equals()`, `hashCode()`, `toString()`**

```java
public record Point(int x, int y) { }
```

### 4.1 Compact Constructor

```java
public record Person(String name, int age) {
    public Person {
        if (age < 0) throw new IllegalArgumentException();
    }
}
```



## 5. Nested Classes

Nested classes help organize code and control access. They exist in four forms:

- **Static nested class**
- **Inner class**
- **Local class**
- **Anonymous class**


### 5.1 Static Nested Class

Behaves like a top-level class but scoped inside another class. Cannot access instance members directly.

```java
class Outer {
    static class Nested { }
}
```


### 5.2 Inner Class

Has an implicit reference to the outer instance.

```java
class A {
    class B {
        void hello() { System.out.println("inner"); }
    }
}
```


### 5.3 Local Classes

Defined inside a block, used for localized behavior.


### 5.4 Anonymous Classes

Used for quick one-time implementations

```java
Runnable r = new Runnable() {
    public void run() { }
};
```



## 6. Certification Pitfalls

- Abstract methods in interfaces are implicitly public.
- Enums cannot extend classes but can implement interfaces.
- Sealed classes require explicit permission lists.
- Records are immutable unless you cheat via mutable fields.
- Inner classes cannot contain static declarations except constants.
