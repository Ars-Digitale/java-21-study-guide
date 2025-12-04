# Inheritance in Java

Inheritance is one of the core pillars of Object-Oriented Programming.  
It allows a class (the *subclass*) to acquire the state and behavior of another class (the *superclass*), creating hierarchical relationships that promote code reuse, specialization, and polymorphism.

## 1. General Definition of Inheritance

Inheritance enables a class to extend another class, automatically gaining its accessible fields and methods.  
The extending class may add new features or override existing behaviors, creating more specialized versions of its parent.

> **Note:** Inheritance expresses an *“is-a”* relationship: a Dog **is a** Animal.

## 2. Single Inheritance and java.lang.Object

Java supports **single inheritance**, meaning every class may extend **only one** direct superclass.  
All classes ultimately inherit from `java.lang.Object`, which sits at the top of the hierarchy.  
This ensures all Java objects share a minimal common behavior (e.g., `toString()`, `equals()`, `hashCode()`).

```java
class Animal { }
class Dog extends Animal { }

// All classes implicitly extend Object
System.out.println(new Dog() instanceof Object); // true
```

## 3. Transitive Inheritance

Inheritance is **transitive**.  
If class C extends B and B extends A, then C effectively inherits accessible members from both B *and* A.

```java
class A { }
class B extends A { }
class C extends B { } // C inherits from both A and B
```

## 4. What Gets Inherited? (Short Reminder)

A subclass inherits all **accessible** members of the superclass.  
However, this depends on access modifiers.

- **public** → always inherited
- **protected** → inherited if accessible through package or subclass rules
- **default (package-private)** → inherited only within the same package
- **private** → **NOT** inherited

> **Note:** (Please refer to: [Access Modifiers](../module-01/basic-building-blocks.md#3-access-modifiers)) 


## 5. Class Modifiers Affecting Inheritance

Some class-level modifiers affect whether a class may be extended.

```text
| Modifier      | Meaning | Effect on Inheritance |
|---------------|---------|-----------------------|
| final         | Class cannot be extended | Inheritance STOP |
| abstract      | Class cannot be instantiated | Must be extended |
| sealed        | Only allows a fixed list of subclasses | Restricts inheritance |
| non-sealed    | Subclass of sealed class that reopens inheritance | Inheritance allowed |
| static        | Applies only to nested classes | Behaves like a top-level class inside its enclosing class |
```

> **Note:** A `static` class in Java can exist only as a **static nested class**.


## 6. `this` and `super` References

### 6.1 The `this` Reference
The `this` reference refers to the current object instance and helps in disambiguing access to current and inherited members. 
 
Java uses a **granular scope** rule:  
- If a method/local variable has the same name as an instance field, the local one “shadows” the field.  
- `this.fieldName` is required to access the instance attribute.

```java
public class Person {
    String name;

    public Person(String name) {
        // Without "this", we would reassign the parameter to itself
        this.name = name;
    }
}
```

If names differ, `this` is optional:

```java
public class Person {
    String name;

	public Person(String n) {
		name = n; // fine, the names of the variables differ: there is no ambiguity, no shadowing
	}
}
```

> [!WARNING]
> `this` cannot be used inside static methods because no instance exists.

### 6.2 The `super` Reference
The `super` reference gives access to members of the direct parent class.  

Useful when:  
- The parent and child define a field/method with the same name: (See below: [Inheriting Members](#13-inheriting-members))
- When a child class defines a `field` with the same name of an `inherited variable` defined in a parent class, we have **`variable hiding`** and the two variables exist indipendently of each other;  
- When a child class defines a `method` with the same `signature` as a method defined in a parent class, we have **`method overridding`**; 
- You want to explicitly refer to the inherited implementations

```java
class Parent { int value = 10; }
class Child extends Parent {
    int value = 20;

    void printBoth() {
        System.out.println(value);      // child value
        System.out.println(super.value); // parent value
    }
}
```

> **Note:** `super` cannot be used inside static contexts.


## 7. Declaring Constructors in an Inheritance Chain

A constructor initializes a newly created object.  
Constructors are **never inherited**, but each subclass constructor must ensure that the superclass is initialized.

Constructors are special methods with a name that matches the name of the class and that does not declare any return type.

A class may implement `constructor overloading` declaring multiple constructors, each with a unique `signature`.

You can explicitely declare a no-arg or a specific constructor or, if you don't, Java will  implicitely create a `default no-arg constructor`.

If you explicitely declare a constructor, the Java compiler will not include any `default no-arg constructor`.

## 8. Default `no-arg` Constructor

If a class does not declare any constructor, Java automatically inserts a **default no-argument constructor**.  
This constructor calls `super()` implicitly: the Java compiler implicitely insert a call to the no-arg constructor super(). 

```java
class Parent { }

class Child extends Parent {
    // Compiler inserts:
    // Child() { super(); }
}
```


## 9. Using `this()` and Constructor Overloading

**this()** calls another constructor in the same class. 
 
Rules:

- Must be the **first** statement in the constructor
- Cannot be combined with `super()`
- There can only be one call to `this()` in any constructor
- Used to centralize initialization

```java
class Car {
    int year;
    String model;

    Car() {
        this(2020, "Unknown");
    }

    Car(int year, String model) {
        this.year = year;
        this.model = model;
    }
}
```


## 10. Calling the Parent Constructor Using `super()`

Every constructor must call a superclass constructor, either explicitly or implicitly.  
`super()` must appear as the **first** line in the constructor (unless replaced by `this()`).


```java
class Parent {
    Parent() { System.out.println("Parent constructor"); }
}

class Child extends Parent {
    Child() {
        super(); // optional, compiler would insert it
        System.out.println("Child constructor");
    }
}
```


## 11. Default Constructor — Tips and Traps

- **If the superclass does not have a no-arg constructor, the subclass MUST call `super(args)` explicitly.**
- If the subclass defines any constructor, Java does NOT create a default constructor automatically for the parent class.
- If you forget to call an existing parent constructor explicitly, the compiler inserts `super()` — which may not exist.

```java
class Parent {
    Parent(int x) { }
}

class Child extends Parent {
    // ERROR → compiler inserts super(), but Parent() does not exist
    Child() { }
}
```


## 12. `super()` Always Refers to the **Most Direct Parent**

Even in long inheritance chains, `super()` always calls the constructor of the **immediate** superclass, not any higher ancestor.

```java
class A { 
	A() { System.out.println("A"); } 
}
class B extends A { 
	B() { System.out.println("B"); } 
}
class C extends B {
    C() {
        super(); // Calls B(), not A()
        System.out.println("C");
    }
}
```

Output:

```bash
A
B
C
```

## 13. Inheriting Members

### 13.1 Method Overriding

Method overriding is a core concept of inheritance: it allows a subclass to provide a **new implementation** for a method that is already defined in its superclass.
 
At runtime, the version of the method that is executed depends on the **actual object type**, not on the reference type.
 
This is called **dynamic dispatch** and it is what enables polymorphism in Java.

#### 13.1.1 Definition and Role in Inheritance

A method in a subclass **overrides** a method in its superclass if:

- the superclass method is `instance` (non static);
- the subclass method has the same name, the same parameter list and a return type which is the same type or a subtype of the return type in the inherited method;
- both methods are accessible (not private) and the subclass method is NOT less visible than the superclass one.
- The overridding method cannot declare NEW or BROADER checked exceptions than those declared in the inherited method. 

Overriding is used to specialize behavior: a subclass can adapt or refine what the parent class does while still being used through a reference of the parent type.

```java
class Animal {
	void speak() {
		System.out.println("Some generic animal sound");
	}
}

class Dog extends Animal {

	@Override
	void speak() {
		System.out.println("Woof!");
	}
}

public class TestOverride {
	public static void main(String[] args) {
		Animal a = new Dog(); // reference type = Animal, object type = Dog
		a.speak(); // prints "Woof!" (Dog implementation)
	}
}
```

#### 13.1.2 Using `super` to Call the Parent Implementation

When a subclass overrides a method, it can still access the superclass implementation via the `super` reference. This is useful if you want to reuse or extend the behavior defined in the parent class.

```java
class Person {
	void introduce() {
		System.out.println("I am a person.");
	}
}

class Student extends Person {
	@Override
	void introduce() {
		super.introduce(); // calls Person.introduce()
		System.out.println("I am also a student.");
	}
}
```

If both parent and child declare a member (field or method) with the same name, the child instance effectively has access to **two versions**:

- the one defined in the child class (default when called directly);
- the parent version, accessible using `super`.

```java
class Base {
int value = 10;

void show() {
    System.out.println("Base value = " + value);
}


}

class Derived extends Base {
int value = 20; // hides Base.value

void show() {
    System.out.println("Base value = " + value);
}

}

class Derived extends Base {
int value = 20; // hides Base.value

@Override
void show() {
    System.out.println("Derived value = " + value);          // 20
    System.out.println("Base value via super = " + super.value); // 10
}

class Derived extends Base {
int value = 20; // hides Base.value

@Override
void show() {
    System.out.println("Derived value = " + value);          // 20
    System.out.println("Base value via super = " + super.value); // 10
}

.show(); // A.show()  (reference type A)
    b.show(); // B.show()  (reference type B)
}
}
```

**final** static methods cannot be hidden, and instance methods declared **final** cannot be overridden. If you try to redefine them in a subclass, the code will not compile.

### 13.2 Abstract Classes

#### 13.2.1 Definition and Purpose

An **abstract class** is a class that cannot be instantiated directly and is intended to be extended. It may contain:

- abstract methods (declared without a body);
- concrete methods (with implementation);
- fields, constructors, static members, and even static initializers.

Abstract classes are used when you want to define a common **base behavior** and contract, but leave some details to be implemented by concrete subclasses.

#### 13.2.2 Rules for Abstract Classes

- A class with at least one abstract method **must** be declared abstract.
- An abstract class **cannot** be instantiated directly.
- Abstract methods have no body and end with a semicolon.
- Abstract methods cannot be `final`, `static`, or `private`, because they must be overridable.
- The first concrete (non abstract) subclass in the hierarchy must implement all inherited abstract methods, otherwise it must itself be declared abstract.

```java
abstract class Shape {
abstract double area(); // must be implemented by concrete subclasses

csharp
Copier le code
void describe() {
    System.out.println("I am a shape.");
}

Shape() {
    System.out.println("Shape constructor");
}
}

class Circle extends Shape {
private final double radius;

csharp
Copier le code
Circle(double radius) {
    this.radius = radius;
}

@Override
double area() {
    return Math.PI * radius * radius;
}
}
```

Although an abstract class cannot be instantiated, its constructors are still called when creating instances of concrete subclasses. The chain always starts from the top of the hierarchy and moves down.

### 13.3 Creating Immutable Objects

#### 13.3.1 What Is an Immutable Object?

An object is **immutable** if, after it has been created, its state **cannot change**. All fields that represent the state remain constant for the lifetime of that object. Immutable objects are simpler to reason about, inherently thread safe (if properly designed), and widely used in the Java Standard Library (for example, `String`, wrapper classes like `Integer`, and many classes in `java.time`).

#### 13.3.2 Guidelines for Designing Immutable Classes

- Declare the class **final** so it cannot be subclassed (or make all constructors private and provide controlled factory methods).
- Make all fields that represent state **private** and **final**.
- Do not provide any mutator (setter) methods.
- Initialize all fields in constructors (or factory methods) and never expose them in a mutable way.
- If a field refers to a mutable object, make **defensive copies** on construction and when returning it via getters.

```java
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class Person {
private final String name; // String is immutable
private final int age;
private final List<String> hobbies; // List is mutable, we must protect it

arduino
Copier le code
public Person(String name, int age, List<String> hobbies) {
    this.name = name;
    this.age = age;
    // Defensive copy on input
    this.hobbies = new ArrayList<>(hobbies);
}

public String getName() {
    return name; // safe (String is immutable)
}

public int getAge() {
    return age;
}

public List<String> getHobbies() {
    // Defensive copy or unmodifiable view on output
    return Collections.unmodifiableList(hobbies);
}
}
```

In this example:

- `Person` is final: it cannot be subclassed and its behavior cannot be altered through inheritance.
- All fields are `private` and `final`, set only once in the constructor.
- The list of hobbies is defensively copied on construction and wrapped as unmodifiable in the getter, so external code cannot modify the internal state.

Designing immutable objects is especially important in multi thread contexts and when passing objects across layers of an application. 
The certification exam often tests whether a supposedly immutable design actually prevents state changes through exposed mutable fields or collections.




