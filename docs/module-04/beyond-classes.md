# Beyond Classes

This chapter presents several advanced type mechanisms beyond the Java Class design: **interfaces**, **enums**, **sealed / non-sealed classes**, **records**, and **nested classes**. 

## 1. Interfaces

An **interface** in Java is a reference type that defines a contract of methods that a class agrees to implement. 

A java class may implement any number of interface through the `implements` keyword.

An `interface` may in turn extend multiple interfaces using the `extends` keyword.

Interfaces enable abstraction, loose coupling, and multiple inheritance of type.

### 1.1 What Interfaces Can Contain

- **Abstract** an interface is implicitly abstract and cannot be marked as `final`
- **Abstract methods** (implicitly `public` and `abstract`)
- **Default methods** (include code)
- **Static methods**
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

> **Note:** **Every** abstract method must be implemented unless the class is abstract.


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


## 2. Enums

**Enums** define a fixed set of constant values. They are full-fledged classes with fields, constructors, and methods.

### 2.1 Basic Enum Definition

```java
enum Day { MON, TUE, WED, THU, FRI, SAT, SUN }
```


### 2.2 Enums with State and Behavior

```java
enum Level {
    LOW(1), MEDIUM(5), HIGH(10);
    private int code; 
    Level(int code) { this.code = code; }
    public int getCode() { return code; }
}
```


### 2.3 Enum Methods

- `values()` – returns all constants
- `valueOf(String)` – returns constant by name
- `ordinal()` – index of the constant



## 3. Sealed and non-sealed Classes

Sealed classes (Java 17+) restrict which other classes can extend or implement them.

```java
public sealed class Shape permits Circle, Rectangle { }
final class Circle extends Shape { }
non-sealed class Rectangle extends Shape { }
```

### 3.1 Rules

- A sealed class must declare all permitted subclasses.
- A permitted subclass must be **final**, **sealed**, or **non-sealed**.
- Enforced at compile time and runtime.



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
