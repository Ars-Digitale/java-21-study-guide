# 16. Inheritance in Java

### Table of Contents

- [16. Inheritance in Java](#16-inheritance-in-java)
  - [16.1 General Definition of Inheritance](#161-general-definition-of-inheritance)
  - [16.2 Single Inheritance and java.lang.Object](#162-single-inheritance-and-javalangobject)
  - [16.3 Transitive Inheritance](#163-transitive-inheritance)
  - [16.4 What Gets Inherited Short Reminder](#164-what-gets-inherited-short-reminder)
  - [16.5 Class Modifiers Affecting Inheritance](#165-class-modifiers-affecting-inheritance)
  - [16.6 this and super References](#166-this-and-super-references)
    - [16.6.1 The this Reference](#1661-the-this-reference)
    - [16.6.2 The super Reference](#1662-the-super-reference)
  - [16.7 Declaring Constructors in an Inheritance Chain](#167-declaring-constructors-in-an-inheritance-chain)
  - [16.8 Default no-arg Constructor](#168-default-no-arg-constructor)
  - [16.9 Using this and Constructor Overloading](#169-using-this-and-constructor-overloading)
  - [16.10 Calling the Parent Constructor Using super](#1610-calling-the-parent-constructor-using-super)
  - [16.11 Default Constructor Tips and Traps](#1611-default-constructor-tips-and-traps)
  - [16.12 super Always Refers to the Most Direct Parent](#1612-super-always-refers-to-the-most-direct-parent)
  - [16.13 Inheriting Members](#1613-inheriting-members)
    - [16.13.1 Method Overriding](#16131-method-overriding)
      - [16.13.1.1 Definition and Role in Inheritance](#161311-definition-and-role-in-inheritance)
      - [16.13.1.2 Using super to Call the Parent Implementation](#161312-using-super-to-call-the-parent-implementation)
      - [16.13.1.3 Overriding Rules Instance Methods](#161313-overriding-rules-instance-methods)
      - [16.13.1.4 Hiding Static Methods Method Hiding](#161314-hiding-static-methods-method-hiding)
    - [16.13.2 Abstract Classes](#16132-abstract-classes)
      - [16.13.2.1 Definition and Purpose](#161321-definition-and-purpose)
      - [16.13.2.2 Rules for Abstract Classes](#161322-rules-for-abstract-classes)
    - [16.13.3 Creating Immutable Objects](#16133-creating-immutable-objects)
      - [16.13.3.1 What Is an Immutable Object](#161331-what-is-an-immutable-object)
      - [16.13.3.2 Guidelines for Designing Immutable Classes](#161332-guidelines-for-designing-immutable-classes)


---


`Inheritance` is one of the core pillars of Object-Oriented Programming. 
 
It allows a class (the *subclass*) to acquire the state and behavior of another class (the *superclass*), creating hierarchical relationships that promote code reuse, specialization, and polymorphism.

## 16.1 General Definition of Inheritance

Inheritance enables a class to extend another class, automatically gaining its accessible fields and methods.  
The extending class may add new features or override existing behaviors, creating more specialized versions of its parent.

> [!NOTE] 
> Inheritance expresses an *“is-a”* relationship: a Dog **is a** Animal.

## 16.2 Single Inheritance and java.lang.Object

Java supports **single inheritance**, meaning every class may extend **only one** direct superclass.  
All classes ultimately inherit from `java.lang.Object`, which sits at the top of the hierarchy.  
This ensures all Java objects share a minimal common behavior (e.g., `toString()`, `equals()`, `hashCode()`).

```java
class Animal { }
class Dog extends Animal { }

// All classes implicitly extend Object
System.out.println(new Dog() instanceof Object); // true
```

## 16.3 Transitive Inheritance

Inheritance is **transitive**.  
If class C extends B and B extends A, then C effectively inherits accessible members from both B *and* A.

```java
class A { }
class B extends A { }
class C extends B { } // C inherits from both A and B
```

## 16.4 What Gets Inherited? (Short Reminder)

A subclass inherits all **accessible** members of the superclass.  
However, this depends on access modifiers.

- **public** → always inherited
- **protected** → inherited if accessible through package or subclass rules
- **default (package-private)** → inherited only within the same package
- **private** → **NOT** inherited

> [!NOTE] 
> (Please refer to: [Access Modifiers](../module-01/basic-building-blocks.md#3-access-modifiers)) 


## 16.5 Class Modifiers Affecting Inheritance

Some class-level modifiers affect whether a class may be extended.


| Modifier      | Meaning | Effect on Inheritance |
|---------------|---------|-----------------------|
| final         | Class cannot be extended | Inheritance STOP |
| abstract      | Class cannot be instantiated | Must be extended |
| sealed        | Only allows a fixed list of subclasses | Restricts inheritance |
| non-sealed    | Subclass of sealed class that reopens inheritance | Inheritance allowed |
| static        | Applies only to nested classes | Behaves like a top-level class inside its enclosing class |


> [!NOTE] 
> A `static` class in Java can exist only as a **static nested class**.


## 16.6 `this` and `super` References

### 16.6.1 The `this` Reference
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

### 16.6.2 The `super` Reference
The `super` reference gives access to members of the direct parent class.  

Useful when:  
- The parent and child define a field/method with the same name: (See below: [Inheriting Members](#13-inheriting-members))
- Parent and child define a field with the same name → variable hiding (two copies)
- Parent and child define a method with the same signature → method overriding
- You want to explicitly call the inherited implementation

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

> [!NOTE] 
> `super` cannot be used inside static contexts.


## 16.7 Declaring Constructors in an Inheritance Chain

A constructor initializes a newly created object. 
 
Constructors are **never inherited**, but each subclass constructor must ensure that the superclass is initialized.

Constructors are special methods with a name that matches the name of the class and that does not declare any return type.

A class may define multiple constructors (constructor overloading), each with a unique `signature`.

You can explicitly declare a no-arg or a specific constructor or, if you don't, Java will  implicitly create a `default no-arg constructor`.

If you explicitly declare a constructor, the Java compiler will not include any `default no-arg constructor`: this rule applies independently to every class in the hierarchy.
A parent class still gets its own default constructor unless it also defines one.


## 16.8 Default `no-arg` Constructor

If a class does not declare any constructor, Java automatically inserts a **default no-argument constructor**.  
This constructor calls `super()` implicitly: the Java compiler implicitly insert a call to the no-arg constructor super(). 

```java
class Parent { }

class Child extends Parent {
    // Compiler inserts:
    // Child() { super(); }
}
```


## 16.9 Using `this()` and Constructor Overloading

**this()** calls another constructor in the same class. 
 
Rules:

- Must be the **first** statement in the constructor
- Cannot be combined with `super()`
- Only one call to this() is allowed in a constructor
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


## 16.10 Calling the Parent Constructor Using `super()`

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


## 16.11 Default Constructor — Tips and Traps

- **If the superclass does not have a no-arg constructor, the subclass MUST call `super(args)` explicitly.**
- If the subclass defines any constructor, Java does NOT create a default constructor automatically for that subclass.
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


## 16.12 `super()` Always Refers to the **Most Direct Parent**

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

## 16.13 Inheriting Members

### 16.13.1 Method Overriding

Method overriding is a core concept of inheritance: it allows a subclass to provide a **new implementation** for a method that is already defined in its superclass.
 
At runtime, the version of the method that is executed depends on the **actual object type**, not on the reference type.
 
This is called **dynamic dispatch** and it is what enables polymorphism in Java.

#### 16.13.1.1 Definition and Role in Inheritance

A method in a subclass **overrides** a method in its superclass if:

- the superclass method is `instance` (non static);
- the subclass method has the same name, the same parameter list and a return type which is the same type or a subtype of the return type in the inherited method;
- both methods are accessible (not private) and the subclass method is NOT less visible than the superclass one.
- The overriding method cannot declare new or broader checked exceptions. 

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

#### 16.13.1.2 Using `super` to Call the Parent Implementation

When a subclass overrides a method, it can still access the superclass implementation via the `super` reference. 

This is useful if you want to reuse or extend the behavior defined in the parent class.

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

If both parent and child declare a member (field or method) with the same name, The child can access both:

- the overridden version (default)
- the parent version via `super`

```java
class Base {
	int value = 10;

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
}
```

#### 16.13.1.3 Overriding Rules (Instance Methods)

- **Same signature**: same method name, same parameter types and order.
- **Covariant return type**: the overriding method can return the same type as the parent, or a **subtype** of the parent return type.
- **Accessibility**: the overriding method cannot be less accessible than the overridden one (for example, cannot change from public to protected or private). It can keep the same visibility or increase it.
- **Checked exceptions**: the overriding method cannot declare new or broader checked exceptions than the parent method; it may declare fewer or more specific checked exceptions, or remove them entirely.
- **Unchecked exceptions**: can be added or removed without restriction.
- **final methods**: cannot be overridden.

```java
class Parent {
	Number getValue() throws Exception {
		return 42;
	}
}

class Child extends Parent {
@Override
	// Covariant return type: Integer is a subclass of Number
	Integer getValue() throws RuntimeException {
		return 100;
	}
}
```

#### 16.13.1.4 Hiding Static Methods (Method Hiding)

Static methods are **not overridden**; they are **hidden**. 

If a subclass defines a static method with the same signature as a static method in the parent, the subclass method **hides** the parent method. 

If one of the methods is marked as `static` and the other is not, the code will NOT compile.

Method selection for static methods happens at **compile time**, based on the reference type, not the object type.

```java
class A {
	static void show() {
		System.out.println("A.show()");
	}
}

class B extends A {
	static void show() {
		System.out.println("B.show()");
	}
}

public class TestStatic {
	public static void main(String[] args) {
		A a = new B();
		B b = new B();

		a.show(); // A.show()  (reference type A)
		b.show(); // B.show()  (reference type B)
	}
}
```

> [!IMPORTANT] 
> - **final** static methods cannot be hidden, and instance methods declared **final** cannot be overridden. 
> - If you try to redefine them in a subclass, the code will not compile.


### 16.13.2 Abstract Classes

#### 16.13.2.1 Definition and Purpose

An **abstract class** is a class that cannot be instantiated directly and is intended to be extended. 

It may contain:

- abstract methods (declared without a body);
- concrete methods (with implementation);
- fields, constructors, static members, and even static initializers.

Abstract classes are used when you want to define a common **base behavior** and contract, but leave some details to be implemented by concrete subclasses.

#### 16.13.2.2 Rules for Abstract Classes

- A class with at least one abstract method **must** be declared abstract.
- An abstract class **cannot** be instantiated directly.
- Abstract methods have no body and end with a semicolon.
- **Abstract methods cannot be `final`, `static`, or `private`**, because they must be overridable.
- The first concrete (non-abstract) subclass in the hierarchy must implement all inherited abstract methods, otherwise it must itself be declared abstract.

```java
abstract class Shape {

	abstract double area(); // must be implemented by concrete subclasses

	void describe() {
		System.out.println("I am a shape.");
	}

	Shape() {
		System.out.println("Shape constructor");
	}
}

class Circle extends Shape {
	private final double radius;

	Circle(double radius) {
		this.radius = radius;
	}

	@Override
	double area() {
		return Math.PI * radius * radius;
	}
}
```


> [!NOTE]
> - Although an abstract class cannot be instantiated, its constructors are still called when creating instances of concrete subclasses. 
> - The chain always starts from the top of the hierarchy and moves down.

### 16.13.3 Creating Immutable Objects

#### 16.13.3.1 What Is an Immutable Object?

An object is **immutable** if, after it has been created, its state **cannot change**. 

All fields that represent the state remain constant for the lifetime of that object. 

Immutable objects are simpler to reason about, inherently thread safe (if properly designed), and widely used in the Java Standard Library (for example, `String`, wrapper classes like `Integer`, and many classes in `java.time`).

#### 16.13.3.2 Guidelines for Designing Immutable Classes

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

Designing immutable objects is especially important in multithread contexts and when passing objects across layers of an application. 





