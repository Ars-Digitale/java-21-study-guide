# Object-Oriented Programming Concepts

This chapter introduces fundamental Object-Oriented Programming (OOP) concepts in Java, starting with **methods**, **parameter passing**, **overloading**, **local vs. instance variables**, and **varargs**.  


## 1. Methods

Methods represent the **operations/behaviors** that can be performed by a particular data type (a **class**).  
They describe *what the object can do* and how it interacts with its internal state and the outside world.

A method declaration is composed of **mandatory** and **optional** components.


### 1.1 Mandatory Components of a Method

#### 1.1.1  Access Modifiers 

They control *visibility*, not behavior.
(Please refer to: [Access Modifiers](../module-01/basic-building-blocks.md#3-access-modifiers)) 

#### 1.1.2 Return Type  
Appears **immediately before** the method name.

- If the method returns a value → the return type specifies the value’s type.
- If the method does *not* return a value → the keyword `void` **must** be used.
- A method with a non-void return type **must** contain at least one `return value;` statement.
- A `void` method may:
  - omit a return statement
  - include `return;` (with **no** value)

#### 1.1.3 Method Name

Follows the same rules as identifiers (Please refer to: [Java Naming Rules](../module-01/naming-rules.md)).

#### 1.1.4 Method Signature  
The **method signature** in Java includes:

- the *method name*
- the *parameter type list* (types + order)

> **Parameter names do NOT belong to the signature**, only types and order matter.

Example of distinct signatures:

```java
void process(int x)
void process(int x, int y)
void process(int x, String y)
```

Example of *same* signature (illegal overloading):

```java
// ❌ same signature: only parameter names differ
void m(int a)
void m(int b)
```

#### 1.1.5 Method Body  
A block `{ }` containing **zero or more statements**.  
If the method is `abstract`, the body must be omitted.


### 1.2 Optional Modifiers

Optional method modifiers include:

- `static`
- `abstract`
- `final`
- `default` (interface methods)
- `synchronized`
- `native`
- `strictfp`

Rules:

- Optional modifiers may appear in **any order**.
- All modifiers must appear **before the return type**.

Example:

```java
public static final int compute() {
    return 10;
}
```


### 1.3 Declaring Methods 

```java
public final synchronized String formatValue(int x, double y) throws IOException {
    return "Result: " + x + ", " + y;
}
```

Breakdown:

| Part | Meaning |
|------|---------|
| `public` | access modifier |
| `final` | cannot be overridden |
| `synchronized` | thread control modifier |
| `String` | return type |
| `formatValue` | method name |
| `(int x, double y)` | parameter list |
| `throws IOException` | exception list |
| method body | implementation |


## 2. Java Is a “Pass-by-Value” Language

Java uses **only pass-by-value**, no exceptions.

This means:

- For **primitive types** → the method receives a *copy of the value*.
- For **reference types** → the method receives a *copy of the reference*, meaning:
  - the reference itself cannot be changed by the method
  - the *object* **can** be modified through that reference

Example:

```java
void modify(int a, StringBuilder b) {
    a = 50;           // modifying the *copy* → no effect outside
    b.append("!");    // modifying the *object* → visible outside
}
```


## 3. Overloading Methods

Method overloading means **same method name**, **different signature**.

Two methods are considered overloaded if they differ in:

- number of parameters  
- parameter types  
- parameter order  

Overloading **does NOT depend on**:

- return type  
- access modifier  
- exceptions  

Example:

```java
void print(int x)
void print(double x)
void print(int x, int y)
```

Illegal overloaded method:

```java
// ❌ Return type does not count in overloading
int compute(int x)
double compute(int x)
```

## 4. Local and Instance Variables

### 4.1 Instance Variables

Instance variables are:

- declared as members of a class
- created when an object is instantiated
- accessible by all methods of the instance

Possible modifiers for instance variables:

- access modifiers (`public`, `protected`, `private`)
- `final`
- `volatile`
- `transient`

Example:

```java
public class Person {
    private String name;         // instance variable
    protected final int age = 0; // final means cannot be reassigned
}
```


### 4.2 Local Variables

Local variables:

- are declared *inside* a method, constructor, or block
- have **no default values** → must be explicitly initialized before use
- only modifier allowed: **final**

Example:

```java
void calculate() {
    int x;        // declared
    x = 10;       // must be initialized before use

    final int y = 5;  // legal
}
```

Two special cases:

#### 4.2.1 Effectively Final Local Variables  
A local variable is *effectively final* if it is **assigned once**, even without `final`.

Effectively final variables can be used in:

- lambda expressions
- local/anonymous classes

#### 4.2.2 Parameters as Effectively Final  
Method parameters behave as local variables and follow the same rules.


## 5. Varargs (Variable-Length Argument Lists)

Varargs allow a method to accept **zero or more** parameters of the same type.

Syntax:

```java
void printNames(String... names)
```

Rules:

- A method may have **only one** varargs parameter.
- It must be the **last** parameter in the list.
- Varargs are treated as an **array** inside the method.

Example:

```java
void show(int x, String... values) {
    System.out.println(values.length);
}

show(10);                     // length = 0
show(10, "A");                // length = 1
show(10, "A", "B", "C");      // length = 3
```

> **Common pitfall**:  
> Varargs and arrays participate in method overloading.  
> Overload resolution may become ambiguous.

## 6. Static Methods, Static Variables, and Static Initializers

In Java, the keyword **`static`** marks elements that **belong to the class itself**, not to individual instances.  
This means:

- They are **loaded once** into memory when the class is first loaded by the JVM.
- They are shared among **all instances**.
- They can be accessed **without creating an object** of the class.

Static members are stored in the JVM **method area** (class-level memory), while instance members live in the **heap**.


### 6.1 Static Variables (Class Variables)

A **static variable** is a variable defined at class level and shared by all instances.

Characteristics:

- Created when the class is loaded.
- Exists **even if no instance** of the class is created.
- All objects see the **same value**.
- May be marked `final`, `volatile`, or `transient`.

Example:

```java
public class Counter {
    static int count = 0;    // shared by all instances
    int id;                  // instance variable

    public Counter() {
        count++;
        id = count;          // each instance gets a unique id
    }
}
```


### 6.2 Static Methods

A **static method** belongs to the class, not to any object instance.

Rules:

- They can be called using the class name: `ClassName.method()`.
- They **cannot** access instance variables or instance methods directly, but only through an istance of the class.
- They **cannot** use `this` or `super`.
- They are commonly used for:
  - utility methods (e.g., `Math.sqrt()`)
  - factory methods
  - global behaviors that do not depend on instance state

Example:

```java
public class MathUtil {

    static int square(int x) {        // static method
        return x * x;
    }

    void instanceMethod() {
        // System.out.println(count);   // OK: accessing static variable
        // square(5);                   // OK: static method accessible
    }
}
```

Common pitfall:

```java
// ❌ Compile error: instance method cannot be accessed directly in static context
static void go() {
    run();        // run() is instance method!
}

void run() { }
```


### 6.3 Static Initializer Blocks

Static initializer blocks allow executing code **once**, when the class is loaded.

Syntax:

```java
static {
    // initialization logic
}
```

Usage:

- initializing complex static variables  
- performing class-level setup  
- running code that must execute exactly once  

Example:

```java
public class Config {

    static final Map<String, String> settings = new HashMap<>();

    static {
        settings.put("mode", "production");
        settings.put("version", "1.0");
        System.out.println("Static initializer executed");
    }
}
```

> Static initializer blocks run **once**, in the order they appear, before `main()` and before any static method is called.


### 6.4 Initialization Order (Static vs. Instance)

This is extremely important for the exam.

#### 6.4.1 Class loading order
When a class is loaded:

1. **Static variables** are initialized (default values first).
2. **Static initializer blocks** run, in declared order.
3. The class becomes ready for use.

#### 6.4.2 Instance creation order
When `new` is invoked:

1. Instance variables → default values  
2. Instance variables → explicit initializations  
3. Instance initializer blocks  
4. Constructor runs  

Example showing full initialization order:

```java
public class InitOrder {

    static int a = 10;

    static {
        System.out.println("Static block 1, a=" + a);
    }

    static {
        System.out.println("Static block 2");
    }

    int x = 5;

    {
        System.out.println("Instance initializer, x=" + x);
    }

    public InitOrder() {
        System.out.println("Constructor");
    }

    public static void main(String[] args) {
        new InitOrder();
    }
}
```

Output:

```bash
Static block 1, a=10
Static block 2
Instance initializer, x=5
Constructor
```


### 6.5 Accessing Static Members

#### 6.5.1 Recommended: use class name

```java
Math.sqrt(16);
MyClass.staticMethod();
```

#### 6.5.2 Also legal: via instance reference

```java
MyClass obj = new MyClass();
obj.staticMethod();   
```


### 6.6 Static and Inheritance

Static methods:

- **can be hidden**, not overridden  
- binding is **compile-time**, not runtime  
- accessed based on **reference type**, not object type

Example:

```java
class A {
    static void test() { System.out.println("A"); }
}

class B extends A {
    static void test() { System.out.println("B"); }
}

A ref = new B();
ref.test();   // prints "A" — static binding!
```

> Key rule: static methods use **reference type**, not object type.


### 6.7 Common  Pitfalls

- Attempting to reference an instance variable/method from a static context.
- Assuming static methods are overridden → they are **hidden**.
- Calling a static method from an instance reference (legal but confusing).
- Confusing initialization order of static elements vs. instance elements.
- Forgetting that static variables are shared across all objects.
- Not knowing that static initializers run *once*, in declaration order.

---


 




