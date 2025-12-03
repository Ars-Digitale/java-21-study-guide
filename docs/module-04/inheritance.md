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
		name = n; // fine: there is no ambiguity, no shadowing
	}
}
```

> [!WARNING]
> `this` cannot be used inside static methods because no instance exists.

### 6.2 The `super` Reference
The `super` reference gives access to members of the direct parent class.  

Useful when:  
- The parent and child define a field/method with the same name (the child instance holds two separated values for a variable with the same name)  
- You want to explicitly refer to the inherited implementation

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

A class may implement `constructor overloading` having multiple constructors, each of them with a unique `signature`.

You can explicitely declare a no-arg or a specific constructor or, if you don't, Java will  implicitely create a default no-arg constructor.

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


