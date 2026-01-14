# 14. Methods, Attributes and Variables

### Table of Contents

- [14. Methods, Attributes and Variables](#14-methods-attributes-and-variables)
  - [14.1 Methods](#141-methods)
    - [14.1.1 Mandatory Components of a Method](#1411-mandatory-components-of-a-method)
      - [14.1.1.1 Access Modifiers](#14111--access-modifiers)
      - [14.1.1.2 Return Type](#14112-return-type)
      - [14.1.1.3 Method Name](#14113-method-name)
      - [14.1.1.4 Method Signature](#14114-method-signature)
      - [14.1.1.5 Method Body](#14115-method-body)
    - [14.1.2 Optional Modifiers](#1412-optional-modifiers)
    - [14.1.3 Declaring Methods](#1413-declaring-methods)
  - [14.2 Java Is a Pass-by-Value Language](#142-java-is-a-pass-by-value-language)
  - [14.3 Overloading Methods](#143-overloading-methods)
    - [14.3.1 Calling overloaded methods](#1431-calling-overloaded-methods)
      - [14.3.1.1 Exact match wins](#14311-exact-match-wins)
      - [14.3.1.2 If no exact match exists Java picks the most specific compatible type](#14312--if-no-exact-match-exists-java-picks-the-most-specific-compatible-type)
      - [14.3.1.3 Primitive widening beats boxing](#14313--primitive-widening-beats-boxing)
      - [14.3.1.4 Boxing beats varargs](#14314--boxing-beats-varargs)
      - [14.3.1.5 For references Java picks the most specific reference type](#14315--for-references-java-picks-the-most-specific-reference-type)
      - [14.3.1.6 When there is no unambiguous most specific the-call-is-a-compile-error](#14316--when-there-is-no-unambiguous-most-specific-the-call-is-a-compile-error)
      - [14.3.1.7 Mixed primitive + wrapper overloads](#14317--mixed-primitive--wrapper-overloads)
      - [14.3.1.8 When primitives mix with reference types](#14318--when-primitives-mix-with-reference-types)
      - [14.3.1.9 When Object wins](#14319--when-object-wins)
      - [14.3.1.10 Summary Table Overload Resolution](#143110-summary-table-overload-resolution)
  - [14.4 Local and Instance Variables](#144-local-and-instance-variables)
    - [14.4.1 Instance Variables](#1441-instance-variables)
    - [14.4.2 Local Variables](#1442-local-variables)
      - [14.4.2.1 Effectively Final Local Variables](#14421-effectively-final-local-variables)
      - [14.4.2.2 Parameters as Effectively Final](#14422-parameters-as-effectively-final)
  - [14.5 Varargs Variable-Length Argument Lists](#145-varargs-variable-length-argument-lists)
  - [14.6 Static Methods Static Variables and Static Initializers](#146-static-methods-static-variables-and-static-initializers)
    - [14.6.1 Static Variables Class Variables](#1461-static-variables-class-variables)
    - [14.6.2 Static Methods](#1462-static-methods)
    - [14.6.3 Static Initializer Blocks](#1463-static-initializer-blocks)
    - [14.6.4 Initialization Order Static vs Instance](#1464-initialization-order-static-vs-instance)
    - [14.6.5 Accessing Static Members](#1465-accessing-static-members)
      - [14.6.5.1 Recommended use class name](#14651-recommended-use-class-name)
      - [14.6.5.2 Also legal via instance reference](#14652-also-legal-via-instance-reference)
    - [14.6.6 Static and Inheritance](#1466-static-and-inheritance)
    - [14.6.7 Common Pitfalls](#1467-common--pitfalls)


---

This chapter introduces fundamental Object-Oriented Programming (OOP) concepts in Java, starting with **methods**, **parameter passing**, **overloading**, **local vs. instance variables**, and **varargs**.  


## 14.1 Methods

Methods represent the **operations/behaviors** that can be performed by a particular data type (a **class**).
  
They describe *what the object can do* and how it interacts with its internal state and the outside world.

A method declaration is composed of **mandatory** and **optional** components.


### 14.1.1 Mandatory Components of a Method

#### 14.1.1.1  Access Modifiers 

They control *visibility*, not behavior.

( Please refer to Paragraph "**Access Modifiers**" in Chapter: [2. Basic Language Java Building Blocks](../module-01/basic-building-blocks.md) ) 

#### 14.1.1.2 Return Type

Appears **immediately before** the method name.

- If the method returns a value → the return type specifies the value’s type.
- If the method does *not* return a value → the keyword `void` **must** be used.
- A method with a non-void return type **must** contain at least one `return value;` statement.
- A `void` method may:
  - omit a return statement
  - include `return;` (with **no** value)

#### 14.1.1.3 Method Name

Follows the same rules as identifiers ( Please refer to Chapter: [3. Java Naming Rules](../module-01/naming-rules.md) ).

#### 14.1.1.4 Method Signature
 
The **method signature** in Java includes:

- the *method name*
- the *parameter type list* (types + order)

> [!NOTE]
> **Parameter names do NOT belong to the signature**, only types and order matter.

- Example of distinct signatures:

```java
void process(int x)
void process(int x, int y)
void process(int x, String y)
```

- Example of *same* signature (illegal overloading):

```java
// ❌ same signature: only parameter names differ
void m(int a)
void m(int b)
```

#### 14.1.1.5 Method Body 
 
A block `{ }` containing **zero or more statements**.
  
If the method is `abstract`, the body must be omitted.


### 14.1.2 Optional Modifiers

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

- Example:

```java
public static final int compute() {
    return 10;
}
```


### 14.1.3 Declaring Methods 

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

---

## 14.2 Java Is a “Pass-by-Value” Language

Java uses **only pass-by-value**, no exceptions.

This means:

- For **primitive types** → the method receives a *copy of the value*.
- For **reference types** → the method receives a *copy of the reference*, meaning:
  - the reference itself cannot be changed by the method
  - the *object* **can** be modified through that reference

- Example:

```java
void modify(int a, StringBuilder b) {
    a = 50;           // modifying the *copy* → no effect outside
    b.append("!");    // modifying the *object* → visible outside
}
```

```java
public static void main(String[] args) {
    
	int num1 = 11;
	methodTryModif(num1);
	System.out.println(num1);
	
}

public static void methodTryModif(int num1){	
	num1 = 10;  // this new assignement affects only the method parameter which, accidentally, has the same name as the external variable.
}

```

---

## 14.3 Overloading Methods

Method overloading means **same method name**, **different signature**.

Two methods are considered overloaded if they differ in:

- number of parameters  
- parameter types  
- parameter order  

Overloading **does NOT depend on**:

- return type  
- access modifier  
- exceptions  

- Example:

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

### 14.3.1 Calling overloaded methods


When multiple overloaded methods are available, Java applies **overload resolution** to decide which method to call.
  
The compiler selects the method whose parameter types are the **most specific** and **compatible** with the provided arguments.

Overload resolution happens **at compile time** (unlike overriding, which is run-time based).

Java follows these rules:


#### 14.3.1.1 Exact match wins

If an argument matches a method parameter exactly, that method is chosen.

```java
void call(int x)    { System.out.println("int"); }
void call(long x)   { System.out.println("long"); }

call(5); // prints: int (exact match for int)
```


#### 14.3.1.2 — If no exact match exists, Java picks the *most specific* compatible type

Java prefers:

1. **widening** over autoboxing  
2. **autoboxing** over varargs  
3. **wider reference** only if more specific type is not available  

- Example with numeric primitives:

```java
void test(long x)   { System.out.println("long"); }
void test(float x)  { System.out.println("float"); }

test(5);  // int literal: can widen to long or float
          // but long is more specific than float for integer types
          // Output: long
```


#### 14.3.1.3 — Primitive widening beats boxing

If a primitive argument can either widen or autobox, Java chooses widening.

```java
void m(int x)       { System.out.println("int"); }
void m(Integer x)   { System.out.println("Integer"); }

byte b = 10;
m(b);               // byte → int (widening) wins
                    // Output: int
```


#### 14.3.1.4 — Boxing beats varargs

```java
void show(Integer x)    { System.out.println("Integer"); }
void show(int... x)     { System.out.println("varargs"); }

show(5);                // int → Integer (boxing) preferred
                        // Output: Integer
```


#### 14.3.1.5 — For references, Java picks the most specific reference type

```java
void ref(Object o)      { System.out.println("Object"); }
void ref(String s)      { System.out.println("String"); }

ref("abc");             // "abc" is a String → more specific than Object
                        // Output: String
```

More specific means *lower in the inheritance hierarchy*.


#### 14.3.1.6 — When there is no unambiguous “most specific”, the call is a compile error

Example with sibling classes:

```java
void check(Number n)      { System.out.println("Number"); }
void check(String s)      { System.out.println("String"); }

check(null);    // Both String and Number can accept null
                // String is more specific because it is a concrete class
                // Output: String
```

But if two unrelated classes compete:

```java
void run(String s)   { }
void run(Integer i)  { }

run(null);  // ❌ Compile-time error: ambiguous method call
```


#### 14.3.1.7 — Mixed primitive + wrapper overloads

Java evaluates widening, boxing, and varargs in this order:

**widening → boxing → varargs**

Example:

```java
void mix(long x)        { System.out.println("long"); }
void mix(Integer x)     { System.out.println("Integer"); }
void mix(int... x)      { System.out.println("varargs"); }

short s = 5;
mix(s);   // short → int → long  (widening)
          // Boxing and varargs ignored
          // Output: long
```


#### 14.3.1.8 — When primitives mix with reference types

```java
void fun(Object o)     { System.out.println("Object"); }
void fun(int x)        { System.out.println("int"); }

fun(10);                // exact primitive match wins
                        // Output: int

Integer i = 10;
fun(i);                 // reference accepted → Object
                        // Output: Object
```


#### 14.3.1.9 — When Object wins

```java
void fun(List<String> o)    { System.out.println("O"); }
void fun(CharSequence x)    { System.out.println("X"); }
void fun(Object y)        	{ System.out.println("Y"); }

fun(LocalDate.now());       // Output: Y

```

#### 14.3.1.10 Summary Table (Overload Resolution)

| Situation | Rule |
|----------|------|
| Exact match | Always chosen |
| Primitive widening vs boxing | Widening wins |
| Boxing vs varargs | Boxing wins |
| Most specific reference type | Wins |
| Unrelated reference types | Ambiguous → compile error |
| Mixed primitive + wrapper | Widening → boxing → varargs |

---

## 14.4 Local and Instance Variables

### 14.4.1 Instance Variables

Instance variables are:

- declared as members of a class
- created when an object is instantiated
- accessible by all methods of the instance

Possible modifiers for instance variables:

- access modifiers (`public`, `protected`, `private`)
- `final`
- `volatile`
- `transient`

- Example:

```java
public class Person {
    private String name;         // instance variable
    protected final int age = 0; // final means cannot be reassigned
}
```


### 14.4.2 Local Variables

Local variables:

- are declared *inside* a method, constructor, or block
- have **no default values** → must be explicitly initialized before use
- only modifier allowed: **final**

- Example:

```java
void calculate() {
    int x;        // declared
    x = 10;       // must be initialized before use

    final int y = 5;  // legal
}
```

Two special cases:

#### 14.4.2.1 Effectively Final Local Variables
 
A local variable is *effectively final* if it is **assigned once**, even without `final`.

Effectively final variables can be used in:

- lambda expressions
- local/anonymous classes

#### 14.4.2.2 Parameters as Effectively Final  

Method parameters behave as local variables and follow the same rules.

---

## 14.5 Varargs (Variable-Length Argument Lists)

Varargs allow a method to accept **zero or more** parameters of the same type.

Syntax:

```java
void printNames(String... names)
```

Rules:

- A method may have **only one** varargs parameter.
- It must be the **last** parameter in the list.
- Varargs are treated as an **array** inside the method.

- Example:

```java
void show(int x, String... values) {
    System.out.println(values.length);
}

show(10);                     // length = 0
show(10, "A");                // length = 1
show(10, "A", "B", "C");      // length = 3
```

> [!IMPORTANT]  
> Varargs and arrays participate in method overloading.  
> Overload resolution may become ambiguous.

---

## 14.6 Static Methods, Static Variables, and Static Initializers

In Java, the keyword **`static`** marks elements that **belong to the class itself**, not to individual instances.  
This means:

- They are **loaded once** into memory when the class is first loaded by the JVM.
- They are shared among **all instances**.
- They can be accessed **without creating an object** of the class.

Static members are stored in the JVM **method area** (class-level memory), while instance members live in the **heap**.


### 14.6.1 Static Variables (Class Variables)

A **static variable** is a variable defined at class level and shared by all instances.

Characteristics:

- Created when the class is loaded.
- Exists **even if no instance** of the class is created.
- All objects see the **same value**.
- May be marked `final`, `volatile`, or `transient`.

- Example:

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

### 14.6.2 Static Methods

A **static method** belongs to the class, not to any object instance.

Rules:

- They can be called using the class name: `ClassName.method()`.
- They **cannot** access instance variables or instance methods directly, but only through an instance of the class.
- They **cannot** use `this` or `super`.
- They are commonly used for:
  - utility methods (e.g., `Math.sqrt()`)
  - factory methods
  - global behaviors that do not depend on instance state

- Example:

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

Common errors:

```java
// ❌ Compile error: instance method cannot be accessed directly in static context
static void go() {
    run();        // run() is instance method!
}

void run() { }
```


### 14.6.3 Static Initializer Blocks

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

- Example:

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

> [!IMPORTANT]
> Static initializer blocks run **once**, in the order they appear, before `main()` and before any static method is called.


### 14.6.4 Initialization Order (Static vs. Instance)


( Please refer to Chapter: [15. Class Loading, Initialization, and Object Construction](class-loading.md) ) 


### 14.6.5 Accessing Static Members

#### 14.6.5.1 Recommended: use class name

```java
Math.sqrt(16);
MyClass.staticMethod();
```

#### 14.6.5.2 Also legal: via instance reference

```java
MyClass obj = new MyClass();
obj.staticMethod();   
```


### 14.6.6 Static and Inheritance

Static methods:

- **can be hidden**, not overridden  
- binding is **compile-time**, not runtime  
- accessed based on **reference type**, not object type

- Example:

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

> [!NOTE]
> Key rule: static methods use **reference type**, not object type.


### 14.6.7 Common  Pitfalls

- Attempting to reference an instance variable/method from a static context.
- Assuming static methods are overridden → they are **hidden**.
- Calling a static method from an instance reference (legal but confusing).
- Confusing initialization order of static elements vs. instance elements.
- Forgetting that static variables are shared across all objects.
- Not knowing that static initializers run *once*, in declaration order.



 




